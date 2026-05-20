import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/core/api_response.dart';
import 'package:newprovider/core/dio_provider.dart';
import 'package:newprovider/feature/user_profile/data/model/UserResponse.dart';
import 'package:newprovider/feature/user_profile/data/model/user_change_password_request.dart';
import 'package:newprovider/feature/user_profile/data/model/user_set_contact.dart';
import '../../../../core/utils/file_upload_helper.dart';
final userServiceProvider = Provider<UserService>((ref){
   final dio =  ref.read(dioProvider);
   return UserService(dio);
});
class UserService {
   final Dio dio;
   UserService(this.dio);

   Future<String> uploadImage(File file) async {
     try {
       final formData = await FileUploadHelper.imageToFormData(file);
       final response = await dio.put(
         "/user/set_profile",
         data: formData,
       );
       return response.data["imageUrl"];
     } on DioException catch (e) {
       throw Exception(
         e.response?.data ?? e.message ?? "Upload failed",
       );
     }
   }

   Future<UserResponse> getMe() async{
     final response = await dio.get("/user/me");
     return UserResponse.fromJson(response.data);
   }

   Future<String> changePassword(UserChangePasswordRequest request) async{
     final response = await dio.patch("/user/change-password",
       data: request.toJson()
     );
     final api = ApiResponse.fromJson(response.data, (data) => data.toString());
     return api.message;
   }
   Future<String> createContact(UserSetContact request) async{
         final response = await dio.put('/user/create-contact', data: request.toJson());
          final message = response.data['message'];
          return message;
   }
   Future<UserResponse> getOwner(int userId)async{
     final response = await dio.get('/user/getById/$userId');
     final data = response.data['data'];
     return UserResponse.fromJson(data);
   }
}