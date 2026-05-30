import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/feature/history/presentation/view/order_history_view.dart';
import 'package:newprovider/feature/splash/presentation/view/splash_view.dart';
import 'package:newprovider/feature/user_profile/presentation/view/change_password_view.dart';

import '../../feature/auth/presentation/states/auth_controller.dart';
import '../../feature/auth/presentation/views/login_view.dart';
import '../../feature/auth/presentation/views/otp_view.dart';
import '../../feature/auth/presentation/views/register_view.dart';
import '../../feature/checkout/presentation/view/checkout_view.dart';
import '../../feature/home/presentation/view/home_view.dart';
import '../../feature/product/presentation/view/product_management.dart';
import '../../feature/product/presentation/view/product_view.dart';
import '../../feature/profile_owner/presentaion/view/owner_content_view.dart';
import '../../feature/profile_owner/presentaion/view/owner_profile_view.dart';
import '../../feature/upgradePlan/presentation/view/plan_payment_view.dart';
import '../../feature/user_profile/data/model/UserResponse.dart';
import '../../feature/user_profile/presentation/view/create_contact_view.dart';
import '../../feature/user_profile/presentation/view/profile_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',

    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text("Route Error")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Text(state.error?.toString() ?? "Page not found"),
        ),
      );
    },

    redirect: (context, state) {
      final loggedIn = ref.read(authControllerProvider).isAuthenticated;
      final path = state.matchedLocation;

      final isAuthPage =
          path == '/login' ||
          path == '/register' ||
          path == '/otp' ||
          path == '/splash' ||
          path == '/';

      if (!loggedIn && !isAuthPage) {
        return '/login';
      }

      return null;
    },

    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/splash'),

      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashView(),
      ),

      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterView(),
      ),

      GoRoute(
        path: '/payment-view/:id',
        name: 'payment-view',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PlanPaymentView(subscriptionId: id);
        },
      ),

      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final email = state.extra;

          if (email is! String || email.isEmpty) {
            return const LoginView();
          }

          return OtpView(email: email);
        },
      ),

      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),

      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutView(),
      ),

      GoRoute(
        path: '/product/:id',
        name: 'product',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductView(productId: id);
        },
      ),

      GoRoute(
        path: '/product-management',
        name: 'productManagementCreate',
        builder: (context, state) => const ProductManagement(),
      ),

      GoRoute(
        path: '/product-management/:id',
        name: 'productManagementUpdate',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductManagement(productId: id);
        },
      ),

      GoRoute(
        path: '/passwordChanges',
        name: 'passwordChanges',
        builder: (context, state) => const ChangePasswordView(),
      ),

      GoRoute(
        path: '/notification',
        name: 'notification',
        builder: (context, state) => const ChangePasswordView(),
      ),

      GoRoute(
        path: '/create-contact',
        name: 'create-contact',
        builder: (context, state) {
          return const CreateContactView();
        },
      ),

      GoRoute(
        path: '/owner/:id',
        name: 'owner',
        builder: (context, state) {
          final userId = int.parse(state.pathParameters['id']!);
          return OwnerProfileView(userId: userId);
        },
      ),

      GoRoute(
        path: '/owner-content',
        name: 'owner-content',
        builder: (context, state) {
          final user = state.extra as UserResponse;
          return OwnerContentView(user: user);
        },
      ),

      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) {
          final user = state.extra as UserResponse;
          return ProfileView(user: user, hasAppBar: true,);
        },
      ),

      GoRoute(
        path: '/order-history',
        name: 'order-history',
        builder: (context, state) {
          return OrderHistoryView();
        },
      ),

    ],
  );
});
