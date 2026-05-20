import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/helper_image.dart';
import '../../../home/presentation/state/favorite_controller.dart';
import '../../../product/data/models/product_response.dart';

class FavoriteList extends ConsumerWidget {
  final List<ProductResponse> favorites;
  final double padding;

  const FavoriteList({
    super.key,
    required this.favorites,
    required this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(padding, 16, padding, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final product = favorites[index];
                return _FavoriteListItem(
                  product: product,
                  onTap: () => context.push('/product/${product.id}'),
                  onRemove: () => ref
                      .read(favoriteControllerProvider.notifier)
                      .toggle(product),
                );
              },
              childCount: favorites.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _FavoriteListItem extends StatelessWidget {
  final ProductResponse product;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteListItem({
    required this.product,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color:scheme.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: scheme.surface,
          highlightColor: scheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // ── Image ──────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                   imageUrl:  HelperImage.buildImageUrl(product.imageUrl),
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade100,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey.shade400,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // ── Info ───────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style:  TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: product.stock > 0
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.stock > 0 ? "In Stock" : "Out of Stock",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: product.stock > 0
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Remove button ──────────────────────────
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 18,
                      color: Colors.red.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}