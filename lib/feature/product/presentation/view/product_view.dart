import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/feature/cart/presentation/state/cart_contoller.dart';
import 'package:newprovider/feature/profile_owner/presentaion/state/user_owner_controller.dart';
import '../../../../core/app_style.dart';
import '../../../../core/app_size.dart';
import '../../../../shared/app_scaffold.dart';
import '../state/product_controller.dart';
import '../widgets/product_detail_app_bar.dart';
import '../widgets/product_detail_body.dart';

class ProductView extends ConsumerWidget {
  final int productId;

  const ProductView({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));
    final quantity = ref.watch(addCartQuantityProvider(productId));
    void addToCard(int productId, int quantity) {
      ref.read(cartProvider.notifier).addToCart(productId, quantity);
    }
    final isFromHone = ref.read(ownerPushVerificationControllerProvider.notifier).state;

    final theme = Theme.of(context);

    return LayoutBuilder(

      builder: (context, constraints) {
        final w = AppStyle.screenWidth(context);
        final iconSize = AppStyle.iconSize(context, w * 1.5);
        final titleSize = AppStyle.titleSize(context, w);
        final bodySize = AppStyle.bodySize(context, w);
        final maxWidth = AppStyle.maxWidth(context);
        final height = AppStyle.appBarHeight(context);

        return AppScaffold(
          appBar: ProductDetailAppBar(
            productAsync: productAsync,
            productId: productId,
            iconSize: iconSize,
            height: height,
          ),
          body: productAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
            data: (product) {
              return ProductDetailBody(
                  isFromHome: isFromHone,
                  product: product,
                  maxWidth: maxWidth,
                  titleSize: titleSize,
                  bodySize: bodySize,
                  theme: theme,
                  iconSize: iconSize,
                  add: () => addToCard(productId, quantity),
                  onTop: () {
                    context.pushNamed(
                      'owner',
                      pathParameters: {'id': product.userId.toString()},
                    );
                  },
              );
            },
          ),
        );
      },

    );
  }
}
