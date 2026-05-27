class SubscriptionFeatureResponse {
  final int id;
  final String feature;

  SubscriptionFeatureResponse({
    required this.id,
    required this.feature,
  });

  factory SubscriptionFeatureResponse.fromJson(
      Map<String, dynamic> json) {
    return SubscriptionFeatureResponse(
      id: json['id'],
      feature: json['feature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "feature": feature,
    };
  }
}