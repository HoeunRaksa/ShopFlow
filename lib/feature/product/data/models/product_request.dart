class ProductRequest{
  final String name;
  final String description;
  final double price;
  final int stock;
  final bool isActive;
  final int? categoryId;
  ProductRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.isActive,
    this.categoryId,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'isActive': isActive,
      'categoryId': categoryId,
    };
  }
}