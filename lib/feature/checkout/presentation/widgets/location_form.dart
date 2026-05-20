import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_style.dart';
import '../../../../shared/app_button.dart.dart';
import '../../../../shared/app_select_field.dart';
import '../../../../shared/app_text_field.dart';
import '../../data/model/location_request.dart';
import '../../data/model/location_response.dart';
import '../state/checkout_controller_provider.dart';

class LocationForm extends ConsumerStatefulWidget {
  const LocationForm({super.key});

  @override
  ConsumerState<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends ConsumerState<LocationForm> {
  final _key = GlobalKey<FormState>();
  final _receiverCtrl = TextEditingController();
  final _phoneNumberCtrl = TextEditingController();
  final _deliveryAddressCtrl = TextEditingController();
  final _deliveryNoteCtrl = TextEditingController();
  String? _selectedCategory;
  final List<String> _categoryItems = ["Home", "Office", "School"];

  @override
  void dispose() {
    _receiverCtrl.dispose();
    _phoneNumberCtrl.dispose();
    _deliveryAddressCtrl.dispose();
    _deliveryNoteCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_key.currentState!.validate()) return;
    final request = LocationRequest(
      receiverName: _receiverCtrl.text.trim(),
      phoneNumber: _phoneNumberCtrl.text.trim(),
      deliveryAddress: _deliveryAddressCtrl.text.trim(),
      deliveryNote: _deliveryNoteCtrl.text.trim(),
    );
    print(request);
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
    final locations = ref.watch(checkoutControllerProvider);
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Toggle buttons ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(0, padding, padding, padding),
            child: Row(
              spacing: spacing,
              children: [
                AppButton(
                    style: !isSelected ? AppButtonStyle.primary : AppButtonStyle.text,
                  isRounded: true,
                  size: AppButtonSize.small,
                  label: "New Location",
                  onPressed: () {
                    ref.read(isSelectedProvider.notifier).state = false;
                  }
                ),
                AppButton(
                  style: isSelected ? AppButtonStyle.primary : AppButtonStyle.text,
                  isRounded: true,
                  size: AppButtonSize.small,
                  label: "Select Location",
                  onPressed: () => ref.read(isSelectedProvider.notifier).state = true,
                ),
              ],
            ),
          ),

          // ── New Location form ───────────────────────────────────
          if (!isSelected) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    Icons.location_on_outlined,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
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

            // ✅ Fixed: now correctly uses _receiverCtrl
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
              label: 'Save location',
              prefixIcon: Icon(
                Icons.check_rounded,
                size: iconSize,
                color: theme.colorScheme.onPrimary,
              ),
              onPressed: _submit,
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

          // ── Select existing location ────────────────────────────
          if (isSelected) ...[

            locations.when(
              data: (data) {
                final selectedId = ref.watch(selectedLocationIdProvider);
                return AppSelectField<int>(
                  label: "Select Location",
                  value: selectedId,
                  items: data.map((location) {
                    return DropdownMenuItem<int>(
                      value: location.id,
                      child: Text(location.deliveryAddress),
                    );
                  }).toList(),
                  onChanged: (value) {
                    ref.read(selectedLocationIdProvider.notifier).state = value;
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, s) => Text(e.toString()),
            ),

            const SizedBox(height: 24),
            const SizedBox(height: 16),

            AppButton(
              isFullWidth: true,
              isRounded: true,
              label: 'Save location',
              prefixIcon: Icon(
                Icons.check_rounded,
                size: iconSize,
                color: theme.colorScheme.onPrimary,
              ),
              onPressed: _submit,
            ),
          ],
        ],
      ),
    );
  }
}
