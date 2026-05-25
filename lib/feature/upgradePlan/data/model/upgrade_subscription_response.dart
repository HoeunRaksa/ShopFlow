class UpgradeSubscriptionResponse {
  final int paymentId;
  final String paymentCode;
  final int subscriptionId;
  final String plan;
  final double amount;
  final String paymentStatus;
  UpgradeSubscriptionResponse({
    required this.paymentId,
    required this.paymentCode,
    required this.subscriptionId,
    required this.plan,
    required this.amount,
    required this.paymentStatus,
  });
  factory UpgradeSubscriptionResponse.fromJson(
      Map<String, dynamic> json) {
    return UpgradeSubscriptionResponse(
      paymentId: json['paymentId'],
      paymentCode: json['paymentCode'],
      subscriptionId: json['subscriptionId'],
      plan: json['plan'],
      amount: (json['amount'] as num).toDouble(),
      paymentStatus: json['paymentStatus'],
    );
  }
}