import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/product/data/models/product_response.dart';

import '../../../product/data/storage/favorite_storage.dart';

final favoriteControllerProvider =
    NotifierProvider<FavoriteController, List<ProductResponse>>(
      FavoriteController.new,
    );

class FavoriteController extends Notifier<List<ProductResponse>> {

  @override
  List<ProductResponse> build() {
    return [];
  }
  void toggle(ProductResponse product) {
    final exists = state.any((p) => p.id == product.id);
    if (exists) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
      addFavorite(product);
    }
  }
}
