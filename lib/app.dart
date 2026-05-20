import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeType = ref.watch(themeTypeProvider);
    final themeMode = ref.watch(themeModeProvider);

    ThemeData lightTheme = AppTheme.light;
    ThemeData darkTheme = AppTheme.dark;

    if (themeType == AppThemeType.midnight) {
      darkTheme = AppTheme.midnight;
    } else if (themeType == AppThemeType.forest) {
      lightTheme = AppTheme.forest;
    }

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
    );
  }
}