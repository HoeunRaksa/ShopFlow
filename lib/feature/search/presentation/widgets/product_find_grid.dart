import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/core/app_style.dart';
import 'package:newprovider/core/utils/helper_image.dart';
import 'package:newprovider/feature/product/data/models/product_response.dart';
import 'package:newprovider/shared/product_card.dart';

import '../../../profile_owner/presentaion/state/user_owner_controller.dart';

class ProductFindGrid extends ConsumerWidget {
  final List<ProductResponse> products;
  final VoidCallback? onTop;
  const ProductFindGrid({super.key, required this.products, this.onTop});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context, w);
    final sectionGap = AppStyle.sectionGap(context, w);
    final columns = AppStyle.columns(context, w);
    final cartGap = AppStyle.cardGap(context, w);
    final childAspectRatio = AppStyle.productCardAspectRatio(context);
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(padding, sectionGap, padding, 0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: cartGap,
          mainAxisSpacing: cartGap,
          childAspectRatio: childAspectRatio,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index];
          final imageUrl = HelperImage.buildImageUrl(product.imageUrl);
          return InkWell(
            onTap:() {
              ref.read(ownerPushVerificationControllerProvider.notifier).state = false;
                context.push('/product/${product.id}');
            },
            child: ProductCard(
              product: product,
              imageUrl: imageUrl,
              isFav: false,
            ),
          );
        },
          childCount: products.length,
        ),
      ),
    );
  }
}
