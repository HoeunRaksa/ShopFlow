import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_style.dart';
import '../../../../core/result_ressage.dart';
import '../../../../shared/app_button.dart.dart';
import '../../../../shared/app_select_field.dart';
import '../../../../shared/app_text_field.dart';
import '../../../../shared/payment_count_down_dialog.dart';
import '../../data/model/location_request.dart';
import '../state/checkout_controller_provider.dart';

class LocationForm extends ConsumerStatefulWidget {
  const LocationForm({super.key});

  @override
  ConsumerState<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends ConsumerState<LocationForm> {
  final _key = GlobalKey<FormState>();

  bool _isSubmitting = false;
  bool _isCountdownDialogOpen = false;

  final _receiverCtrl = TextEditingController();
  final _phoneNumberCtrl = TextEditingController();
  final _deliveryAddressCtrl = TextEditingController();
  final _deliveryNoteCtrl = TextEditingController();

  @override
  void dispose() {
    _receiverCtrl.dispose();
    _phoneNumberCtrl.dispose();
    _deliveryAddressCtrl.dispose();
    _deliveryNoteCtrl.dispose();
    super.dispose();
  }
  Future<void> _submitNewLocation() async {
    if (_isSubmitting) return;
    if (!_key.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final request = LocationRequest(
        receiverName: _receiverCtrl.text.trim(),
        phoneNumber: _phoneNumberCtrl.text.trim(),
        deliveryAddress: _deliveryAddressCtrl.text.trim(),
        deliveryNote: _deliveryNoteCtrl.text.trim(),
      );

      final result = await ref
          .read(checkoutProvider.notifier)
          .checkout(null, request);

      if (!mounted) return;
      if (result?.data?.paymentId != null) {
        _showPaymentCountdownDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result?.message ?? "Something went wrong")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
  Future<void> _checkoutExistingLocation(int selectedLocationId) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      final result = await ref
          .read(checkoutProvider.notifier)
          .checkout(selectedLocationId, null);
      if (!mounted) return;
      debugPrint("Payment Id: ${result?.data}");
      if (result?.data?.paymentId != null) {
        _showPaymentCountdownDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result?.message ?? "Checkout failed")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showPaymentCountdownDialog() {
    if (_isCountdownDialogOpen) return;
    _isCountdownDialogOpen = true;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),

      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: PaymentCountdownDialog(
            onDismissed: () {
              if (mounted) {
                setState(() {
                  _isCountdownDialogOpen = false;
                });
              }
            },
          ),
        );
      },

      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        );
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
          ),
        );
        final scaleAnimation = Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              alignment: Alignment.bottomCenter,
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bodySmall = AppStyle.bodySizeSmall(context);
    final iconSize = AppStyle.iconSize(context);
    final w = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context, w);
    final spacing = AppStyle.cardGap(context, w);

    final isSelected = ref.watch(isSelectedProvider);
    final locations = ref.watch(getLocationControllerProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final countdown = ref.watch(paymentCountdownProvider);

    final isLoading =
        checkoutState.isLoading || _isSubmitting || countdown != null;
    ref.listen<ResultMessage<String>?>(
      paymentCallbackResultProvider,
          (previous, next) {
        if (!mounted || next == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(next.message),
              duration: const Duration(seconds: 15),
            ),
          );
        Future.delayed(const Duration(seconds: 15), () {
          if (!mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      },
    );

    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, padding, padding, padding),
            child: Row(
              spacing: spacing,
              children: [
                AppButton(
                  style: !isSelected
                      ? AppButtonStyle.primary
                      : AppButtonStyle.text,
                  isRounded: true,
                  size: AppButtonSize.small,
                  label: "New Location",
                  onPressed: isLoading
                      ? null
                      : () {
                    ref.read(isSelectedProvider.notifier).state = false;
                    ref
                        .read(selectedLocationIdProvider.notifier)
                        .state = null;
                  },
                ),
                AppButton(
                  style: isSelected
                      ? AppButtonStyle.primary
                      : AppButtonStyle.text,
                  isRounded: true,
                  size: AppButtonSize.small,
                  label: "Select Location",
                  onPressed: isLoading
                      ? null
                      : () {
                    ref.read(isSelectedProvider.notifier).state = true;
                  },
                ),
              ],
            ),
          ),
          if (!isSelected) ...[
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer
                    .withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color:
                  theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Add your delivery location information.',
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

            const SizedBox(height: 24),

            AppTextField(
              label: 'Receiver Name',
              hint: 'Enter receiver name',
              controller: _receiverCtrl,
              iosStyle: true,
              prefixIcon: const Icon(Icons.person_outline),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Phone number',
              hint: 'Enter phone number',
              controller: _phoneNumberCtrl,
              iosStyle: true,
              prefixIcon: const Icon(Icons.phone_outlined),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Delivery address',
              hint: 'Enter delivery address',
              controller: _deliveryAddressCtrl,
              iosStyle: true,
              prefixIcon: const Icon(Icons.home_outlined),
              textInputAction: TextInputAction.next,
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Delivery note',
              hint: 'Example: near school, call before arrive',
              controller: _deliveryNoteCtrl,
              iosStyle: true,
              prefixIcon: const Icon(Icons.note_alt_outlined),
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 36),

            AppButton(
              isFullWidth: true,
              isRounded: true,
              label: isLoading ? 'Saving...' : 'Save location',
              prefixIcon: isLoading
                  ? SizedBox(
                width: iconSize,
                height: iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.onPrimary,
                ),
              )
                  : Icon(Icons.check_rounded,
                  size: iconSize, color: theme.colorScheme.onPrimary),
              onPressed: isLoading ? null : _submitNewLocation,
            ),

            const SizedBox(height: 12),

            AppButton(
              isFullWidth: true,
              isRounded: true,
              label: 'Cancel',
              style: AppButtonStyle.text,
              onPressed:
              isLoading ? null : () => Navigator.of(context).pop(),
            ),

            const SizedBox(height: 32),
          ],
          if (isSelected) ...[
            locations.when(
              data: (data) {
                final selectedId = ref.watch(selectedLocationIdProvider);

                if (data.isEmpty) {
                  return const Text("No saved location found");
                }

                final value = selectedId ?? data.first.id;

                return AppSelectField<int>(
                  label: "Select Location",
                  value: value,
                  items: data.map((location) {
                    return DropdownMenuItem<int>(
                      value: location.id,
                      child: Text(
                        "${location.deliveryAddress} (${location.deliveryNote})",
                      ),
                    );
                  }).toList(),
                  onChanged: isLoading
                      ? null
                      : (value) {
                    ref
                        .read(selectedLocationIdProvider.notifier)
                        .state = value;
                  },
                );
              },
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text(e.toString()),
            ),

            const SizedBox(height: 40),

            AppButton(
              isFullWidth: true,
              isRounded: true,
              label: isLoading ? 'Checking out...' : 'Checkout',
              prefixIcon: isLoading
                  ? SizedBox(
                width: iconSize,
                height: iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.onPrimary,
                ),
              )
                  : Icon(Icons.check_rounded,
                  size: iconSize, color: theme.colorScheme.onPrimary),
              onPressed: isLoading
                  ? null
                  : () {
                final locationsValue = locations.value;

                if (locationsValue == null ||
                    locationsValue.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No saved location found"),
                    ),
                  );
                  return;
                }

                final selectedLocationId =
                    ref.read(selectedLocationIdProvider) ??
                        locationsValue.first.id;

                _checkoutExistingLocation(selectedLocationId);
              },
            ),
          ],
        ],
      ),
    );
  }
}