import 'package:flutter/material.dart';

class HomeDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final Color color;
  final bool isActive;

  const HomeDrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
    this.color = const Color(0xFF0D1B2A),
    this.isActive = false,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final textColor = color == const Color(0xFF0D1B2A) ? colorScheme.onSurface : color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      child: Material(
        color: isActive ? primaryColor.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          splashColor: primaryColor.withOpacity(0.1),
          highlightColor: primaryColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isActive
                        ? primaryColor.withOpacity(0.12)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    icon,
                    size: iconSize - 2,
                    color: isActive
                        ? primaryColor
                        : color == const Color(0xFF0D1B2A)
                            ? colorScheme.onSurfaceVariant
                            : color,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: isActive ? primaryColor : textColor,
                      fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (color == const Color(0xFF0D1B2A))
                  Icon(
                    Icons.chevron_right_rounded,
                    size: iconSize * 0.7,
                    color: colorScheme.outlineVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
