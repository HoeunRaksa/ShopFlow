class SubscriptionResponse {
  final String plan;
  final String displayName;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool active;

  SubscriptionResponse({
    required this.plan,
    required this.displayName,
    this.startDate,
    this.endDate,
    required this.active,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      plan: json['plan'] ?? 'FREE',
      displayName: json['displayName'] ?? 'Free Member',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "plan": plan,
      "displayName": displayName,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "active": active,
    };
  }
}