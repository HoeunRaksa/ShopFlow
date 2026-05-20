import 'package:newprovider/feature/product/data/models/product_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
void addFavorite(ProductResponse product) async {
  final prefs = await SharedPreferences.getInstance();
  final faves = prefs.getStringList('favorites') ?? [];
  if (!faves.contains(product.id.toString())) {
    faves.add(product.id.toString());
    await prefs.setStringList('favorites', faves);
  }
}