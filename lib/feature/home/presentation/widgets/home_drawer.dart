import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/history/presentation/view/order_history_view.dart';
import 'package:newprovider/feature/user_profile/presentation/state/user_contoller.dart';
import 'package:newprovider/feature/favorite/presentation/view/favorite_view.dart';
import 'package:newprovider/feature/home/presentation/widgets/home_body.dart';
import 'package:newprovider/feature/product/presentation/view/product_management.dart';
import 'package:newprovider/feature/user_profile/presentation/view/profile_view.dart';
import '../../../../core/app_style.dart';
import '../../../cart/presentation/view/cart_view.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../upgradePlan/presentation/view/upgrade_view.dart';
import '../state/home_controller.dart';
import 'home_drawer_header.dart';
import 'home_drawer_item.dart';

class HomeDrawer extends ConsumerWidget {
  final double padding;
  final double iconSize;
  final double bodySize;
  final double titleSize;

  const HomeDrawer({
    super.key,
    required this.padding,
    required this.iconSize,
    required this.bodySize,
    required this.titleSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeMenu = ref.watch(appBarTitleProvider);
    final w = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context,w);
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width * 0.78,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: padding * 0.6),
                    child: HomeDrawerHeader(
                      padding: padding,
                      iconSize: iconSize,
                      bodySize: bodySize,
                      titleSize: titleSize,
                    ),
                  ),

                  const SizedBox(height: 12),

                  HomeDrawerItem(
                    icon: Icons.home_rounded,
                    title: "Home",
                    iconSize: iconSize,
                    fontSize: bodySize,
                    isActive: activeMenu == "Home",
                    onTap: () {
                      Navigator.pop(context);

                      ref.read(appBarTitleProvider.notifier).state = "Home";

                      ref.read(shellBodyProvider.notifier).state = () =>
                          HomeBody();
                    },
                  ),

                  HomeDrawerItem(
                    icon: Icons.shopping_bag_rounded,
                    title: "Cart",
                    iconSize: iconSize,
                    fontSize: bodySize,
                    isActive: activeMenu == "Cart",
                    onTap: () {
                      Navigator.pop(context);

                      ref.read(appBarTitleProvider.notifier).state = "Cart";

                      ref.read(shellBodyProvider.notifier).state = () =>
                          CartView();
                    },
                  ),
                  HomeDrawerItem(
                    icon: Icons.sell_rounded,
                    title: "sell history",
                    iconSize: iconSize,
                    fontSize: bodySize,
                    isActive: activeMenu == "Sell-history",
                    onTap: () {
                      Navigator.pop(context);

                      ref.read(appBarTitleProvider.notifier).state = "Sell-history";

                      ref.read(shellBodyProvider.notifier).state = () =>
                          OrderHistoryView(isSell: activeMenu == "Sell-history",);
                    },
                  ),
                  HomeDrawerItem(
                    icon: Icons.category_rounded,
                    title: "Order history",
                    iconSize: iconSize,
                    fontSize: bodySize,
                    isActive: activeMenu == "Order-history",
                    onTap: () {
                      Navigator.pop(context);

                      ref.read(appBarTitleProvider.notifier).state = "Order-history";

                      ref.read(shellBodyProvider.notifier).state = () =>
                          OrderHistoryView();
                    },
                  ),

                  HomeDrawerItem(
                    icon: Icons.favorite_rounded,
                    title: "Favorites",
                    iconSize: iconSize,
                    fontSize: bodySize,
                    isActive: activeMenu == "Favorites",
                    onTap: () {
                      Navigator.pop(context);

                      ref.read(appBarTitleProvider.notifier).state =
                          "Favorites";

                      ref.read(shellBodyProvider.notifier).state = () =>
                          FavoriteView();
                    },
                  ),

                  /// FIXED PROFILE
                  HomeDrawerItem(
                    icon: Icons.person_rounded,
                    title: "Profile",
                    iconSize: iconSize,
                    fontSize: bodySize,
                    isActive: activeMenu == "Profile",
                    onTap: () {
                      final user = ref.read(userControllerProvider).value;
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile loading, please try again"),
                          ),
                        );
                        return;
                      }
                      Navigator.pop(context);
                      ref.read(appBarTitleProvider.notifier).state = "Profile";
                      ref.read(shellBodyProvider.notifier).state = () =>
                          ProfileView(user: user);
                    },
                  ),

                  HomeDrawerItem(
                    icon: Icons.create_rounded,
                    title: "Creation",
                    iconSize: iconSize,
                    fontSize: bodySize,
                    isActive: activeMenu == "Creation",
                    onTap: () {
                      Navigator.pop(context);

                      ref.read(appBarTitleProvider.notifier).state = "Creation";

                      ref.read(shellBodyProvider.notifier).state = () =>
                          ProductManagement();
                    },
                  ),

                  HomeDrawerItem(
                    icon: Icons.star_border_rounded,
                    title: "Upgrade",
                    iconSize: iconSize,
                    fontSize: bodySize,
                    isActive: activeMenu == "Upgrade",
                    onTap: () {
                      Navigator.pop(context);

                      ref.read(appBarTitleProvider.notifier).state = "Upgrade";

                      ref.read(shellBodyProvider.notifier).state = () =>
                          UpgradeView();
                    },
                  ),

                  const Spacer(),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Text(
                      "Theme Mode",
                      style: TextStyle(
                        fontSize: bodySize - 2,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      children: [
                        _ThemeOption(
                          icon: Icons.brightness_auto_rounded,
                          label: "System",
                          isSelected:
                              ref.watch(themeTypeProvider) ==
                              AppThemeType.system,
                          onTap: () {
                            ref.read(themeTypeProvider.notifier).changeTheme(AppThemeType.system);
                          },
                        ),

                        const SizedBox(width: 8),

                        _ThemeOption(
                          icon: Icons.light_mode_rounded,
                          label: "Light",
                          isSelected:
                              ref.watch(themeTypeProvider) ==
                              AppThemeType.light,
                          onTap: () {
                            ref.read(themeTypeProvider.notifier).changeTheme(AppThemeType.light);
                          },
                        ),

                        const SizedBox(width: 8),

                        _ThemeOption(
                          icon: Icons.dark_mode_rounded,
                          label: "Dark",
                          isSelected:
                              ref.watch(themeTypeProvider) == AppThemeType.dark,
                          onTap: () {
                            ref.read(themeTypeProvider.notifier).changeTheme(AppThemeType.dark);
                          },
                        ),

                        const SizedBox(width: 8),

                        _ThemeOption(
                          icon: Icons.nightlight_round,
                          label: "Midnight",
                          isSelected:
                              ref.watch(themeTypeProvider) ==
                              AppThemeType.midnight,
                          onTap: () {
                            ref.read(themeTypeProvider.notifier).changeTheme(AppThemeType.midnight);
                          },
                        ),

                        const SizedBox(width: 8),

                        _ThemeOption(
                          icon: Icons.forest_rounded,
                          label: "Forest",
                          isSelected:
                              ref.watch(themeTypeProvider) ==
                              AppThemeType.forest,
                          onTap: () {

                            ref.read(themeTypeProvider.notifier).changeTheme(AppThemeType.forest);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Divider(color: Theme.of(context).dividerColor),
                  ),

                  HomeDrawerItem(
                    icon: Icons.logout_rounded,
                    title: "Logout",
                    iconSize: iconSize,
                    fontSize: bodySize,
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = AppStyle.screenWidth(context);
    final iconsSize = AppStyle.iconSize(context, w);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.cardColor,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),

          boxShadow: [
            if (isSelected)
              BoxShadow(
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 4),
                color: theme.colorScheme.primary.withOpacity(.2),
              ),
          ],
        ),

        child: Row(
          children: [
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: iconsSize,
                color: theme.colorScheme.primary,
              ),

            Icon(
              icon,
              size: iconsSize,
              color: isSelected ? theme.colorScheme.primary : Colors.grey,
            ),

            const SizedBox(height: 10),

            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,

                color: isSelected ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
