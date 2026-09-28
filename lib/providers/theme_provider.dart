import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the user's light/dark preference. Defaults to following the system.
class ThemeProvider extends ChangeNotifier {
  static const _key = 'theme_mode';

  ThemeMode _mode;
  ThemeProvider._(this._mode);

  ThemeMode get mode => _mode;

  /// Loaded before the first frame so the app never flashes the wrong theme.
  static Future<ThemeProvider> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);
      final mode = ThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => ThemeMode.system,
      );
      return ThemeProvider._(mode);
    } catch (_) {
      return ThemeProvider._(ThemeMode.system);
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}
