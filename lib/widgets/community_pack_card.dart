import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/community_pack_model.dart';
import '../theme.dart';

class CommunityPackCard extends StatelessWidget {
  final CommunityPackModel pack;
  final VoidCallback onTap;

  const CommunityPackCard({super.key, required this.pack, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.palette.bgTertiary,
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
              _placeholder(theme),

              // Dark gradient overlay
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                    stops: [0.3, 1.0],
                  ),
                ),
              ),

              // Top-left owner avatar
              Positioned(top: 8, left: 8, child: _OwnerAvatar(pack: pack)),

              // Top-right badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: pack.isPublic
                        ? Colors.green.withValues(alpha: 0.85)
                        : Colors.orange.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        pack.isPublic ? Icons.public : Icons.vpn_key_outlined,
                        size: 10,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        pack.shareCode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom info
              Positioned(
                left: 12,
                right: 12,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pack.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pack.ownerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xB3FFFFFF),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          size: 11,
                          color: Color(0x99FFFFFF),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${pack.viewCount}',
                          style: const TextStyle(
                            color: Color(0x99FFFFFF),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (pack.ratingCount > 0) ...[
                          const Icon(Icons.star, size: 11, color: Colors.amber),
                          const SizedBox(width: 3),
                          Text(
                            pack.ratingAvg.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Color(0xCCFFFFFF),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
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

  Widget _placeholder(ThemeData theme) => Container(
    color: theme.colorScheme.primary.withValues(alpha: 0.15),
    child: Center(
      child: Icon(
        Icons.folder_shared_outlined,
        size: 48,
        color: theme.colorScheme.primary.withValues(alpha: 0.4),
      ),
    ),
  );
}

class _OwnerAvatar extends StatelessWidget {
  final CommunityPackModel pack;
  const _OwnerAvatar({required this.pack});

  static const _size = 30.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initial = Text(
      pack.ownerName.isNotEmpty ? pack.ownerName[0].toUpperCase() : '?',
      style: TextStyle(
        color: scheme.primary,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );

    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.primaryContainer,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: pack.ownerPhotoUrl != null
          ? CachedNetworkImage(
              imageUrl: pack.ownerPhotoUrl!,
              width: _size,
              height: _size,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => initial,
            )
          : initial,
    );
  }
}
