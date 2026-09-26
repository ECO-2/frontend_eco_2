class Co2Log {
  final String id;
  final String userId;
  final DateTime date;
  final double co2Grams;
  final DateTime createdAt;

  Co2Log({
    required this.id,
    required this.userId,
    required this.date,
    required this.co2Grams,
    required this.createdAt,
  });

  factory Co2Log.fromJson(Map<String, dynamic> json) {
    return Co2Log(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      co2Grams: (json['co2_grams'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      'co2_grams': co2Grams,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Co2Log copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? co2Grams,
    DateTime? createdAt,
  }) {
    return Co2Log(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      co2Grams: co2Grams ?? this.co2Grams,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
