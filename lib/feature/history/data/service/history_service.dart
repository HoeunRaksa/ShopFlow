import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/core/network/dio_provider.dart';
import 'package:newprovider/core/result_ressage.dart';
import 'package:newprovider/feature/history/data/models/order_history_response.dart';

final historyServiceProvider = Provider<HistoryService>((ref) {
  final dio = ref.read(dioProvider);
  return HistoryService(dio);
});

class HistoryService {
  final Dio dio;
  HistoryService(this.dio);
  Future<ResultMessage<List<OrderHistoryResponse>>> getOrderHistories() async {
    final response = await dio.get("/order");
    final result = ResultMessage<List<OrderHistoryResponse>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((item) => OrderHistoryResponse.fromJson(item))
          .toList(),
    );
    return result;
  }
  Future<ResultMessage<List<OrderHistoryResponse>>> getSellHistories() async {
    final response = await dio.get("/order/selling-history");
    final result = ResultMessage<List<OrderHistoryResponse>>.fromJson(
      response.data,
      (data) => (data as List)
          .map((item) => OrderHistoryResponse.fromJson(item))
          .toList(),
    );
    return result;
  }
}
