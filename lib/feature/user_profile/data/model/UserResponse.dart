import '../../../../core/utils/helper_image.dart';

class UserResponse {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? imageUrl;
  final String? facebookLink;
  final String? telegramLink;
  final String? phoneNumber;

  UserResponse({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.facebookLink,
    this.telegramLink,
    this.phoneNumber,
    this.imageUrl,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      facebookLink: json['facebookLink'],
      telegramLink: json['telegramLink'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
    );
  }
  String get displayImage {
    return HelperImage.buildImageUrl(imageUrl);
  }

  UserResponse copyWith({
    String? imageUrl,
    String? facebookLink,
    String? telegramLink,
    String? phoneNumber,
  }) {
    return UserResponse(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      imageUrl: imageUrl ?? this.imageUrl,
      facebookLink: facebookLink ?? this.facebookLink,
      telegramLink: telegramLink ?? this.telegramLink,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
