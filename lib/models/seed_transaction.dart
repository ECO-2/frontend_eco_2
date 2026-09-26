class SeedTransaction {
  final String id;
  final String userId;
  final int amount;
  final String reason;
  final DateTime createdAt;

  SeedTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.reason,
    required this.createdAt,
  });

  factory SeedTransaction.fromJson(Map<String, dynamic> json) {
    return SeedTransaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: json['amount'] as int,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  SeedTransaction copyWith({
    String? id,
    String? userId,
    int? amount,
    String? reason,
    DateTime? createdAt,
  }) {
    return SeedTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
