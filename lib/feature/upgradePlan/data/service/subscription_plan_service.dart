import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/core/network/dio_provider.dart';
import 'package:newprovider/core/result_ressage.dart';
import 'package:newprovider/feature/upgradePlan/data/model/subscription_plan_response.dart';
final subscriptionPlanServiceProvider = Provider<SubscriptionPlanService>((ref){
    final dio = ref.read(dioProvider);
    return  SubscriptionPlanService(dio);
});
class SubscriptionPlanService {
  final Dio dio;
  SubscriptionPlanService(this.dio);
  Future<ResultMessage<List<SubscriptionPlanResponse>>> getSubscriptionEntry()async{
        final response = await dio.get("/subscriptionEntry");
        final result = ResultMessage<List<SubscriptionPlanResponse>>.fromJson(
          response.data,
              (data) => (data as List)
              .map((e) => SubscriptionPlanResponse.fromJson(e))
              .toList(),
        );
        return result;
  }
}