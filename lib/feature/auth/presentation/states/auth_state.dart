import '../../../user_profile/data/model/UserResponse.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final String? accessToken;
  final String? refreshToken;
  final UserResponse? user;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  bool get isAuthenticated =>
      accessToken != null && accessToken!.isNotEmpty;

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? accessToken,
    String? refreshToken,
    UserResponse? user,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }
}