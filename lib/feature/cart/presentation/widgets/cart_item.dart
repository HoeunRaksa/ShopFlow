import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newprovider/core/app_style.dart';
import 'package:newprovider/feature/product/data/models/product_response.dart';
import '../../../../shared/app_icon_button.dart';
import '../../../../shared/product_horizontal_card.dart';
import '../../../history/data/models/order_history_response.dart';

class CartItem extends StatelessWidget {
  final ProductResponse product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;


  const CartItem({
    super.key,
    required this.product,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.quantity
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final width = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context);
    final imageSize = width * 0.10;
    return ProductHorizontalCard(
      product: product,
      imageUrl: product.displayImage,
      showStock: false,
      trailing: AppIconButton(
        isBackground: true,
        isRounded: true,
        style: AppIconButtonStyle.primary,
        icon: Icons.close_rounded,
        onPressed: onRemove,
      ),
      bottomTrailing: Row(
        children: [
          _QtyButton(
            icon: Icons.remove_rounded,
            onTap: onDecrement,
            enabled: quantity > 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(quantity.toString()),
          ),
          _QtyButton(
            icon: Icons.add_rounded,
            onTap: onIncrement,
            enabled: true,
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = AppStyle.screenWidth(context);

    final size = (width * 0.075).clamp(28.0, 36.0);
    final radius = AppStyle.cardRadius(context) * 0.7;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Icon(
          icon,
          size: size * 0.48,
          color: enabled
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}