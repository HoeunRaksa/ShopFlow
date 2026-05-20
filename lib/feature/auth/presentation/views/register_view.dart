import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/app_style.dart';
import '../../../../core/app_size.dart';
import '../../../../shared/app_button.dart.dart';
import '../../../../shared/app_text_field.dart';


import '../../data/models/RegisterRequest.dart';
import '../states/auth_controller.dart';
import 'otp_view.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final request = RegisterRequest(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    await ref.read(authControllerProvider.notifier).register(request);

    final state = ref.read(authControllerProvider);

    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!)),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpView(email: request.email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final padding = AppStyle.padding(context, w);
        final titleSize = AppStyle.titleSize(context, w);
        final subtitleSize = AppStyle.bodySize(context, w);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: AppStyle.maxWidth(context)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Register to continue with Furniture App",
                          style: TextStyle(
                            fontSize: subtitleSize,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 32),
                        AppTextField(
                          label: "First Name",
                          hint: "Enter first name",
                          controller: _firstNameController,
                          prefixIcon: const Icon(Icons.person_outline),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "First name is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: "Last Name",
                          hint: "Enter last name",
                          controller: _lastNameController,
                          prefixIcon: const Icon(Icons.person_outline),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Last name is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: "Email",
                          hint: "Enter email",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.email_outlined),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Email is required";
                            }

                            if (!value.contains("@")) {
                              return "Please enter a valid email";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: "Password",
                          hint: "Enter password",
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: const Icon(Icons.lock_outline),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _register(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Password is required";
                            }

                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          label: "Register",
                          isFullWidth: true,
                          isLoading: authState.isLoading,
                          onPressed: authState.isLoading ? null : _register,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push("/login");
                              },
                              child: const Text("Login"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}