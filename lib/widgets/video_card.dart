import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/tag_model.dart';
import '../models/video_model.dart';
import '../theme.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onRemoveFromPack;
  final VoidCallback? onAddToPack;
  final VoidCallback? onEdit;
  final VoidCallback? onMoveToPrivate;
  final VoidCallback? onMoveToPublic;

  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
    this.onDelete,
    this.onRemoveFromPack,
    this.onAddToPack,
    this.onEdit,
    this.onMoveToPrivate,
    this.onMoveToPublic,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showOptions(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail 16:9 con badge superpuesto
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _Thumbnail(video: video),
              ),
              // Contenido
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
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
                      if (video.tags.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _TagsRow(tags: video.tags),
                      ],
                      if (video.notes != null && video.notes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          video.notes!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
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
              leading: const Icon(Icons.play_circle_outline),
              title: Text(l10n.play),
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
            ),
            if (onEdit != null)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(l10n.editVideo),
                onTap: () {
                  Navigator.pop(context);
                  onEdit!();
                },
              ),
            if (onAddToPack != null)
              ListTile(
                leading: const Icon(Icons.folder_special_outlined),
                title: Text(l10n.addToPack),
                onTap: () {
                  Navigator.pop(context);
                  onAddToPack!();
                },
              ),
            if (onMoveToPrivate != null)
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(l10n.moveToPrivate),
                onTap: () {
                  Navigator.pop(context);
                  onMoveToPrivate!();
                },
              ),
            if (onMoveToPublic != null)
              ListTile(
                leading: const Icon(Icons.lock_open_outlined),
                title: Text(l10n.moveToHome),
                onTap: () {
                  Navigator.pop(context);
                  onMoveToPublic!();
                },
              ),
            if (onRemoveFromPack != null)
              ListTile(
                leading: const Icon(Icons.remove_circle_outline,
                    color: AppColors.red),
                title: Text(l10n.removeFromPack,
                    style: const TextStyle(color: AppColors.red)),
                onTap: () {
                  Navigator.pop(context);
                  onRemoveFromPack!();
                },
              ),
            if (onDelete != null)
              ListTile(
                leading: const Icon(Icons.delete_outline,
                    color: AppColors.red),
                title: Text(l10n.delete,
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

// ── Thumbnail con badge superpuesto ───────────────────────────────────────────

class _Thumbnail extends StatelessWidget {
  final VideoModel video;
  const _Thumbnail({required this.video});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Imagen
        video.thumbnailUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: video.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => _placeholder(),
                errorWidget: (_, _, _) => _placeholder(),
              )
            : _placeholder(),
        // Overlay oscuro sutil
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
        // Icono play centrado
        const Center(
          child: Icon(Icons.play_circle_fill,
              size: 32, color: Color(0xB3FFFFFF)),
        ),
        // Badge de plataforma — esquina inferior derecha
        Positioned(
          bottom: 6,
          right: 6,
          child: _PlatformBadge(platform: video.platform),
        ),
      ],
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.bgTertiary,
        child: const Icon(Icons.ondemand_video,
            size: 36, color: AppColors.textTertiary),
      );
}

// ── Badge de plataforma (overlay en thumbnail) ────────────────────────────────

class _PlatformBadge extends StatelessWidget {
  final String platform;
  const _PlatformBadge({required this.platform});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (platform) {
      'youtube'   => ('YT', AppColors.red),
      'facebook'  => ('FB', AppColors.red),
      'tiktok'    => ('TK', AppColors.blue),
      'instagram' => ('IG', AppColors.blue),
      _           => ('••', AppColors.textSecondary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

// ── Tags row ──────────────────────────────────────────────────────────────────

class _TagsRow extends StatelessWidget {
  final List<String> tags;
  const _TagsRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 3,
      children: tags.take(3).map((tag) {
        final emoji = kTagEmoji[tag];
        final name = tag.localized(context);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.bgTertiary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            emoji != null ? '$emoji $name' : name,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Sheet handle reutilizable ─────────────────────────────────────────────────

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
