class PaymentCallbackRequest {
  final int paymentId;
  final String paymentStatus;

  PaymentCallbackRequest({
    required this.paymentId,
    required this.paymentStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      "paymentId": paymentId,
      "paymentStatus": paymentStatus,
    };
  }
}