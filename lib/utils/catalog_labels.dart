import 'package:flutter/widgets.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';

/// Etiquetas traducibles del catálogo (categoría, luz, dificultad, humedad).
///
/// Los valores que llegan del backend son claves estables en inglés
/// (`tropical`, `indirect`, `low`...), pero la app los mostraba con literales
/// en español escritos en `plant_visuals.dart` y en el modelo `PlantSpecies`,
/// que son código sin acceso a `BuildContext`. Por eso al cambiar la app a
/// inglés seguían apareciendo "Tropical", "Luz Baja" o "Muy fácil".
///
/// Aquí la traducción se resuelve en la capa de UI, donde sí hay contexto,
/// dejando el dato crudo intacto en el modelo.

String categoryLabel(BuildContext context, String? category) {
  final l = AppLocalizations.of(context)!;
  switch (category) {
    case 'tropical': return l.catTropical;
    case 'succulent': return l.catSucculent;
    case 'cactus': return l.catCactus;
    case 'fern': return l.catFern;
    case 'flowering': return l.catFlowering;
    case 'herb': return l.catHerb;
    case 'tree': return l.catTree;
    default: return l.catOther;
  }
}

String lightLabel(BuildContext context, String? light) {
  final l = AppLocalizations.of(context)!;
  switch (light) {
    case 'low': return l.lightLow;
    case 'medium': return l.lightMedium;
    case 'high': return l.lightHigh;
    case 'indirect': return l.lightIndirect;
    default: return l.lightIndirect;
  }
}

/// "Luz Baja" en español, "Low light" en inglés — el orden de las palabras
/// cambia entre idiomas, así que se resuelve con un placeholder y no
/// concatenando cadenas.
String lightWithPrefix(BuildContext context, String? light) =>
    AppLocalizations.of(context)!.lightPrefix(lightLabel(context, light));

/// Dificultad derivada de la frecuencia de riego: cuanto menos exige, más
/// fácil de mantener.
String difficultyLabel(BuildContext context, int waterFrequencyDays) {
  final l = AppLocalizations.of(context)!;
  if (waterFrequencyDays >= 20) return l.difficultyVeryEasy;
  if (waterFrequencyDays >= 10) return l.difficultyEasy;
  return l.difficultyMedium;
}

String humidityLabel(BuildContext context, String? humidity) {
  final l = AppLocalizations.of(context)!;
  switch (humidity) {
    case 'low': return l.humidityLow;
    case 'high': return l.humidityHigh;
    default: return l.humidityMedium;
  }
}

String wateringFrequencyLabel(BuildContext context, int days) =>
    AppLocalizations.of(context)!.wateringEveryDays(days);

/// Chip de especie: el texto visible junto al tipo que le da color e ícono.
///
/// El tipo viaja con el chip porque antes se deducía leyendo el propio texto
/// ("riego", "luz", "humedad"...). Con la app en inglés ninguna de esas
/// palabras aparecía y todos los chips caían al estilo genérico.
class SpeciesTag {
  final String text;
  final TagKind kind;

  const SpeciesTag(this.text, this.kind);
}

/// Chips de una especie, ya traducidos. Reemplaza a `PlantSpecies.tags`, que
/// devolvía las etiquetas en español desde el modelo.
List<SpeciesTag> speciesTags(
  BuildContext context, {
  required String? category,
  required String? lightRequirement,
  required int waterFrequencyDays,
}) =>
    [
      SpeciesTag(categoryLabel(context, category), TagKind.category),
      SpeciesTag(lightWithPrefix(context, lightRequirement), TagKind.light),
      SpeciesTag(
          wateringFrequencyLabel(context, waterFrequencyDays), TagKind.water),
    ];

/// Clave estable de dificultad a partir de la frecuencia de riego.
/// Se usa para filtrar: comparar contra la etiqueta visible rompería el
/// filtro en cuanto la app cambia de idioma.
String difficultyKey(int waterFrequencyDays) {
  if (waterFrequencyDays >= 20) return 'very_easy';
  if (waterFrequencyDays >= 10) return 'easy';
  return 'medium';
}

/// Etiqueta visible de una opción del filtro de dificultad.
String difficultyOptionLabel(BuildContext context, String key) {
  final l = AppLocalizations.of(context)!;
  switch (key) {
    case 'very_easy': return l.difficultyVeryEasy;
    case 'easy': return l.difficultyEasy;
    case 'medium': return l.difficultyMedium;
    default: return l.difficultyAll;
  }
}

/// Rango numérico de humedad. Los números no se traducen, pero la clave se
/// resuelve aquí para que el modelo no tenga que cargar con texto.
String humidityRange(BuildContext context, String? humidity) {
  final l = AppLocalizations.of(context)!;
  switch (humidity) {
    case 'low': return l.humidityRangeLow;
    case 'high': return l.humidityRangeHigh;
    default: return l.humidityRangeMedium;
  }
}

/// Descripción de la especie construida con sus datos reales del catálogo.
///
/// Vivía en `PlantSpecies.description`, que es un modelo sin `BuildContext`:
/// devolvía la frase en español montada a mano y se mostraba igual con la app
/// en inglés.
String speciesDescription(
  BuildContext context, {
  required String? category,
  required String? lightRequirement,
  required String? humidityPreference,
  required int waterFrequencyDays,
  int? minTemperature,
  int? maxTemperature,
  int? airPurificationScore,
}) {
  final l = AppLocalizations.of(context)!;
  final base = l.speciesDescription(
    categoryLabel(context, category).toLowerCase(),
    lightLabel(context, lightRequirement).toLowerCase(),
    humidityLabel(context, humidityPreference).toLowerCase(),
    waterFrequencyDays,
    minTemperature ?? 15,
    maxTemperature ?? 30,
  );

  final score = airPurificationScore ?? 0;
  if (score >= 7) return '$base ${l.purifierExcellent}';
  if (score >= 4) return '$base ${l.purifierGood}';
  return base;
}

/// Pista de ubicación según la luz que necesita la especie.
String lightHint(BuildContext context, String? light) {
  final l = AppLocalizations.of(context)!;
  switch (light?.toLowerCase()) {
    case 'low': return l.lightHintLow;
    case 'high': return l.lightHintHigh;
    case 'indirect': return l.lightHintIndirect;
    default: return l.lightHintDefault;
  }
}

/// Chips de la ficha de especie (categoría, luz, humedad y, si aplica, aire).
/// Sustituye a `PlantSpecies.detailTags`, que los devolvía en español.
List<SpeciesTag> speciesDetailTags(
  BuildContext context, {
  required String? category,
  required String? lightRequirement,
  required String? humidityPreference,
  int? airPurificationScore,
}) {
  final l = AppLocalizations.of(context)!;
  return [
    SpeciesTag(categoryLabel(context, category), TagKind.category),
    SpeciesTag(lightWithPrefix(context, lightRequirement), TagKind.light),
    SpeciesTag(l.humidityWithPrefix(humidityLabel(context, humidityPreference)),
        TagKind.humidity),
    if ((airPurificationScore ?? 0) >= 7)
      SpeciesTag(l.airPurifierTag, TagKind.generic),
  ];
}
