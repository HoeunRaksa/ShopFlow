import 'package:flutter/material.dart';
import 'package:newprovider/core/app_style.dart';

enum AppIconButtonStyle {
  primary,
  outline,
  text,
  danger,
  success,
  warning,
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.style = AppIconButtonStyle.text,
    this.isLoading = false,
    this.isRounded = false,
    this.badge = false,
    this.isBackground = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final AppIconButtonStyle style;
  final bool isLoading;
  final bool isRounded;
  final bool badge;
  final bool isBackground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final disabled = onPressed == null || isLoading;

    final iconSize = AppStyle.iconSize(context);
    final dim = iconSize + 20;

    final colors = {
      AppIconButtonStyle.primary: (
      bg: scheme.primary,
      fg: scheme.onPrimary,
      ),
      AppIconButtonStyle.danger: (
      bg: scheme.error,
      fg: scheme.onError,
      ),
      AppIconButtonStyle.success: (
      bg: const Color(0xFF3B6D11),
      fg: Colors.white,
      ),
      AppIconButtonStyle.warning: (
      bg: const Color(0xFF854F0B),
      fg: Colors.white,
      ),
    };

    Color fgColor() {
      if (disabled) return theme.disabledColor;

      return switch (style) {
        AppIconButtonStyle.outline ||
        AppIconButtonStyle.text =>
        scheme.onSurface,

        _ => colors[style]!.fg,
      };
    }

    Color bgColor() {
      if (!isBackground) {
        return Colors.transparent;
      }

      if (disabled) {
        return theme.disabledColor.withValues(alpha: 0.12);
      }

      return switch (style) {
        AppIconButtonStyle.outline ||
        AppIconButtonStyle.text =>
            scheme.surfaceVariant.withValues(alpha: 0.5),

        _ => colors[style]!.bg,
      };
    }

    BorderSide borderSide() {
      if (!isBackground || style != AppIconButtonStyle.outline) {
        return BorderSide.none;
      }

      return BorderSide(
        color: disabled ? theme.disabledColor : scheme.primary,
        width: 1.5,
      );
    }

    Widget iconChild = isLoading
        ? SizedBox.square(
      dimension: iconSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: fgColor(),
      ),
    )
        : Icon(
      icon,
      size: iconSize,
      color: fgColor(),
    );

    if (badge && !isLoading) {
      iconChild = Stack(
        clipBehavior: Clip.none,
        children: [
          iconChild,
          Positioned(
            top: -3,
            right: -3,
            child: Container(
              width: 7,
              height: 7,
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
      );
    }

    return IconButton(
      onPressed: disabled ? null : onPressed,
      constraints: BoxConstraints(
        minWidth: dim,
        minHeight: dim,
      ),
      style: IconButton.styleFrom(
        backgroundColor: bgColor(),
        foregroundColor: fgColor(),
        disabledBackgroundColor: Colors.transparent,

        overlayColor:
        isBackground ? null : Colors.transparent,

        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,

        fixedSize: Size(dim, dim),
        minimumSize: Size(dim, dim),
        maximumSize: Size(dim, dim),

        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,

        shape: isRounded
            ? CircleBorder(side: borderSide())
            : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppStyle.cardRadius(context),
          ),
          side: borderSide(),
        ),
      ),
      icon: iconChild,
    );
  }
}