import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/app_provider.dart';
import 'community_pack_detail_screen.dart';

class FindPackScreen extends StatefulWidget {
  const FindPackScreen({super.key});

  @override
  State<FindPackScreen> createState() => _FindPackScreenState();
}

class _FindPackScreenState extends State<FindPackScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  bool _notFound = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final code = _ctrl.text.trim().toUpperCase();
    if (code.length != 6) return;
    setState(() { _loading = true; _notFound = false; });
    final pack = await context.read<AppProvider>().findPackByCode(code);
    if (!mounted) return;
    setState(() => _loading = false);
    if (pack == null) {
      setState(() => _notFound = true);
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommunityPackDetailScreen(pack: pack),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.packEnterCode)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.vpn_key_outlined,
                size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              l10n.packEnterCode,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _ctrl,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'A3K9F2',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  letterSpacing: 8,
                ),
                border: const OutlineInputBorder(),
                counterText: '',
                errorText: _notFound ? l10n.packNotFound : null,
              ),
              onChanged: (_) => setState(() => _notFound = false),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 20),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : FilledButton.icon(
                    onPressed: _search,
                    icon: const Icon(Icons.search),
                    label: Text(l10n.packSearch),
                  ),
          ],
        ),
      ),
    );
  }
}
