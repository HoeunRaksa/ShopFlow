import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:newprovider/core/api_response.dart';
import 'package:newprovider/feature/product/data/models/product_response.dart';
import 'package:newprovider/feature/product/data/service/product_service.dart';
import 'package:newprovider/feature/user_profile/data/model/UserResponse.dart';
import 'package:newprovider/feature/user_profile/data/service/user_service.dart';
final ownerCounterProductControllerProvider = StateProvider<int>((ref){
   return 0;
});
final userOwnerProvider = FutureProvider.family<UserResponse, int>((ref,userId) async{
   final service = ref.read(userServiceProvider);
   return service.getOwner(userId);
});

final productForUserOwnerProvider = FutureProvider.family<ApiResponse<List<ProductResponse>>, int>((ref, userId) async{
   final service = ref.read(productServiceProvider);
   return await service.getProductByUserOwnerId(userId);
});


final ownerPushVerificationControllerProvider = StateProvider<bool>((ref){
      return false;
});