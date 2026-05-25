import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/shared/app_text_field.dart';
import '../../../../shared/app_bar_icon_button.dart';
import '../state/home_controller.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final double padding;
  final double iconSize;
  final double titleSize;
  final double bodySize;
  final String title;
  final VoidCallback onSearch;
  final VoidCallback onNotification;

  const HomeAppBar({
    super.key,
    required this.padding,
    required this.iconSize,
    required this.titleSize,
    required this.bodySize,
    required this.title,
    required this.onSearch,
    required this.onNotification,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isProductManagerForm =
        ref.watch(appBarTitleProvider) == "Creation" ||
        ref.watch(appBarTitleProvider) == "Profile";

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,

      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black12,
      titleSpacing: padding,
      automaticallyImplyLeading: false,

      title: Row(
        children: [
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => Scaffold.of(ctx).openDrawer(),

              child: Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(Icons.menu_rounded, size: iconSize, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),

      actions: !isProductManagerForm
          ? [
              AppBarIconButton(
                isBackground: true,
                icon: Icons.search_rounded,
                iconSize: iconSize,
                onPressed: onSearch,
              ),

              AppBarIconButton(
                isBackground: true,
                icon: Icons.notifications_none_rounded,
                iconSize: iconSize,
                onPressed: onNotification,
                badge: true,
              ),

              SizedBox(width: padding / 2),
            ]
          : null,
    );
  }
}
