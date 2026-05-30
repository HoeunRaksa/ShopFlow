import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/app_bar_icon_button.dart';
import '../state/home_controller.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final double iconSize;
  final double titleSize;
  final double bodySize;
  final String title;
  final VoidCallback onSearch;
  final VoidCallback onNotification;
  final double height;

  const HomeAppBar({
    super.key,
    required this.iconSize,
    required this.titleSize,
    required this.bodySize,
    required this.title,
    required this.onSearch,
    required this.onNotification,
     this.height = 40
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isProductManagerForm =
        ref.watch(appBarTitleProvider) == "Creation" ||
        ref.watch(appBarTitleProvider) == "Upgrade" ||
        ref.watch(appBarTitleProvider) == "Profile" ||
            ref.watch(appBarTitleProvider) == "Sell-history" ||
        ref.watch(appBarTitleProvider) == "Order-history";
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,

      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black12,
      automaticallyImplyLeading: false,

      title: Row(
        children: [
          Builder(

            builder: (ctx) => AppBarIconButton(
              icon: Icons.menu_rounded,
              iconSize: iconSize,
              onPressed: () => Scaffold.of(ctx).openDrawer(),
              filled: true,
              color: theme.colorScheme.primary,
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
                icon: Icons.search_rounded,
                iconSize: iconSize,
                onPressed: onSearch,
              ),

              AppBarIconButton(
                icon: Icons.notifications_none_rounded,
                iconSize: iconSize,
                onPressed: onNotification,
                badge: true,
              ),
            ]
          : null,
    );
  }
}
