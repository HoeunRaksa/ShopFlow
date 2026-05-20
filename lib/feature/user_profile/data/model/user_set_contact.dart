class UserSetContact {
  String? facebookLink;
  String? telegramLink;
  String? phoneNumber;
  UserSetContact({this.facebookLink, this.telegramLink, this.phoneNumber});
  Map<String, dynamic> toJson() {
    return {
      'facebookLink': facebookLink,
      'telegramLink': telegramLink,
      'phoneNumber': phoneNumber,
    };
  }
}
