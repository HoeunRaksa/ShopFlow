import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../shared/app_icon_button.dart';

class CartItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItem({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey.shade400,
                    size: 26,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // ── Details ──────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppIconButton(
                        isRounded: true,
                        style: AppIconButtonStyle.primary,
                        icon: Icons.close_rounded,
                        onPressed: onRemove,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF185FA5),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Quantity control ──────────────────
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _QtyButton(
                              icon: Icons.remove_rounded,
                              onTap: onDecrement,
                              enabled: quantity > 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Text(
                                "$quantity",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            _QtyButton(
                              icon: Icons.add_rounded,
                              onTap: onIncrement,
                              enabled: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? theme.colorScheme.onPrimary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? theme.colorScheme.primary : Colors.grey.shade400,
        ),
      ),
    );
  }
}
