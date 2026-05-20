import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_style.dart';
import '../../../../core/theme/theme_provider.dart';

class InfoBlock extends ConsumerWidget {
  final String title;
  final List<Widget> children;

  const InfoBlock({
    super.key,
    this.title = 'Personal Information',
    required this.children,
  });
  static ColorFilter _desaturate(double strength) {
    final s = 1.0 - strength;
    const r = 0.2126, g = 0.7152, b = 0.0722;
    return ColorFilter.matrix([
      r + s * (1 - r), g * (1 - s),     b * (1 - s),     0, 0,
      r * (1 - s),     g + s * (1 - g), b * (1 - s),     0, 0,
      r * (1 - s),     g * (1 - s),     b + s * (1 - b), 0, 0,
      0,               0,               0,               1, 0,
    ]);
  }
  static ({double desat, double dim}) _weights(AppThemeType type) {
    return switch (type) {
      AppThemeType.light    => (desat: 0.60, dim: 0.72),
      AppThemeType.forest   => (desat: 0.55, dim: 0.70),
      AppThemeType.dark     => (desat: 0.45, dim: 0.55),
      AppThemeType.midnight => (desat: 0.40, dim: 0.50),
      AppThemeType.system   => (desat: 0.50, dim: 0.62),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context, w);
    final theme = Theme.of(context).colorScheme;
    final textBodySize = AppStyle.bodySize(context, w * 2);
    final labelSize = textBodySize * 0.72;

    final themeType = ref.watch(themeTypeProvider);
    final weights = _weights(themeType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: theme.onSurface,
                  fontSize: textBodySize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: padding * 0.4),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: padding * 0.45,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: theme.onSurface.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: theme.onSurface.withOpacity(0.14),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  'read only',
                  style: TextStyle(
                    fontSize: labelSize,
                    color: theme.onSurface.withOpacity(0.45),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        IgnorePointer(
          child: Opacity(
            opacity: weights.dim,
            child: ColorFiltered(
              colorFilter: _desaturate(weights.desat),
              child: Column(children: children),
            ),
          ),
        ),
      ],
    );
  }
}