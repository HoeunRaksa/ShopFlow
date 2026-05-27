import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:newprovider/feature/cart/presentation/state/cart_contoller.dart';
import '../../../../core/result_ressage.dart';
import '../../data/model/OrderResponse.dart';
import '../../data/model/location_request.dart';
import '../../data/model/location_response.dart';
import '../../data/model/payment_callback_request.dart';
import '../../data/service/checkout_service.dart';

enum PaymentStatus {
  paid('PAID'),
  pending('PENDING'),
  failed('FAILED');

  const PaymentStatus(this.value);
  final String value;
}
final isSelectedProvider = StateProvider<bool>((ref) => false);
final appButtonStyleProvider = StateProvider<String>((ref) => "");
final selectedLocationIdProvider = StateProvider<int?>((ref) => null);
final paymentCountdownProvider = StateProvider<int?>((ref) => null);
final paymentCallbackResultProvider =
StateProvider<ResultMessage<String>?>((ref) => null);

final getLocationControllerProvider =
FutureProvider<List<LocationResponse>>((ref) async {
  final service = ref.read(checkoutServiceProvider);

  final locations = await service.getLocation();

  final currentSelectedId = ref.read(selectedLocationIdProvider);

  if (locations.isNotEmpty && currentSelectedId == null) {
    Future.microtask(() {
      ref.read(selectedLocationIdProvider.notifier).state = locations.first.id;
      debugPrint("Default Location ID: ${locations.first.id}");
    });
  }

  return locations;
});
final checkoutProvider =
AsyncNotifierProvider<CheckoutController, ResultMessage<OrderResponse>?>(
  CheckoutController.new,
);

class CheckoutController extends AsyncNotifier<ResultMessage<OrderResponse>?> {
  bool _isSubmitting = false;
  Timer? _countdownTimer;

  @override
  FutureOr<ResultMessage<OrderResponse>?> build() {
    ref.onDispose(() => _countdownTimer?.cancel());
    return null;
  }
  Future<ResultMessage<OrderResponse>?> checkout(
      int? locationId,
      LocationRequest? request,
      ) async {
    if (_isSubmitting || state.isLoading) {
      debugPrint("Checkout blocked: already submitting");
      return state.value;
    }

    if (locationId == null && request == null) {
      final error = Exception("Please select or add a location first");
      state = AsyncError(error, StackTrace.current);
      return null;
    }

    _isSubmitting = true;
    state = const AsyncLoading();

    try {
      final service = ref.read(checkoutServiceProvider);
      final result = await service.checkout(locationId, request);
      state = AsyncData(result);

      debugPrint("Checkout Message: ${result.message}");
      debugPrint("Checkout Data: ${result.data}");
      final paymentId = result.data?.paymentId;
      if (paymentId != null) {
        _startPaymentCountdown(paymentId);
      } else {
        debugPrint("Payment ID missing — skipping callback");
      }
      return result;
    } catch (e, s) {
      state = AsyncError(e, s);
      debugPrint("Checkout Error: $e");
      return null;
    } finally {
      _isSubmitting = false;
    }
  }

  Future<void> startPayment(int paymentId) async {
    _triggerPaymentCallback(
      paymentId,
      PaymentStatus.paid,
    );
  }

  void _startPaymentCountdown(int paymentId) {
    const int countdownSeconds = 3;

    ref.read(paymentCountdownProvider.notifier).state = countdownSeconds;
    int remaining = countdownSeconds;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining--;
      ref.read(paymentCountdownProvider.notifier).state =
      remaining > 0 ? remaining : null;
      if (remaining <= 0) timer.cancel();
    });

    Timer(const Duration(seconds: countdownSeconds), () {
      _countdownTimer?.cancel();
      ref.read(paymentCountdownProvider.notifier).state = null;
      _triggerPaymentCallback(paymentId, PaymentStatus.paid);
    });
  }
  Future<void> _triggerPaymentCallback(
      int paymentId,
      PaymentStatus status,
      ) async {
    try {
      final service = ref.read(checkoutServiceProvider);

      final callbackRequest = PaymentCallbackRequest(
        paymentId: paymentId,
        paymentStatus: status.value,
      );

      final result = await service.paymentCallback(callbackRequest);

      debugPrint("Payment Callback Message: ${result.message}");
      debugPrint("Payment Callback Data: ${result.data}");

      ref.read(paymentCallbackResultProvider.notifier).state = result;
      ref.read(cartProvider.notifier).refreshCart();
    } catch (e, s) {
      debugPrint("Payment Callback Error: $e");
      ref.read(paymentCallbackResultProvider.notifier).state =
          ResultMessage<String>(
            code: 0,
            status: 500,
            message: e.toString(),
            data: null,
          );
    }
  }
}