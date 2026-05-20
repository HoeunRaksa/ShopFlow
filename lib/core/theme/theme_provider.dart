import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum AppThemeType {
  light,
  dark,
  system,
  midnight,
  forest,
}

final themeTypeProvider =
StateProvider<AppThemeType>((ref) => AppThemeType.system);

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