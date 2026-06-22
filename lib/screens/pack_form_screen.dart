import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/pack_model.dart';
import '../models/tag_model.dart';
import '../providers/app_provider.dart';

/// Used for both creating a new pack and editing an existing one's metadata.
class PackFormScreen extends StatefulWidget {
  final PackModel? existing; // null = create mode

  const PackFormScreen({super.key, this.existing});

  @override
  State<PackFormScreen> createState() => _PackFormScreenState();
}

class _PackFormScreenState extends State<PackFormScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  final _customTagCtrl = TextEditingController();
  final Set<String> _tags = {};
  bool _saving = false;

  bool get _isEdit => widget.existing != null;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _descCtrl = TextEditingController(text: widget.existing?.description ?? '');
    _tags.addAll(widget.existing?.tags ?? []);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _customTagCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final provider = context.read<AppProvider>();
    try {
      if (_isEdit) {
        // Update name if changed
        if (name != widget.existing!.name) {
          await provider.renamePack(_uid, widget.existing!.id, name);
        }
        // Update description + tags
        await provider.updatePackMeta(
          _uid,
          widget.existing!.id,
          description: _descCtrl.text.trim(),
          tags: _tags.toList(),
        );
      } else {
        await provider.createPack(_uid, name);
        // Get the newly created pack and update its meta
        await Future.delayed(const Duration(milliseconds: 300));
        final newPack = provider.packs.firstOrNull;
        if (newPack != null &&
            (_descCtrl.text.trim().isNotEmpty || _tags.isNotEmpty)) {
          await provider.updatePackMeta(
            _uid,
            newPack.id,
            description: _descCtrl.text.trim(),
            tags: _tags.toList(),
          );
        }
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toggleTag(String tag) => setState(() {
        _tags.contains(tag) ? _tags.remove(tag) : _tags.add(tag);
      });

  void _addCustomTag() {
    final t = _customTagCtrl.text.trim().toLowerCase();
    if (t.isEmpty) return;
    setState(() {
      _tags.add(t);
      _customTagCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.edit : l10n.newPack),
        actions: [
          _saving
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : TextButton(
                  onPressed: _save,
                  child: Text(
                    _isEdit ? l10n.saveChanges : l10n.createPack,
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          // Name
          TextField(
            controller: _nameCtrl,
            autofocus: !_isEdit,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.packName,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Description
          TextField(
            controller: _descCtrl,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.packDescription,
              hintText: l10n.packDescriptionHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          // Tags header
          Text(l10n.labelsTitle, style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),

          // Selected tags
          if (_tags.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _tags
                  .map((t) => Chip(
                        label: Text(t.localized(context)),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () => _toggleTag(t),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
          ],

          // Custom tag input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customTagCtrl,
                  decoration: InputDecoration(
                    hintText: l10n.labelsCustomPlaceholder,
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                  onSubmitted: (_) => _addCustomTag(),
                  textCapitalization: TextCapitalization.none,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                  onPressed: _addCustomTag,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                      minimumSize: const Size(40, 40))),
            ],
          ),
          const SizedBox(height: 12),

          // Predefined tag sections
          ...kTagSections.map((s) => ExpansionTile(
                leading: Text(s.emoji,
                    style: const TextStyle(fontSize: 18)),
                title: Text(s.label(l10n),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: s.tags
                          .map((tag) => FilterChip(
                                label: Text(
                                  '${kTagEmoji[tag] ?? ''} ${tag.localized(context)}'
                                      .trim(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                selected: _tags.contains(tag),
                                onSelected: (_) => _toggleTag(tag),
                                showCheckmark: false,
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
