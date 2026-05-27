import 'subscription_feature_response.dart';

class SubscriptionPlanResponse {
  final int id;
  final String title;
  final double price;
  final String description;
  final bool active;
  final List<SubscriptionFeatureResponse> features;

  SubscriptionPlanResponse({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.active,
    required this.features,
  });

  factory SubscriptionPlanResponse.fromJson(
      Map<String, dynamic> json) {
    return SubscriptionPlanResponse(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      active: json['active'],
      features: (json['features'] as List)
          .map(
            (e) => SubscriptionFeatureResponse.fromJson(e),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "description": description,
      "active": active,
      "features":
      features.map((e) => e.toJson()).toList(),
    };
  }
}