import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/core/app_style.dart';
import '../../../../../core/utils/helper_image.dart';
import '../../../../shared/product_horizontal_card.dart';
import '../../../home/presentation/state/favorite_controller.dart';
import '../../../product/data/models/product_response.dart';

class FavoriteList extends ConsumerWidget {
  final List<ProductResponse> favorites;

  const FavoriteList({
    super.key,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
   SliverList(
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppStyle.cardGap(context),
      ),
      child: ProductHorizontalCard(
        product: product,
        imageUrl: HelperImage.buildImageUrl(product.imageUrl),
        onTap: onTap,
        showStock: true,
        trailing: GestureDetector(
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
      ),
    );
  }
}