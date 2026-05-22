import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/core/dio_provider.dart';
import 'package:newprovider/feature/checkout/data/model/location_request.dart';
import 'package:newprovider/feature/checkout/data/model/location_response.dart';

final checkoutServiceProvider = Provider<CheckoutService>((ref){
  final dio = ref.read(dioProvider);
 return CheckoutService(dio);
});

class CheckoutService {
    final Dio dio;
    CheckoutService(this.dio);

    Future<String> checkout(int? locationId, LocationRequest? request) async{
          final response = await dio.post("/order/create",
            data: request?.toJson(),
            queryParameters: {
              'id':locationId
            }
          );
          String data = response.data['message'];
          return data;
    }

    Future<List<LocationResponse>> getLocation() async{
        final response = await dio.get("/location");
        final List data = response.data['data'];
        return data.map((item) => LocationResponse.fromJson(item)).toList();
    }
}