import 'package:flutter/widgets.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

/// Una pregunta del centro de ayuda con su respuesta.
class HelpTopic {
  final String id;
  final String question;
  final String answer;

  /// Preguntas que suelen venir después de esta. El seguimiento natural
  /// importa: quien pregunta por el tope de macetas casi siempre pregunta
  /// después qué pasa al caducar O₂₊.
  final List<String> related;

  const HelpTopic({
    required this.id,
    required this.question,
    required this.answer,
    this.related = const [],
  });
}

/// Categorías en las que se agrupan las preguntas de la portada.
class HelpCategory {
  final String id;
  final String title;
  final List<String> topicIds;

  const HelpCategory({
    required this.id,
    required this.title,
    required this.topicIds,
  });
}

/// Contenido de la ayuda, traducido.
///
/// Vive aparte de la pantalla para que añadir una pregunta sea editar una
/// lista y no tocar la interfaz, y para que las traducciones salgan del mismo
/// sitio que el resto de la app.
List<HelpTopic> helpTopics(BuildContext context) {
  final l = AppLocalizations.of(context)!;
  return [
    HelpTopic(
      id: 'add_plant',
      question: l.helpQAddPlant,
      answer: l.helpAAddPlant,
      related: ['last_watered', 'scan_limit'],
    ),
    HelpTopic(
      id: 'last_watered',
      question: l.helpQLastWatered,
      answer: l.helpALastWatered,
      related: ['water_reminder'],
    ),
    HelpTopic(
      id: 'scan_limit',
      question: l.helpQScanLimit,
      answer: l.helpAScanLimit,
      related: ['o2plus', 'scan_fails'],
    ),
    HelpTopic(
      id: 'scan_fails',
      question: l.helpQScanFails,
      answer: l.helpAScanFails,
      related: ['scan_limit'],
    ),
    HelpTopic(
      id: 'water_reminder',
      question: l.helpQWaterReminder,
      answer: l.helpAWaterReminder,
      related: ['no_notifications', 'mute_plant'],
    ),
    HelpTopic(
      id: 'no_notifications',
      question: l.helpQNoNotifications,
      answer: l.helpANoNotifications,
      related: ['mute_plant'],
    ),
    HelpTopic(
      id: 'mute_plant',
      question: l.helpQMutePlant,
      answer: l.helpAMutePlant,
      related: ['water_reminder'],
    ),
    HelpTopic(
      id: 'pot_limit',
      question: l.helpQPotLimit,
      answer: l.helpAPotLimit,
      related: ['o2plus_ends', 'rental'],
    ),
    HelpTopic(
      id: 'o2plus',
      question: l.helpQO2Plus,
      answer: l.helpAO2Plus,
      related: ['o2plus_ends', 'payment'],
    ),
    HelpTopic(
      id: 'o2plus_ends',
      question: l.helpQO2PlusEnds,
      answer: l.helpAO2PlusEnds,
      related: ['pot_limit'],
    ),
    HelpTopic(
      id: 'rental',
      question: l.helpQRental,
      answer: l.helpARental,
      related: ['pot_limit', 'o2plus_ends'],
    ),
    HelpTopic(
      id: 'seeds',
      question: l.helpQSeeds,
      answer: l.helpASeeds,
      related: ['avatars', 'o2plus'],
    ),
    HelpTopic(
      id: 'avatars',
      question: l.helpQAvatars,
      answer: l.helpAAvatars,
      related: ['seeds'],
    ),
    HelpTopic(
      id: 'payment',
      question: l.helpQPayment,
      answer: l.helpAPayment,
      related: ['seeds'],
    ),
    HelpTopic(
      id: 'co2',
      question: l.helpQCo2,
      answer: l.helpACo2,
      related: ['add_plant'],
    ),
    HelpTopic(
      id: 'password',
      question: l.helpQPassword,
      answer: l.helpAPassword,
      related: ['biometric', 'google'],
    ),
    HelpTopic(
      id: 'google',
      question: l.helpQGoogle,
      answer: l.helpAGoogle,
      related: ['password'],
    ),
    HelpTopic(
      id: 'biometric',
      question: l.helpQBiometric,
      answer: l.helpABiometric,
      related: ['password'],
    ),
    HelpTopic(
      id: 'offline',
      question: l.helpQOffline,
      answer: l.helpAOffline,
      related: [],
    ),
    HelpTopic(
      id: 'language',
      question: l.helpQLanguage,
      answer: l.helpALanguage,
      related: [],
    ),
  ];
}

List<HelpCategory> helpCategories(BuildContext context) {
  final l = AppLocalizations.of(context)!;
  return [
    HelpCategory(
      id: 'plants',
      title: l.helpCatPlants,
      topicIds: ['add_plant', 'last_watered', 'scan_limit', 'scan_fails', 'co2'],
    ),
    HelpCategory(
      id: 'reminders',
      title: l.helpCatReminders,
      topicIds: ['water_reminder', 'no_notifications', 'mute_plant'],
    ),
    HelpCategory(
      id: 'plan',
      title: l.helpCatPlan,
      topicIds: ['pot_limit', 'o2plus', 'o2plus_ends', 'rental', 'payment'],
    ),
    HelpCategory(
      id: 'account',
      title: l.helpCatAccount,
      topicIds: ['seeds', 'avatars', 'password', 'google', 'biometric', 'language', 'offline'],
    ),
  ];
}
