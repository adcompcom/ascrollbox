import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'l10n/generated/app_localizations.dart';
import 'models/video_model.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/firestore_service.dart';
import 'services/metadata_service.dart';
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
    runApp(const _ShareApp());
    return;
  }

  runApp(const _SplashApp());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const App(),
    ),
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

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      supportedLocales: const [Locale('en'), Locale('es')],
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
      onSave: (tags) {
        handled = true;
        Navigator.pop(context);
        _saveAndClose(user.uid, url, tags);
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

  Future<void> _saveAndClose(String uid, String url, List<String> tags) async {
    try {
      final meta = await MetadataService().fetch(url);
      await FirestoreService().addVideo(
        uid,
        VideoModel(
          id: '',
          url: url,
          platform: meta.platform,
          title: meta.title.isEmpty ? url : meta.title,
          thumbnailUrl: meta.thumbnailUrl,
          tags: tags,
          packIds: [],
          createdAt: DateTime.now(),
        ),
      );
    } finally {
      _close();
    }
  }

  void _close() => _channel.invokeMethod<void>('close');

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.transparent);
  }
}
