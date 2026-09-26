class XpLog {
  final String id;
  final String userId;
  final String actionType;
  final int xpEarned;
  final DateTime createdAt;

  XpLog({
    required this.id,
    required this.userId,
    required this.actionType,
    required this.xpEarned,
    required this.createdAt,
  });

  factory XpLog.fromJson(Map<String, dynamic> json) {
    return XpLog(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      actionType: json['action_type'] as String,
      xpEarned: json['xp_earned'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'action_type': actionType,
      'xp_earned': xpEarned,
      'created_at': createdAt.toIso8601String(),
    };
  }

  XpLog copyWith({
    String? id,
    String? userId,
    String? actionType,
    int? xpEarned,
    DateTime? createdAt,
  }) {
    return XpLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      actionType: actionType ?? this.actionType,
      xpEarned: xpEarned ?? this.xpEarned,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
