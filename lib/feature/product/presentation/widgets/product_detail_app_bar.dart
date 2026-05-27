import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/shared/app_bar_icon_button.dart';

import '../../../user_profile/presentation/state/user_contoller.dart';

class ProductDetailAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  final AsyncValue productAsync;
  final int productId;
  final double iconSize;

  const ProductDetailAppBar({
    super.key,
    required this.productAsync,
    required this.productId,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(userControllerProvider).value;
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

      data: (product) => AppBar(
        backgroundColor:theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: iconSize),
        title: Text(
          product.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          product.userId == user?.id
              ? AppBarIconButton(
            icon: Icons.edit_outlined,
            iconSize: iconSize,
            onPressed: () {
              context.push(
                '/product-management/$productId',
              );
            },
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
