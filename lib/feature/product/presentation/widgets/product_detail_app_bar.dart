import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/shared/app_bar_icon_button.dart';

import '../../../../core/app_style.dart';
import '../../../../shared/app_custom_appBar.dart';
import '../../../user_profile/presentation/state/user_contoller.dart';

class ProductDetailAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  final AsyncValue productAsync;
  final int productId;
  final double iconSize;
  final double height;

  const ProductDetailAppBar({
    super.key,
    required this.productAsync,
    required this.productId,
    required this.iconSize,
    required this.height
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(userControllerProvider).value;
    final height = AppStyle.appBarHeight(context);
    return productAsync.when(
      loading: () => AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: iconSize),
        title: const Text("Loading..."),
      ),

      error: (e, _) => AppBar(
        backgroundColor:theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: iconSize),
        title: const Text("Error"),
      ),

      data: (product) => AppCustomAppBar(
        height: height,
        title: product.name,
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          if (product.userId == user?.id)
            AppBarIconButton(
              icon: Icons.edit_outlined,
              iconSize: iconSize,
              onPressed: () {
                context.push(
                  '/product-management/$productId',
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>  Size.fromHeight(height);
}
