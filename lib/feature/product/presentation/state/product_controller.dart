import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/product/data/models/product_response.dart';
import '../../data/models/product_request.dart';
import '../../data/service/product_service.dart';

final productControllerProvider =
    AsyncNotifierProvider<ProductController, List<ProductResponse>>(
      ProductController.new,
    );
class ProductController extends AsyncNotifier<List<ProductResponse>> {
  int _page = 0;
  final int _size = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  @override
  Future<List<ProductResponse>> build() async {
    final service = ref.read(productServiceProvider);
    final products = await service.getProducts(page: _page, size: _size);
    _hasMore = products.length ==  _size;
    return products;
  }
  Future<void> loadMore() async{
    if(_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    _page++;
    try{
      final service = ref.read(productServiceProvider);
      final newProducts = await service.getProducts(page: _page, size: _size);
      if(newProducts.length < _size){
        _hasMore = false;
      }
      final currentProducts = state.value ?? [];
      state = AsyncData([
        ...currentProducts,
        ...newProducts,
      ]);
    }catch(e,s){
      _page--;
      state = AsyncError(e, s);
    }finally{
      _isLoadingMore = false;
    }
  }
  Future<void> refresh() async {
    _page = 0;
    _hasMore = true;
    _isLoadingMore = false;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final service = ref.read(productServiceProvider);

      final products = await service.getProducts(
        page: _page,
        size: _size,
      );

      _hasMore = products.length == _size;

      return products;
    });
  }
  Future<void> createProduct({
    required ProductRequest request,
    required File imageFile,
  }) async {
    final service = ref.read(productServiceProvider);
    await service.createProduct(request, imageFile);
    ref.invalidateSelf();
  }

  Future<void> updateProduct(
      int productId, {
        required ProductRequest request,
        required File imageFile,
      }) async {
    final service = ref.read(productServiceProvider);
    await service.updateProduct(productId, request, imageFile);
    ref.invalidateSelf();
  }

  Future<void> deleteProduct(int id) async {
    final service = ref.read(productServiceProvider);
    await service.deleteProduct(id);
    ref.invalidateSelf();
  }
}

final productDetailProvider = FutureProvider.family<ProductResponse, int>((
    ref,
    id,
    ) async {
  final service = ref.watch(productServiceProvider);
  return service.getProductById(id);
});

final filterProductByCategoryNameControllerProvider = Provider.family<List<ProductResponse>, String?>((ref, categoryName) {
  final productList = ref.watch(productControllerProvider).value ?? <ProductResponse> [];
  if (categoryName == null || categoryName == "All") {
    return productList;
  }
  return productList.where((p) {
    return p.categoryName == categoryName;
  }).toList();
});

final top3ProductControllerProvider = FutureProvider<List<ProductResponse>>((ref) async{
  ref.keepAlive();
  final service = ref.read(productServiceProvider);
  return service.getTop3();
});