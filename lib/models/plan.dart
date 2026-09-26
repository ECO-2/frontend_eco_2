class Plan {
  final String id;
  final String name;
  final String displayName;
  final int paymentFrequency;
  final double price;
  final int plantLimit;
  final int aiScansMonthly;
  final bool hasCo2Tracking;
  final bool hasAdvancedStats;
  final bool active;
  final DateTime createdAt;

  Plan({
    required this.id,
    required this.name,
    required this.displayName,
    required this.paymentFrequency,
    required this.price,
    required this.plantLimit,
    required this.aiScansMonthly,
    required this.hasCo2Tracking,
    required this.hasAdvancedStats,
    required this.active,
    required this.createdAt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      paymentFrequency: json['payment_frequency'] as int,
      price: (json['price'] as num).toDouble(),
      plantLimit: json['plant_limit'] as int,
      aiScansMonthly: json['ai_scans_monthly'] as int,
      hasCo2Tracking: json['has_co2_tracking'] as bool? ?? false,
      hasAdvancedStats: json['has_advanced_stats'] as bool? ?? false,
      active: json['active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'payment_frequency': paymentFrequency,
      'price': price,
      'plant_limit': plantLimit,
      'ai_scans_monthly': aiScansMonthly,
      'has_co2_tracking': hasCo2Tracking,
      'has_advanced_stats': hasAdvancedStats,
      'active': active,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Plan copyWith({
    String? id,
    String? name,
    String? displayName,
    int? paymentFrequency,
    double? price,
    int? plantLimit,
    int? aiScansMonthly,
    bool? hasCo2Tracking,
    bool? hasAdvancedStats,
    bool? active,
    DateTime? createdAt,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
      price: price ?? this.price,
      plantLimit: plantLimit ?? this.plantLimit,
      aiScansMonthly: aiScansMonthly ?? this.aiScansMonthly,
      hasCo2Tracking: hasCo2Tracking ?? this.hasCo2Tracking,
      hasAdvancedStats: hasAdvancedStats ?? this.hasAdvancedStats,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
