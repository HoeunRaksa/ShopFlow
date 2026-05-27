import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/token_storage.dart';
import '../../data/models/AuthResponse.dart';
import '../../data/models/LoginRequest.dart';
import '../../data/models/RegisterRequest.dart';
import '../../data/models/VerifyOtpRequest.dart';
import '../../data/services/auth_service.dart';
import 'auth_state.dart';

final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    authService: ref.read(authServiceProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  );
});

class AuthController extends StateNotifier<AuthState> {
  final AuthService authService;
  final TokenStorage tokenStorage;

  AuthController({
    required this.authService,
    required this.tokenStorage,
  }) : super(const AuthState());

  Future<bool> login(LoginRequest request) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await tokenStorage.clearToken();

      await authService.login(request);

      state = state.copyWith(isLoading: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data.toString() ?? e.message,
      );
      return false;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await authService.register(request);

      state = state.copyWith(isLoading: false);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e),
      );
      return false;
    }
  }

  Future<bool> verifyOtp(VerifyOtpRequest request) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final AuthResponse response = await authService.verifyOtp(request);

      await tokenStorage.saveAccessToken(response.accessToken);
      await tokenStorage.saveRefreshToken(response.refreshToken);

      state = state.copyWith(
        isLoading: false,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        user: response.user,
      );

      return true;
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _parseError(e),
      );
      return false;
    }
  }

  Future<void> loadSavedToken() async {
    final accessToken = await tokenStorage.getAccessToken();
    final refreshToken = await tokenStorage.getRefreshToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      state = state.copyWith(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
  }

  Future<void> logout() async {
    await tokenStorage.clearToken();
    state = const AuthState();
  }

  String _parseError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            data.toString();
      }
      return data.toString();
    }
    return switch (e.type) {
      DioExceptionType.connectionTimeout => "Connection timeout",
      DioExceptionType.receiveTimeout    => "Server not responding",
      DioExceptionType.sendTimeout       => "Request timeout",
      DioExceptionType.connectionError   => "No internet connection",
      _                                  => e.message ?? "Something went wrong",
    };
  }
  
}