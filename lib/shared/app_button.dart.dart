import 'package:flutter/material.dart';

enum AppButtonStyle { primary, outline, text, danger, success, warning }
enum AppButtonSize  { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style   = AppButtonStyle.primary,
    this.size    = AppButtonSize.medium,
    this.isLoading  = false,
    this.isFullWidth = false,
    this.isRounded  = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String          label;
  final VoidCallback?   onPressed;
  final AppButtonStyle  style;
  final AppButtonSize   size;
  final bool            isLoading;
  final bool            isFullWidth;
  final bool            isRounded;
  final Widget?         prefixIcon;
  final Widget?         suffixIcon;

  // ── Sizes ──────────────────────────────────────────────────
  double get _height => switch (size) {
    AppButtonSize.small  => 36,
    AppButtonSize.medium => 48,
    AppButtonSize.large  => 56,
  };

  double get _fontSize => switch (size) {
    AppButtonSize.small  => 12,
    AppButtonSize.medium => 14,
    AppButtonSize.large  => 16,
  };

  EdgeInsets get _padding => switch (size) {
    AppButtonSize.small  => const EdgeInsets.symmetric(horizontal: 16),
    AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: 24),
    AppButtonSize.large  => const EdgeInsets.symmetric(horizontal: 32),
  };

  BorderRadius get _radius => BorderRadius.circular(
    isRounded ? 100 : switch (size) {
      AppButtonSize.small  => 6,
      AppButtonSize.medium => 8,
      AppButtonSize.large  => 10,
    },
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final disabled = onPressed == null || isLoading;

    final colors = {
      AppButtonStyle.primary: (bg: colorScheme.primary, fg: colorScheme.onPrimary),
      AppButtonStyle.danger: (bg: colorScheme.error, fg: colorScheme.onError),
      AppButtonStyle.success: (bg: const Color(0xFF3B6D11), fg: Colors.white), // keeping special ones for now or use custom
      AppButtonStyle.warning: (bg: const Color(0xFF854F0B), fg: Colors.white),
    };

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading) ...[
          SizedBox.square(
            dimension: _fontSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: style == AppButtonStyle.outline || style == AppButtonStyle.text
                  ? colorScheme.primary
                  : colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 8),
        ] else if (prefixIcon != null) ...[
          prefixIcon!,
          const SizedBox(width: 6),
        ],
        Text(label),
        if (!isLoading && suffixIcon != null) ...[
          const SizedBox(width: 6),
          suffixIcon!,
        ],
      ],
    );

    if (isFullWidth) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [child],
      );
    }

    final buttonStyle = switch (style) {
      AppButtonStyle.primary ||
      AppButtonStyle.danger ||
      AppButtonStyle.success ||
      AppButtonStyle.warning =>
        ElevatedButton.styleFrom(
          backgroundColor: disabled ? theme.disabledColor : colors[style]!.bg,
          foregroundColor: disabled ? theme.hintColor : colors[style]!.fg,
          minimumSize: Size(isFullWidth ? double.infinity : 0, _height),
          padding: _padding,
          shape: RoundedRectangleBorder(borderRadius: _radius),
          elevation: 0,
          textStyle:
              TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w500),
        ),
      AppButtonStyle.outline => OutlinedButton.styleFrom(
          foregroundColor: disabled ? theme.disabledColor : colorScheme.primary,
          minimumSize: Size(isFullWidth ? double.infinity : 0, _height),
          padding: _padding,
          shape: RoundedRectangleBorder(borderRadius: _radius),
          side: BorderSide(
            color: disabled ? theme.disabledColor : colorScheme.primary,
            width: 1.5,
          ),
          textStyle:
              TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w500),
        ),
      AppButtonStyle.text => TextButton.styleFrom(
          foregroundColor: disabled ? theme.disabledColor : colorScheme.primary,
          minimumSize: Size(isFullWidth ? double.infinity : 0, _height),
          padding: _padding,
          shape: RoundedRectangleBorder(borderRadius: _radius),
          textStyle:
              TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w500),
        ),
    };

    return switch (style) {
      AppButtonStyle.primary ||
      AppButtonStyle.danger  ||
      AppButtonStyle.success ||
      AppButtonStyle.warning => ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: buttonStyle,
        child: child,
      ),
      AppButtonStyle.outline => OutlinedButton(
        onPressed: disabled ? null : onPressed,
        style: buttonStyle,
        child: child,
      ),
      AppButtonStyle.text => TextButton(
        onPressed: disabled ? null : onPressed,
        style: buttonStyle,
        child: child,
      ),
    };
  }

  Color _labelColor(BuildContext context) {
    if (style == AppButtonStyle.outline || style == AppButtonStyle.text) {
      return const Color(0xFF185FA5);
    }
    return Colors.white;
  }
}