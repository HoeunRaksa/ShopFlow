import '../../../user_profile/data/model/UserResponse.dart';

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserResponse user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: UserResponse.fromJson(json['user']),
    );
  }
}