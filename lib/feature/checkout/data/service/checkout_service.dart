import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:newprovider/core/network/dio_provider.dart';
import 'package:newprovider/feature/checkout/data/model/location_request.dart';
import 'package:newprovider/feature/checkout/data/model/location_response.dart';
import '../../../../core/result_ressage.dart';
import '../model/OrderResponse.dart';
import '../model/payment_callback_request.dart';

final checkoutServiceProvider = Provider<CheckoutService>((ref) {
  final dio = ref.read(dioProvider);
  return CheckoutService(dio);
});

class CheckoutService {
  final Dio dio;

  CheckoutService(this.dio);
  Future<ResultMessage<OrderResponse>> checkout(
      int? locationId,
      LocationRequest? request,
      ) async {
    final response = await dio.post(
      "/order/create",
      data: request?.toJson(),
      queryParameters: {
        if (locationId != null) "id": locationId,
      },
    );

    return ResultMessage<OrderResponse>.fromJson(
      response.data,
          (data) => OrderResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<List<LocationResponse>> getLocation() async {
    final response = await dio.get("/location");
    final List data = response.data["data"];
    return data.map((e) => LocationResponse.fromJson(e)).toList();
  }

  Future<ResultMessage<String>> paymentCallback(
      PaymentCallbackRequest request,
      ) async {
    final response = await dio.post(
      "/payment/callback",
      data: request.toJson(),
    );

    return ResultMessage<String>.fromJson(
      response.data,
          (data) => data.toString(),
    );
  }
}