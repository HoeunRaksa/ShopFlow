import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/core/dio_provider.dart';
import 'package:newprovider/feature/category/data/models/category_response.dart';

final categoryServiceProvider = Provider<CategoryService>((ref){
    final dio = ref.watch(dioProvider);
    return CategoryService(dio);
});

class CategoryService {
  final Dio dio;
  CategoryService(this.dio);
  Future<List<CategoryResponse>> getCategories() async{
       final response = await dio.get("/category");
       final List data = response.data;
       return data.map((p) => CategoryResponse.fromJson(p)).toList();
  }
}