class EnvironmentSnapshot {
  final String id;
  final String roomId;
  final double temperature;
  final double humidity;
  final double co2Level;
  final DateTime createdAt;

  EnvironmentSnapshot({
    required this.id,
    required this.roomId,
    required this.temperature,
    required this.humidity,
    required this.co2Level,
    required this.createdAt,
  });

  factory EnvironmentSnapshot.fromJson(Map<String, dynamic> json) {
    return EnvironmentSnapshot(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      co2Level: (json['co2_level'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'temperature': temperature,
      'humidity': humidity,
      'co2_level': co2Level,
      'created_at': createdAt.toIso8601String(),
    };
  }

  EnvironmentSnapshot copyWith({
    String? id,
    String? roomId,
    double? temperature,
    double? humidity,
    double? co2Level,
    DateTime? createdAt,
  }) {
    return EnvironmentSnapshot(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      co2Level: co2Level ?? this.co2Level,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
