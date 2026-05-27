import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import '../models/AuthResponse.dart';
import '../models/LoginRequest.dart';
import '../models/RegisterRequest.dart';
import '../models/VerifyOtpRequest.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(dioProvider);
  return AuthService(dio);
});

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<void> login(LoginRequest request) async {
    await dio.post(
      "/auth/login",
      data: request.toJson(),
      options: Options(
        responseType: ResponseType.plain,
      ),
    );
  }

  Future<void> register(RegisterRequest request) async {
    await dio.post("/auth/register", data: request.toJson());
  }

  Future<AuthResponse> verifyOtp(VerifyOtpRequest request) async {
    final res = await dio.post(
      "/auth/verify-otp",
      data: request.toJson(),
    );

    return AuthResponse.fromJson(res.data);
  }
}