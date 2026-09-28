import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/pack_model.dart';
import '../providers/app_provider.dart';
import '../services/firestore_service.dart';
import '../theme.dart';
import '../utils/tap_guard.dart';

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
    _loadShareCode();
  }

  /// Loads share code from in-memory provider first (faster), then Firestore
  /// as fallback so that code-only packs (not in publicCommunityPacks) also
  /// show their share code and link correctly.
  Future<void> _loadShareCode() async {
    final cpId = widget.pack.communityPackId;
    if (cpId == null) return;

    // Check in-memory first (public packs are already loaded)
    final inMemory = context
        .read<AppProvider>()
        .publicCommunityPacks
        .where((p) => p.id == cpId)
        .firstOrNull;

    if (inMemory != null) {
      if (mounted) {
        setState(() {
          _shareCode = inMemory.shareCode;
          _isPublic = inMemory.isPublic;
        });
      }
      return;
    }

    // Fetch from Firestore (covers code-only packs not in public stream)
    try {
      final cp = await FirestoreService().getCommunityPack(cpId);
      if (mounted && cp != null) {
        setState(() {
          _shareCode = cp.shareCode;
          _isPublic = cp.isPublic;
        });
      }
    } catch (_) {}
  }

  Future<void> _publish() async {
    if (_loading) return;
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
      // Reload share code after publish (small delay for Firestore propagation)
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) await _loadShareCode();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _unpublish() =>
      runOnce('unpublish:${widget.pack.id}', _unpublishImpl);

  Future<void> _unpublishImpl() async {
    if (_loading) return;
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.packUnpublish),
        content: const Text(
          '¿Seguro que quieres dejar de compartir este pack?',
        ),
        actions: [
          TextButton(
            onPressed: () => popOnce(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => popOnce(ctx, true),
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
    final code = _shareCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.packShareSettings),
        actions: [
          if (isPublished)
            TextButton(
              onPressed: _loading ? null : _unpublish,
              child: Text(
                l10n.packUnpublish,
                style: const TextStyle(color: Colors.red),
              ),
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
                      Text(
                        widget.pack.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.pack.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.pack.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: context.palette.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Share code (if already published)
                if (code != null) ...[
                  _ShareCodeCard(code: code, packName: widget.pack.name),
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
  final String packName;

  const _ShareCodeCard({required this.code, required this.packName});

  static const _baseUrl = 'https://ascrollbox.web.app/p/';

  String get _link => '$_baseUrl$code';

  Future<void> _share() => runOnce(
    'sharePack:$code',
    () => Share.share('🎬 Mira este pack en Ascrollbox: "$packName"\n\n$_link'),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Code row
          Row(
            children: [
              Icon(Icons.tag, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.packShareCode,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
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
                icon: const Icon(Icons.copy, size: 20),
                tooltip: 'Copiar código',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.packShareCodeCopied)),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Link row
          Row(
            children: [
              Icon(Icons.link, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _link,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                tooltip: 'Copiar link',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _link));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Link copiado')));
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Share button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _share,
              icon: const Icon(Icons.share, size: 18),
              label: const Text('Compartir por WhatsApp / más'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
              ),
            ),
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
