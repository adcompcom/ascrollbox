import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/app_provider.dart';
import '../widgets/pack_card.dart';
import 'pack_detail_screen.dart';

class PacksScreen extends StatelessWidget {
  const PacksScreen({super.key});

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> _createPack(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.newPack),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.packName,
            border: const OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(l10n.createPack),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty && context.mounted) {
      await context.read<AppProvider>().createPack(_uid, name);
    }
  }

  Future<void> _renamePack(
      BuildContext context, String packId, String current) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: current);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.renamePack),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty && context.mounted) {
      await context.read<AppProvider>().renamePack(_uid, packId, name);
    }
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
    final provider = context.watch<AppProvider>();
    final packs = provider.packs;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.packsTitle), centerTitle: true),
      body: packs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 72, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(l10n.packsEmpty,
                      style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(l10n.packsEmptySubtitle,
                      style: TextStyle(color: Colors.grey[400])),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  onRename: () => _renamePack(context, pack.id, pack.name),
                  onDelete: () =>
                      _confirmDelete(context, pack.id, pack.name),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createPack(context),
        icon: const Icon(Icons.create_new_folder_outlined),
        label: Text(l10n.newPack),
      ),
    );
  }
}
