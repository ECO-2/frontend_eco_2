import 'package:frontend_eco_2/models/plant_species.dart';
import 'package:frontend_eco_2/models/user_plant.dart';

/// Estimación de CO₂ absorbido por el jardín del usuario.
///
/// No existe medición real: el backend no expone ningún endpoint de CO₂ y en
/// la app los valores estaban escritos a mano ("12.4 g/día", "36.5 kg"), de
/// modo que todos los usuarios veían exactamente el mismo número sin importar
/// cuántas plantas tuvieran.
///
/// Aquí se calcula a partir del único dato real disponible, el
/// `air_purification_score` de cada especie (0–10 en el catálogo), con la
/// misma fórmula que ya usaba la ficha de especie para su estimación diaria.
/// Es una ESTIMACIÓN, no una medición, y la UI debe presentarla como tal.
class Co2Estimate {
  /// Gramos de CO₂ al día que absorbe el jardín completo.
  final double gramsPerDay;

  /// Kilos acumulados desde que cada planta entró a la colección.
  final double totalKg;

  /// Número de plantas que entraron en el cálculo.
  final int plantCount;

  const Co2Estimate({
    required this.gramsPerDay,
    required this.totalKg,
    required this.plantCount,
  });

  static const Co2Estimate empty =
      Co2Estimate(gramsPerDay: 0, totalKg: 0, plantCount: 0);

  /// Gramos diarios de una especie. Una especie sin puntuación aporta el
  /// mínimo (1 g/día) en vez de cero: cualquier planta fija algo de CO₂.
  static double dailyGramsFor(PlantSpecies? species) {
    final score = species?.airPurificationScore ?? 0;
    return 1.0 + score * 0.4;
  }

  /// Calcula la estimación para la colección del usuario.
  ///
  /// [speciesById] permite resolver la especie cuando la planta no la trae
  /// embebida; si no se encuentra por ninguna vía, se usa el mínimo.
  factory Co2Estimate.forPlants(
    List<UserPlant> plants, {
    Map<String, PlantSpecies> speciesById = const {},
    DateTime? now,
  }) {
    if (plants.isEmpty) return empty;

    final current = now ?? DateTime.now();
    double gramsPerDay = 0;
    double totalGrams = 0;

    for (final plant in plants) {
      final species = plant.species ?? speciesById[plant.speciesId];
      final daily = dailyGramsFor(species);
      gramsPerDay += daily;

      // Acumulado desde que la planta está en el jardín.
      final since = plant.acquiredAt ?? plant.createdAt;
      final days = current.difference(since).inDays;
      totalGrams += daily * (days < 0 ? 0 : days);
    }

    return Co2Estimate(
      gramsPerDay: gramsPerDay,
      totalKg: totalGrams / 1000,
      plantCount: plants.length,
    );
  }
}
