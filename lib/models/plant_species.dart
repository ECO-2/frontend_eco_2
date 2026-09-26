
class PlantSpecies {
  final String id;
  final String scientificName;
  final String commonName;
  final String? category;
  final String? lightRequirement;
  final int waterFrequencyDays;
  final String? humidityPreference;
  final int? airPurificationScore;
  final int? minTemperature;
  final int? maxTemperature;
  final String? imageUrl;
  final DateTime createdAt;

  PlantSpecies({
    required this.id,
    required this.scientificName,
    required this.commonName,
    this.category,
    this.lightRequirement,
    required this.waterFrequencyDays,
    this.humidityPreference,
    this.airPurificationScore,
    this.minTemperature,
    this.maxTemperature,
    this.imageUrl,
    required this.createdAt,
  });

  factory PlantSpecies.fromJson(Map<String, dynamic> json) {
    return PlantSpecies(
      id: json['id'] as String,
      scientificName: json['scientific_name'] as String,
      commonName: json['common_name'] as String,
      category: json['category'] as String?,
      lightRequirement: json['light_requirement'] as String?,
      waterFrequencyDays: json['water_frequency_days'] as int,
      humidityPreference: json['humidity_preference'] as String?,
      airPurificationScore: json['air_purification_score'] as int?,
      minTemperature: json['min_temperature'] as int?,
      maxTemperature: json['max_temperature'] as int?,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scientific_name': scientificName,
      'common_name': commonName,
      'category': category,
      'light_requirement': lightRequirement,
      'water_frequency_days': waterFrequencyDays,
      'humidity_preference': humidityPreference,
      'air_purification_score': airPurificationScore,
      'min_temperature': minTemperature,
      'max_temperature': maxTemperature,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PlantSpecies copyWith({
    String? id,
    String? scientificName,
    String? commonName,
    String? category,
    String? lightRequirement,
    int? waterFrequencyDays,
    String? humidityPreference,
    int? airPurificationScore,
    int? minTemperature,
    int? maxTemperature,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return PlantSpecies(
      id: id ?? this.id,
      scientificName: scientificName ?? this.scientificName,
      commonName: commonName ?? this.commonName,
      category: category ?? this.category,
      lightRequirement: lightRequirement ?? this.lightRequirement,
      waterFrequencyDays: waterFrequencyDays ?? this.waterFrequencyDays,
      humidityPreference: humidityPreference ?? this.humidityPreference,
      airPurificationScore: airPurificationScore ?? this.airPurificationScore,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Los getters de texto (difficulty, tags, description, humidityRange,
  // humidityLevel, detailTags) se retiraron: montaban frases en español dentro
  // del modelo, que no tiene BuildContext y por tanto no puede saber en qué
  // idioma está la app. Ahora viven en utils/catalog_labels.dart, que sí lo
  // tiene. Los datos crudos siguen intactos aquí.

  int get difficultySegments {
    if (waterFrequencyDays >= 20) return 1; // Muy fácil
    if (waterFrequencyDays >= 10) return 2; // Fácil
    return 3; // Media
  }
}
