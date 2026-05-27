import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:newprovider/feature/upgradePlan/data/model/subscription_plan_response.dart';
import 'package:newprovider/feature/upgradePlan/data/service/subscription_plan_service.dart';

final subscriptionPlanEntryProvider =
FutureProvider<List<SubscriptionPlanResponse>>((
    ref,
    ) async {
  final service =
  ref.read(subscriptionPlanServiceProvider);
  final result =
  await service.getSubscriptionEntry();
  return result.data ?? [];
});

final subscriptionPlanTypeProvider = Provider.family<SubscriptionPlanResponse?, int>((ref, id){
   final plan = ref.watch(subscriptionPlanEntryProvider).value;
   final onePlan = plan?.where((p) => p.id == id).first;
   return onePlan;
});