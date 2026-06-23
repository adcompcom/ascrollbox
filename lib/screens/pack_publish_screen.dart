import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/pack_model.dart';
import '../providers/app_provider.dart';

class PackPublishScreen extends StatefulWidget {
  final PackModel pack;

  const PackPublishScreen({super.key, required this.pack});

  @override
  State<PackPublishScreen> createState() => _PackPublishScreenState();
}

class _PackPublishScreenState extends State<PackPublishScreen> {
  bool _isPublic = true;
  bool _loading = false;
  String? _shareCode;

  @override
  void initState() {
    super.initState();
    _shareCode = _findShareCode();
  }

  String? _findShareCode() {
    final cpId = widget.pack.communityPackId;
    if (cpId == null) return null;
    final found = context
        .read<AppProvider>()
        .publicCommunityPacks
        .where((p) => p.id == cpId)
        .firstOrNull;
    return found?.shareCode;
  }

  Future<void> _publish() async {
    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser!;
    final provider = context.read<AppProvider>();
    final videos = provider.videosInPack(widget.pack);

    try {
      final profile = provider.userProfile;
      final ownerName = profile?.nickname.isNotEmpty == true
          ? profile!.nickname
          : user.displayName ?? 'Usuario';
      final ownerPhotoUrl = profile?.photoUrl ?? user.photoURL;

      await provider.publishPack(
        uid: user.uid,
        packId: widget.pack.id,
        ownerName: ownerName,
        ownerPhotoUrl: ownerPhotoUrl,
        name: widget.pack.name,
        description: widget.pack.description,
        tags: widget.pack.tags,
        isPublic: _isPublic,
        videos: videos,
      );
      // Get share code from the freshly created community pack
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        final code = _findShareCode();
        setState(() => _shareCode = code);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _unpublish() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.packUnpublish),
        content: const Text('¿Seguro que quieres dejar de compartir este pack?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _loading = true);
    try {
      await context.read<AppProvider>().unpublishPack(
            FirebaseAuth.instance.currentUser!.uid,
            widget.pack.id,
            widget.pack.communityPackId!,
          );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isPublished = widget.pack.isPublished;
    final code = _shareCode ?? _findShareCode();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.packShareSettings),
        actions: [
          if (isPublished)
            TextButton(
              onPressed: _loading ? null : _unpublish,
              child: Text(l10n.packUnpublish,
                  style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              children: [
                // Pack info summary (read-only)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.pack.name,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      if (widget.pack.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(widget.pack.description,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600])),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Share code (if already published)
                if (code != null) ...[
                  _ShareCodeCard(code: code),
                  const SizedBox(height: 24),
                ],

                // Visibility
                Text(l10n.packShare, style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                _VisibilityToggle(
                  isPublic: _isPublic,
                  onChanged: isPublished
                      ? null
                      : (v) => setState(() => _isPublic = v),
                  l10n: l10n,
                ),
                const SizedBox(height: 28),

                if (!isPublished)
                  FilledButton.icon(
                    onPressed: _publish,
                    icon: const Icon(Icons.public),
                    label: Text(l10n.packPublish),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(l10n.packIsPublic),
                  ),
              ],
            ),
    );
  }
}

// ── Share code card ───────────────────────────────────────────────────────────

class _ShareCodeCard extends StatelessWidget {
  final String code;
  const _ShareCodeCard({required this.code});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.share, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.packShareCode,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.colorScheme.primary)),
                Text(
                  code,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.packShareCodeCopied)),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Visibility toggle ─────────────────────────────────────────────────────────

class _VisibilityToggle extends StatelessWidget {
  final bool isPublic;
  final ValueChanged<bool>? onChanged;
  final AppLocalizations l10n;

  const _VisibilityToggle({
    required this.isPublic,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<bool>(
          value: true,
          groupValue: isPublic,
          onChanged: onChanged == null ? null : (v) => onChanged!(v!),
          title: Text(l10n.packPublicLabel),
          subtitle: Text(l10n.packPublicSubtitle),
          secondary: const Icon(Icons.public),
        ),
        RadioListTile<bool>(
          value: false,
          groupValue: isPublic,
          onChanged: onChanged == null ? null : (v) => onChanged!(v!),
          title: Text(l10n.packCodeOnlyLabel),
          subtitle: Text(l10n.packCodeOnlySubtitle),
          secondary: const Icon(Icons.vpn_key_outlined),
        ),
      ],
    );
  }
}
