import 'package:flutter/material.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────

abstract final class AppColors {
  // Acentos — extraídos del logo (cubo isométrico)
  static const blue     = Color(0xFF2D6FE8); // cara superior — acción principal
  static const blueLt   = Color(0xFF5B9EF7); // hover / badge bg
  static const red      = Color(0xFFBF2020); // cara derecha — destructivo / YT / FB
  static const redLt    = Color(0xFFE64D4D); // badge bg
  static const green    = Color(0xFF0FA84A); // cara izquierda — éxito / guardado
  static const greenLt  = Color(0xFF2DC76A); // badge éxito

  // Fondos
  static const bgPrimary   = Color(0xFFFFFFFF); // tarjetas, sheets
  static const bgSecondary = Color(0xFFF2F2F7); // fondo de pantalla
  static const bgTertiary  = Color(0xFFE5E5EA); // separadores, inputs

  // Texto
  static const textPrimary   = Color(0xFF1C1C1E);
  static const textSecondary = Color(0xFF6C6C70);
  static const textTertiary  = Color(0xFFAEAEB2);
}

// ── Theme builder ─────────────────────────────────────────────────────────────

ThemeData buildTheme() {
  const scheme = ColorScheme.light(
    primary:              AppColors.blue,
    onPrimary:            Colors.white,
    primaryContainer:     Color(0xFFD6E4FC), // blue ~12% sobre blanco
    onPrimaryContainer:   AppColors.blue,
    secondary:            AppColors.green,
    onSecondary:          Colors.white,
    secondaryContainer:   Color(0xFFCDF4DE),
    onSecondaryContainer: AppColors.green,
    error:                AppColors.red,
    onError:              Colors.white,
    surface:              AppColors.bgPrimary,
    onSurface:            AppColors.textPrimary,
    onSurfaceVariant:     AppColors.textSecondary,
    surfaceContainerHighest: AppColors.bgTertiary,
    surfaceContainerHigh:    AppColors.bgSecondary,
    surfaceContainer:        AppColors.bgSecondary,
    outline:              AppColors.bgTertiary,
    outlineVariant:       AppColors.bgTertiary,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bgSecondary,

    // ── AppBar ──────────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgPrimary,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      shadowColor: Color(0x12000000),
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: AppColors.textSecondary, size: 22),
    ),

    // ── Cards ───────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColors.bgPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
    ),

    // ── Bottom sheets ───────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.bgPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
    ),

    // ── Dialogs ─────────────────────────────────────────────────
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.bgPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
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
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.blue,
        side: const BorderSide(color: AppColors.blue, width: 1),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        side: const BorderSide(color: AppColors.bgTertiary),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.blue,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
      backgroundColor: AppColors.bgTertiary,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    ),

    // ── Inputs ──────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgTertiary,
      hintStyle: const TextStyle(
          color: AppColors.textTertiary, fontSize: 15),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
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
        borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    // ── Divider ─────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.bgTertiary,
      thickness: 0.5,
      space: 0,
    ),

    // ── Drawer ──────────────────────────────────────────────────
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.bgPrimary,
      elevation: 0,
    ),

    // ── ListTile ────────────────────────────────────────────────
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.textSecondary,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    ),

    // ── PopupMenu ───────────────────────────────────────────────
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.bgPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}
