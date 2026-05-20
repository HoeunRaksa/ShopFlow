import 'package:newprovider/core/utils/helper_image.dart';

class CategoryResponse {
  int id;
  String name;
  String description;
  String imageUrl;
  CategoryResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl
  });
  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
        id: json['id'], 
        name: json['name'], 
        description: json['description'],
        imageUrl: HelperImage.buildImageUrl(json['imageUrl'])
    );
  }
}
