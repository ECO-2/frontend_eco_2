import 'package:flutter/widgets.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/models/achievement.dart';

/// Nombre y descripción traducidos de un logro.
///
/// El backend guarda ambos en español dentro de la tabla `Achievement`, así que
/// con la app en inglés se seguían viendo "Guardián Verde" y "Realiza 30
/// cuidados". Traducirlos en la base exigiría columnas por idioma; en su lugar
/// se identifican por `condition_type` + `condition_value`, que son datos
/// estables y no texto, y la traducción se resuelve aquí.
///
/// Si aparece un logro nuevo que todavía no está mapeado, se muestra tal cual
/// llega del servidor: se ve en español, pero nunca vacío ni con la clave.

/// Clave estable de un logro. Devuelve null si no está mapeado.
String? achievementKey(String conditionType, int conditionValue) {
  switch (conditionType) {
    case 'onboarding_completed':
      return 'first_steps';
    case 'plant_scans':
      return 'botanical_eye';
    case 'rooms_created':
      return 'first_room';
    case 'care_logs':
      switch (conditionValue) {
        case 1:
          return 'hands_on';
        case 10:
          return 'steady_carer';
        case 30:
          return 'green_guardian';
        case 50:
          return 'care_master';
        case 100:
          return 'botanical_legend';
      }
      return null;
    case 'user_plants':
      switch (conditionValue) {
        case 3:
          return 'my_little_garden';
        case 5:
          return 'collector';
      }
      return null;
  }
  return null;
}

String achievementName(BuildContext context, Achievement a) {
  final l = AppLocalizations.of(context)!;
  switch (achievementKey(a.conditionType, a.conditionValue)) {
    case 'first_steps':
      return l.achFirstSteps;
    case 'botanical_eye':
      return l.achBotanicalEye;
    case 'first_room':
      return l.achFirstRoom;
    case 'hands_on':
      return l.achHandsOn;
    case 'steady_carer':
      return l.achSteadyCarer;
    case 'green_guardian':
      return l.achGreenGuardian;
    case 'care_master':
      return l.achCareMaster;
    case 'botanical_legend':
      return l.achBotanicalLegend;
    case 'my_little_garden':
      return l.achMyLittleGarden;
    case 'collector':
      return l.achCollector;
    default:
      return a.name;
  }
}

/// Descripción del logro. Las de contar (cuidados, plantas) se arman con el
/// propio `condition_value`, así que un logro nuevo de 200 cuidados también
/// saldría traducido sin tocar nada.
String? achievementDescription(BuildContext context, Achievement a) {
  final l = AppLocalizations.of(context)!;
  switch (a.conditionType) {
    case 'onboarding_completed':
      return l.achDescOnboarding;
    case 'plant_scans':
      return l.achDescFirstScan;
    case 'rooms_created':
      return l.achDescFirstRoom;
    case 'care_logs':
      return a.conditionValue == 1
          ? l.achDescFirstCare
          : l.achDescNCares(a.conditionValue);
    case 'user_plants':
      return l.achDescNPlants(a.conditionValue);
    default:
      return a.description;
  }
}
