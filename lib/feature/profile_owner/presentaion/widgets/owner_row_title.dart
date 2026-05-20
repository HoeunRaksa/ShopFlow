import 'package:flutter/material.dart';
import 'package:newprovider/core/app_style.dart';

class OwnerRowTitle extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onTap;
  final bool isReadOnly;

  const OwnerRowTitle({
    super.key,
    required this.icon,
    required this.text,
    this.color = Colors.blue,
    this.onTap,
    this. isReadOnly = false
  });

  @override
  State<OwnerRowTitle> createState() => _OwnerRowTitleState();
}

class _OwnerRowTitleState extends State<OwnerRowTitle> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final w = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context, w);
    final iconSize = w * 0.06;
    final theme = Theme.of(context);
    final textBodySize = AppStyle.bodySize(context, w);
    final chevronSize = iconSize * 0.55;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding * 0.5,
      ),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap:() => widget.onTap?.call(),
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            borderRadius: BorderRadius.circular(15),   // ← ink clips to card
            splashColor: widget.color.withOpacity(0.15),
            highlightColor: widget.color.withOpacity(0.07),
            child: Ink(
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(15),
                border: Border(
                  left: BorderSide(color: widget.color, width: 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_pressed ? 0.04 : 0.08),
                    blurRadius: _pressed ? 6 : 12,
                    offset: Offset(0, _pressed ? 1 : 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: padding * 0.30,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Accent icon bubble
                    Container(
                      padding: EdgeInsets.all(iconSize * 0.35),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.icon, size: iconSize, color: widget.color),
                    ),
                    SizedBox(width: padding * 0.75),

                    // Label
                    Expanded(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: textBodySize,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(width: padding * 0.5),
                    if(widget.isReadOnly)
                      Icon(
                        Icons.lock,
                        size: chevronSize,
                        color: theme.colorScheme.onSurface.withOpacity(0.35),
                      ),
                    if(!widget.isReadOnly)
                    Icon(
                      Icons.chevron_right_rounded,
                      size: chevronSize,
                      color: theme.colorScheme.onSurface.withOpacity(0.35),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}