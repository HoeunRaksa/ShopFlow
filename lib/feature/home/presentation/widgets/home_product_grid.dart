import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/app_style.dart';
import '../../../../core/utils/helper_image.dart';
import '../../../../shared/product_card.dart';
import '../../../profile_owner/presentaion/state/user_owner_controller.dart';
import '../state/favorite_controller.dart';
import 'animated_product_card.dart';

class HomeProductGrid extends ConsumerWidget {
  final List products;
  final BoxConstraints constraints;

  const HomeProductGrid({
    super.key,
    required this.products,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = constraints.maxWidth;
    final padding = AppStyle.padding(context, w);
    final cardGap = AppStyle.cardGap(context, w);
    final radius = AppStyle.cardRadius(context, w);
    final aspectRatio = AppStyle.productCardAspectRatio(context, w);
    final columns = AppStyle.columns(context, w);
    final sectionGap = AppStyle.sectionGap(context, w);

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        padding,
        sectionGap,
        padding,
        0,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: cardGap,
          mainAxisSpacing: cardGap,
          childAspectRatio: aspectRatio,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final favoriteProducts = ref.watch(favoriteControllerProvider);
            final product = products[index];
            final isFav = favoriteProducts.any((p) => p.id == product.id);

            return AnimatedProductCard(
              index: index,
              child: InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: () {
                  ref.read(ownerPushVerificationControllerProvider.notifier).state = true;
                  context.push('/product/${product.id}');},
                child: ProductCard(
                  product: product,
                  imageUrl: HelperImage.buildImageUrl(product.imageUrl),
                  isFav: isFav,
                  setFav: () {
                    ref
                        .read(favoriteControllerProvider.notifier)
                        .toggle(product);
                  },
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
