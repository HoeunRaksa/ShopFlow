import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/user_profile/data/model/user_change_password_request.dart';
import 'package:newprovider/shared/app_text_field.dart';
import '../../../../core/app_style.dart';
import '../../../../shared/app_button.dart.dart';
import '../state/user_contoller.dart';

class PasswordForm extends ConsumerStatefulWidget {
  const PasswordForm({super.key});

  @override
  ConsumerState<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends ConsumerState<PasswordForm> {
  final _key = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodySmall = AppStyle.bodySizeSmall(context);
    final iconSize = AppStyle.iconSize(context);
    final loading = ref.watch(changePasswordLoadingProvider);
    Future<String> changePassWord(UserChangePasswordRequest request) async {
      String message = await ref
          .read(userControllerProvider.notifier)
          .changePassword(request);
      return message;
    }

    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header hint ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.6,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your new password must be at least 8 characters.',
                        style: TextStyle(
                          fontSize: bodySmall,
                          color: theme.colorScheme.onPrimaryContainer,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // ── Current password card ─────────────────────────────
              AppTextField(
                label: 'Current password',
                hint: 'Required',
                controller: _currentCtrl,
                isPassword: true,
                iosStyle: true,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  AppTextField(
                    label: 'New password',
                    hint: 'At least 8 characters',
                    controller: _newCtrl,
                    isPassword: true,
                    iosStyle: true,
                    prefixIcon: const Icon(Icons.lock_reset_rounded),
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (v.length < 8) return 'Minimum 8 characters';
                      return null;
                    },
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  AppTextField(
                    label: 'Confirm password',
                    hint: 'Re-enter new password',
                    controller: _confirmCtrl,
                    isPassword: true,
                    iosStyle: true,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (v != _newCtrl.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 36),
              AppButton(
                isFullWidth: true,
                isRounded: true,
                label: 'Update password',
                prefixIcon: Icon(
                  Icons.check_rounded,
                  size: iconSize,
                  color: theme.colorScheme.onPrimary,
                ),
                onPressed: loading
                    ? null
                    : () async {
                        if (_key.currentState!.validate()) {
                          final userRequest = UserChangePasswordRequest(
                            currentPassword: _currentCtrl.text,
                            newPassword: _newCtrl.text,
                          );
                          final message = await changePassWord(userRequest);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        }
                      },
              ),
              const SizedBox(height: 12),
              AppButton(
                isFullWidth: true,
                isRounded: true,
                label: 'Cancel',
                style: AppButtonStyle.text,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
