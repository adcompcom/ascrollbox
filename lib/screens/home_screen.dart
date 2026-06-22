import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/tag_model.dart';
import '../models/video_model.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/metadata_service.dart';
import '../services/tag_classifier.dart';
import '../widgets/video_card.dart';
import 'categories_screen.dart';
import 'packs_screen.dart';
import 'pin_entry_screen.dart';
import 'private_screen.dart';
import 'video_player_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Save dialog ───────────────────────────────────────────────

  Future<void> _showSaveDialog(String url) async {
    final provider = context.read<AppProvider>();
    final l10n = AppLocalizations.of(context);
    await showSaveSheet(
      context,
      url: url,
      onSave: (tags, isPrivate) async {
        Navigator.pop(context);
        await provider.saveVideo(widget.user.uid, url, tags, isPrivate: isPrivate);
        provider.setPendingShare(null);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.videoSaved)),
          );
        }
      },
      onCancel: () {
        Navigator.pop(context);
        provider.setPendingShare(null);
      },
    );
  }

  Future<void> _moveToPrivate(VideoModel video) async {
    final l10n = AppLocalizations.of(context);
    await context.read<AppProvider>().moveToPrivate(widget.user.uid, video.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.movedToPrivate)),
      );
    }
  }

  Future<void> _openPrivateSection() async {
    final uid = widget.user.uid;
    final hash = await FirestoreService().getPrivatePinHash(uid);
    if (!mounted) return;
    final success = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PinEntryScreen(
          uid: uid,
          isSetup: hash == null,
          existingPinHash: hash,
        ),
      ),
    );
    if (success == true && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PrivateScreen(user: widget.user)),
      );
    }
  }

  Future<void> _showAddUrlDialog() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addVideoTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.pasteUrlHint,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              final url = controller.text.trim();
              Navigator.pop(ctx);
              if (url.isNotEmpty) _showSaveDialog(url);
            },
            child: Text(l10n.next),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(VideoModel video) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteVideo),
        content: Text(l10n.deleteVideoConfirm(video.title)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<AppProvider>().deleteVideo(widget.user.uid, video.id);
    }
  }

  void _showAddToPackDialog(VideoModel video) {
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
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.addToPack,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ...packs.map((p) => ListTile(
                leading: const Icon(Icons.folder_special_outlined),
                title: Text(p.name),
                trailing: p.videoIds.contains(video.id)
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () async {
                  Navigator.pop(context);
                  if (!p.videoIds.contains(video.id)) {
                    await provider.addVideoToPack(
                        widget.user.uid, p.id, video.id);
                    if (mounted) {
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

  Future<void> _showEditSheet(VideoModel video) async {
    final provider = context.read<AppProvider>();
    await showEditSheet(
      context,
      video: video,
      onSave: (tags, notes) async {
        Navigator.pop(context);
        await provider.updateVideo(
          widget.user.uid,
          video.copyWith(tags: tags, notes: notes.isEmpty ? null : notes),
        );
      },
      onCancel: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();
    // Feed l10n into provider for localized tag search
    provider.setL10n(l10n);
    final videos = provider.filteredVideos;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/icon.png', height: 34, width: 34),
            ),
            const SizedBox(width: 10),
            const Text('Ascrollbox',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          // ── Sort button ──────────────────────────────────
          PopupMenuButton<SortOrder>(
            icon: Icon(
              Icons.sort,
              color: provider.sortOrder != SortOrder.newest
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            tooltip: l10n.sortBy,
            onSelected: provider.setSortOrder,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: SortOrder.newest,
                child: Row(children: [
                  if (provider.sortOrder == SortOrder.newest)
                    Icon(Icons.check,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary),
                  if (provider.sortOrder != SortOrder.newest)
                    const SizedBox(width: 16),
                  const SizedBox(width: 8),
                  Text(l10n.sortNewest),
                ]),
              ),
              PopupMenuItem(
                value: SortOrder.oldest,
                child: Row(children: [
                  if (provider.sortOrder == SortOrder.oldest)
                    Icon(Icons.check,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary),
                  if (provider.sortOrder != SortOrder.oldest)
                    const SizedBox(width: 16),
                  const SizedBox(width: 8),
                  Text(l10n.sortOldest),
                ]),
              ),
              PopupMenuItem(
                value: SortOrder.byPlatform,
                child: Row(children: [
                  if (provider.sortOrder == SortOrder.byPlatform)
                    Icon(Icons.check,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary),
                  if (provider.sortOrder != SortOrder.byPlatform)
                    const SizedBox(width: 16),
                  const SizedBox(width: 8),
                  Text(l10n.sortByPlatform),
                ]),
              ),
            ],
          ),
          CircleAvatar(
            radius: 16,
            backgroundImage: widget.user.photoURL != null
                ? NetworkImage(widget.user.photoURL!)
                : null,
            child: widget.user.photoURL == null
                ? Text((widget.user.displayName ?? 'U')[0].toUpperCase())
                : null,
          ),
          const SizedBox(width: 12),
        ],
      ),
      drawer: _AppDrawer(user: widget.user, onPrivateTap: _openPrivateSection),
      body: Column(
        children: [
          // ── Search bar ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          provider.setSearchQuery('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: provider.setSearchQuery,
            ),
          ),

          // ── Tag filter bar ───────────────────────────────────
          if (provider.allUsedTags.isNotEmpty)
            _TagFilterBar(
              usedTags: provider.allUsedTags,
              activeTags: provider.filterTags,
              onToggle: provider.toggleFilterTag,
              onClear: provider.clearFilterTags,
            ),

          // ── Video grid ───────────────────────────────────────
          Expanded(
            child: Stack(
              children: [
                if (videos.isEmpty)
                  _EmptyState(
                    hasVideos: provider.videos.isNotEmpty,
                    onAdd: _showAddUrlDialog,
                  )
                else
                  GridView.builder(
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
                              builder: (_) => VideoPlayerScreen(video: video)),
                        ),
                        onDelete: () => _confirmDelete(video),
                        onAddToPack: () => _showAddToPackDialog(video),
                        onEdit: () => _showEditSheet(video),
                        onMoveToPrivate: () => _moveToPrivate(video),
                      );
                    },
                  ),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUrlDialog,
        icon: const Icon(Icons.add),
        label: Text(l10n.addVideo),
      ),
    );
  }
}

