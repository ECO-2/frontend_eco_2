class CareLog {
  final String id;
  final String userPlantId;
  final String taskType;
  final DateTime performedAt;

  CareLog({
    required this.id,
    required this.userPlantId,
    required this.taskType,
    required this.performedAt,
  });

  factory CareLog.fromJson(Map<String, dynamic> json) {
    return CareLog(
      id: json['id'] as String,
      userPlantId: json['user_plant_id'] as String,
      taskType: json['task_type'] as String,
      performedAt: DateTime.parse(json['performed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_plant_id': userPlantId,
      'task_type': taskType,
      'performed_at': performedAt.toIso8601String(),
    };
  }

  CareLog copyWith({
    String? id,
    String? userPlantId,
    String? taskType,
    DateTime? performedAt,
  }) {
    return CareLog(
      id: id ?? this.id,
      userPlantId: userPlantId ?? this.userPlantId,
      taskType: taskType ?? this.taskType,
      performedAt: performedAt ?? this.performedAt,
    );
  }
}
