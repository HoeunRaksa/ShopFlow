import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/app_style.dart';
import '../../../../core/app_size.dart';
import '../../../../shared/app_button.dart.dart';
import '../../../../shared/app_text_field.dart';
import '../../data/models/LoginRequest.dart';
import '../states/auth_controller.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const Color _primary = Color(0xFF185FA5);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final request = LoginRequest(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final success =
    await ref.read(authControllerProvider.notifier).login(request);

    print("LOGIN SUCCESS = $success"); // ← add this

    if (!mounted) return;

    if (!success) {
      final error = ref.read(authControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? "Login failed"),
          backgroundColor: const Color(0xFFA32D2D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    context.goNamed('otp', extra: request.email.trim());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final padding = AppStyle.padding(context, w);
        final maxWidth = AppStyle.maxWidth(context);
        final titleSize = AppStyle.titleSize(context, w);

        return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Logo / Header ──────────────────────────────
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: _primary,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: _primary.withOpacity(0.35),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.storefront_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: titleSize,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0D1B2A),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Sign in to your account",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // ── Form Card ──────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Email ────────────────────────────
                              _FieldLabel(label: "Email Address"),
                              const SizedBox(height: 8),
                              AppTextField(
                                hint: "you@example.com",
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                prefixIcon:
                                const Icon(Icons.email_outlined, size: 18),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Email is required";
                                  }
                                  if (!value.contains("@")) {
                                    return "Invalid email address";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // ── Password ─────────────────────────
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const _FieldLabel(label: "Password"),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              AppTextField(
                                hint: "Min 6 characters",
                                controller: _passwordController,
                                isPassword: true,
                                prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    size: 18),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _login(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is required";
                                  }
                                  if (value.length < 6) {
                                    return "Minimum 6 characters";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 28),

                              // ── Login Button ─────────────────────
                              AppButton(
                                label: "Sign In",
                                isFullWidth: true,
                                isRounded: true,
                                size: AppButtonSize.large,
                                isLoading: authState.isLoading,
                                onPressed:
                                authState.isLoading ? null : _login,
                                suffixIcon: authState.isLoading
                                    ? null
                                    : const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Register ───────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => context.goNamed('register'),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )),);
      },
    );
  }
}

// ── Supporting Widgets ────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0D1B2A),
        letterSpacing: 0.1,
      ),
    );
  }
}