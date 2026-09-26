class User {
  final String id;
  final String email;
  final String username;
  final String? avatarUrl;
  final String? passwordHash;
  final String? provider;
  final bool mfaEnabled;
  final String? planType;
  final String? gender;
  final DateTime? birthDay;
  final String? role;
  final String? resetTokenHash;
  final bool onboardingCompleted;
  final bool? notificationsEnabled;
  final int? reminderStartHour;
  final int? reminderEndHour;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    this.passwordHash,
    this.provider,
    required this.mfaEnabled,
    this.planType,
    this.gender,
    this.birthDay,
    this.role,
    this.resetTokenHash,
    this.onboardingCompleted = false,
    this.notificationsEnabled,
    this.reminderStartHour,
    this.reminderEndHour,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      passwordHash: json['password_hash'] as String?,
      provider: json['provider'] as String?,
      mfaEnabled: json['mfa_enabled'] as bool? ?? false,
      planType: json['plan_type'] as String?,
      gender: json['gender'] as String?,
      birthDay: json['birth_day'] != null
          ? DateTime.tryParse(json['birth_day'] as String)
          : null,
      role: json['role'] as String?,
      resetTokenHash: json['reset_token_hash'] as String?,
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      notificationsEnabled: json['notifications_enabled'] as bool?,
      reminderStartHour: json['reminder_start_hour'] as int?,
      reminderEndHour: json['reminder_end_hour'] as int?,
      createdAt: json['created_at'] != null
          ? (DateTime.tryParse(json['created_at'] as String) ?? DateTime.now())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'password_hash': passwordHash,
      'provider': provider,
      'mfa_enabled': mfaEnabled,
      'plan_type': planType,
      'gender': gender,
      'birth_day': birthDay?.toIso8601String(),
      'role': role,
      'reset_token_hash': resetTokenHash,
      'onboarding_completed': onboardingCompleted,
      'notifications_enabled': notificationsEnabled,
      'reminder_start_hour': reminderStartHour,
      'reminder_end_hour': reminderEndHour,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
    String? passwordHash,
    String? provider,
    bool? mfaEnabled,
    String? planType,
    String? gender,
    DateTime? birthDay,
    String? role,
    String? resetTokenHash,
    bool? onboardingCompleted,
    bool? notificationsEnabled,
    int? reminderStartHour,
    int? reminderEndHour,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      passwordHash: passwordHash ?? this.passwordHash,
      provider: provider ?? this.provider,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      planType: planType ?? this.planType,
      gender: gender ?? this.gender,
      birthDay: birthDay ?? this.birthDay,
      role: role ?? this.role,
      resetTokenHash: resetTokenHash ?? this.resetTokenHash,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderStartHour: reminderStartHour ?? this.reminderStartHour,
      reminderEndHour: reminderEndHour ?? this.reminderEndHour,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
