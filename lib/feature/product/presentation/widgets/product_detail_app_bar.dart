import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductDetailAppBar extends StatelessWidget
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      title: productAsync.when(
        loading: () => const Text("Loading..."),
        error: (e, _) => const Text("Error"),
        data: (product) => Text(
          product.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
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
              onTap: () {
                context.push('/product-management/$productId');
              },
              child: Icon(
                Icons.edit_rounded, 
                size: iconSize,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}