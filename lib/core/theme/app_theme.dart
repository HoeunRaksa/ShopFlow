import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const Color primary = Color(0xFF185FA5);
  static const Color primaryDark = Color(0xFF1A73E8);
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);
  static ThemeData get midnight =>
      _buildTheme(Brightness.dark, seed: Colors.indigo);
  static ThemeData get forest =>
      _buildTheme(Brightness.light, seed: Colors.green);
  static void toggleTheme() {
    themeNotifier.value =
    themeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }
  static ThemeData _buildTheme(
      Brightness brightness, {
        Color seed = primary,
      }) {
    final bool isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: seed,
      scaffoldBackgroundColor:
      isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBarTheme: AppBarTheme(
        backgroundColor:
        isDark ? const Color(0xFF0F172A) : Colors.white,
        foregroundColor:
        isDark
            ? Colors.white
            : const Color(0xFF0D1B2A),
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side:
          isDark
              ? BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          )
              : BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        color:
        isDark
            ? const Color(0xFF1E293B)
            : Colors.white,
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color:
        isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.05),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
        isDark
            ? const Color(0xFF1E293B)
            : const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}