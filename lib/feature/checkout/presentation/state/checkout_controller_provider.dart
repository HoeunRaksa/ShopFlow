import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:newprovider/feature/checkout/data/model/location_response.dart';
import 'package:newprovider/feature/checkout/data/service/checkout_service.dart';

import '../../data/model/location_request.dart';

final isSelectedProvider = StateProvider<bool>((ref) => false);
final appButtonStyleProvider = StateProvider<String>((ref) => "");
final selectedLocationIdProvider = StateProvider<int?>((ref) => null);
final getLocationControllerProvider = FutureProvider<List<LocationResponse>>((
  ref,
) async {
  final data = ref.read(checkoutServiceProvider);
  return data.getLocation();
});

final checkoutProvider = AsyncNotifierProvider<CheckoutController, String>(
  CheckoutController.new,
);

class CheckoutController extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() {
    return "";
  }

  Future<String> checkout(int? locationId, LocationRequest? request) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      final service = ref.read(checkoutServiceProvider);

      return await service.checkout(locationId, request);
    });

    state = result;

    return result.value ?? "";
  }
}
