import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/tap_guard.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/pack_model.dart';
import '../models/tag_model.dart';
import '../models/video_model.dart';
import '../providers/app_provider.dart';
import '../widgets/video_card.dart';
import 'pack_form_screen.dart';
import 'pack_publish_screen.dart';
import 'video_player_screen.dart';
import '../theme.dart';

class PackDetailScreen extends StatelessWidget {
  final PackModel pack;
  const PackDetailScreen({super.key, required this.pack});

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> _showAddVideosSheet(BuildContext context) => runOnce(
    'addVideosSheet:${pack.id}',
    () => _showAddVideosSheetImpl(context),
  );

  Future<void> _showAddVideosSheetImpl(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final provider = context.read<AppProvider>();
    final alreadyIn = pack.videoIds.toSet();
    final available = provider.videos
        .where((v) => !alreadyIn.contains(v.id))
        .toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.noAvailableVideos)));
      return;
    }

    // Capture messenger before async gap so it stays valid after sheet pop
    final messenger = ScaffoldMessenger.of(context);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.95,
        builder: (ctx, scroll) => _AddVideoSheet(
          available: available,
          uid: _uid,
          packId: pack.id,
          provider: provider,
          scrollController: scroll,
          onAdded: () => messenger.showSnackBar(
            SnackBar(content: Text(l10n.videoAddedToPack)),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    AppProvider provider,
    String packId,
    VideoModel video,
  ) => runOnce(
    'removeFromPack:$packId:${video.id}',
    () => _confirmRemoveImpl(context, provider, packId, video),
  );

  Future<void> _confirmRemoveImpl(
    BuildContext context,
    AppProvider provider,
    String packId,
    VideoModel video,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.removeFromPack),
        content: Text(l10n.deleteVideoConfirm(video.title)),
        actions: [
          TextButton(
            onPressed: () => popOnce(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => popOnce(ctx, true),
            child: Text(
              l10n.removeFromPack,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await provider.removeVideoFromPack(_uid, packId, video.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();
    final livePack = provider.packs.firstWhere(
      (p) => p.id == pack.id,
      orElse: () => pack,
    );
    final videos = provider.videosInPack(livePack);

    return Scaffold(
      appBar: AppBar(
        title: Text(livePack.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.edit,
            onPressed: () => pushOnce(
              context,
              MaterialPageRoute(
                builder: (_) => PackFormScreen(existing: livePack),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              livePack.isPublished ? Icons.public : Icons.share_outlined,
            ),
            tooltip: l10n.packShare,
            onPressed: () => pushOnce(
              context,
              MaterialPageRoute(
                builder: (_) => PackPublishScreen(pack: livePack),
              ),
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
                    Text(
                      livePack.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
                    ),
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
                            style: const TextStyle(fontSize: 11),
                          ),
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
                        Icon(
                          Icons.video_library_outlined,
                          size: 72,
                          color: context.palette.muted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.packEmpty,
                          style: TextStyle(color: context.palette.textTertiary),
                        ),
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
                        onTap: () => pushOnce(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoPlayerScreen(video: video),
                          ),
                        ),
                        onRemoveFromPack: () => _confirmRemove(
                          context,
                          provider,
                          livePack.id,
                          video,
                        ),
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

// ── Add-video sheet with search ───────────────────────────────────────────────

class _AddVideoSheet extends StatefulWidget {
  final List<VideoModel> available;
  final String uid;
  final String packId;
  final AppProvider provider;
  final ScrollController scrollController;
  final VoidCallback onAdded;

  const _AddVideoSheet({
    required this.available,
    required this.uid,
    required this.packId,
    required this.provider,
    required this.scrollController,
    required this.onAdded,
  });

  @override
  State<_AddVideoSheet> createState() => _AddVideoSheetState();
}

class _AddVideoSheetState extends State<_AddVideoSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<VideoModel> get _filtered {
    if (_query.isEmpty) return widget.available;
    final q = _query.toLowerCase();
    return widget.available.where((v) {
      if (v.title.toLowerCase().contains(q)) return true;
      if (v.platform.toLowerCase().contains(q)) return true;
      return v.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  Widget _thumb(VideoModel v) => v.thumbnailUrl.isEmpty
      ? const CircleAvatar(child: Icon(Icons.ondemand_video))
      : CircleAvatar(backgroundImage: NetworkImage(v.thumbnailUrl));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final filtered = _filtered;

    return Column(
      children: [
        // Drag handle
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: context.palette.muted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Text(
            l10n.addVideosToPack,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: TextField(
            controller: _searchCtrl,
            autofocus: false,
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              hintStyle: TextStyle(color: context.palette.textTertiary),
              prefixIcon: Icon(
                Icons.search,
                color: context.palette.textTertiary,
              ),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),

        const Divider(height: 1),

        // Results count hint when searching
        if (_query.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filtered.length} / ${widget.available.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: context.palette.textTertiary,
                ),
              ),
            ),
          ),

        // List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    l10n.noResults,
                    style: TextStyle(color: context.palette.textTertiary),
                  ),
                )
              : ListView.builder(
                  controller: widget.scrollController,
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final v = filtered[i];
                    return ListTile(
                      leading: _thumb(v),
                      title: Text(
                        v.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(v.platform),
                      trailing: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey,
                      ),
                      onTap: () async {
                        if (!popOnce(context)) return;
                        await widget.provider.addVideoToPack(
                          widget.uid,
                          widget.packId,
                          v.id,
                        );
                        widget.onAdded();
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
