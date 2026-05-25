class OrderResponse {
  final int orderId;
  final double totalAmount;
  final String orderStatus;
  final int paymentId;
  final String paymentCode;
  final String paymentStatus;
  final String createdAt;

  OrderResponse({
    required this.orderId,
    required this.totalAmount,
    required this.orderStatus,
    required this.paymentId,
    required this.paymentCode,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['orderId'] as int,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderStatus: json['orderStatus'] as String,
      paymentId: json['paymentId'] as int,
      paymentCode: json['paymentCode'] as String,
      paymentStatus: json['paymentStatus'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  @override
  String toString() =>
      'OrderResponse(orderId: $orderId, paymentId: $paymentId, '
          'paymentCode: $paymentCode, paymentStatus: $paymentStatus)';
}