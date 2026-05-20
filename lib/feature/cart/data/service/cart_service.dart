import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/core/dio_provider.dart';
import '../../../../core/api_response.dart';
import '../model/cart_response.dart';

final cartServiceProvider = Provider<CartService>((ref) {
  final dio = ref.read(dioProvider);
  return CartService(dio);
});

class CartService {
  final Dio dio;
  CartService(this.dio);
  Future<CartResponse> createCart(int productId, int quantity) async {
    final response = await dio.post(
      "/cart/create",
      data: {"productId": productId, "quantity": quantity},
    );
    final api = ApiResponse.fromJson(
      response.data,
      (data) => CartResponse.fromJson(data),
    );
    return api.data;
  }

  Future<List<CartResponse>> getCarts() async {
    final response = await dio.get("/cart");

    final api = ApiResponse.fromJson(
      response.data,
      (data) => (data as List).map((e) => CartResponse.fromJson(e)).toList(),
    );
    return api.data;
  }

  Future<String> updateCounter(int cartId, int quantity) async {
    final response = await dio.patch(
      "/cart/$cartId",
      queryParameters: {"quantity": quantity},
    );
    final api = ApiResponse.fromJson(response.data, (data) => data.toString());
    return api.data;
  }

  Future<String> removeCart(int cartId) async {
    final response = await dio.delete("/cart/$cartId");
    final api = ApiResponse.fromJson(response.data, (data) => data.toString());
    return api.data;
  }
}
