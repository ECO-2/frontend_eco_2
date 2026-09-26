class Session {
  final String id;
  final String userId;
  final String? refreshTokenHash;
  final DateTime expiresAt;
  final DateTime? revokedAt;
  final DateTime createdAt;

  Session({
    required this.id,
    required this.userId,
    this.refreshTokenHash,
    required this.expiresAt,
    this.revokedAt,
    required this.createdAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      refreshTokenHash: json['refresh_token_hash'] as String?,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      revokedAt: json['revoked_at'] != null ? DateTime.parse(json['revoked_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'refresh_token_hash': refreshTokenHash,
      'expires_at': expiresAt.toIso8601String(),
      'revoked_at': revokedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Session copyWith({
    String? id,
    String? userId,
    String? refreshTokenHash,
    DateTime? expiresAt,
    DateTime? revokedAt,
    DateTime? createdAt,
  }) {
    return Session(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      refreshTokenHash: refreshTokenHash ?? this.refreshTokenHash,
      expiresAt: expiresAt ?? this.expiresAt,
      revokedAt: revokedAt ?? this.revokedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
