import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/video_model.dart';
import '../providers/app_provider.dart';
import '../widgets/video_card.dart';
import 'video_player_screen.dart';
import 'home_screen.dart' show showEditSheet;

class PrivateScreen extends StatelessWidget {
  final User user;
  const PrivateScreen({super.key, required this.user});

  Future<void> _confirmDelete(BuildContext context, VideoModel video) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteVideo),
        content: Text(l10n.deleteVideoConfirm(video.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AppProvider>().deleteVideo(user.uid, video.id);
    }
  }

  Future<void> _moveToPublic(BuildContext context, VideoModel video) async {
    final l10n = AppLocalizations.of(context);
    await context.read<AppProvider>().moveToPublic(user.uid, video.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.movedToHome)),
      );
    }
  }

  Future<void> _showEditSheet(BuildContext context, VideoModel video) async {
    final provider = context.read<AppProvider>();
    await showEditSheet(
      context,
      video: video,
      onSave: (tags, notes) async {
        Navigator.pop(context);
        await provider.updateVideo(
          user.uid,
          video.copyWith(tags: tags, notes: notes.isEmpty ? null : notes),
        );
      },
      onCancel: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();
    final videos = provider.privateVideos;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.lock, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(l10n.privateTitle,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: videos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 72, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.privateEmpty,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.privateEmptySubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[400]),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: videos.length,
              itemBuilder: (ctx, i) {
                final video = videos[i];
                return VideoCard(
                  video: video,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => VideoPlayerScreen(video: video)),
                  ),
                  onDelete: () => _confirmDelete(context, video),
                  onEdit: () => _showEditSheet(context, video),
                  onMoveToPublic: () => _moveToPublic(context, video),
                );
              },
            ),
    );
  }
}
