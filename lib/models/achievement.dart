class Achievement {
  final String id;
  final String name;
  final String conditionType;
  final int conditionValue;
  final int xpReward;
  final int seedReward;
  final String? description;

  Achievement({
    required this.id,
    required this.name,
    required this.conditionType,
    required this.conditionValue,
    required this.xpReward,
    this.seedReward = 0,
    this.description,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      conditionType: json['condition_type'] as String,
      conditionValue: json['condition_value'] as int,
      xpReward: json['xp_reward'] as int,
      // Fallback a 0 mientras el backend no tenga la migración de
      // seed_reward aplicada en todos los ambientes.
      seedReward: json['seed_reward'] as int? ?? 0,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'condition_type': conditionType,
      'condition_value': conditionValue,
      'xp_reward': xpReward,
      'seed_reward': seedReward,
      'description': description,
    };
  }

  Achievement copyWith({
    String? id,
    String? name,
    String? conditionType,
    int? conditionValue,
    int? xpReward,
    int? seedReward,
    String? description,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      conditionType: conditionType ?? this.conditionType,
      conditionValue: conditionValue ?? this.conditionValue,
      xpReward: xpReward ?? this.xpReward,
      seedReward: seedReward ?? this.seedReward,
      description: description ?? this.description,
    );
  }
}
