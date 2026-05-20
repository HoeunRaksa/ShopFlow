import 'package:flutter/material.dart';

class AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;
  final bool badge;

  // ✅ NEW
  final bool isBackground;

  const AppBarIconButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.onPressed,
    this.badge = false,
    this.isBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999),
          child: Ink(
            width: iconSize + 16,
            height: iconSize + 16,
            decoration: BoxDecoration(
              color: isBackground
                  ? scheme.surfaceVariant.withValues(alpha: 0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: scheme.onSurface,
                ),

                if (badge)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: scheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: scheme.surface,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}