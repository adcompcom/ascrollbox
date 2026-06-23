import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/user_profile_model.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'pin_entry_screen.dart';

class SettingsScreen extends StatefulWidget {
  final User user;
  const SettingsScreen({super.key, required this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _nicknameCtrl;
  Uint8List? _pendingPhotoBytes;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppProvider>().userProfile;
    _nicknameCtrl = TextEditingController(
        text: profile?.nickname.isNotEmpty == true
            ? profile!.nickname
            : widget.user.displayName ?? '');
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    super.dispose();
  }

  String? get _currentPhotoUrl {
    if (_pendingPhotoBytes != null) return null;
    final profile = context.read<AppProvider>().userProfile;
    return profile?.photoUrl ?? widget.user.photoURL;
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (image == null) return;
    final bytes = await image.readAsBytes();
    if (mounted) setState(() => _pendingPhotoBytes = bytes);
  }

  static final _nicknameRegex = RegExp(r'^[a-zA-Z0-9._]+$');

  Future<void> _save() async {
    // Capture context-dependent values before any async gap
    final l10n = AppLocalizations.of(context);
    final provider = context.read<AppProvider>();
    final existingPhotoUrl =
        provider.userProfile?.photoUrl ?? widget.user.photoURL;
    final pendingBytes = _pendingPhotoBytes;
    final nickname = _nicknameCtrl.text.trim();

    // Validate format
    if (nickname.isNotEmpty && !_nicknameRegex.hasMatch(nickname)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nicknameInvalid)),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      String? photoUrl;
      if (pendingBytes != null) {
        photoUrl = await StorageService().uploadProfilePhoto(
          widget.user.uid,
          pendingBytes,
          'image/jpeg',
        );
      }
      photoUrl ??= existingPhotoUrl;

      await provider.saveProfile(
        widget.user.uid,
        UserProfileModel(nickname: nickname, photoUrl: photoUrl),
      );

      if (mounted) {
        setState(() => _pendingPhotoBytes = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileSaved)),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        final msg = e.toString().contains('nickname_taken')
            ? l10n.nicknameTaken
            : e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    context.watch<AppProvider>(); // rebuild when profile changes

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
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
                  child: Text(l10n.save,
                      style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                ),
        ],
      ),
      body: ListView(
        children: [
          // ── Profile section ──────────────────────────────────────
          _SectionHeader(label: l10n.profileSection),

          // Avatar
          Center(
            child: GestureDetector(
              onTap: _pickPhoto,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.15),
                    backgroundImage: _pendingPhotoBytes != null
                        ? MemoryImage(_pendingPhotoBytes!) as ImageProvider
                        : (_currentPhotoUrl != null
                            ? CachedNetworkImageProvider(_currentPhotoUrl!)
                            : null),
                    child: _pendingPhotoBytes == null &&
                            _currentPhotoUrl == null
                        ? Text(
                            (_nicknameCtrl.text.isNotEmpty
                                    ? _nicknameCtrl.text
                                    : widget.user.displayName ?? 'U')[0]
                                .toUpperCase(),
                            style: TextStyle(
                                fontSize: 36,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: theme.colorScheme.surface, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: _pickPhoto,
              icon: const Icon(Icons.photo_library_outlined, size: 16),
              label: Text(l10n.changePhoto,
                  style: const TextStyle(fontSize: 13)),
            ),
          ),
          const SizedBox(height: 12),

          // Nickname
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _nicknameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.nickname,
                hintText: l10n.nicknameHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
          ),

          // Current account info (read-only)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text(widget.user.email ?? '',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.grey[500])),
          ),

          const SizedBox(height: 8),

          // ── Private section ──────────────────────────────────────
          const Divider(),
          _SectionHeader(label: l10n.privateSection),

          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l10n.changePin),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PinEntryScreen(
                  uid: widget.user.uid,
                  isSetup: true,
                  skipSecuritySetup: true,
                ),
              ),
            ),
          ),

          // ── Account section ──────────────────────────────────────
          const Divider(),
          _SectionHeader(label: l10n.accountSection),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.signOut,
                style: const TextStyle(color: Colors.red)),
            onTap: () => AuthService().signOut(),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      );
}
