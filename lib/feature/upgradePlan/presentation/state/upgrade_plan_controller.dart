import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:newprovider/feature/upgradePlan/data/model/upgrade_subscription_request.dart';
import 'package:newprovider/feature/upgradePlan/data/model/upgrade_subscription_response.dart';
import 'package:newprovider/feature/upgradePlan/data/service/upgrade_plan_service.dart';

final upgradePlanControllerProvider =
    AsyncNotifierProvider<UpgradePlanController, UpgradeSubscriptionResponse?>(
      UpgradePlanController.new,
    );

class UpgradePlanController
    extends AsyncNotifier<UpgradeSubscriptionResponse?> {
  @override
  FutureOr<UpgradeSubscriptionResponse?> build() {
    return null;
  }

  bool _isSubmitting = false;

  Future<UpgradeSubscriptionResponse?> subscriptionMake(UpgradeSubscriptionRequest request) async {
    if (_isSubmitting) return null;

    _isSubmitting = true;
    state = const AsyncLoading();
    try {
      final service = ref.read(upgradePlanServiceProvider);
      final result = await service.subscriptionMake(request);
      state = AsyncData(result.data);
      return result.data;
    } catch (e, s) {
      state = AsyncError(e, s);
      return null;
    } finally {
      _isSubmitting = false;
    }
  }
}
