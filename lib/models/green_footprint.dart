/// Aporte de CO₂ de una planta concreta del jardín.
class PlantCo2Contribution {
  final String userPlantId;
  final String name;
  final String species;

  /// Gramos al día. **Puede ser negativo**: hay especies que a luz de interior
  /// respiran más de lo que fijan (p. ej. la Sanseveria, medida en −0.15).
  final double gramsPerDay;

  /// Nivel de evidencia del valor: `medido`, `proxy_genero`, `cam_bajo_pcl`…
  /// De las 51 especies del catálogo solo 9 son mediciones publicadas, así que
  /// este dato acompaña siempre al número.
  final String evidenceLevel;

  final String? metabolism;
  final int daysInGarden;

  const PlantCo2Contribution({
    required this.userPlantId,
    required this.name,
    required this.species,
    required this.gramsPerDay,
    required this.evidenceLevel,
    required this.daysInGarden,
    this.metabolism,
  });

  factory PlantCo2Contribution.fromJson(Map<String, dynamic> json) {
    return PlantCo2Contribution(
      userPlantId: json['user_plant_id'] as String,
      name: (json['nickname'] as String?)?.isNotEmpty == true
          ? json['nickname'] as String
          : (json['species'] as String? ?? 'Planta'),
      species: json['species'] as String? ?? '',
      gramsPerDay: (json['grams_per_day'] as num?)?.toDouble() ?? 0,
      evidenceLevel: json['evidence_level'] as String? ?? 'sin_nivel',
      metabolism: json['metabolism'] as String?,
      daysInGarden: (json['days_in_garden'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Un día de la serie de los últimos 7.
class Co2Day {
  final String date;
  final double gramsPerDay;

  const Co2Day({required this.date, required this.gramsPerDay});

  factory Co2Day.fromJson(Map<String, dynamic> json) => Co2Day(
        date: json['date'] as String? ?? '',
        gramsPerDay: (json['grams_per_day'] as num?)?.toDouble() ?? 0,
      );
}

/// Huella verde del usuario, calculada por el backend a partir de sus plantas
/// reales y de los valores de CO₂ del catálogo.
class GreenFootprint {
  final double gramsPerDay;
  final double totalKg;
  final int plantCount;

  /// Cuántas plantas se apoyan en una medición publicada, cuántas en una
  /// derivación y cuántas en el respaldo por score.
  final int measured;
  final int derived;
  final int fallback;

  final String referenceConditions;
  final List<Co2Day> last7Days;
  final List<PlantCo2Contribution> breakdown;

  const GreenFootprint({
    required this.gramsPerDay,
    required this.totalKg,
    required this.plantCount,
    required this.measured,
    required this.derived,
    required this.fallback,
    required this.referenceConditions,
    required this.last7Days,
    required this.breakdown,
  });

  /// True si algún valor del total no procede de una medición directa.
  bool get hasDerivedValues => derived > 0 || fallback > 0;

  factory GreenFootprint.fromJson(Map<String, dynamic> json) {
    final evidence = json['evidence'] as Map<String, dynamic>? ?? const {};
    return GreenFootprint(
      gramsPerDay: (json['grams_per_day'] as num?)?.toDouble() ?? 0,
      totalKg: (json['total_kg'] as num?)?.toDouble() ?? 0,
      plantCount: (json['plant_count'] as num?)?.toInt() ?? 0,
      measured: (evidence['measured'] as num?)?.toInt() ?? 0,
      derived: (evidence['derived'] as num?)?.toInt() ?? 0,
      fallback: (evidence['fallback'] as num?)?.toInt() ?? 0,
      referenceConditions: json['reference_conditions'] as String? ?? '',
      last7Days: (json['last_7_days'] as List<dynamic>? ?? [])
          .map((e) => Co2Day.fromJson(e as Map<String, dynamic>))
          .toList(),
      breakdown: (json['breakdown'] as List<dynamic>? ?? [])
          .map((e) => PlantCo2Contribution.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
