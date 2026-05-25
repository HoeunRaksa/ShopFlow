import 'package:flutter/material.dart';

class ProfileRowTile extends StatelessWidget {
  const ProfileRowTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(0),
            splashColor: colorScheme.primary.withOpacity(0.06),
            highlightColor: colorScheme.primary.withOpacity(0.04),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  // ── Icon badge ─────────────────────────────────
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 19,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // ── Label + value ──────────────────────────────
                  Expanded(
                    child: onTap != null
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface.withOpacity(0.45),
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          value,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                            height: 1.3,
                          ),
                        ),
                      ],
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface.withOpacity(0.45),
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          value,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Trailing ───────────────────────────────────
                  if (trailing != null)
                    trailing!
                  else if (onTap != null)
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.35),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 76),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color: colorScheme.onSurface.withOpacity(0.08),
            ),
          ),
      ],
    );
  }
}