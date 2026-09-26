import 'plant_identification.dart';
import 'plant_species.dart';

/// Una alternativa real devuelta por la API de identificación (Plant.id),
/// solo incluida cuando esa especie sí está en nuestro catálogo — si no,
/// no habría nada que el usuario pudiera "Ver ficha" o "Añadir".
class IdentificationAlternate {
  final PlantSpecies species;
  final double confidenceScore;

  IdentificationAlternate({
    required this.species,
    required this.confidenceScore,
  });

  factory IdentificationAlternate.fromJson(Map<String, dynamic> json) {
    return IdentificationAlternate(
      species: PlantSpecies.fromJson(json['species'] as Map<String, dynamic>),
      confidenceScore: (json['confidence_score'] as num).toDouble(),
    );
  }
}

/// Respuesta real de POST /identifications/fallback.
class IdentificationResult {
  /// false si el backend todavía no tiene PLANT_ID_API_KEY configurada —
  /// en ese caso no se llamó a ninguna IA ni se creó ningún registro.
  final bool configured;
  final PlantIdentification? identification;
  final PlantSpecies? species;
  final bool lowConfidence;
  final List<IdentificationAlternate> alternates;
  // Cuando Plant.id identificó algo con confianza aceptable pero esa
  // especie no está en nuestro catálogo — nombre real devuelto por la API,
  // no inventado, para poder decirle al usuario qué fue lo que reconoció.
  final String? unmatchedScientificName;
  final String? unmatchedCommonName;

  IdentificationResult({
    required this.configured,
    this.identification,
    this.species,
    required this.lowConfidence,
    required this.alternates,
    this.unmatchedScientificName,
    this.unmatchedCommonName,
  });

  double? get confidenceScore => identification?.confidenceScore;

  factory IdentificationResult.fromJson(Map<String, dynamic> json) {
    final suggestion = json['plant_id_suggestion'] as Map<String, dynamic>?;
    return IdentificationResult(
      configured: json['configured'] as bool? ?? true,
      identification: json['identification'] != null
          ? PlantIdentification.fromJson(json['identification'] as Map<String, dynamic>)
          : null,
      species: json['species'] != null
          ? PlantSpecies.fromJson(json['species'] as Map<String, dynamic>)
          : null,
      lowConfidence: json['low_confidence'] as bool? ?? false,
      alternates: (json['alternates'] as List<dynamic>? ?? [])
          .map((e) => IdentificationAlternate.fromJson(e as Map<String, dynamic>))
          .toList(),
      unmatchedScientificName: suggestion?['scientific_name'] as String?,
      unmatchedCommonName: suggestion?['common_name'] as String?,
    );
  }
}
