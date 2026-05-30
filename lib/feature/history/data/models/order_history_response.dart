import 'order_item_response.dart';

class OrderHistoryResponse {
  final int id;
  final double totalPrice;
  final String status;
  final DateTime createAt;
  final List<OrderItemResponse> items;

  OrderHistoryResponse({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.createAt,
    required this.items,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    return OrderHistoryResponse(
      id: json['id'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'],
      createAt: DateTime.parse(json['createAt']),
      items: (json['items'] as List)
          .map((e) => OrderItemResponse.fromJson(e))
          .toList(),
    );
  }
}