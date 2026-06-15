import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/tag_model.dart';
import '../providers/app_provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();
    final counts = provider.tagCounts;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.labelsTitle), centerTitle: true),
      body: counts.isEmpty
          ? _EmptyState()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.labelsSectionMostUsed,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: counts.entries.map((entry) {
                    final tag = entry.key;
                    final count = entry.value;
                    final emoji = kTagEmoji[tag] ?? '';
                    final isActive = provider.filterTags.contains(tag);

                    return _TagCard(
                      tag: tag,
                      emoji: emoji,
                      count: count,
                      isActive: isActive,
                      onTap: () {
                        provider.toggleFilterTag(tag);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}

class _TagCard extends StatelessWidget {
  final String tag;
  final String emoji;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const _TagCard({
    required this.tag,
    required this.emoji,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final localizedName = tag.localized(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? scheme.primaryContainer : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? scheme.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji.isNotEmpty) ...[
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
            ],
            Text(
              localizedName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? scheme.onPrimaryContainer : scheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? scheme.primary : scheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : scheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.label_outline, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            l10n.labelsEmpty,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.labelsEmptySubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
