import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/core/api_response.dart';
import 'package:newprovider/feature/product/data/models/product_response.dart';
import '../../../../core/dio_provider.dart';
import '../models/product_request.dart';


final productServiceProvider = Provider<ProductService>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductService(dio);
});


class ProductService {
  final Dio dio;
  ProductService(this.dio);

  Future<ProductResponse> getProductById(int id) async {
    final response = await dio.get("/product/$id");
    return ProductResponse.fromJson(response.data);
  }

  Future<List<ProductResponse>> getProducts({int page =0 , int size =10 }) async {
    final response = await dio.get('/product', queryParameters: {
      'page' : page,
      'size' : size
    });
    final List data = response.data['content'];
    return data.map((e) => ProductResponse.fromJson(e)).toList();
  }

  Future<List<ProductResponse>> getTop3() async{
    final response = await dio.get('/product/get-top-3');
    final List data = response.data['data'];
    return data.map((item) => ProductResponse.fromJson(item)).toList();
  }


  Future<List<ProductResponse>> searchByNameAndCategory({int page = 0, int size = 10, String? name, String? categoryName}) async{
    final response = await dio.get('/product/find-product',
        queryParameters: {
          "page": page,
          "size": size,
          if(name != null && name.isNotEmpty) "productName": name,
          if(categoryName != null && categoryName.isNotEmpty)
            "categoryName": categoryName,
        }
    );
    final List data = response.data['content'];
    return data.map((item) => ProductResponse.fromJson(item)).toList();
  }

  Future<ProductResponse> createProduct(
    ProductRequest request,
    File imageFile,
  ) async {
    final formData = FormData.fromMap({
      "data": MultipartFile.fromString(
        jsonEncode(request.toJson()),
        contentType: DioMediaType.parse("application/json"),
      ),
      "image": await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });
    final response = await dio.post("/product/create", data: formData);
    return ProductResponse.fromJson(response.data);
  }

  Future<ProductResponse> updateProduct(
    int id,
    ProductRequest request,
    File? imageFile,
  ) async {
    final formData = FormData.fromMap({
      "data": MultipartFile.fromString(
        jsonEncode(request.toJson()),
        contentType: DioMediaType.parse("application/json"),
      ),

      if (imageFile != null)
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
    });

    final response = await dio.put("/product/update/$id", data: formData);

    return ProductResponse.fromJson(response.data);
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await dio.delete("/product/delete/$id");

      if (response.statusCode == 200) {
        debugPrint("Product deleted successfully");
      }
    } catch (e) {
      debugPrint("Delete failed: $e");
      rethrow;
    }
  }

  Future<ApiResponse<List<ProductResponse>>>
  getProductByUserOwnerId(int id) async {

    final response =
    await dio.get("/product/getProductOwner/$id");

    final List data = response.data['data'];

    return ApiResponse(
      success: response.data['success'],
      message: response.data['message'],
      data: data
          .map((item) =>
          ProductResponse.fromJson(item))
          .toList(),
    );
  }
}
