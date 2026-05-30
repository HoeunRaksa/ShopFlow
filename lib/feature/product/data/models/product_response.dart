import 'package:newprovider/core/utils/helper_image.dart';

class ProductResponse {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;
  final bool isActive;
  final int? categoryId;
  final String? categoryName;
  final int userId;

  ProductResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.isActive,
    this.categoryId,
    this.categoryName,
    required this.userId
  });

  String get displayImage => HelperImage.buildImageUrl(imageUrl);

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      isActive: json['isActive'] ?? false,
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      userId: json['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'userId': userId,
    };
  }

}