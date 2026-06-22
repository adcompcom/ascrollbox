import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/firestore_service.dart';
import 'security_questions_screen.dart';

class PinEntryScreen extends StatefulWidget {
  final String uid;
  final bool isSetup;
  // true when resetting after security question verification (skips re-setup of questions)
  final bool skipSecuritySetup;
  final String? existingPinHash;

  const PinEntryScreen({
    super.key,
    required this.uid,
    required this.isSetup,
    this.skipSecuritySetup = false,
    this.existingPinHash,
  });

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String _pin = '';
  String _firstPin = '';
  bool _inConfirm = false;
  bool _error = false;
  bool _loading = false;

  void _onDigit(String d) {
    if (_pin.length >= 6 || _loading) return;
    setState(() {
      _pin += d;
      _error = false;
    });
    if (_pin.length == 6) Future.microtask(_onComplete);
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _onComplete() async {
    if (widget.isSetup) {
      if (!_inConfirm) {
        setState(() {
          _firstPin = _pin;
          _pin = '';
          _inConfirm = true;
        });
      } else {
        if (_pin == _firstPin) {
          setState(() => _loading = true);

          if (widget.skipSecuritySetup) {
            // PIN reset after security question verification — just update hash
            await FirestoreService().resetPinHash(widget.uid, _pin);
            if (mounted) Navigator.pop(context, true);
          } else {
            // First-time setup — save PIN then go set security questions
            await FirestoreService().setPrivatePinHash(widget.uid, _pin);
            if (!mounted) return;
            final done = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    SecurityQuestionsSetupScreen(uid: widget.uid),
              ),
            );
            if (done == true && mounted) {
              Navigator.pop(context, true);
            } else if (mounted) {
              setState(() => _loading = false);
            }
          }
        } else {
          setState(() {
            _pin = '';
            _error = true;
          });
        }
      }
    } else {
      // Verify mode
      if (FirestoreService.verifyPin(_pin, widget.existingPinHash!)) {
        if (mounted) Navigator.pop(context, true);
      } else {
        setState(() {
          _pin = '';
          _error = true;
        });
      }
    }
  }

  void _openRecovery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SecurityQuestionsVerifyScreen(uid: widget.uid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final String title;
    final String subtitle;
    if (widget.isSetup) {
      title = _inConfirm ? l10n.privateConfirmTitle : l10n.privateSetupTitle;
      subtitle =
          _inConfirm ? l10n.privateConfirmSubtitle : l10n.privateSetupSubtitle;
    } else {
      title = l10n.privateTitle;
      subtitle = l10n.privateEnterSubtitle;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Icon(Icons.lock_outline, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 40),
            // PIN dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                final filled = i < _pin.length;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _error
                        ? Colors.red
                        : filled
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                    border: Border.all(
                      color: _error
                          ? Colors.red
                          : filled
                              ? theme.colorScheme.primary
                              : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            AnimatedOpacity(
              opacity: _error ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                widget.isSetup
                    ? l10n.privatePinMismatch
                    : l10n.privatePinWrong,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
            const Spacer(),
            if (_loading)
              const CircularProgressIndicator()
            else ...[
              _PinPad(onDigit: _onDigit, onDelete: _onDelete),
              // "Forgot PIN?" only in verify mode
              if (!widget.isSetup) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _openRecovery,
                  child: Text(
                    l10n.privateForgotPin,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Numeric PIN pad ───────────────────────────────────────────────────────────

class _PinPad extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onDelete;

  const _PinPad({required this.onDigit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          for (final row in [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
            ['', '0', '⌫'],
          ])
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((d) {
                if (d.isEmpty) return const SizedBox(width: 80, height: 64);
                if (d == '⌫') {
                  return _PinButton(label: d, onTap: onDelete, isDelete: true);
                }
                return _PinButton(label: d, onTap: () => onDigit(d));
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _PinButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDelete;

  const _PinButton({
    required this.label,
    required this.onTap,
    this.isDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 64,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isDelete ? 22 : 28,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
