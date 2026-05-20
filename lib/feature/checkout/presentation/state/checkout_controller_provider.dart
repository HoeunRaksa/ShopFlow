import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:newprovider/feature/checkout/data/model/location_response.dart';
import 'package:newprovider/feature/checkout/data/service/checkout_service.dart';

final isSelectedProvider =
StateProvider<bool>((ref) => false);

final appButtonStyleProvider = StateProvider<String>(
      (ref) => "",
);

final selectedLocationIdProvider =
StateProvider<int?>(
        (ref) => null
);

final checkoutControllerProvider = FutureProvider<List<LocationResponse>>((ref) async{
      final data = ref.read(checkoutServiceProvider);
      return data.getLocation();
});