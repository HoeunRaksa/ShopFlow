class UpgradeSubscriptionRequest {
  final int subscriptionId;
  final String cardNumber;
  final String expiryDate;
  final String securityCode;

  UpgradeSubscriptionRequest({
    required this.subscriptionId,
    required this.cardNumber,
    required this.expiryDate,
    required this.securityCode,
  });
  
  Map<String, dynamic> toJson() {
    return {
      "subscriptionId": subscriptionId,
      "cardNumber": cardNumber,
      "expiryDate": expiryDate,
      "securityCode": securityCode,
    };
  }

  UpgradeSubscriptionRequest copyWith({
    int? subscriptionId,
    String? cardNumber,
    String? expiryDate,
    String? securityCode,
  }) {
    return UpgradeSubscriptionRequest(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      securityCode: securityCode ?? this.securityCode,
    );
  }
}