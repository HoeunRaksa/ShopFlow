import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/core/network/dio_provider.dart';
import 'package:newprovider/core/result_ressage.dart';
import 'package:newprovider/feature/upgradePlan/data/model/upgrade_subscription_response.dart';

import '../model/upgrade_subscription_request.dart';

final upgradePlanServiceProvider = Provider<UpgradePlanService>( (ref){
  final dio = ref.read(dioProvider);
  return UpgradePlanService(dio);
});
class UpgradePlanService {
  final Dio dio;
   UpgradePlanService(this.dio);
  Future<ResultMessage<UpgradeSubscriptionResponse>> subscriptionMake(UpgradeSubscriptionRequest request)async{
       final response = await dio.post("/subscription/upgrade-subscription",
         data: request.toJson()
       );
       final result = ResultMessage<UpgradeSubscriptionResponse>.fromJson(response.data,(data) => UpgradeSubscriptionResponse.fromJson(data));
       return result;
  }
}