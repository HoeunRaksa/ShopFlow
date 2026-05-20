import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/profile_owner/presentaion/state/user_owner_controller.dart';

import '../../../search/presentation/widgets/product_find_grid.dart';

class OwnerContentBody extends ConsumerWidget {
  final int userId;
  const OwnerContentBody({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productForUserOwnerProvider(userId));
    return CustomScrollView(
      slivers: [
        productAsync.when(
          data: (products) {
            ref.read(ownerCounterProductControllerProvider.notifier).state = products.data.length;
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: ProductFindGrid(products: products.data),
            );
          },
          loading: () => const SliverFillRemaining(
            child: Center(child: CupertinoActivityIndicator()),
          ),
          error: (e, s) =>
              SliverFillRemaining(child: Center(child: Text(e.toString()))),
        ),
      ],
    );
  }
}
