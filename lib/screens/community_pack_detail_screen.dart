import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/community_pack_model.dart';
import '../models/tag_model.dart';
import '../models/video_model.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import 'video_player_screen.dart';

class CommunityPackDetailScreen extends StatefulWidget {
  final CommunityPackModel pack;

  const CommunityPackDetailScreen({super.key, required this.pack});

  @override
  State<CommunityPackDetailScreen> createState() =>
      _CommunityPackDetailScreenState();
}

class _CommunityPackDetailScreenState
    extends State<CommunityPackDetailScreen> {
  int? _userRating;
  bool _savingRating = false;
  bool _savingPack = false;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;
  bool get _isOwner => widget.pack.ownerId == _uid;

  @override
  void initState() {
    super.initState();
    _loadUserRating();
    context.read<AppProvider>().incrementViewCount(widget.pack.id);
  }

  Future<void> _loadUserRating() async {
    final r = await context.read<AppProvider>().getUserRating(_uid, widget.pack.id);
    if (mounted) setState(() => _userRating = r);
  }

  Future<void> _rate(int stars) async {
    setState(() { _savingRating = true; _userRating = stars; });
    await context.read<AppProvider>().ratePack(_uid, widget.pack.id, stars);
    if (mounted) {
      setState(() => _savingRating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).packRated)),
      );
    }
  }

  Future<void> _toggleSave() async {
    final l10n = AppLocalizations.of(context);
    final provider = context.read<AppProvider>();
    final isSaved = provider.isSavedCommunityPack(widget.pack.id);
    setState(() => _savingPack = true);
    try {
      if (isSaved) {
        await provider.unsaveCommunityPack(_uid, widget.pack.id);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.packRemovedFromShared)));
      } else {
        await provider.saveCommunityPack(_uid, widget.pack.id);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.packAddedToShared)));
      }
    } finally {
      if (mounted) setState(() => _savingPack = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();
    final isSaved = provider.isSavedCommunityPack(widget.pack.id);
    final theme = Theme.of(context);
    final pack = widget.pack;

    return Scaffold(
      appBar: AppBar(
        title: Text(pack.name),
        actions: [
          if (!_isOwner)
            _savingPack
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : IconButton(
                    icon: Icon(isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_outline),
                    tooltip: isSaved
                        ? l10n.packRemoveFromShared
                        : l10n.packAddToShared,
                    onPressed: _toggleSave,
                  ),
        ],
      ),
      body: StreamBuilder<List<CommunityPackVideo>>(
        stream: provider.communityPackVideos(pack.id),
        builder: (context, snap) {
          final videos = snap.data ?? [];
          return CustomScrollView(
            slivers: [
              // ── Header ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Owner
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: pack.ownerPhotoUrl != null
                                ? NetworkImage(pack.ownerPhotoUrl!)
                                : null,
                            child: pack.ownerPhotoUrl == null
                                ? Text(pack.ownerName.isNotEmpty
                                    ? pack.ownerName[0].toUpperCase()
                                    : '?')
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.packBy(pack.ownerName),
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Description
                      if (pack.description.isNotEmpty)
                        Text(pack.description,
                            style: theme.textTheme.bodyMedium),
                      if (pack.description.isEmpty)
                        Text(l10n.packNoDescription,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[400],
                                    fontStyle: FontStyle.italic)),

                      const SizedBox(height: 12),

                      // Tags
                      if (pack.tags.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: pack.tags.map((t) {
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

                      const SizedBox(height: 16),

                      // Stats row
                      _StatsRow(pack: pack, l10n: l10n),

                      const Divider(height: 24),

                      // Rating
                      if (!_isOwner) ...[
                        Text(l10n.packRateTitle,
                            style: theme.textTheme.labelLarge),
                        const SizedBox(height: 8),
                        _StarRating(
                          current: _userRating,
                          onRate: _savingRating ? null : _rate,
                        ),
                        const Divider(height: 24),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Videos grid ───────────────────────────────────
              videos.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(l10n.packEmpty,
                            style: TextStyle(color: Colors.grey[500])),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 40),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => _CommunityVideoCard(
                            video: videos[i],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerScreen(
                                  video: _toVideoModel(videos[i]),
                                ),
                              ),
                            ),
                          ),
                          childCount: videos.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
      // Add to shared FAB (for non-owners who haven't saved it)
      floatingActionButton: (!_isOwner && !isSaved)
          ? FloatingActionButton.extended(
              onPressed: _savingPack ? null : _toggleSave,
              icon: const Icon(Icons.bookmark_add_outlined),
              label: Text(l10n.packAddToShared),
            )
          : null,
    );
  }

  VideoModel _toVideoModel(CommunityPackVideo v) => VideoModel(
        id: v.id,
        url: v.url,
        platform: v.platform,
        title: v.title,
        thumbnailUrl: v.thumbnailUrl,
        tags: [],
        packIds: [],
        createdAt: DateTime.now(),
      );
}

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final CommunityPackModel pack;
  final AppLocalizations l10n;

  const _StatsRow({required this.pack, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(
            icon: Icons.visibility_outlined,
            label: l10n.packViews(pack.viewCount)),
        const SizedBox(width: 16),
        _Stat(
            icon: Icons.bookmark_outline,
            label: l10n.packShares(pack.shareCount)),
        const SizedBox(width: 16),
        if (pack.ratingCount > 0)
          _Stat(
            icon: Icons.star,
            iconColor: Colors.amber,
            label:
                '${pack.ratingAvg.toStringAsFixed(1)} (${l10n.packRatingCount(pack.ratingCount)})',
          ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _Stat({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: iconColor ?? Colors.grey[500]),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      );
}

// ── Star rating widget ────────────────────────────────────────────────────────

class _StarRating extends StatelessWidget {
  final int? current;
  final void Function(int)? onRate;

  const _StarRating({this.current, this.onRate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final star = i + 1;
        return GestureDetector(
          onTap: onRate == null ? null : () => onRate!(star),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              (current ?? 0) >= star ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 32,
            ),
          ),
        );
      }),
    );
  }
}

// ── Community video card (read-only) ─────────────────────────────────────────

class _CommunityVideoCard extends StatelessWidget {
  final CommunityPackVideo video;
  final VoidCallback onTap;

  const _CommunityVideoCard({required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 12,
                offset: Offset(0, 2)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    video.thumbnailUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: video.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) =>
                                Container(color: AppColors.bgTertiary),
                          )
                        : Container(color: AppColors.bgTertiary),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0x33000000)],
                          stops: [0.6, 1.0],
                        ),
                      ),
                    ),
                    const Center(
                      child: Icon(Icons.play_circle_fill,
                          size: 32, color: Color(0xB3FFFFFF)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
