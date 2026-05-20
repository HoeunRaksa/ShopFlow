import 'package:flutter/material.dart';
import 'package:newprovider/shared/app_text_field.dart';
import '../../../../shared/app_bar_icon_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
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
    required this.onNotification
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        size: iconSize,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        "Find what you love",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: bodySize - 2,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
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
              SizedBox(width: padding / 2),
            ],
          );
  }
}
