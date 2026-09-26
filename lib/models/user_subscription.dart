class UserSubscription {
  final String id;
  final String userId;
  final String planId;
  final String status;
  final DateTime startedAt;
  final DateTime? expiresAt;
  final DateTime? cancelledAt;

  UserSubscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.startedAt,
    this.expiresAt,
    this.cancelledAt,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      planId: json['plan_id'] as String,
      status: json['status'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
      cancelledAt: json['cancelled_at'] != null ? DateTime.parse(json['cancelled_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan_id': planId,
      'status': status,
      'started_at': startedAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
    };
  }

  UserSubscription copyWith({
    String? id,
    String? userId,
    String? planId,
    String? status,
    DateTime? startedAt,
    DateTime? expiresAt,
    DateTime? cancelledAt,
  }) {
    return UserSubscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }
}
