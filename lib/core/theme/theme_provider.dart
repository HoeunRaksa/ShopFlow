import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeType {
  light,
  dark,
  system,
  midnight,
  forest,
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final themeTypeProvider =
StateNotifierProvider<ThemeController, AppThemeType>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeController(prefs);
});

class ThemeController extends StateNotifier<AppThemeType> {
  final SharedPreferences prefs;

  static const String _themeKey = "selected_theme";

  ThemeController(this.prefs) : super(AppThemeType.system) {
    loadTheme();
  }

  void loadTheme() {
    final savedTheme = prefs.getString(_themeKey);

    if (savedTheme == null) return;

    state = AppThemeType.values.firstWhere(
          (theme) => theme.name == savedTheme,
      orElse: () => AppThemeType.system,
    );
  }

  Future<void> changeTheme(AppThemeType theme) async {
    state = theme;
    await prefs.setString(_themeKey, theme.name);
  }
}

final themeModeProvider = Provider<ThemeMode>((ref) {
  final type = ref.watch(themeTypeProvider);

  switch (type) {
    case AppThemeType.light:
    case AppThemeType.forest:
      return ThemeMode.light;

    case AppThemeType.dark:
    case AppThemeType.midnight:
      return ThemeMode.dark;

    case AppThemeType.system:
      return ThemeMode.system;
  }
});