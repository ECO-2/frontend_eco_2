import 'plant_species.dart';

class PlantIdentification {
  final String id;
  final String userId;
  // Nulo en la práctica: no subimos la foto a ningún lado (se manda como
  // base64 directo a la API de identificación y no se guarda), así que el
  // backend siempre crea el registro sin image_url. El campo es nullable en
  // el schema (PlantIdentification.image_url String?) — este modelo debe
  // reflejar eso, no asumir que siempre viene.
  final String? imageUrl;
  final String? identifiedSpeciesId;
  final double? confidenceScore;
  final DateTime createdAt;
  // El backend incluye la especie relacionada (include: { species: true })
  // tanto en GET /identifications como en el registro que crea
  // POST /identifications/fallback — nulo cuando no se pudo hacer match.
  final PlantSpecies? species;

  PlantIdentification({
    required this.id,
    required this.userId,
    this.imageUrl,
    this.identifiedSpeciesId,
    this.confidenceScore,
    required this.createdAt,
    this.species,
  });

  factory PlantIdentification.fromJson(Map<String, dynamic> json) {
    return PlantIdentification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageUrl: json['image_url'] as String?,
      identifiedSpeciesId: json['identified_species_id'] as String?,
      confidenceScore: json['confidence_score'] != null ? (json['confidence_score'] as num).toDouble() : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      species: json['species'] != null
          ? PlantSpecies.fromJson(json['species'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'identified_species_id': identifiedSpeciesId,
      'confidence_score': confidenceScore,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PlantIdentification copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? identifiedSpeciesId,
    double? confidenceScore,
    DateTime? createdAt,
  }) {
    return PlantIdentification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      identifiedSpeciesId: identifiedSpeciesId ?? this.identifiedSpeciesId,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
