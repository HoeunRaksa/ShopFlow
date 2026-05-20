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
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                // ── Icon badge ───────────────────────────────
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 17, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(width: 14),

                // ── Label + value ────────────────────────────
                Expanded(
                  child: onTap != null
                      ? Text(
                    value,
                    style:  TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface,
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style:  TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Trailing ─────────────────────────────────
                if (trailing != null) trailing!,
                if (onTap != null && trailing == null)
                  Icon(Icons.chevron_right_rounded,
                      size: 18, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(height: 1, indent: 64, color: Colors.grey.shade100),
      ],
    );
  }
}