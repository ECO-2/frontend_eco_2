class UserProgress {
  final String userId;
  final int xp;
  final int level;
  final int streakDays;
  final int seeds;
  final DateTime? updatedAt;

  /// Nombre del nivel ("Semilla", "Brote", "Retoño"...) que devuelve el
  /// backend junto al número. Antes las pantallas de Perfil y Ajustes lo
  /// tenian escrito a mano como "Nivel 2 - Brote", igual para todos.
  final String? levelName;

  /// Progreso 0..1 dentro del nivel actual y XP que falta para el siguiente.
  /// `xpForNext` es null en el ultimo nivel, donde no hay siguiente.
  final double levelProgress;
  final int? xpForNext;
  final String? nextLevelName;

  UserProgress({
    required this.userId,
    required this.xp,
    required this.level,
    required this.streakDays,
    required this.seeds,
    this.updatedAt,
    this.levelName,
    this.levelProgress = 0,
    this.xpForNext,
    this.nextLevelName,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['user_id'] as String,
      xp: json['xp'] as int,
      level: json['level'] as int,
      streakDays: json['streak_days'] as int,
      seeds: json['seeds'] as int,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      levelName: json['level_name'] as String?,
      levelProgress: (json['level_progress'] as num?)?.toDouble() ?? 0,
      xpForNext: (json['xp_for_next'] as num?)?.toInt(),
      nextLevelName: json['next_level_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'xp': xp,
      'level': level,
      'streak_days': streakDays,
      'seeds': seeds,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserProgress copyWith({
    String? userId,
    int? xp,
    int? level,
    int? streakDays,
    int? seeds,
    DateTime? updatedAt,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      seeds: seeds ?? this.seeds,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
