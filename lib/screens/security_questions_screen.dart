import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/security_question_model.dart';
import '../services/firestore_service.dart';
import 'pin_entry_screen.dart';

// ── Setup mode ────────────────────────────────────────────────────────────────

class SecurityQuestionsSetupScreen extends StatefulWidget {
  final String uid;

  const SecurityQuestionsSetupScreen({super.key, required this.uid});

  @override
  State<SecurityQuestionsSetupScreen> createState() =>
      _SecurityQuestionsSetupScreenState();
}

class _SecurityQuestionsSetupScreenState
    extends State<SecurityQuestionsSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _answers = List<TextEditingController>.generate(3, (_) => TextEditingController());
  final _selected = List<String?>.filled(3, null, growable: false);
  bool _saving = false;
  String? _errorMsg;

  @override
  void dispose() {
    for (final c in _answers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _errorMsg = null);

    // All 3 selected and answered
    if (_selected.any((s) => s == null) ||
        _answers.any((c) => c.text.trim().isEmpty)) {
      setState(() => _errorMsg = l10n.sqSelectAll);
      return;
    }
    // No duplicates
    if (_selected.toSet().length < 3) {
      setState(() => _errorMsg = l10n.sqDuplicate);
      return;
    }

    setState(() => _saving = true);
    final questions = List.generate(3, (i) => {
          'questionId': _selected[i]!,
          'answerHash': FirestoreService.hashAnswer(_answers[i].text),
        });
    await FirestoreService().saveSecurityQuestions(widget.uid, questions);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sqTitle),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            Icon(Icons.shield_outlined, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              l10n.sqSetupSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 28),

            for (int i = 0; i < 3; i++) ...[
              Text(
                '${i + 1}.',
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 6),
              // Question dropdown
              DropdownButtonFormField<String>(
                value: _selected[i],
                hint: Text(l10n.sqSelectHint),
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  isDense: true,
                ),
                items: kSecurityQuestions
                    .map((q) => DropdownMenuItem(
                          value: q.id,
                          child: Text(
                            q.label(l10n),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selected[i] = v),
              ),
              const SizedBox(height: 8),
              // Answer field
              TextField(
                controller: _answers[i],
                decoration: InputDecoration(
                  hintText: l10n.sqAnswerHint,
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  isDense: true,
                ),
                textCapitalization: TextCapitalization.none,
              ),
              const SizedBox(height: 20),
            ],

            if (_errorMsg != null) ...[
              Text(
                _errorMsg!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            _saving
                ? const Center(child: CircularProgressIndicator())
                : FilledButton(
                    onPressed: _save,
                    child: Text(l10n.sqSave),
                  ),
          ],
        ),
      ),
    );
  }
}

// ── Verify mode ───────────────────────────────────────────────────────────────

class SecurityQuestionsVerifyScreen extends StatefulWidget {
  final String uid;

  const SecurityQuestionsVerifyScreen({super.key, required this.uid});

  @override
  State<SecurityQuestionsVerifyScreen> createState() =>
      _SecurityQuestionsVerifyScreenState();
}

class _SecurityQuestionsVerifyScreenState
    extends State<SecurityQuestionsVerifyScreen> {
  List<Map<String, dynamic>>? _questions;
  final _answers = List<TextEditingController>.generate(3, (_) => TextEditingController());
  bool _loading = true;
  bool _saving = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in _answers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final qs = await FirestoreService().getSecurityQuestions(widget.uid);
    if (mounted) setState(() { _questions = qs; _loading = false; });
  }

  Future<void> _verify() async {
    if (_questions == null) return;

    final allCorrect = List.generate(3, (i) {
      final stored = _questions![i]['answerHash'] as String;
      return FirestoreService.verifyAnswer(_answers[i].text, stored);
    }).every((ok) => ok);

    if (!allCorrect) {
      setState(() {
        _error = true;
        for (final c in _answers) { c.clear(); }
      });
      return;
    }

    // Answers correct → go to PIN reset
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PinEntryScreen(
          uid: widget.uid,
          isSetup: true,
          skipSecuritySetup: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sqTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                Icon(Icons.shield_outlined,
                    size: 48, color: theme.colorScheme.primary),
                const SizedBox(height: 12),
                Text(
                  l10n.sqVerifySubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 28),

                for (int i = 0; i < (_questions?.length ?? 0); i++) ...[
                  Text(
                    questionLabel(
                        _questions![i]['questionId'] as String, l10n),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _answers[i],
                    decoration: InputDecoration(
                      hintText: l10n.sqAnswerHint,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      isDense: true,
                      errorText: _error ? '' : null,
                    ),
                    onChanged: (_) => setState(() => _error = false),
                    textCapitalization: TextCapitalization.none,
                  ),
                  const SizedBox(height: 16),
                ],

                if (_error) ...[
                  Text(
                    l10n.sqWrong,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                ],

                _saving
                    ? const Center(child: CircularProgressIndicator())
                    : FilledButton(
                        onPressed: _verify,
                        child: Text(l10n.sqVerify),
                      ),
              ],
            ),
    );
  }
}
