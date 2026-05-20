import '../../../product/data/models/product_response.dart';

class CartResponse {
  final int id;
  late final int quantity;
  final ProductResponse product;

  CartResponse({
    required this.id,
    required this.quantity,
    required this.product,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      id: json['id'],
      quantity: json['quantity'],
      product: ProductResponse.fromJson(json['product']),
    );
  }

  CartResponse copyWith({
    int? id,
    int? quantity,
    ProductResponse? product,
  }) {
    return CartResponse(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}