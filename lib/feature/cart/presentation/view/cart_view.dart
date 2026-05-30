import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/feature/cart/presentation/state/cart_contoller.dart';
import '../../../../../core/app_style.dart';
import '../../../../core/utils/helper_image.dart';
import '../../../../shared/app_scaffold.dart';
import '../widgets/cart_empty_state.dart';
import '../widgets/cart_item.dart';
import '../widgets/cart_summary.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);

    Future<void> onIncrement(int productId, int cartId) async {
      ref
          .read(cartProvider.notifier)
          .increment(productId, cartId: cartId, apiCall: true);
    }

    Future<void> onDecrement(int productId, int cartId) async {
      ref
          .read(cartProvider.notifier)
          .decrement(productId, cartId: cartId, apiCall: true);
    }

    Future<void> onRemove(int cartId) async {
      ref.read(cartProvider.notifier).remove(cartId, apiCall: true);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        return cartAsync.when(
          data: (carts) {
            return AppScaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              usePadding: false,
              bottomNavigationBar: carts.isEmpty
                  ? null
                  : CartSummary(
                      subtotal: subtotal,
                      shipping: subtotal > 50 ? 0 : 5.99,
                      onCheckout: () => context.push("/checkout"),
                    ),
              body: carts.isEmpty
                  ? const CartEmptyState()
                  : CustomScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              final item = carts[index];
                              final String image = HelperImage.buildImageUrl(
                                item.product.imageUrl,
                              );
                              return CartItem(
                               product: item.product,
                                quantity: item.quantity,
                                onIncrement: () =>
                                    onIncrement(item.product.id, item.id),
                                onDecrement: () =>
                                    onDecrement(item.product.id, item.id),
                                onRemove: () => onRemove(item.id),
                              );
                            }, childCount: carts.length),
                          ),

                        SliverToBoxAdapter(
                            child: SizedBox(
                                height: AppStyle.bottomSpace(context, w))),
                      ],
                    ),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
        );
      },
    );
  }
}
