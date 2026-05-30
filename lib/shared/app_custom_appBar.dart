import 'package:flutter/material.dart';

import '../core/app_style.dart';
import 'app_bar_icon_button.dart';

class AppCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool showBackButton;
  final Color? backgroundColor;
  final double height;

  const AppCustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.centerTitle = false,
    this.showBackButton = true,
    this.backgroundColor,
    this.height = 40,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final iconSize = AppStyle.iconSize(context);
    final titleSize = AppStyle.titleSize(context);

    return AppBar(
      toolbarHeight: height,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black12,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      title: Row(
        children: [
          if (showBackButton)
            AppBarIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              iconSize: iconSize,
              onPressed: onBack ?? () => Navigator.pop(context),
              filled: true,
              color: scheme.primary,
            ),

          if (showBackButton) const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }
}