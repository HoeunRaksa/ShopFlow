import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/feature/user_profile/presentation/state/user_contoller.dart';
import '../../../auth/presentation/states/auth_controller.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(_checkAuth);
  }

  Future<void> _checkAuth() async {
    await ref.read(authControllerProvider.notifier).loadSavedToken();

    final loggedIn = ref.read(authControllerProvider).isAuthenticated;

    if (!mounted) return;

    if (!loggedIn) {
      context.go('/login');
      return;
    }

    try {
      await ref.read(userControllerProvider.future);

      if (!mounted) return;
      context.go('/home');
    } catch (_) {
      await ref.read(authControllerProvider.notifier).logout();

      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}