import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/pack_model.dart';
import '../models/video_model.dart';
import '../theme.dart';

class PackCard extends StatelessWidget {
  final PackModel pack;
  final List<VideoModel> videos;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onRename;

  const PackCard({
    super.key,
    required this.pack,
    required this.videos,
    required this.onTap,
    this.onDelete,
    this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final thumbs = videos.take(4).toList();
    final count = pack.videoIds.length;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showOptions(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Mosaico 2×2
              _ThumbGrid(thumbs: thumbs),

              // Degradado: transparente → oscuro
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x73000000)],
                    stops: [0.45, 1.0],
                  ),
                ),
              ),

              // Título + contador en blanco sobre el degradado
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pack.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      count == 1
                          ? l10n.packVideosCount(count)
                          : l10n.packVideosCountPlural(count),
                      style: const TextStyle(
                        color: Color(0xB3FFFFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetHandle(),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text(l10n.open),
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
            ),
            if (onRename != null)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(l10n.rename),
                onTap: () {
                  Navigator.pop(context);
                  onRename!();
                },
              ),
            if (onDelete != null)
              ListTile(
                leading: const Icon(Icons.delete_outline,
                    color: AppColors.red),
                title: Text(l10n.deletePack,
                    style: const TextStyle(color: AppColors.red)),
                onTap: () {
                  Navigator.pop(context);
                  onDelete!();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Mosaico 2×2 ───────────────────────────────────────────────────────────────

class _ThumbGrid extends StatelessWidget {
  final List<VideoModel> thumbs;
  const _ThumbGrid({required this.thumbs});

  @override
  Widget build(BuildContext context) {
    if (thumbs.isEmpty) {
      return Container(
        color: AppColors.bgTertiary,
        child: const Center(
          child: Icon(Icons.folder_open,
              size: 48, color: AppColors.textTertiary),
        ),
      );
    }
    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(4, (i) {
        if (i >= thumbs.length) {
          return Container(color: AppColors.bgTertiary);
        }
        final url = thumbs[i].thumbnailUrl;
        return url.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) =>
                    Container(color: AppColors.bgTertiary),
              )
            : Container(color: AppColors.bgTertiary);
      }),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 4),
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.bgTertiary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}
