import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/video_model.dart';
import '../providers/app_provider.dart';

/// Platforms that block embedding — open in native app instead.
const _nativeOnlyPlatforms = {'youtube', 'tiktok', 'facebook', 'instagram'};

class VideoPlayerScreen extends StatelessWidget {
  final VideoModel video;
  const VideoPlayerScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    if (_nativeOnlyPlatforms.contains(video.platform)) {
      return _NativeOpenScreen(video: video);
    }
    return _WebViewScreen(video: video);
  }
}

// ── Native-open screen (YouTube / TikTok / FB / IG) ─────────────────────────

class _NativeOpenScreen extends StatefulWidget {
  final VideoModel video;
  const _NativeOpenScreen({required this.video});

  @override
  State<_NativeOpenScreen> createState() => _NativeOpenScreenState();
}

class _NativeOpenScreenState extends State<_NativeOpenScreen> {
  late String? _notes;

  @override
  void initState() {
    super.initState();
    _notes = widget.video.notes;
  }

  Future<void> _open(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final uri = Uri.tryParse(widget.video.url);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.openAppFailed)),
      );
    }
  }

  Future<void> _editNotes(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: _notes ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.notes),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.notesHint),
          maxLines: 4,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () =>
                  Navigator.pop(ctx, controller.text.trim()),
              child: Text(l10n.save)),
        ],
      ),
    );
    if (result == null || !context.mounted) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await context
        .read<AppProvider>()
        .updateVideoNotes(uid, widget.video, result.isEmpty ? null : result);
    setState(() => _notes = result.isEmpty ? null : result);
  }

  String get _appName => switch (widget.video.platform) {
        'youtube' => 'YouTube',
        'tiktok' => 'TikTok',
        'facebook' => 'Facebook',
        'instagram' => 'Instagram',
        _ => widget.video.platform,
      };

  IconData get _platformIcon => switch (widget.video.platform) {
        'youtube' => Icons.smart_display,
        'tiktok' => Icons.music_video,
        'facebook' => Icons.facebook,
        'instagram' => Icons.camera_alt,
        _ => Icons.open_in_new,
      };

  Color get _platformColor => switch (widget.video.platform) {
        'youtube' => const Color(0xFFFF0000),
        'tiktok' => Colors.black87,
        'facebook' => const Color(0xFF1877F2),
        'instagram' => const Color(0xFFE1306C),
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title, overflow: TextOverflow.ellipsis),
        actions: [_AddToPackButton(video: widget.video)],
      ),
      body: Column(
        children: [
          // Thumbnail
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (widget.video.thumbnailUrl.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: widget.video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => _thumbPlaceholder(),
                  )
                else
                  _thumbPlaceholder(),
                Container(
                  color: Colors.black45,
                  child: Center(
                    child: Icon(
                      _platformIcon,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info + open button
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Platform badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _platformColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _appName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.video.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (widget.video.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: widget.video.tags
                          .map((s) => Chip(
                                label: Text(s,
                                    style: const TextStyle(fontSize: 12)),
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    l10n.savedOn(_fmt(widget.video.createdAt)),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),

                  // Notes section
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.notes,
                          size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 6),
                      Text(l10n.notes,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.grey[600])),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _editNotes(context),
                        child: Icon(Icons.edit_outlined,
                            size: 16,
                            color:
                                Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _editNotes(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _notes?.isNotEmpty == true
                            ? _notes!
                            : l10n.notesHint,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: _notes?.isNotEmpty == true
                                  ? null
                                  : Colors.grey[500],
                              fontStyle: _notes?.isNotEmpty == true
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                            ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                  // Open button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: _platformColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _open(context),
                      icon: Icon(_platformIcon, color: Colors.white),
                      label: Text(
                        l10n.openInApp(_appName),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumbPlaceholder() => Container(
        color: Colors.grey[900],
        child: const Icon(Icons.ondemand_video, size: 64, color: Colors.grey),
      );

  String _fmt(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';
}

// ── WebView screen (other URLs) ───────────────────────────────────────────────

class _WebViewScreen extends StatefulWidget {
  final VideoModel video;
  const _WebViewScreen({required this.video});

  @override
  State<_WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<_WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 13; Pixel 7) '
        'AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/120.0.6099.144 Mobile Safari/537.36',
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => _isLoading = true),
        onPageFinished: (_) => setState(() => _isLoading = false),
        onWebResourceError: (_) => setState(() => _isLoading = false),
      ))
      ..loadRequest(Uri.parse(widget.video.embedUrl));

    if (_controller.platform is AndroidWebViewController) {
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title, overflow: TextOverflow.ellipsis),
        actions: [_AddToPackButton(video: widget.video)],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

// ── Shared "Add to Pack" action button ───────────────────────────────────────

class _AddToPackButton extends StatelessWidget {
  final VideoModel video;
  const _AddToPackButton({required this.video});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      icon: const Icon(Icons.folder_special_outlined),
      tooltip: l10n.addToPack,
      onPressed: () => _show(context),
    );
  }

  void _show(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.read<AppProvider>();
    final packs = provider.packs;

    if (packs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.createPackFirst)),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.addToPack,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ...packs.map((p) => ListTile(
                leading: const Icon(Icons.folder_special_outlined),
                title: Text(p.name),
                trailing: p.videoIds.contains(video.id)
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () async {
                  Navigator.pop(ctx);
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid != null && !p.videoIds.contains(video.id)) {
                    await provider.addVideoToPack(uid, p.id, video.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.addedToPack(p.name))),
                      );
                    }
                  }
                },
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
