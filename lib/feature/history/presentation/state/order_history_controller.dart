import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/history/data/models/order_history_response.dart';

import '../../data/service/history_service.dart';

final orderHistoryOneTimeProvider = FutureProvider<List<OrderHistoryResponse?>>((ref) async{
      final service = ref.read(historyServiceProvider);
      final result = await service.getOrderHistories();
      return result.data?? [];
});

final sellHistoryOneTimeProvider = FutureProvider<List<OrderHistoryResponse?>>((ref) async{
      final service = ref.read(historyServiceProvider);
      final result = await service.getSellHistories();
      return result.data?? [];
});