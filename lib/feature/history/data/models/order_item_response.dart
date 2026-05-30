import '../../../product/data/models/product_response.dart';

class OrderItemResponse {
  final int id;
  final ProductResponse product;
  final int quantity;
  final double price;


  OrderItemResponse({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) {

    return OrderItemResponse(
      id: json['id'],
      product: ProductResponse.fromJson(json['product']),
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
