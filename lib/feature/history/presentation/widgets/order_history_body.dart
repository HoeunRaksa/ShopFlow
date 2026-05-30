import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:newprovider/feature/history/presentation/state/order_history_controller.dart';
import 'package:newprovider/shared/product_horizontal_card.dart';

class OrderHistoryBody extends ConsumerWidget {
  final bool isSell;
  const OrderHistoryBody({super.key, this.isSell = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = isSell ?  ref.watch(sellHistoryOneTimeProvider) :  ref.watch(orderHistoryOneTimeProvider);
    return items.when(
      data: (items) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final orderHis = items[index];

            return Column(
              children: [
                ListTile(
                  title: Text(
                    DateFormat(
                      'dd MMM yyyy • HH:mm',
                    ).format(orderHis!.createAt),
                  ),
                  trailing: Text("\$${orderHis.totalPrice}"),
                ),

                ...orderHis.items.map(
                      (item) => ProductHorizontalCard(
                    showStock: false,
                    showQty: true,
                    orderItemResponse: item,
                    product: item.product,
                    imageUrl: item.product.displayImage,
                  ),
                ),
              ],
            );
          },
        );
      },
      loading: () => const Center(
        child: CupertinoActivityIndicator(),
      ),
      error: (e, st) => Center(
        child: Text(e.toString()),
      ),
    );
  }
}