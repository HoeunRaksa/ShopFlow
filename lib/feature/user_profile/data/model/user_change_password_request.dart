class UserChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  UserChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });
  Map<String, dynamic> toJson() {
    return {'currentPassword': currentPassword, 'newPassword': newPassword};
  }
}
