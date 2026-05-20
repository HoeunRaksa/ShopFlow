import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/app_style.dart';

import '../../../../shared/app_button.dart.dart';
import '../../../../shared/app_text_field.dart';
import '../../data/models/VerifyOtpRequest.dart';
import '../states/auth_controller.dart';


class OtpView extends ConsumerStatefulWidget {
  final String email;

  const OtpView({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends ConsumerState<OtpView> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final request = VerifyOtpRequest(
      email: widget.email,
      code: _codeController.text.trim(),
    );

    final success =
    await ref.read(authControllerProvider.notifier).verifyOtp(request);

    final state = ref.read(authControllerProvider);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error ?? "OTP verification failed")),
      );
      return;
    }
    context.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final padding = AppStyle.padding(context, w);
        final titleSize = AppStyle.titleSize(context, w);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: AppStyle.maxWidth(context)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Verify OTP",
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Enter the code sent to:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.email,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 32),
                        AppTextField(
                          label: "OTP Code",
                          hint: "Enter 6-digit code",
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(Icons.lock_outline),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _verifyOtp(),
                          maxLength: 6,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "OTP is required";
                            }

                            if (value.length != 6) {
                              return "OTP must be 6 digits";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          label: "Verify",
                          isFullWidth: true,
                          isLoading: authState.isLoading,
                          onPressed: authState.isLoading ? null : _verifyOtp,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // optional resend logic
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Resend OTP not implemented yet"),
                                ),
                              );
                            },
                            child: const Text("Resend Code"),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Back"),
                          ),
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