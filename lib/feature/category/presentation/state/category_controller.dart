import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:newprovider/feature/category/data/models/category_response.dart';
import 'package:newprovider/feature/category/data/services/category_service.dart';

import '../../data/models/category_item.dart';
final selectedCategoryProvider =
StateProvider<String>((ref) => "All");

final categoryNameControllerProvider =
Provider<List<CategoryItem>>((ref) {

  final categories =
      ref.watch(categoryControllerProvider).value ?? [];

  return [
    CategoryItem(
      name: "All",
      imageUrl: "",
    ),

    ...categories.map(
          (item) => CategoryItem(
        name: item.name,
        imageUrl: item.imageUrl,
      ),
    ),
  ];
});

final categoryControllerProvider =
    AsyncNotifierProvider<CategoryController, List<CategoryResponse>>(
      CategoryController.new,
    );

class CategoryController extends AsyncNotifier<List<CategoryResponse>> {
  @override
  Future<List<CategoryResponse>> build() async {
    final service = ref.read(categoryServiceProvider);
    return service.getCategories();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(categoryServiceProvider);
      return service.getCategories();
    });
  }
}
