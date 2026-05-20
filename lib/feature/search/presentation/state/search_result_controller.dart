import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/product/data/models/product_response.dart';
import 'package:newprovider/feature/product/data/service/product_service.dart';

final searchResultControllerProvider =
AsyncNotifierProvider<SearchResultController, List<ProductResponse>>(
  SearchResultController.new,
);

class SearchResultController extends AsyncNotifier<List<ProductResponse>> {
  int _page = 0;
  final int _size = 10;

  String? _name;
  String? _categoryName;

  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<List<ProductResponse>> build() async {
    return [];
  }

  Future<void> performSearch({
    String? name,
    String? categoryName,
  }) async {
    _page = 0;
    _hasMore = true;
    _name = name;
    _categoryName = categoryName;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final service = ref.read(productServiceProvider);

      final products = await service.searchByNameAndCategory(
        name: _name,
        categoryName: _categoryName,
        page: _page,
        size: _size,
      );

      _hasMore = products.length == _size;

      return products;
    });
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    _page++;

    final oldProducts = state.value ?? [];

    try {
      final service = ref.read(productServiceProvider);

      final newProducts = await service.searchByNameAndCategory(
        name: _name,
        categoryName: _categoryName,
        page: _page,
        size: _size,
      );

      _hasMore = newProducts.length == _size;

      state = AsyncValue.data([
        ...oldProducts,
        ...newProducts,
      ]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  void clearSearch() {
    _page = 0;
    _hasMore = true;
    _name = null;
    _categoryName = null;
    state = const AsyncValue.data([]);
  }
}