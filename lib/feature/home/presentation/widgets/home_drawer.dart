import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/product/data/models/product_response.dart';
import 'package:newprovider/feature/user_profile/presentation/state/user_contoller.dart';
import 'package:newprovider/feature/favorite/presentation/view/favorite_view.dart';
import 'package:newprovider/feature/home/presentation/widgets/home_body.dart';
import 'package:newprovider/feature/product/presentation/view/product_management.dart';
import 'package:newprovider/feature/user_profile/presentation/view/profile_view.dart';
import '../../../cart/presentation/view/cart_view.dart';
import '../../../../core/theme/theme_provider.dart';
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
  Widget build(BuildContext context,  WidgetRef ref) {
    final activeMenu = ref.watch(appBarTitleProvider);
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
                HomeDrawerHeader(
                  padding: padding,
                  iconSize: iconSize,
                  bodySize: bodySize,
                  titleSize: titleSize,
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
                    ref.read(shellBodyProvider.notifier).state = () => HomeBody();
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
                    ref.read(shellBodyProvider.notifier).state = () => CartView();
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
                    ref.read(appBarTitleProvider.notifier).state = "Favorites";
                    ref.read(shellBodyProvider.notifier).state = () => FavoriteView();
                  },
                ),
                HomeDrawerItem(
                  icon: Icons.person_rounded,
                  title: "Profile",
                  iconSize: iconSize,
                  fontSize: bodySize,
                  isActive: activeMenu == "Profile",
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(appBarTitleProvider.notifier).state = "Profile";
                    final userAsync =  ref.watch(userControllerProvider);
                    final user = userAsync.value!;
                    ref.read(shellBodyProvider.notifier).state = () => ProfileView(user: user,);
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
                    ref.read(shellBodyProvider.notifier).state = () => ProductManagement();
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
                        isSelected: ref.watch(themeTypeProvider) == AppThemeType.system,
                        onTap: () => ref.read(themeTypeProvider.notifier).state = AppThemeType.system,
                      ),
                      const SizedBox(width: 8),
                      _ThemeOption(
                        icon: Icons.light_mode_rounded,
                        label: "Light",
                        isSelected: ref.watch(themeTypeProvider) == AppThemeType.light,
                        onTap: () => ref.read(themeTypeProvider.notifier).state = AppThemeType.light,
                      ),
                      const SizedBox(width: 8),
                      _ThemeOption(
                        icon: Icons.dark_mode_rounded,
                        label: "Dark",
                        isSelected: ref.watch(themeTypeProvider) == AppThemeType.dark,
                        onTap: () => ref.read(themeTypeProvider.notifier).state = AppThemeType.dark,
                      ),
                      const SizedBox(width: 8),
                      _ThemeOption(
                        icon: Icons.nights_stay_rounded,
                        label: "Midnight",
                        isSelected: ref.watch(themeTypeProvider) == AppThemeType.midnight,
                        onTap: () => ref.read(themeTypeProvider.notifier).state = AppThemeType.midnight,
                      ),
                      const SizedBox(width: 8),
                      _ThemeOption(
                        icon: Icons.forest_rounded,
                        label: "Forest",
                        isSelected: ref.watch(themeTypeProvider) == AppThemeType.forest,
                        onTap: () => ref.read(themeTypeProvider.notifier).state = AppThemeType.forest,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Divider(color: Theme.of(context).dividerColor, thickness: 1),
                ),
                const SizedBox(height: 4),
                HomeDrawerItem(
                  icon: Icons.logout_rounded,
                  title: "Logout",
                  iconSize: iconSize,
                  fontSize: bodySize,
                  color: Colors.red.shade400,
                  onTap: () => Navigator.pop(context),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
