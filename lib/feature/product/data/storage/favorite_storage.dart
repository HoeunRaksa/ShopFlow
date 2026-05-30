import 'dart:convert';

import 'package:newprovider/feature/product/data/models/product_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> addFavorite(ProductResponse product) async {
  final prefs = await SharedPreferences.getInstance();
  final faves = prefs.getStringList('favorites') ?? [];

  final productString = jsonEncode(product.toJson());

  // Safely check if the product ID exists
  bool alreadyExists = faves.any((item) {
    try {
      final decoded = jsonDecode(item);
      if (decoded is Map<String, dynamic>) {
        return decoded['id'] == product.id;
      }
    } catch (_) {}
    return false; // Skip/ignore items that aren't valid maps
  });

  if (!alreadyExists) {
    faves.add(productString);
    await prefs.setStringList('favorites', faves);
  }
}

Future<void> removeFavorite(ProductResponse product) async {
  final prefs = await SharedPreferences.getInstance();
  final faves = prefs.getStringList('favorites') ?? [];

  // Safely remove by filtering out items matching the product ID
  faves.removeWhere((item) {
    try {
      final decoded = jsonDecode(item);
      if (decoded is Map<String, dynamic>) {
        return decoded['id'] == product.id;
      }
    } catch (_) {}
    return false;
  });

  await prefs.setStringList('favorites', faves);
}
