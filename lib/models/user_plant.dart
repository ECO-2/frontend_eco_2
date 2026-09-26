import 'plant_species.dart';

class UserPlant {
  final String id;
  final String userId;
  final String speciesId;
  final String nickname;
  final String name;
  final String? healthStatus;
  final DateTime? acquiredAt;
  final DateTime? lastWateredAt;

  /// Recordatorios silenciados solo para esta planta. Es distinto de apagar
  /// las notificaciones de toda la cuenta: el resto del jardín sigue avisando.
  final bool remindersMuted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  /// Especie tal como la devuelve el backend junto a la planta.
  ///
  /// Antes se descartaba y cada pantalla tenía que buscarla en el catálogo
  /// cargado; si no estaba (catálogo aún cargando, o especie retirada) se
  /// caía en un valor inventado de 7 días de frecuencia, que se mostraba al
  /// usuario como si fuera real. Conservarla aquí evita esa invención.
  final PlantSpecies? species;

  UserPlant({
    required this.name,
    required this.id,
    required this.userId,
    required this.speciesId,
    required this.nickname,
    this.healthStatus,
    this.acquiredAt,
    this.lastWateredAt,
    this.remindersMuted = false,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.species,
  });

  factory UserPlant.fromJson(Map<String, dynamic> json) {
    // El endpoint GET /plants devuelve la especie embebida bajo la clave 'species'.
    final species = json['species'] as Map<String, dynamic>?;
    final speciesName = species?['common_name'] as String?;

    return UserPlant(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      speciesId: json['species_id'] as String,
      nickname: json['nickname'] as String? ?? '',
      healthStatus: json['health_status'] as String?,
      acquiredAt: json['acquired_at'] != null
          ? DateTime.tryParse(json['acquired_at'] as String)
          : null,
      lastWateredAt: json['last_watered_at'] != null
          ? DateTime.tryParse(json['last_watered_at'] as String)
          : null,
      remindersMuted: json['reminders_muted'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'] as String)
          : null,
      name: speciesName ?? json['name'] as String? ?? json['nickname'] as String? ?? '',
      species: species != null ? PlantSpecies.fromJson(species) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'species_id': speciesId,
      'nickname': nickname,
      'health_status': healthStatus,
      'acquired_at': acquiredAt?.toIso8601String(),
      'last_watered_at': lastWateredAt?.toIso8601String(),
      'reminders_muted': remindersMuted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  UserPlant copyWith({
    String? id,
    String? userId,
    String? speciesId,
    String? nickname,
    String? name,
    String? healthStatus,
    DateTime? acquiredAt,
    DateTime? lastWateredAt,
    bool? remindersMuted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    PlantSpecies? species,
  }) {
    return UserPlant(
      name: name ?? this.name,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      speciesId: speciesId ?? this.speciesId,
      nickname: nickname ?? this.nickname,
      healthStatus: healthStatus ?? this.healthStatus,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      lastWateredAt: lastWateredAt ?? this.lastWateredAt,
      remindersMuted: remindersMuted ?? this.remindersMuted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      species: species ?? this.species,
    );
  }
}
