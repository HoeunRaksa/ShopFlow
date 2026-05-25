import '../../../../core/utils/helper_image.dart';
import '../../../upgradePlan/data/model/subscription_response.dart';

class UserResponse {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? imageUrl;
  final String? facebookLink;
  final String? telegramLink;
  final String? phoneNumber;
  final String? role;
  final SubscriptionResponse? subscription;

  UserResponse({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.imageUrl,
    this.facebookLink,
    this.telegramLink,
    this.phoneNumber,
    this.role,
    this.subscription,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      imageUrl: json['imageUrl'],
      facebookLink: json['facebookLink'],
      telegramLink: json['telegramLink'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      subscription: json['subscription'] != null
          ? SubscriptionResponse.fromJson(json['subscription'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "imageUrl": imageUrl,
      "facebookLink": facebookLink,
      "telegramLink": telegramLink,
      "phoneNumber": phoneNumber,
      "role": role,
      "subscription": subscription?.toJson(),
    };
  }

  String get displayImage {
    return HelperImage.buildImageUrl(imageUrl);
  }

  UserResponse copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? imageUrl,
    String? facebookLink,
    String? telegramLink,
    String? phoneNumber,
    String? role,
    SubscriptionResponse? subscription,
  }) {
    return UserResponse(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      imageUrl: imageUrl ?? this.imageUrl,
      facebookLink: facebookLink ?? this.facebookLink,
      telegramLink: telegramLink ?? this.telegramLink,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      subscription: subscription ?? this.subscription,
    );
  }
}