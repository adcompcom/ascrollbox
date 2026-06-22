import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/pack_model.dart';
import '../models/tag_model.dart';
import '../models/video_model.dart';
import '../providers/app_provider.dart';
import '../widgets/video_card.dart';
import 'pack_form_screen.dart';
import 'pack_publish_screen.dart';
import 'video_player_screen.dart';

class PackDetailScreen extends StatelessWidget {
  final PackModel pack;
  const PackDetailScreen({super.key, required this.pack});

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> _showAddVideosSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final provider = context.read<AppProvider>();
    final allVideos = provider.videos;
    final alreadyIn = pack.videoIds.toSet();
    final available =
        allVideos.where((v) => !alreadyIn.contains(v.id)).toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noAvailableVideos)),
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (ctx, scroll) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.addVideosToPack,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Expanded(
              child: ListView.builder(
                controller: scroll,
                itemCount: available.length,
                itemBuilder: (_, i) {
                  final v = available[i];
                  return ListTile(
                    leading: _thumb(v),
                    title: Text(v.title,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(v.platform),
                    onTap: () async {
                      Navigator.pop(ctx);
                      await provider.addVideoToPack(_uid, pack.id, v.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.videoAddedToPack)),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmRemove(BuildContext context, AppProvider provider,
      String packId, VideoModel video) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.removeFromPack),
        content: Text(l10n.deleteVideoConfirm(video.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.removeFromPack,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await provider.removeVideoFromPack(_uid, packId, video.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _thumb(VideoModel v) {
    if (v.thumbnailUrl.isEmpty) {
      return const CircleAvatar(child: Icon(Icons.ondemand_video));
    }
    return CircleAvatar(backgroundImage: NetworkImage(v.thumbnailUrl));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();
    final livePack =
        provider.packs.firstWhere((p) => p.id == pack.id, orElse: () => pack);
    final videos = provider.videosInPack(livePack);

    return Scaffold(
      appBar: AppBar(
        title: Text(livePack.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.edit,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PackFormScreen(existing: livePack)),
            ),
          ),
          IconButton(
            icon: Icon(livePack.isPublished
                ? Icons.public
                : Icons.share_outlined),
            tooltip: l10n.packShare,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PackPublishScreen(pack: livePack)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.video_library_outlined),
            tooltip: l10n.addVideos,
            onPressed: () => _showAddVideosSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Description + tags header (if set)
          if (livePack.description.isNotEmpty || livePack.tags.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (livePack.description.isNotEmpty)
                    Text(livePack.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[700])),
                  if (livePack.tags.isNotEmpty) ...[
                    if (livePack.description.isNotEmpty)
                      const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: livePack.tags.map((t) {
                        final emoji = kTagEmoji[t];
                        final name = t.localized(context);
                        return Chip(
                          label: Text(
                              emoji != null ? '$emoji $name' : name,
                              style: const TextStyle(fontSize: 11)),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          Expanded(
            child: videos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.video_library_outlined,
                            size: 72, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(l10n.packEmpty,
                            style: TextStyle(color: Colors.grey[500])),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () => _showAddVideosSheet(context),
                          icon: const Icon(Icons.add),
                          label: Text(l10n.addVideos),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: videos.length,
                    itemBuilder: (_, i) {
                      final video = videos[i];
                      return VideoCard(
                        video: video,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoPlayerScreen(video: video),
                          ),
                        ),
                        onRemoveFromPack: () =>
                            _confirmRemove(context, provider, livePack.id, video),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVideosSheet(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addVideos),
      ),
    );
  }
}
