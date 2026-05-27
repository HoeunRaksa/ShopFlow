import 'package:flutter/material.dart';
import 'package:newprovider/core/app_style.dart';

class AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;
  final bool badge;
  final bool isBackground;
  final Color color;
  final bool filled;

  const AppBarIconButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.onPressed,
    this.isBackground = false,
    this.badge = false,
    this.color = Colors.black,
    this.filled = false
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final w = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context,w);
    return Padding(
      padding: EdgeInsets.only(right: padding),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9999),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(9999),
          child: Ink(
            width: iconSize + 20,
            height: iconSize + 20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: iconSize, color: filled ? color : scheme.onSurface),
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
                        border: Border.all(color: scheme.surface, width: 1.5),
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
