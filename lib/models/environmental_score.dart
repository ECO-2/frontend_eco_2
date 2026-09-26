class EnvironmentalScore {
  final String id;
  final String roomId;
  final double score;
  final DateTime calculatedAt;

  EnvironmentalScore({
    required this.id,
    required this.roomId,
    required this.score,
    required this.calculatedAt,
  });

  factory EnvironmentalScore.fromJson(Map<String, dynamic> json) {
    return EnvironmentalScore(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      score: (json['score'] as num).toDouble(),
      calculatedAt: DateTime.parse(json['calculated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'score': score,
      'calculated_at': calculatedAt.toIso8601String(),
    };
  }

  EnvironmentalScore copyWith({
    String? id,
    String? roomId,
    double? score,
    DateTime? calculatedAt,
  }) {
    return EnvironmentalScore(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      score: score ?? this.score,
      calculatedAt: calculatedAt ?? this.calculatedAt,
    );
  }
}