// ── Tag filter bar ────────────────────────────────────────────────────────────

class _TagFilterBar extends StatelessWidget {
  final List<String> usedTags;
  final Set<String> activeTags;
  final void Function(String) onToggle;
  final VoidCallback onClear;

  const _TagFilterBar({
    required this.usedTags,
    required this.activeTags,
    required this.onToggle,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 44,
      color: Theme.of(context).colorScheme.surface,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: Text(l10n.filterAll),
              selected: activeTags.isEmpty,
              onSelected: (_) => onClear(),
              showCheckmark: false,
            ),
          ),
          ...usedTags.map((tag) {
            final emoji = kTagEmoji[tag];
            final localizedName = tag.localized(context);
            final label =
                emoji != null ? '$emoji $localizedName' : localizedName;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                label: Text(label),
                selected: activeTags.contains(tag),
                onSelected: (_) => onToggle(tag),
                showCheckmark: false,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Drawer ────────────────────────────────────────────────────────────────────

class _AppDrawer extends StatelessWidget {
  final User user;
  final VoidCallback onPrivateTap;
  const _AppDrawer({required this.user, required this.onPrivateTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C47FF), Color(0xFF9B6DFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(user.displayName ?? 'U'),
            accountEmail: Text(user.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : null,
              child: user.photoURL == null
                  ? Text((user.displayName ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(fontSize: 22))
                  : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(l10n.home),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.label_outline),
            title: Text(l10n.labelsTitle),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CategoriesScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_special_outlined),
            title: Text(l10n.packsTitle),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PacksScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l10n.privateTitle),
            onTap: () {
              Navigator.pop(context);
              onPrivateTap();
            },
          ),
          const Divider(),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.signOut,
                style: const TextStyle(color: Colors.red)),
            onTap: () => AuthService().signOut(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool hasVideos;
  final VoidCallback onAdd;
  const _EmptyState({required this.hasVideos, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(hasVideos ? Icons.filter_list_off : Icons.video_library_outlined,
              size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            hasVideos ? l10n.noResults : l10n.noVideosSaved,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey[500]),
          ),
          if (!hasVideos) ...[
            const SizedBox(height: 8),
            Text(
              l10n.sharePrompt,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(l10n.addByUrl),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Save video sheet ──────────────────────────────────────────────────────────

Future<void> showSaveSheet(
  BuildContext context, {
  required String url,
  required void Function(List<String> tags, bool isPrivate) onSave,
  required VoidCallback onCancel,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => Padding(
      // Push sheet content above keyboard when it appears
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (innerCtx, scroll) => _SaveVideoSheet(
          url: url,
          scrollController: scroll,
          onSave: onSave,
          onCancel: onCancel,
        ),
      ),
    ),
  );
}

class _SaveVideoSheet extends StatefulWidget {
  final String url;
  final ScrollController scrollController;
  final void Function(List<String> tags, bool isPrivate) onSave;
  final VoidCallback onCancel;

  const _SaveVideoSheet({
    required this.url,
    required this.scrollController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<_SaveVideoSheet> createState() => _SaveVideoSheetState();
}

class _SaveVideoSheetState extends State<_SaveVideoSheet> {
  static const _maxTags = 5;

  final Set<String> _selected = {};
  List<String> _suggested = [];
  bool _suggesting = true;
  bool _isPrivate = false;
  final _customController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _autoSuggest();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  Future<void> _autoSuggest() async {
    try {
      final meta = await MetadataService().fetch(widget.url);
      final suggestions =
          TagClassifier.suggest(meta.title, meta.description, max: 3);
      if (mounted) {
        setState(() {
          _suggested = suggestions;
          for (final s in suggestions) {
            if (_selected.length < _maxTags) _selected.add(s);
          }
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _suggesting = false);
  }

  void _toggle(String tag) {
    setState(() {
      if (_selected.contains(tag)) {
        _selected.remove(tag);
      } else if (_selected.length < _maxTags) {
        _selected.add(tag);
      }
    });
  }

  void _addCustom() {
    final l10n = AppLocalizations.of(context);
    final tag = _customController.text.trim().toLowerCase();
    if (tag.isEmpty) return;
    if (_selected.length >= _maxTags) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.labelsMaxReached)),
      );
      return;
    }
    setState(() {
      _selected.add(tag);
      _customController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final remaining = _maxTags - _selected.length;

    return Column(
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset('assets/icon.png', width: 28, height: 28),
              ),
              const SizedBox(width: 8),
              Text(
                'Ascrollbox',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(l10n.labelsTitle,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(width: 8),
                  if (_suggesting)
                    const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2))
                  else
                    Text(l10n.labelsRemaining(remaining),
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
              const SizedBox(height: 8),
              if (_selected.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _selected.map((tag) {
                    final emoji = kTagEmoji[tag] ?? '';
                    final localizedName = tag.localized(context);
                    return Chip(
                      label: Text(
                          '${emoji.isNotEmpty ? '$emoji ' : ''}$localizedName'),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      onDeleted: () => _toggle(tag),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customController,
                      decoration: InputDecoration(
                        hintText: l10n.labelsCustomPlaceholder,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _addCustom(),
                      textCapitalization: TextCapitalization.none,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _addCustom,
                    icon: const Icon(Icons.add),
                    style:
                        IconButton.styleFrom(minimumSize: const Size(40, 40)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              if (_suggested.isNotEmpty)
                _SectionTile(
                  emoji: '✦',
                  label: l10n.labelsSuggested,
                  tags: _suggested,
                  selected: _selected,
                  onToggle: _toggle,
                  initiallyExpanded: true,
                  accentColor: Theme.of(context).colorScheme.primary,
                ),
              ...kTagSections.map((s) => _SectionTile(
                    emoji: s.emoji,
                    label: s.label(l10n),
                    tags: s.tags.where((t) => !_suggested.contains(t)).toList(),
                    selected: _selected,
                    onToggle: _toggle,
                    initiallyExpanded: false,
                  )),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Private switch
              Row(
                children: [
                  Icon(
                    _isPrivate ? Icons.lock : Icons.lock_open_outlined,
                    size: 18,
                    color: _isPrivate
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[500],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.markAsPrivate,
                    style: TextStyle(
                      fontSize: 14,
                      color: _isPrivate
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[700],
                      fontWeight: _isPrivate
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: _isPrivate,
                    onChanged: (v) => setState(() => _isPrivate = v),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () =>
                          widget.onSave(_selected.toList(), _isPrivate),
                      child: Text(l10n.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Edit video sheet ──────────────────────────────────────────────────────────

Future<void> showEditSheet(
  BuildContext context, {
  required VideoModel video,
  required void Function(List<String> tags, String notes) onSave,
  required VoidCallback onCancel,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (ctx, scroll) => _EditVideoSheet(
        video: video,
        scrollController: scroll,
        onSave: onSave,
        onCancel: onCancel,
      ),
    ),
  );
}

class _EditVideoSheet extends StatefulWidget {
  final VideoModel video;
  final ScrollController scrollController;
  final void Function(List<String> tags, String notes) onSave;
  final VoidCallback onCancel;

  const _EditVideoSheet({
    required this.video,
    required this.scrollController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<_EditVideoSheet> createState() => _EditVideoSheetState();
}

class _EditVideoSheetState extends State<_EditVideoSheet> {
  static const _maxTags = 5;
  late final Set<String> _selected;
  late final TextEditingController _notesController;
  final _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.video.tags);
    _notesController =
        TextEditingController(text: widget.video.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    _customController.dispose();
    super.dispose();
  }

  void _toggle(String tag) {
    setState(() {
      if (_selected.contains(tag)) {
        _selected.remove(tag);
      } else if (_selected.length < _maxTags) {
        _selected.add(tag);
      }
    });
  }

  void _addCustom() {
    final l10n = AppLocalizations.of(context);
    final tag = _customController.text.trim().toLowerCase();
    if (tag.isEmpty) return;
    if (_selected.length >= _maxTags) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.labelsMaxReached)),
      );
      return;
    }
    setState(() {
      _selected.add(tag);
      _customController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final remaining = _maxTags - _selected.length;

    return Column(
      children: [
        // Drag handle
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(l10n.editVideo,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Notes field
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: l10n.notes,
                  hintText: l10n.notesHint,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                maxLines: 3,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),

              // Tags header + counter
              Row(
                children: [
                  Text(l10n.labelsTitle,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(width: 8),
                  Text(l10n.labelsRemaining(remaining),
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
              const SizedBox(height: 8),

              // Selected chips
              if (_selected.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: _selected.map((tag) {
                    final emoji = kTagEmoji[tag] ?? '';
                    final localizedName = tag.localized(context);
                    return Chip(
                      label: Text(
                          '${emoji.isNotEmpty ? '$emoji ' : ''}$localizedName'),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      onDeleted: () => _toggle(tag),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              const SizedBox(height: 8),

              // Custom tag input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customController,
                      decoration: InputDecoration(
                        hintText: l10n.labelsCustomPlaceholder,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _addCustom(),
                      textCapitalization: TextCapitalization.none,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _addCustom,
                    icon: const Icon(Icons.add),
                    style:
                        IconButton.styleFrom(minimumSize: const Size(40, 40)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),

        const Divider(height: 1),

        // Scrollable tag sections
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.only(bottom: 80),
            children: kTagSections
                .map((s) => _SectionTile(
                      emoji: s.emoji,
                      label: s.label(l10n),
                      tags: s.tags,
                      selected: _selected,
                      onToggle: _toggle,
                      initiallyExpanded: false,
                    ))
                .toList(),
          ),
        ),

        // Footer
        Container(
          padding: EdgeInsets.fromLTRB(
              16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  child: Text(l10n.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => widget.onSave(
                    _selected.toList(),
                    _notesController.text.trim(),
                  ),
                  child: Text(l10n.saveChanges),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Section tile (expandible) ─────────────────────────────────────────────────

class _SectionTile extends StatelessWidget {
  final String emoji;
  final String label;
  final List<String> tags;
  final Set<String> selected;
  final void Function(String) onToggle;
  final bool initiallyExpanded;
  final Color? accentColor;

  const _SectionTile({
    required this.emoji,
    required this.label,
    required this.tags,
    required this.selected,
    required this.onToggle,
    required this.initiallyExpanded,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();
    final activeCount = tags.where(selected.contains).length;

    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      leading: Text(emoji, style: const TextStyle(fontSize: 20)),
      title: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: accentColor ??
                      Theme.of(context).colorScheme.onSurface)),
          if (activeCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('$activeCount',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags
                .map((tag) => _TagToggle(
                      tag: tag,
                      selected: selected.contains(tag),
                      onTap: () => onToggle(tag),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ── Tag toggle chip ───────────────────────────────────────────────────────────

class _TagToggle extends StatelessWidget {
  final String tag;
  final bool selected;
  final VoidCallback onTap;

  const _TagToggle(
      {required this.tag, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final emoji = kTagEmoji[tag];
    final localizedName = tag.localized(context);
    final label = emoji != null ? '$emoji $localizedName' : localizedName;
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

// ── Platform icon ─────────────────────────────────────────────────────────────

class _PlatformIcon extends StatelessWidget {
  final String platform;
  const _PlatformIcon({required this.platform});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (platform) {
      'youtube'   => (Icons.smart_display, const Color(0xFFFF0000)),
      'tiktok'    => (Icons.music_video, Colors.black87),
      'instagram' => (Icons.camera_alt, const Color(0xFFE1306C)),
      'facebook'  => (Icons.facebook, const Color(0xFF1877F2)),
      _           => (Icons.link, Colors.grey),
    };
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
