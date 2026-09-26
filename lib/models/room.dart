class Room {
  final String id;
  final String userId;
  final String name;
  final double? sizeM2;
  final String? lightLevel;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Room({
    required this.id,
    required this.userId,
    required this.name,
    this.sizeM2,
    this.lightLevel,
    required this.createdAt,
    this.deletedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      sizeM2: json['size_m2'] != null ? (json['size_m2'] as num).toDouble() : null,
      lightLevel: json['light_level'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'size_m2': sizeM2,
      'light_level': lightLevel,
      'created_at': createdAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Room copyWith({
    String? id,
    String? userId,
    String? name,
    double? sizeM2,
    String? lightLevel,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return Room(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      sizeM2: sizeM2 ?? this.sizeM2,
      lightLevel: lightLevel ?? this.lightLevel,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
