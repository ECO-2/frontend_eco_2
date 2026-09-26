class UserPlantTask {
  final String id;
  final String userPlantId;
  final String taskType;
  final DateTime nextDueAt;
  final DateTime? lastCompletedAt;
  final int frequencyDays;

  UserPlantTask({
    required this.id,
    required this.userPlantId,
    required this.taskType,
    required this.nextDueAt,
    this.lastCompletedAt,
    required this.frequencyDays,
  });

  factory UserPlantTask.fromJson(Map<String, dynamic> json) {
    return UserPlantTask(
      id: json['id'] as String,
      userPlantId: json['user_plant_id'] as String,
      taskType: json['task_type'] as String,
      nextDueAt: DateTime.parse(json['next_due_at'] as String),
      lastCompletedAt: json['last_completed_at'] != null ? DateTime.parse(json['last_completed_at'] as String) : null,
      frequencyDays: json['frequency_days'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_plant_id': userPlantId,
      'task_type': taskType,
      'next_due_at': nextDueAt.toIso8601String(),
      'last_completed_at': lastCompletedAt?.toIso8601String(),
      'frequency_days': frequencyDays,
    };
  }

  UserPlantTask copyWith({
    String? id,
    String? userPlantId,
    String? taskType,
    DateTime? nextDueAt,
    DateTime? lastCompletedAt,
    int? frequencyDays,
  }) {
    return UserPlantTask(
      id: id ?? this.id,
      userPlantId: userPlantId ?? this.userPlantId,
      taskType: taskType ?? this.taskType,
      nextDueAt: nextDueAt ?? this.nextDueAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      frequencyDays: frequencyDays ?? this.frequencyDays,
    );
  }
}
