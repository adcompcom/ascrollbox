import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────

abstract final class AppColors {
  // Acentos — extraídos del logo (cubo isométrico)
  static const blue     = Color(0xFF2D6FE8); // cara superior — acción principal
  static const blueLt   = Color(0xFF5B9EF7); // hover / badge bg
  static const red      = Color(0xFFBF2020); // cara derecha — destructivo / YT / FB
  static const redLt    = Color(0xFFE64D4D); // badge bg
  static const green    = Color(0xFF0FA84A); // cara izquierda — éxito / guardado
  static const greenLt  = Color(0xFF2DC76A); // badge éxito
}

// ── Neutral palette (per brightness) ──────────────────────────────────────────

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color bgPrimary;     // tarjetas, sheets
  final Color bgSecondary;   // fondo de pantalla
  final Color bgTertiary;    // separadores, inputs
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color muted;         // íconos de estado vacío, handles de sheets
  final Color tiktok;        // TikTok es negro — en oscuro necesita contraste

  const AppPalette({
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgTertiary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.muted,
    required this.tiktok,
  });

  static const light = AppPalette(
    bgPrimary:     Color(0xFFFFFFFF),
    bgSecondary:   Color(0xFFF2F2F7),
    bgTertiary:    Color(0xFFE5E5EA),
    textPrimary:   Color(0xFF1C1C1E),
    textSecondary: Color(0xFF6C6C70),
    textTertiary:  Color(0xFFAEAEB2),
    muted:         Color(0xFFD1D1D6),
    tiktok:        Color(0xDD000000),
  );

  static const dark = AppPalette(
    bgPrimary:     Color(0xFF1C1C1E),
    bgSecondary:   Color(0xFF000000),
    bgTertiary:    Color(0xFF2C2C2E),
    textPrimary:   Color(0xFFF2F2F7),
    textSecondary: Color(0xFF98989F),
    textTertiary:  Color(0xFF636366),
    muted:         Color(0xFF3A3A3C),
    tiktok:        Color(0xFF3A3A3C),
  );

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      bgPrimary:     Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSecondary:   Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgTertiary:    Color.lerp(bgTertiary, other.bgTertiary, t)!,
      textPrimary:   Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary:  Color.lerp(textTertiary, other.textTertiary, t)!,
      muted:         Color.lerp(muted, other.muted, t)!,
      tiktok:        Color.lerp(tiktok, other.tiktok, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}

// ── Theme builder ─────────────────────────────────────────────────────────────

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final p = isDark ? AppPalette.dark : AppPalette.light;
  final scheme = ColorScheme(
    brightness:           brightness,
    primary:              AppColors.blue,
    onPrimary:            Colors.white,
    // blue / green ~12% sobre la superficie
    primaryContainer:     isDark ? const Color(0xFF1A2E52) : const Color(0xFFD6E4FC),
    onPrimaryContainer:   isDark ? AppColors.blueLt : AppColors.blue,
    secondary:            AppColors.green,
    onSecondary:          Colors.white,
    secondaryContainer:   isDark ? const Color(0xFF0E3A22) : const Color(0xFFCDF4DE),
    onSecondaryContainer: isDark ? AppColors.greenLt : AppColors.green,
    error:                isDark ? AppColors.redLt : AppColors.red,
    onError:              Colors.white,
    surface:              p.bgPrimary,
    onSurface:            p.textPrimary,
    onSurfaceVariant:     p.textSecondary,
    surfaceContainerHighest: p.bgTertiary,
    surfaceContainerHigh:    p.bgSecondary,
    surfaceContainer:        p.bgSecondary,
    outline:              p.bgTertiary,
    outlineVariant:       p.bgTertiary,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    extensions: [p],
    scaffoldBackgroundColor: p.bgSecondary,

    // ── AppBar ──────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      systemOverlayStyle:
          isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      backgroundColor: p.bgPrimary,
      foregroundColor: p.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      shadowColor: Color(0x12000000),
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: p.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: p.textSecondary, size: 22),
    ),

    // ── Cards ───────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: p.bgPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
    ),

    // ── Bottom sheets ───────────────────────────────────────────
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.bgPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
    ),

    // ── Dialogs ─────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: p.bgPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      titleTextStyle: TextStyle(
        color: p.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    ),

    // ── Buttons ─────────────────────────────────────────────────
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.blue,
        side: BorderSide(color: AppColors.blue, width: 1),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: p.bgPrimary,
        foregroundColor: p.textPrimary,
        elevation: 0,
        side: BorderSide(color: p.bgTertiary),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.blue,
        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    ),

    // ── FAB ─────────────────────────────────────────────────────
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // ── Chips ───────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: p.bgTertiary,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    ),

    // ── Inputs ──────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.bgTertiary,
      hintStyle: TextStyle(
          color: p.textTertiary, fontSize: 15),
      labelStyle: TextStyle(color: p.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.blue, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    // ── Divider ─────────────────────────────────────────────────
    dividerTheme: DividerThemeData(
      color: p.bgTertiary,
      thickness: 0.5,
      space: 0,
    ),

    // ── Drawer ──────────────────────────────────────────────────
    drawerTheme: DrawerThemeData(
      backgroundColor: p.bgPrimary,
      elevation: 0,
    ),

    // ── ListTile ────────────────────────────────────────────────
    listTileTheme: ListTileThemeData(
      iconColor: p.textSecondary,
      titleTextStyle: TextStyle(
        color: p.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    ),

    // ── PopupMenu ───────────────────────────────────────────────
    popupMenuTheme: PopupMenuThemeData(
      color: p.bgPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    // ── Switch ──────────────────────────────────────────────────
    // outline == surfaceContainerHighest in this palette, so the M3
    // default (unselected thumb = outline, track = surfaceContainerHighest)
    // renders the thumb invisible against its own track. Give the
    // unselected thumb a darker gray so it's visible.
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? Colors.white
              : p.textTertiary),
      trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? AppColors.blue
              : p.bgTertiary),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? Colors.transparent
              : p.textSecondary),
    ),
  );
}
