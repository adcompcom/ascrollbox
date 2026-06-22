import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/community_pack_model.dart';
import '../providers/app_provider.dart';
import '../widgets/community_pack_card.dart';
import '../widgets/pack_card.dart';
import 'community_pack_detail_screen.dart';
import 'find_pack_screen.dart';
import 'pack_detail_screen.dart';
import 'pack_form_screen.dart';

class PacksScreen extends StatelessWidget {
  const PacksScreen({super.key});

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> _createPack(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PackFormScreen()),
    );
  }

  Future<void> _renamePack(
      BuildContext context, String packId, String current) async {
    final pack = context
        .read<AppProvider>()
        .packs
        .firstWhere((p) => p.id == packId);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PackFormScreen(existing: pack)),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, String packId, String name) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deletePack),
        content: Text(l10n.deletePackConfirm(name)),
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
    if (ok == true && context.mounted) {
      await context.read<AppProvider>().deletePack(_uid, packId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.packsTitle),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.myPacks),
              Tab(text: l10n.sharedPacks),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MyPacksTab(
              onCreatePack: _createPack,
              onRenamePack: _renamePack,
              onDeletePack: _confirmDelete,
            ),
            _SharedPacksTab(),
          ],
        ),
      ),
    );
  }
}

// ── My Packs tab ──────────────────────────────────────────────────────────────

class _MyPacksTab extends StatelessWidget {
  final Future<void> Function(BuildContext) onCreatePack;
  final Future<void> Function(BuildContext, String, String) onRenamePack;
  final Future<void> Function(BuildContext, String, String) onDeletePack;

  const _MyPacksTab({
    required this.onCreatePack,
    required this.onRenamePack,
    required this.onDeletePack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();
    final packs = provider.packs;

    return Stack(
      children: [
        packs.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open,
                        size: 72, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(l10n.packsEmpty,
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(l10n.packsEmptySubtitle,
                        style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: packs.length,
                itemBuilder: (_, i) {
                  final pack = packs[i];
                  final videos = provider.videosInPack(pack);
                  return PackCard(
                    pack: pack,
                    videos: videos,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PackDetailScreen(pack: pack),
                      ),
                    ),
                    onRename: () =>
                        onRenamePack(context, pack.id, pack.name),
                    onDelete: () =>
                        onDeletePack(context, pack.id, pack.name),
                  );
                },
              ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            heroTag: 'new_pack',
            onPressed: () => onCreatePack(context),
            icon: const Icon(Icons.create_new_folder_outlined),
            label: Text(l10n.newPack),
          ),
        ),
      ],
    );
  }
}

// ── Shared Packs tab ──────────────────────────────────────────────────────────

class _SharedPacksTab extends StatelessWidget {
  void _openPack(BuildContext context, CommunityPackModel pack) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CommunityPackDetailScreen(pack: pack)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();
    final saved = provider.savedCommunityPacks;
    final public = provider.publicCommunityPacks;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Merge: saved + public packs from others not already in saved
    final savedIds = saved.map((p) => p.id).toSet();
    final discover = public
        .where((p) => p.ownerId != uid && !savedIds.contains(p.id))
        .toList();

    final hasContent = saved.isNotEmpty || discover.isNotEmpty;

    return Stack(
      children: [
        !hasContent
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_shared_outlined,
                        size: 72, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(l10n.sharedEmpty,
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(l10n.sharedEmptySubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[400])),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const FindPackScreen())),
                      icon: const Icon(Icons.vpn_key_outlined),
                      label: Text(l10n.packEnterCode),
                    ),
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                children: [
                  if (saved.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(l10n.sharedPacks,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.grey[600])),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: saved.length,
                      itemBuilder: (_, i) => CommunityPackCard(
                        pack: saved[i],
                        onTap: () => _openPack(context, saved[i]),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (discover.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(l10n.packExplore,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.grey[600])),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: discover.length,
                      itemBuilder: (_, i) => CommunityPackCard(
                        pack: discover[i],
                        onTap: () => _openPack(context, discover[i]),
                      ),
                    ),
                  ],
                ],
              ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            heroTag: 'find_pack',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FindPackScreen())),
            icon: const Icon(Icons.vpn_key_outlined),
            label: Text(l10n.packEnterCode),
          ),
        ),
      ],
    );
  }
}
