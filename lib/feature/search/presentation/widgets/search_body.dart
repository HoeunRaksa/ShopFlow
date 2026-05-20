import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/search/presentation/widgets/product_find_grid.dart';
import '../../../home/presentation/widgets/home_loading_state.dart';
import '../state/search_result_controller.dart';

class SearchBody extends ConsumerStatefulWidget {
  final String? searchKey;
  final String? categoryName;
  const SearchBody({super.key, this.searchKey, this.categoryName});

  @override
  ConsumerState<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends ConsumerState<SearchBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchResultControllerProvider.notifier).performSearch(
        name: widget.searchKey,
        categoryName: widget.categoryName?.isNotEmpty == true
            ? widget.categoryName
            : widget.searchKey,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(searchResultControllerProvider);
    return productAsync.when(
      data: (products) => ProductFindGrid(products: products),
      loading: () => const SliverFillRemaining(
        hasScrollBody: false,
        child: HomeLoadingState(),
      ),
      error: (error, _) => const SliverFillRemaining(hasScrollBody: false),
    );
  }
}