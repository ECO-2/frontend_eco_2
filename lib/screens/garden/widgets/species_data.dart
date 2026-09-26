import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';
import 'package:frontend_eco_2/utils/catalog_labels.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

class SpeciesData {
  final String scientific;
  final Color bg;
  final List<SpeciesTag> tags;
  final String? assetImage;
  final String? imageUrl;
  final String waterFreq;
  final int waterFreqDays;
  final String light;
  final String temp;
  final String co2;
  final String humidity;
  final String personalNote;
  final IconData placeholderIcon;
  final Color placeholderIconColor;
  // Guía de cuidado en lenguaje llano: dónde ubicarla y cómo regarla,
  // pensada para orientar a alguien que recién la agrega a su jardín.
  final String placementHint;
  final String careGuide;

  const SpeciesData({
    required this.scientific,
    required this.bg,
    required this.tags,
    this.assetImage,
    this.imageUrl,
    required this.waterFreq,
    required this.waterFreqDays,
    required this.light,
    required this.temp,
    required this.co2,
    required this.humidity,
    required this.personalNote,
    this.placeholderIcon = Icons.local_florist_rounded,
    this.placeholderIconColor = const Color(0xFFB0B0B0),
    required this.placementHint,
    required this.careGuide,
  });

  // Real catalog species (real UUID from the backend) don't have a legacy
  // illustration or a curated care write-up, so this builds a care summary
  // from the real fields the API does return (category, light, water
  // frequency, humidity, air_purification_score) instead of showing the
  // same generic placeholder text for all 50+ species.
  /// Recibe el contexto porque las etiquetas (luz, humedad, guía de cuidado)
  /// son texto visible: antes se armaban en español dentro del modelo, que no
  /// tiene forma de saber en qué idioma está la app.
  factory SpeciesData.fromReal(BuildContext context, PlantSpecies species) {
    final l = AppLocalizations.of(context)!;
    final visual = visualForCategory(species.category);
    final score = species.airPurificationScore ?? 0;
    final co2Grams = 1.0 + score * 0.4;
    return SpeciesData(
      scientific: species.scientificName,
      bg: visual.background,
      tags: speciesTags(
        context,
        category: species.category,
        lightRequirement: species.lightRequirement,
        waterFrequencyDays: species.waterFrequencyDays,
      ),
      imageUrl: species.imageUrl,
      waterFreq: l.everyNDaysShort(species.waterFrequencyDays),
      waterFreqDays: species.waterFrequencyDays,
      light: lightLabel(context, species.lightRequirement),
      temp: '${species.minTemperature ?? 15}-${species.maxTemperature ?? 30}°C',
      co2: l.gramsPerDayValue(co2Grams.toStringAsFixed(1)),
      humidity: humidityRange(context, species.humidityPreference),
      personalNote: l.noNotesYet,
      placeholderIcon: visual.icon,
      placeholderIconColor: visual.color,
      placementHint: lightHint(context, species.lightRequirement),
      careGuide: speciesDescription(
        context,
        category: species.category,
        lightRequirement: species.lightRequirement,
        humidityPreference: species.humidityPreference,
        waterFrequencyDays: species.waterFrequencyDays,
        minTemperature: species.minTemperature,
        maxTemperature: species.maxTemperature,
        airPurificationScore: species.airPurificationScore,
      ),
    );
  }
}

// Las especies mock s1-s3 se eliminaron: sus IDs no existen en el
// catálogo real (que usa UUID), así que nunca se resolvían. Además
// llevaban valores de CO2 fijos que contradecían los del backend.

