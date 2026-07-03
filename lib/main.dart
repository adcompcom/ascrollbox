import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'l10n/generated/app_localizations.dart';
import 'models/video_model.dart';
import 'providers/app_provider.dart';
import 'screens/community_pack_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/firestore_service.dart';
import 'services/metadata_service.dart';
import 'services/storage_service.dart';
import 'theme.dart';

// ── Splash screen ─────────────────────────────────────────────────────────────

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(flex: 2),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset('assets/icon.png', width: 88, height: 88),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ascrollbox',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2),
          Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Entry point ───────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ShareActivity sets initialRoute to '/share'. Detect it here so we skip
  // the full app stack and show only the share bottom sheet.
  final isShare =
      WidgetsBinding.instance.platformDispatcher.defaultRouteName == '/share';

  if (isShare) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await _activateAppCheck();
    runApp(const _ShareApp());
    return;
  }

  runApp(const _SplashApp());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _activateAppCheck();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const App(),
    ),
  );
}

// ── App Check ─────────────────────────────────────────────────────────────────

Future<void> _activateAppCheck() async {
  await FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode
        ? AndroidProvider.debug
        : AndroidProvider.playIntegrity,
  );
}

// ── Normal app ────────────────────────────────────────────────────────────────

class _SplashApp extends StatelessWidget {
  const _SplashApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _SplashScreen(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    _initLinks();
  }

  Future<void> _initLinks() async {
    final appLinks = AppLinks();

    // Links received while the app is already running
    _linkSub = appLinks.uriLinkStream.listen(_handleLink);

    // Link that opened the app from a cold/warm start
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final initial = await appLinks.getInitialLink();
      if (initial != null) _handleLink(initial);
    });
  }

  void _handleLink(Uri uri) {
    String? code;

    if (uri.scheme == 'https' && uri.host == 'ascrollbox.web.app') {
      // https://ascrollbox.web.app/p/A3K9F2  (App Link — Chrome / verified browsers)
      final segments = uri.pathSegments;
      if (segments.length >= 2 && segments[0] == 'p') {
        code = segments[1];
      }
    } else if (uri.scheme == 'ascrollbox' && uri.host == 'pack') {
      // ascrollbox://pack/A3K9F2  (custom scheme — WhatsApp WebView)
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) code = segments[0];
    }

    if (code != null && code.isNotEmpty) {
      _openPackByCode(code.toUpperCase());
    }
  }

  Future<void> _openPackByCode(String code) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final pack = await FirestoreService().findPackByCode(code);
      if (pack == null) return;

      _navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => CommunityPackDetailScreen(pack: pack),
        ),
      );

      // Auto-save to Compartidos when opened via a shared link,
      // unless the user is the owner or already has it saved.
      if (pack.ownerId == user.uid) return;
      final ctx = _navigatorKey.currentContext;
      if (ctx == null) return;
      final provider = ctx.read<AppProvider>();
      if (!provider.isSavedCommunityPack(pack.id)) {
        await provider.saveCommunityPack(user.uid, pack.id);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Ascrollbox',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('de'),
        Locale('pt'),
      ],
      theme: buildTheme(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _SplashScreen();
          }
          final user = snapshot.data;
          if (user != null) return HomeScreen(user: user);
          return const LoginScreen();
        },
      ),
    );
  }
}

// ── Share app (runs inside ShareActivity) ─────────────────────────────────────

class _ShareApp extends StatelessWidget {
  const _ShareApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildTheme().copyWith(scaffoldBackgroundColor: Colors.transparent),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('de'),
        Locale('pt'),
      ],
      home: const _ShareScreen(),
    );
  }
}

class _ShareScreen extends StatefulWidget {
  const _ShareScreen({super.key});

  @override
  State<_ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<_ShareScreen> {
  static const _channel = MethodChannel('ascrollbox/share');
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    final raw = await _channel.invokeMethod<String>('getSharedText') ?? '';
    final url = MetadataService.extractUrl(raw) ?? raw.trim();

    if (url.isEmpty || !url.startsWith('http')) {
      _close();
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || !mounted) {
      _close();
      return;
    }

    bool handled = false;

    await showSaveSheet(
      context,
      url: url,
      onSave: (tags, isPrivate) {
        handled = true;
        Navigator.pop(context);
        // Save keeps running after the sheet closes — show a spinner
        // instead of a blank screen so it doesn't look frozen.
        setState(() => _saving = true);
        _saveAndClose(user.uid, url, tags, isPrivate);
      },
      onCancel: () {
        handled = true;
        Navigator.pop(context);
        _close();
      },
    );

    // Bottom sheet was swiped away without tapping a button
    if (!handled) _close();
  }

  Future<void> _saveAndClose(
      String uid, String url, List<String> tags, bool isPrivate) async {
    try {
      final meta = await MetadataService().fetch(url);

      final thumbnailUrl = meta.thumbnailUrl.isNotEmpty
          ? (await StorageService().uploadThumbnail(uid, meta.thumbnailUrl) ??
              meta.thumbnailUrl)
          : '';

      await FirestoreService().addVideo(
        uid,
        VideoModel(
          id: '',
          url: url,
          platform: meta.platform,
          title: meta.title.isEmpty ? url : meta.title,
          thumbnailUrl: thumbnailUrl,
          tags: tags,
          packIds: [],
          createdAt: DateTime.now(),
          isPrivate: isPrivate,
        ),
      );
    } finally {
      _close();
    }
  }

  void _close() => _channel.invokeMethod<void>('close');

  @override
  Widget build(BuildContext context) {
    if (!_saving) return const Scaffold(backgroundColor: Colors.transparent);

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              const SizedBox(width: 14),
              Text(l10n.saving,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
