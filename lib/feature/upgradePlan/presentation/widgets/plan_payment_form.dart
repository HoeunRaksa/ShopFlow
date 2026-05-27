import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/checkout/presentation/state/checkout_controller_provider.dart';
import 'package:newprovider/feature/upgradePlan/data/model/upgrade_subscription_request.dart';
import 'package:newprovider/feature/upgradePlan/presentation/state/upgrade_plan_controller.dart';
import 'package:newprovider/shared/app_button.dart.dart';
import 'package:newprovider/shared/app_text_field.dart';
import 'package:newprovider/shared/payment_count_down_dialog.dart';
import '../../../../core/app_style.dart';
import '../../../user_profile/presentation/state/user_contoller.dart';
import '../../data/model/subscription_plan_response.dart';

class PlanPaymentForm extends ConsumerStatefulWidget {
  final SubscriptionPlanResponse subscriptionPlanResponse;
  const PlanPaymentForm({super.key, required this.subscriptionPlanResponse});

  @override
  ConsumerState<PlanPaymentForm> createState() => _PlanPaymentScreenState();
}

class _PlanPaymentScreenState extends ConsumerState<PlanPaymentForm> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _cardNumberCtr;
  late final TextEditingController _expiryDate;
  late final TextEditingController _securityCode;

  @override
  void initState() {
    super.initState();
    _cardNumberCtr = TextEditingController();
    _expiryDate = TextEditingController();
    _securityCode = TextEditingController();
  }

  @override
  void dispose() {
    _cardNumberCtr.dispose();
    _expiryDate.dispose();
    _securityCode.dispose();
    super.dispose();
  }

  void selectExpireDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      helpText: 'Select expiry date',
    );
    if (picked != null) {
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      _expiryDate.text = '$month/$year';
    }
  }
  bool _paymentInProgress = false;
  Future<void> _handlePay(UpgradeSubscriptionRequest request) async {
    if (!_key.currentState!.validate()) return;
    showGeneralDialog(
      context: context,
      barrierLabel: "Payment processing",
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: PaymentCountdownDialog(
            onDismissed: () {
              Navigator.pop(dialogContext);
            },
            onConfirm: () async {
              final navigator = Navigator.of(dialogContext);
              debugPrint("CONFIRM CLICKED");
              if(_paymentInProgress) return;
              _paymentInProgress = true;
              final upgradeResponse = await ref
                  .read(upgradePlanControllerProvider.notifier)
                  .subscriptionMake(request);
              debugPrint("UPGRADE RESPONSE = $upgradeResponse");
              debugPrint("PAYMENT ID = ${upgradeResponse?.paymentId}");
              final paymentId = upgradeResponse?.paymentId;
              if (paymentId == null) {
                _paymentInProgress = false;
                return;
              }
              await ref.read(checkoutProvider.notifier).startPayment(paymentId);
               ref.refresh(userControllerProvider);
              navigator.pop();
            },
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(upgradePlanControllerProvider);
    final plan = widget.subscriptionPlanResponse;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sectionGap = AppStyle.sectionGap(context);
    final cardGap = AppStyle.cardGap(context);
    final bottomSpace = AppStyle.bottomSpace(context);
    final bodySmall = AppStyle.bodySizeSmall(context);
    final iconSz = AppStyle.iconSize(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PlanSummaryCard(plan: plan),

        SizedBox(height: cardGap * 1.5),
        Text(
          'Card details',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: sectionGap * 0.5),
        Text(
          'Your payment is secured with 256-bit SSL encryption.',
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: bodySmall,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        SizedBox(height: cardGap),
        const _CardBrandRow(),
        SizedBox(height: cardGap * 1.1),
        Form(
          key: _key,
          child: Column(
            spacing: cardGap,
            children: [
              AppTextField(
                controller: _cardNumberCtr,
                label: 'Card Number',
                hint: '1234 5678 9012 3456',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _CardNumberFormatter(),
                ],
                validator: (v) =>
                    (v == null || v.replaceAll(' ', '').length < 16)
                    ? 'Enter a valid card number'
                    : null,
              ),
              Row(
                spacing: sectionGap * 1.5,
                children: [
                  Expanded(
                    child: AppTextField(
                      readOnly: true,
                      controller: _expiryDate,
                      label: 'Expiry date',
                      hint: 'MM/YYYY',
                      suffixIcon: Icon(Icons.date_range_rounded, size: iconSz),
                      onPressed: selectExpireDate,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ),
                  Expanded(
                    child: AppTextField(
                      controller: _securityCode,
                      label: 'CVV',
                      hint: '•••',
                      isPassword: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (v) =>
                          (v == null || v.length < 3) ? 'Invalid CVV' : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: bottomSpace * 0.5),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            prefixIcon: paymentState.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.lock),
            label: paymentState.isLoading
                ? "Processing..."
                : "Pay \$${plan.price}",
            onPressed: paymentState.isLoading
                ? null
                : () {
                    final request = UpgradeSubscriptionRequest(
                      subscriptionId: widget.subscriptionPlanResponse.id,
                      cardNumber: _cardNumberCtr.text,
                      expiryDate: _expiryDate.text,
                      securityCode: _securityCode.text,
                    );
                    _handlePay(request);
                  },
          ),
        ),

        SizedBox(height: cardGap),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: sectionGap * 0.6,
            children: [
              Icon(
                Icons.shield_outlined,
                size: iconSz * 0.75,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
              Text(
                'Payments are safe & encrypted',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: bodySmall,
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: cardGap * 1.5),
      ],
    );
  }
}

class _PlanSummaryCard extends StatelessWidget {
  final SubscriptionPlanResponse plan;
  const _PlanSummaryCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final padding = AppStyle.padding(context);
    final cardRadius = AppStyle.cardRadius(context);
    final sectionGap = AppStyle.sectionGap(context);
    final iconSz = AppStyle.iconSize(context);

    // Avatar container size scales with icon
    final avatarSize = (iconSz * 2.2).clamp(36.0, 52.0);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(cardRadius * 1.2),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.15),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding * 0.75,
      ),
      child: Row(
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: colorScheme.primary,
              size: iconSz,
            ),
          ),
          SizedBox(width: sectionGap * 1.4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.title ?? 'Subscription Plan',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: sectionGap * 0.3),
                Text(
                  plan.description ?? 'Full access to all features',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: AppStyle.bodySizeSmall(context),
                    color: colorScheme.onSurface.withOpacity(0.55),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: sectionGap),
          Text(
            plan.price.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card brand badges ────────────────────────────────────────────────────────

class _CardBrandRow extends StatelessWidget {
  const _CardBrandRow();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sectionGap = AppStyle.sectionGap(context);
    final cardRadius = AppStyle.cardRadius(context);
    final captionSz = AppStyle.captionSize(context);
    const brands = ['VISA', 'MC', 'AMEX', 'DISCOVER'];

    return Row(
      spacing: sectionGap,
      children: brands
          .map(
            (b) => Container(
              padding: EdgeInsets.symmetric(
                horizontal: sectionGap * 1.2,
                vertical: sectionGap * 0.6,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.6),
                borderRadius: BorderRadius.circular(cardRadius * 0.5),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
              child: Text(
                b,
                style: TextStyle(
                  fontSize: captionSz,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.55),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ── Card number formatter ────────────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
