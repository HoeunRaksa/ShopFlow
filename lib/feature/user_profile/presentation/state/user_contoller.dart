import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:newprovider/feature/user_profile/data/model/user_change_password_request.dart';
import 'package:newprovider/feature/user_profile/data/model/user_set_contact.dart';
import '../../data/model/UserResponse.dart';
import '../../data/service/user_service.dart';

final changePasswordLoadingProvider = StateProvider<bool>((ref) => false);

final userControllerProvider =
    AsyncNotifierProvider<UserController, UserResponse?>(UserController.new);

class UserController extends AsyncNotifier<UserResponse?> {
  late final UserService userService;
  @override
  Future<UserResponse?> build() async {
    userService = ref.read(userServiceProvider);
    return await userService.getMe();
  }

  Future<void> uploadImage(File file) async {
    try {
      state = const AsyncLoading();
      final imageUrl = await userService.uploadImage(file);
      final currentUser = state.value;
      if (currentUser != null) {
        state = AsyncData(currentUser.copyWith(imageUrl: imageUrl));
      } else {
        state = AsyncData(null);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<String> changePassword(UserChangePasswordRequest request) async {
    final loading = ref.read(changePasswordLoadingProvider.notifier);
    try {
      loading.state = true;
      if (request.currentPassword.isEmpty || request.newPassword.isEmpty) {
        return "Please fill all fields";
      }
      final message = userService.changePassword(request);
      return message;
    } catch (e) {
      return e.toString();
    } finally {
      loading.state = false;
    }
  }

  Future<String> createContact(UserSetContact request) async{
             return userService.createContact(request);
  }
}
