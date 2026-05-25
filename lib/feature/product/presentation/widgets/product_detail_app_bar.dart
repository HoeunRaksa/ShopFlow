import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        title: const Text("Loading..."),
      ),

      error: (e, _) => AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        title: const Text("Error"),
      ),

      data: (product) => AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        title: Text(
          product.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  context.push('/product-management/$productId');
                },
                child: product.userId == user?.id
                    ? Icon(
                  Icons.edit_rounded,
                  size: iconSize,
                  color: colorScheme.primary,
                )
                    : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}