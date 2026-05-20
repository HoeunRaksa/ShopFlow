import 'package:flutter/material.dart';
import '../../../../../shared/app_button.dart.dart';

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final VoidCallback onCheckout;

  const CartSummary({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.onCheckout,
  });

  double get total => subtotal + shipping;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          _SummaryRow(label: "Subtotal", value: subtotal),
          const SizedBox(height: 10),
          _SummaryRow(label: "Shipping", value: shipping),
          const SizedBox(height: 14),
          Divider(color: Colors.grey.shade100, thickness: 1.5),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,

                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style:  TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppButton(
            label: "Checkout",
            isFullWidth: true,
            isRounded: true,
            size: AppButtonSize.large,
            suffixIcon: const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: Colors.white,
            ),
            onPressed: onCheckout,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value == 0 ? "Free" : "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}