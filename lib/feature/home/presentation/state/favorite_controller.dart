import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../product/data/models/product_response.dart';
import '../../../product/data/storage/favorite_storage.dart';
final favoriteControllerProvider = AsyncNotifierProvider<FavoriteController, List<ProductResponse>>(
    FavoriteController.new
);

class FavoriteController extends AsyncNotifier<List<ProductResponse>> {

  @override
  Future<List<ProductResponse>> build() async {
    final data = await getFavorites();
    final List<ProductResponse> validFavorites = [];

    for (final item in data) {
      try {
        final decoded = jsonDecode(item);
        if (decoded is Map<String, dynamic>) {
          validFavorites.add(ProductResponse.fromJson(decoded));
        }
      } catch (e) {
        // Safely skips over old IDs or unparseable strings without crashing the UI
        print("Skipping corrupted favorite data: $e");
      }
    }

    return validFavorites;
  }

  Future<void> toggle(ProductResponse product) async {
    final current = state.value ?? [];

    final exists = current.any((p) => p.id == product.id);

    if (exists) {
      await removeFavorite(product);

      final updated =
      current.where((p) => p.id != product.id).toList();

      state = AsyncValue.data(updated);
    } else {
      await addFavorite(product);

      final updated = [...current, product];

      state = AsyncValue.data(updated);
    }
  }
}
Future<List<String>> getFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('favorites') ?? [];
}