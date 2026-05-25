class UpgradeSubscriptionRequest {
  final int subscriptionId;
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  final String securityCode;

  UpgradeSubscriptionRequest({
    required this.subscriptionId,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.securityCode,
  });
  
  Map<String, dynamic> toJson() {
    return {
      "subscriptionId": subscriptionId,
      "cardNumber": cardNumber,
      "expiryMonth": expiryMonth,
      "expiryYear": expiryYear,
      "securityCode": securityCode,
    };
  }

  UpgradeSubscriptionRequest copyWith({
    int? subscriptionId,
    String? cardNumber,
    String? expiryMonth,
    String? expiryYear,
    String? securityCode,
  }) {
    return UpgradeSubscriptionRequest(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      securityCode: securityCode ?? this.securityCode,
    );
  }
}