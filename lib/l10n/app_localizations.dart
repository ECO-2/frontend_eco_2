import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTagline.
  ///
  /// In es, this message translates to:
  /// **'Cuidado de plantas con IA'**
  String get appTagline;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear Cuenta'**
  String get createAccount;

  /// No description provided for @signIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get signIn;

  /// No description provided for @signInAction.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get signInAction;

  /// No description provided for @welcomeBack.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido de vuelta'**
  String get welcomeBack;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In es, this message translates to:
  /// **'correo@ejemplo.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @passwordMinChars.
  ///
  /// In es, this message translates to:
  /// **'min. 8 caracteres'**
  String get passwordMinChars;

  /// No description provided for @passwordTooShort.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres'**
  String get passwordTooShort;

  /// No description provided for @confirmPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirma contraseña'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPassword;

  /// No description provided for @username.
  ///
  /// In es, this message translates to:
  /// **'Nombre de usuario'**
  String get username;

  /// No description provided for @register.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get register;

  /// No description provided for @noAccountYet.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? '**
  String get noAccountYet;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? '**
  String get alreadyHaveAccount;

  /// No description provided for @enterYourEmail.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa tu correo'**
  String get enterYourEmail;

  /// No description provided for @enterYourPassword.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa tu contraseña'**
  String get enterYourPassword;

  /// No description provided for @termsNotice.
  ///
  /// In es, this message translates to:
  /// **'Al registrarte aceptas los Términos de Uso y la Política de Privacidad de ECO2.'**
  String get termsNotice;

  /// No description provided for @navStore.
  ///
  /// In es, this message translates to:
  /// **'Tienda'**
  String get navStore;

  /// No description provided for @navGarden.
  ///
  /// In es, this message translates to:
  /// **'Jardín'**
  String get navGarden;

  /// No description provided for @navDashboard.
  ///
  /// In es, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navScanner.
  ///
  /// In es, this message translates to:
  /// **'Escáner'**
  String get navScanner;

  /// No description provided for @navProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @myGarden.
  ///
  /// In es, this message translates to:
  /// **'Mi Jardín'**
  String get myGarden;

  /// No description provided for @viewAll.
  ///
  /// In es, this message translates to:
  /// **'ver todas'**
  String get viewAll;

  /// No description provided for @addPlant.
  ///
  /// In es, this message translates to:
  /// **'Añadir Planta'**
  String get addPlant;

  /// No description provided for @gardenEmpty.
  ///
  /// In es, this message translates to:
  /// **'Tu jardín está vacío'**
  String get gardenEmpty;

  /// No description provided for @needsWater.
  ///
  /// In es, this message translates to:
  /// **'Riego'**
  String get needsWater;

  /// No description provided for @upToDate.
  ///
  /// In es, this message translates to:
  /// **'Al día'**
  String get upToDate;

  /// No description provided for @noWateringYet.
  ///
  /// In es, this message translates to:
  /// **'Sin riego aún'**
  String get noWateringYet;

  /// No description provided for @wateringToday.
  ///
  /// In es, this message translates to:
  /// **'Riego hoy'**
  String get wateringToday;

  /// No description provided for @wateringOverdue.
  ///
  /// In es, this message translates to:
  /// **'Riego vencido'**
  String get wateringOverdue;

  /// No description provided for @daysWithoutWater.
  ///
  /// In es, this message translates to:
  /// **'días sin riego'**
  String get daysWithoutWater;

  /// No description provided for @daysInYourGarden.
  ///
  /// In es, this message translates to:
  /// **'días en tu jardín'**
  String get daysInYourGarden;

  /// No description provided for @frequency.
  ///
  /// In es, this message translates to:
  /// **'frecuencia'**
  String get frequency;

  /// No description provided for @remaining.
  ///
  /// In es, this message translates to:
  /// **'restantes'**
  String get remaining;

  /// No description provided for @overdue.
  ///
  /// In es, this message translates to:
  /// **'vencido'**
  String get overdue;

  /// No description provided for @careStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado de cuidado'**
  String get careStatus;

  /// No description provided for @urgentWatering.
  ///
  /// In es, this message translates to:
  /// **'Riego Urgente'**
  String get urgentWatering;

  /// No description provided for @deletePlantTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar planta?'**
  String get deletePlantTitle;

  /// No description provided for @deletePlantBody.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará \"{plantName}\" de tu jardín. Esta acción no se puede deshacer.'**
  String deletePlantBody(String plantName);

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @lastWateredQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo regaste {plantName} por última vez?'**
  String lastWateredQuestion(String plantName);

  /// No description provided for @lastWateredHelp.
  ///
  /// In es, this message translates to:
  /// **'Así calculamos cuándo toca el próximo riego. Si no lo sabes, empezamos a contar desde hoy.'**
  String get lastWateredHelp;

  /// No description provided for @today.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In es, this message translates to:
  /// **'Ayer'**
  String get yesterday;

  /// No description provided for @someDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'Hace unos días…'**
  String get someDaysAgo;

  /// No description provided for @neverOrDontRemember.
  ///
  /// In es, this message translates to:
  /// **'Nunca / no lo recuerdo'**
  String get neverOrDontRemember;

  /// No description provided for @lastWatering.
  ///
  /// In es, this message translates to:
  /// **'Último riego'**
  String get lastWatering;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In es, this message translates to:
  /// **'CUENTA'**
  String get account;

  /// No description provided for @editProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get editProfile;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Nombre de usuario'**
  String get editProfileSubtitle;

  /// No description provided for @changePassword.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get changePassword;

  /// No description provided for @biometricAuth.
  ///
  /// In es, this message translates to:
  /// **'Autenticación biométrica'**
  String get biometricAuth;

  /// No description provided for @notifications.
  ///
  /// In es, this message translates to:
  /// **'NOTIFICACIONES'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones push'**
  String get pushNotifications;

  /// No description provided for @wateringReminders.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios de riego'**
  String get wateringReminders;

  /// No description provided for @achievementsAndMissions.
  ///
  /// In es, this message translates to:
  /// **'Logros y misiones'**
  String get achievementsAndMissions;

  /// No description provided for @preferences.
  ///
  /// In es, this message translates to:
  /// **'PREFERENCIAS'**
  String get preferences;

  /// No description provided for @systemLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma del sistema'**
  String get systemLanguage;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @themeAndColors.
  ///
  /// In es, this message translates to:
  /// **'Tema y colores'**
  String get themeAndColors;

  /// No description provided for @privacyAndData.
  ///
  /// In es, this message translates to:
  /// **'PRIVACIDAD Y DATOS'**
  String get privacyAndData;

  /// No description provided for @privacy.
  ///
  /// In es, this message translates to:
  /// **'Privacidad'**
  String get privacy;

  /// No description provided for @privacySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Qué datos guarda ECO2'**
  String get privacySubtitle;

  /// No description provided for @exportMyData.
  ///
  /// In es, this message translates to:
  /// **'Exportar mis datos'**
  String get exportMyData;

  /// No description provided for @application.
  ///
  /// In es, this message translates to:
  /// **'APLICACIÓN'**
  String get application;

  /// No description provided for @helpAndSupport.
  ///
  /// In es, this message translates to:
  /// **'Ayuda y soporte'**
  String get helpAndSupport;

  /// No description provided for @aboutEco2.
  ///
  /// In es, this message translates to:
  /// **'Sobre ECO2'**
  String get aboutEco2;

  /// No description provided for @dangerZone.
  ///
  /// In es, this message translates to:
  /// **'ZONA DE RIESGO'**
  String get dangerZone;

  /// No description provided for @signOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cuenta'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Esta acción es permanente'**
  String get deleteAccountSubtitle;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @plants.
  ///
  /// In es, this message translates to:
  /// **'Plantas'**
  String get plants;

  /// No description provided for @seeds.
  ///
  /// In es, this message translates to:
  /// **'Semillas'**
  String get seeds;

  /// No description provided for @co2Total.
  ///
  /// In es, this message translates to:
  /// **'CO₂ total'**
  String get co2Total;

  /// No description provided for @levelLabel.
  ///
  /// In es, this message translates to:
  /// **'Nivel {level}'**
  String levelLabel(int level);

  /// No description provided for @levelWithName.
  ///
  /// In es, this message translates to:
  /// **'Nivel {level} · {name}'**
  String levelWithName(int level, String name);

  /// No description provided for @myTrophies.
  ///
  /// In es, this message translates to:
  /// **'Mis Trofeos'**
  String get myTrophies;

  /// No description provided for @trophies.
  ///
  /// In es, this message translates to:
  /// **'Trofeos'**
  String get trophies;

  /// No description provided for @missions.
  ///
  /// In es, this message translates to:
  /// **'Misiones'**
  String get missions;

  /// No description provided for @achievements.
  ///
  /// In es, this message translates to:
  /// **'Logros'**
  String get achievements;

  /// No description provided for @obtained.
  ///
  /// In es, this message translates to:
  /// **'Obtenidos'**
  String get obtained;

  /// No description provided for @available.
  ///
  /// In es, this message translates to:
  /// **'Disponibles'**
  String get available;

  /// No description provided for @completedPercent.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get completedPercent;

  /// No description provided for @streakDays.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 día seguido} other{{count} días seguidos}}'**
  String streakDays(int count);

  /// No description provided for @xpPoints.
  ///
  /// In es, this message translates to:
  /// **'{xp} XP'**
  String xpPoints(int xp);

  /// No description provided for @seedsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} semillas'**
  String seedsCount(int count);

  /// No description provided for @greenFootprint.
  ///
  /// In es, this message translates to:
  /// **'Mi Huella Verde'**
  String get greenFootprint;

  /// No description provided for @co2AbsorbedToday.
  ///
  /// In es, this message translates to:
  /// **'CO₂ absorbido hoy'**
  String get co2AbsorbedToday;

  /// No description provided for @gramsPerDay.
  ///
  /// In es, this message translates to:
  /// **'gramos / día'**
  String get gramsPerDay;

  /// No description provided for @contributionPerPlant.
  ///
  /// In es, this message translates to:
  /// **'Aporte por planta'**
  String get contributionPerPlant;

  /// No description provided for @weeklyEvolution.
  ///
  /// In es, this message translates to:
  /// **'Evolución semanal'**
  String get weeklyEvolution;

  /// No description provided for @weeklyEvolutionHelp.
  ///
  /// In es, this message translates to:
  /// **'Refleja cuándo entró cada planta a tu jardín.'**
  String get weeklyEvolutionHelp;

  /// No description provided for @copyMyFootprint.
  ///
  /// In es, this message translates to:
  /// **'Copiar mi huella verde'**
  String get copyMyFootprint;

  /// No description provided for @copiedToClipboard.
  ///
  /// In es, this message translates to:
  /// **'Copiado al portapapeles'**
  String get copiedToClipboard;

  /// No description provided for @accumulated.
  ///
  /// In es, this message translates to:
  /// **'Acumulado: {kg} kg'**
  String accumulated(String kg);

  /// No description provided for @noPlantsYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes plantas en tu jardín'**
  String get noPlantsYet;

  /// No description provided for @footprintError.
  ///
  /// In es, this message translates to:
  /// **'No pudimos calcular tu huella verde.'**
  String get footprintError;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @scannerPointAtPlant.
  ///
  /// In es, this message translates to:
  /// **'Apunta a una planta'**
  String get scannerPointAtPlant;

  /// No description provided for @scannerAnalyzing.
  ///
  /// In es, this message translates to:
  /// **'Analizando...'**
  String get scannerAnalyzing;

  /// No description provided for @scannerNotInCatalog.
  ///
  /// In es, this message translates to:
  /// **'La reconocimos, pero todavía no está en el catálogo de ECO2 — no podemos añadirla a tu jardín todavía.'**
  String get scannerNotInCatalog;

  /// No description provided for @scannerLowConfidence.
  ///
  /// In es, this message translates to:
  /// **'No pudimos reconocerla con suficiente confianza. Prueba con más luz o de más cerca.'**
  String get scannerLowConfidence;

  /// No description provided for @connectionError.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión. Verifica tu internet.'**
  String get connectionError;

  /// No description provided for @wrongCredentials.
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos.'**
  String get wrongCredentials;

  /// No description provided for @emailAlreadyUsed.
  ///
  /// In es, this message translates to:
  /// **'Este correo ya tiene una cuenta registrada.'**
  String get emailAlreadyUsed;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @greeting.
  ///
  /// In es, this message translates to:
  /// **'Namasté'**
  String get greeting;

  /// No description provided for @yourSeeds.
  ///
  /// In es, this message translates to:
  /// **'Tus semillas'**
  String get yourSeeds;

  /// No description provided for @activeMission.
  ///
  /// In es, this message translates to:
  /// **'Misión Activa'**
  String get activeMission;

  /// No description provided for @searchSpecies.
  ///
  /// In es, this message translates to:
  /// **'Buscar especie...'**
  String get searchSpecies;

  /// No description provided for @searchMyPlant.
  ///
  /// In es, this message translates to:
  /// **'Buscar mi planta...'**
  String get searchMyPlant;

  /// No description provided for @exploreSpecies.
  ///
  /// In es, this message translates to:
  /// **'Explorar especies'**
  String get exploreSpecies;

  /// No description provided for @trendingThisWeek.
  ///
  /// In es, this message translates to:
  /// **'Tendencias esta semana'**
  String get trendingThisWeek;

  /// No description provided for @allCategory.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get allCategory;

  /// No description provided for @plantsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} plantas'**
  String plantsCount(int count);

  /// No description provided for @needsAttentionToday.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 planta necesita atención hoy} other{{count} plantas necesitan atención hoy}}'**
  String needsAttentionToday(int count);

  /// No description provided for @view.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get view;

  /// No description provided for @add.
  ///
  /// In es, this message translates to:
  /// **'Añadir'**
  String get add;

  /// No description provided for @allUpToDate.
  ///
  /// In es, this message translates to:
  /// **'¡Todo al día!'**
  String get allUpToDate;

  /// No description provided for @wateringStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado de riego'**
  String get wateringStatus;

  /// No description provided for @logEveryCare.
  ///
  /// In es, this message translates to:
  /// **'Registra cada cuidado'**
  String get logEveryCare;

  /// No description provided for @viewHistory.
  ///
  /// In es, this message translates to:
  /// **'Ver historial'**
  String get viewHistory;

  /// No description provided for @latestCare.
  ///
  /// In es, this message translates to:
  /// **'Últimos cuidados'**
  String get latestCare;

  /// No description provided for @careType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de cuidado'**
  String get careType;

  /// No description provided for @suggestedNextWatering.
  ///
  /// In es, this message translates to:
  /// **'Próximo riego sugerido'**
  String get suggestedNextWatering;

  /// No description provided for @inMyCollectionSince.
  ///
  /// In es, this message translates to:
  /// **'En mi colección desde'**
  String get inMyCollectionSince;

  /// No description provided for @howToCareTitle.
  ///
  /// In es, this message translates to:
  /// **'Cómo cuidar tu planta'**
  String get howToCareTitle;

  /// No description provided for @everyNDays.
  ///
  /// In es, this message translates to:
  /// **'Cada {days} días'**
  String everyNDays(int days);

  /// No description provided for @daysAgo.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{hace 1 día} other{hace {count} días}}'**
  String daysAgo(int count);

  /// No description provided for @noCareLogged.
  ///
  /// In es, this message translates to:
  /// **'Aún no has registrado cuidados.'**
  String get noCareLogged;

  /// No description provided for @scannerHint.
  ///
  /// In es, this message translates to:
  /// **'Apunta a una planta'**
  String get scannerHint;

  /// No description provided for @analyzing.
  ///
  /// In es, this message translates to:
  /// **'Analizando...'**
  String get analyzing;

  /// No description provided for @notIdentified.
  ///
  /// In es, this message translates to:
  /// **'No identificada con certeza'**
  String get notIdentified;

  /// No description provided for @potsRemaining.
  ///
  /// In es, this message translates to:
  /// **'Macetas restantes: {count}'**
  String potsRemaining(int count);

  /// No description provided for @notificationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificationsTitle;

  /// No description provided for @markedAsRead.
  ///
  /// In es, this message translates to:
  /// **'Marcada como leída'**
  String get markedAsRead;

  /// No description provided for @markAllRead.
  ///
  /// In es, this message translates to:
  /// **'Marcar todas como leídas'**
  String get markAllRead;

  /// No description provided for @todayLabel.
  ///
  /// In es, this message translates to:
  /// **'HOY'**
  String get todayLabel;

  /// No description provided for @thatsAllForNow.
  ///
  /// In es, this message translates to:
  /// **'Eso es todo por ahora'**
  String get thatsAllForNow;

  /// No description provided for @noNotifications.
  ///
  /// In es, this message translates to:
  /// **'No tienes notificaciones'**
  String get noNotifications;

  /// No description provided for @wateringPending.
  ///
  /// In es, this message translates to:
  /// **'Riego pendiente'**
  String get wateringPending;

  /// No description provided for @achievementUnlocked.
  ///
  /// In es, this message translates to:
  /// **'¡Logro desbloqueado!: {title}'**
  String achievementUnlocked(String title);

  /// No description provided for @newPlantAdded.
  ///
  /// In es, this message translates to:
  /// **'Nueva planta agregada: Agregaste {name} a tu colección.'**
  String newPlantAdded(String name);

  /// No description provided for @seedbed.
  ///
  /// In es, this message translates to:
  /// **'Semillero'**
  String get seedbed;

  /// No description provided for @redeemSeeds.
  ///
  /// In es, this message translates to:
  /// **'Canjea tus semillas por recompensas'**
  String get redeemSeeds;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar...'**
  String get search;

  /// No description provided for @communityFavorites.
  ///
  /// In es, this message translates to:
  /// **'Los favoritos de la comunidad'**
  String get communityFavorites;

  /// No description provided for @newBadge.
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get newBadge;

  /// No description provided for @yourImpactEquals.
  ///
  /// In es, this message translates to:
  /// **'Tu impacto equivale a:'**
  String get yourImpactEquals;

  /// No description provided for @treesEquivalent.
  ///
  /// In es, this message translates to:
  /// **'{count} Árboles'**
  String treesEquivalent(int count);

  /// No description provided for @kilometersEquivalent.
  ///
  /// In es, this message translates to:
  /// **'{count} Kilómetros'**
  String kilometersEquivalent(int count);

  /// No description provided for @levelAndTrophies.
  ///
  /// In es, this message translates to:
  /// **'Nivel {level} · {trophies} trofeos'**
  String levelAndTrophies(int level, int trophies);

  /// No description provided for @noAchievementsYet.
  ///
  /// In es, this message translates to:
  /// **'No has completado logros todavía.'**
  String get noAchievementsYet;

  /// No description provided for @allAchievementsDone.
  ///
  /// In es, this message translates to:
  /// **'¡Completaste todos los logros disponibles!'**
  String get allAchievementsDone;

  /// No description provided for @noAchievementsConfigured.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay logros configurados.'**
  String get noAchievementsConfigured;

  /// No description provided for @comingSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get comingSoon;

  /// No description provided for @reward.
  ///
  /// In es, this message translates to:
  /// **'Recompensa'**
  String get reward;

  /// No description provided for @achievementUnlockedLabel.
  ///
  /// In es, this message translates to:
  /// **'Logro desbloqueado'**
  String get achievementUnlockedLabel;

  /// No description provided for @achievementLockedLabel.
  ///
  /// In es, this message translates to:
  /// **'Logro bloqueado'**
  String get achievementLockedLabel;

  /// No description provided for @activeMissions.
  ///
  /// In es, this message translates to:
  /// **'Misiones activas'**
  String get activeMissions;

  /// No description provided for @plantCatalog.
  ///
  /// In es, this message translates to:
  /// **'Catálogo de plantas'**
  String get plantCatalog;

  /// No description provided for @seedStore.
  ///
  /// In es, this message translates to:
  /// **'Tienda de Semillas'**
  String get seedStore;

  /// No description provided for @freePlanActive.
  ///
  /// In es, this message translates to:
  /// **'Plan gratuito activo'**
  String get freePlanActive;

  /// No description provided for @user.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get user;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @genericError.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal. Inténtalo de nuevo.'**
  String get genericError;

  /// No description provided for @catTropical.
  ///
  /// In es, this message translates to:
  /// **'Tropical'**
  String get catTropical;

  /// No description provided for @catSucculent.
  ///
  /// In es, this message translates to:
  /// **'Suculenta'**
  String get catSucculent;

  /// No description provided for @catCactus.
  ///
  /// In es, this message translates to:
  /// **'Cactus'**
  String get catCactus;

  /// No description provided for @catFern.
  ///
  /// In es, this message translates to:
  /// **'Helecho'**
  String get catFern;

  /// No description provided for @catFlowering.
  ///
  /// In es, this message translates to:
  /// **'Con flores'**
  String get catFlowering;

  /// No description provided for @catHerb.
  ///
  /// In es, this message translates to:
  /// **'Aromática'**
  String get catHerb;

  /// No description provided for @catTree.
  ///
  /// In es, this message translates to:
  /// **'Árbol'**
  String get catTree;

  /// No description provided for @catOther.
  ///
  /// In es, this message translates to:
  /// **'Planta'**
  String get catOther;

  /// No description provided for @lightLow.
  ///
  /// In es, this message translates to:
  /// **'Baja'**
  String get lightLow;

  /// No description provided for @lightMedium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get lightMedium;

  /// No description provided for @lightHigh.
  ///
  /// In es, this message translates to:
  /// **'Alta'**
  String get lightHigh;

  /// No description provided for @lightIndirect.
  ///
  /// In es, this message translates to:
  /// **'Indirecta'**
  String get lightIndirect;

  /// No description provided for @lightPrefix.
  ///
  /// In es, this message translates to:
  /// **'Luz {level}'**
  String lightPrefix(String level);

  /// No description provided for @difficultyVeryEasy.
  ///
  /// In es, this message translates to:
  /// **'Muy fácil'**
  String get difficultyVeryEasy;

  /// No description provided for @difficultyEasy.
  ///
  /// In es, this message translates to:
  /// **'Fácil'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get difficultyMedium;

  /// No description provided for @wateringEveryDays.
  ///
  /// In es, this message translates to:
  /// **'Riego c/{days}d'**
  String wateringEveryDays(int days);

  /// No description provided for @humidityLow.
  ///
  /// In es, this message translates to:
  /// **'Baja'**
  String get humidityLow;

  /// No description provided for @humidityMedium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get humidityMedium;

  /// No description provided for @humidityHigh.
  ///
  /// In es, this message translates to:
  /// **'Alta'**
  String get humidityHigh;

  /// No description provided for @impactCarTitle.
  ///
  /// In es, this message translates to:
  /// **'{km} km en coche'**
  String impactCarTitle(String km);

  /// No description provided for @impactCarSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Que no haría falta conducir para emitir ese CO₂.'**
  String get impactCarSubtitle;

  /// No description provided for @impactBulbTitle.
  ///
  /// In es, this message translates to:
  /// **'{hours} h de bombilla LED'**
  String impactBulbTitle(String hours);

  /// No description provided for @impactBulbSubtitle.
  ///
  /// In es, this message translates to:
  /// **'De consumo eléctrico equivalente.'**
  String get impactBulbSubtitle;

  /// No description provided for @impactTreeTitle.
  ///
  /// In es, this message translates to:
  /// **'{days} días de un árbol'**
  String impactTreeTitle(String days);

  /// No description provided for @impactTreeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Lo que tarda un árbol adulto en absorber lo mismo.'**
  String get impactTreeSubtitle;

  /// No description provided for @impactApproxNote.
  ///
  /// In es, this message translates to:
  /// **'Equivalencias aproximadas, calculadas a partir del CO₂ de tu jardín.'**
  String get impactApproxNote;

  /// No description provided for @impactTooSmall.
  ///
  /// In es, this message translates to:
  /// **'Tu jardín aún no acumula CO₂ suficiente para una equivalencia útil.'**
  String get impactTooSmall;

  /// No description provided for @accumulatedGrams.
  ///
  /// In es, this message translates to:
  /// **'Acumulado: {grams} g'**
  String accumulatedGrams(String grams);

  /// No description provided for @category.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get category;

  /// No description provided for @gallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get gallery;

  /// No description provided for @chooseFromGallery.
  ///
  /// In es, this message translates to:
  /// **'Elegir de la galería'**
  String get chooseFromGallery;

  /// No description provided for @cameraPermissionError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo acceder a la cámara o galería. Revisa los permisos de la app.'**
  String get cameraPermissionError;

  /// No description provided for @flashAutoHint.
  ///
  /// In es, this message translates to:
  /// **'El flash se activará de forma automática solo al realizar la captura.'**
  String get flashAutoHint;

  /// No description provided for @showThisGuide.
  ///
  /// In es, this message translates to:
  /// **'Muestra esta guía.'**
  String get showThisGuide;

  /// No description provided for @upcomingAchievements.
  ///
  /// In es, this message translates to:
  /// **'Próximos logros'**
  String get upcomingAchievements;

  /// No description provided for @closest.
  ///
  /// In es, this message translates to:
  /// **'• MÁS CERCANO'**
  String get closest;

  /// No description provided for @paymentMethod.
  ///
  /// In es, this message translates to:
  /// **'Método de pago'**
  String get paymentMethod;

  /// No description provided for @quickPay.
  ///
  /// In es, this message translates to:
  /// **'Pago rápido'**
  String get quickPay;

  /// No description provided for @oneYearPlus.
  ///
  /// In es, this message translates to:
  /// **'1 año de ECO2 Plus'**
  String get oneYearPlus;

  /// No description provided for @whatToDoNow.
  ///
  /// In es, this message translates to:
  /// **'Qué hacer ahora'**
  String get whatToDoNow;

  /// No description provided for @uploadFromGallery.
  ///
  /// In es, this message translates to:
  /// **'Subir de Galería'**
  String get uploadFromGallery;

  /// No description provided for @dayMon.
  ///
  /// In es, this message translates to:
  /// **'Lun'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In es, this message translates to:
  /// **'Mar'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In es, this message translates to:
  /// **'Mié'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In es, this message translates to:
  /// **'Jue'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In es, this message translates to:
  /// **'Vie'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In es, this message translates to:
  /// **'Sáb'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In es, this message translates to:
  /// **'Dom'**
  String get daySun;

  /// No description provided for @careEveryNDays.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{Cada día} other{Cada {count} días}}'**
  String careEveryNDays(int count);

  /// No description provided for @timeAgoDays.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Hoy} =1{hace 1 día} other{hace {count} días}}'**
  String timeAgoDays(int count);

  /// No description provided for @achievementUnlockedNamed.
  ///
  /// In es, this message translates to:
  /// **'¡Logro desbloqueado!: {name}'**
  String achievementUnlockedNamed(String name);

  /// No description provided for @purchaseSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Compra exitosa!: {item}'**
  String purchaseSuccess(String item);

  /// No description provided for @plantAddedToGarden.
  ///
  /// In es, this message translates to:
  /// **'¡{name} añadida a tu jardín! 🌿'**
  String plantAddedToGarden(String name);

  /// No description provided for @couldNotAddPlant.
  ///
  /// In es, this message translates to:
  /// **'No se pudo agregar la planta.'**
  String get couldNotAddPlant;

  /// No description provided for @addNewPlant.
  ///
  /// In es, this message translates to:
  /// **'Añadir nueva planta'**
  String get addNewPlant;

  /// No description provided for @yourPlantName.
  ///
  /// In es, this message translates to:
  /// **'Nombre de tu planta'**
  String get yourPlantName;

  /// No description provided for @gramsPerDayShort.
  ///
  /// In es, this message translates to:
  /// **'{grams} g/día'**
  String gramsPerDayShort(String grams);

  /// No description provided for @difficultyAll.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get difficultyAll;

  /// No description provided for @lightHintLow.
  ///
  /// In es, this message translates to:
  /// **'Rincones con poca luz'**
  String get lightHintLow;

  /// No description provided for @lightHintHigh.
  ///
  /// In es, this message translates to:
  /// **'Cerca de la ventana'**
  String get lightHintHigh;

  /// No description provided for @lightHintIndirect.
  ///
  /// In es, this message translates to:
  /// **'Sin sol directo'**
  String get lightHintIndirect;

  /// No description provided for @lightHintDefault.
  ///
  /// In es, this message translates to:
  /// **'Luz filtrada'**
  String get lightHintDefault;

  /// No description provided for @filterByCategory.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por categoría'**
  String get filterByCategory;

  /// No description provided for @speciesNotFound.
  ///
  /// In es, this message translates to:
  /// **'Especie no encontrada'**
  String get speciesNotFound;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Recuperar contraseña'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordBody.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu correo y te enviaremos un código para restablecer la contraseña.'**
  String get forgotPasswordBody;

  /// No description provided for @forgotPasswordSent.
  ///
  /// In es, this message translates to:
  /// **'Si existe una cuenta con ese correo, te hemos enviado un código.'**
  String get forgotPasswordSent;

  /// No description provided for @send.
  ///
  /// In es, this message translates to:
  /// **'Enviar'**
  String get send;

  /// No description provided for @emailRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu correo primero'**
  String get emailRequired;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Restablecer contraseña'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordIntro.
  ///
  /// In es, this message translates to:
  /// **'Pega aquí el código que te enviamos por correo y elige tu nueva contraseña.'**
  String get resetPasswordIntro;

  /// No description provided for @resetCodeLabel.
  ///
  /// In es, this message translates to:
  /// **'Código de recuperación'**
  String get resetCodeLabel;

  /// No description provided for @resetCodeHint.
  ///
  /// In es, this message translates to:
  /// **'ABCD-2345'**
  String get resetCodeHint;

  /// No description provided for @resetCodeRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe el código que recibiste'**
  String get resetCodeRequired;

  /// No description provided for @newPassword.
  ///
  /// In es, this message translates to:
  /// **'Nueva contraseña'**
  String get newPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsDoNotMatch;

  /// No description provided for @resetPasswordSubmit.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get resetPasswordSubmit;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In es, this message translates to:
  /// **'Contraseña actualizada. Ya puedes iniciar sesión.'**
  String get resetPasswordSuccess;

  /// No description provided for @resetCodeExpiredHint.
  ///
  /// In es, this message translates to:
  /// **'El código vence a los 30 minutos. Pide uno nuevo si ya caducó.'**
  String get resetCodeExpiredHint;

  /// No description provided for @changePasswordIntro.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu contraseña actual y elige una nueva.'**
  String get changePasswordIntro;

  /// No description provided for @changePasswordSubmit.
  ///
  /// In es, this message translates to:
  /// **'Guardar contraseña'**
  String get changePasswordSubmit;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In es, this message translates to:
  /// **'Contraseña actualizada.'**
  String get changePasswordSuccess;

  /// No description provided for @currentPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña actual'**
  String get currentPassword;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu contraseña actual'**
  String get currentPasswordRequired;

  /// No description provided for @passwordMustDiffer.
  ///
  /// In es, this message translates to:
  /// **'La nueva contraseña debe ser distinta de la actual'**
  String get passwordMustDiffer;

  /// No description provided for @biometricLock.
  ///
  /// In es, this message translates to:
  /// **'Bloqueo con huella'**
  String get biometricLock;

  /// No description provided for @biometricLockSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Pide tu huella al abrir la app'**
  String get biometricLockSubtitle;

  /// No description provided for @biometricUnavailable.
  ///
  /// In es, this message translates to:
  /// **'Este dispositivo no tiene huella registrada'**
  String get biometricUnavailable;

  /// No description provided for @biometricPromptReason.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu identidad para abrir ECO2'**
  String get biometricPromptReason;

  /// No description provided for @biometricEnabled.
  ///
  /// In es, this message translates to:
  /// **'Bloqueo con huella activado'**
  String get biometricEnabled;

  /// No description provided for @biometricDisabled.
  ///
  /// In es, this message translates to:
  /// **'Bloqueo con huella desactivado'**
  String get biometricDisabled;

  /// No description provided for @appLockTitle.
  ///
  /// In es, this message translates to:
  /// **'ECO2 está bloqueado'**
  String get appLockTitle;

  /// No description provided for @appLockSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Usa tu huella para continuar.'**
  String get appLockSubtitle;

  /// No description provided for @appLockFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo confirmar tu identidad.'**
  String get appLockFailed;

  /// No description provided for @appLockRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get appLockRetry;

  /// No description provided for @appLockSignOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get appLockSignOut;

  /// No description provided for @managePlus.
  ///
  /// In es, this message translates to:
  /// **'Gestionar ECO2 Plus'**
  String get managePlus;

  /// No description provided for @managePlusFree.
  ///
  /// In es, this message translates to:
  /// **'Plan gratuito activo'**
  String get managePlusFree;

  /// No description provided for @pushNotificationsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Avisos de riego y logros'**
  String get pushNotificationsSubtitle;

  /// No description provided for @reminderWindow.
  ///
  /// In es, this message translates to:
  /// **'Horario de recordatorios'**
  String get reminderWindow;

  /// No description provided for @reminderWindowValue.
  ///
  /// In es, this message translates to:
  /// **'De {start}:00 a {end}:00'**
  String reminderWindowValue(int start, int end);

  /// No description provided for @reminderWindowSheetTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo quieres los avisos?'**
  String get reminderWindowSheetTitle;

  /// No description provided for @reminderWindowIntro.
  ///
  /// In es, this message translates to:
  /// **'Los recordatorios solo se envían dentro de esta franja.'**
  String get reminderWindowIntro;

  /// No description provided for @reminderStart.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get reminderStart;

  /// No description provided for @reminderEnd.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get reminderEnd;

  /// No description provided for @reminderWindowInvalid.
  ///
  /// In es, this message translates to:
  /// **'La hora de inicio debe ser anterior a la de fin'**
  String get reminderWindowInvalid;

  /// No description provided for @reminderWindowSaved.
  ///
  /// In es, this message translates to:
  /// **'Horario de recordatorios actualizado'**
  String get reminderWindowSaved;

  /// No description provided for @privacySheetTitle.
  ///
  /// In es, this message translates to:
  /// **'Tus datos en ECO2'**
  String get privacySheetTitle;

  /// No description provided for @privacySheetBody.
  ///
  /// In es, this message translates to:
  /// **'ECO2 guarda tu correo, tu nombre de usuario, las plantas de tu jardín y su historial de cuidados. Las fotos que tomas se guardan solo en este dispositivo. Puedes exportar todo o borrar la cuenta cuando quieras.'**
  String get privacySheetBody;

  /// No description provided for @exportDataSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Copia un resumen al portapapeles'**
  String get exportDataSubtitle;

  /// No description provided for @exportDataCopied.
  ///
  /// In es, this message translates to:
  /// **'Datos copiados al portapapeles'**
  String get exportDataCopied;

  /// No description provided for @exportDataFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron reunir tus datos'**
  String get exportDataFailed;

  /// No description provided for @helpSupportSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Escríbenos si algo falla'**
  String get helpSupportSubtitle;

  /// No description provided for @helpSheetTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Necesitas ayuda?'**
  String get helpSheetTitle;

  /// No description provided for @helpSheetBody.
  ///
  /// In es, this message translates to:
  /// **'Escríbenos contando qué ocurrió y desde qué pantalla. Copia el correo y mándanos un mensaje.'**
  String get helpSheetBody;

  /// No description provided for @copyEmail.
  ///
  /// In es, this message translates to:
  /// **'Copiar correo'**
  String get copyEmail;

  /// No description provided for @emailCopied.
  ///
  /// In es, this message translates to:
  /// **'Correo copiado'**
  String get emailCopied;

  /// No description provided for @appVersion.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String appVersion(String version);

  /// No description provided for @aboutSheetBody.
  ///
  /// In es, this message translates to:
  /// **'ECO2 te ayuda a cuidar tus plantas y a ver cuánto CO₂ absorben.'**
  String get aboutSheetBody;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar tu cuenta?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In es, this message translates to:
  /// **'Se borrarán tu perfil, tus plantas y todo su historial de cuidados. No se puede deshacer.'**
  String get deleteAccountBody;

  /// No description provided for @deleteAccountConfirmHint.
  ///
  /// In es, this message translates to:
  /// **'Escribe ELIMINAR para confirmar'**
  String get deleteAccountConfirmHint;

  /// No description provided for @deleteAccountConfirmWord.
  ///
  /// In es, this message translates to:
  /// **'ELIMINAR'**
  String get deleteAccountConfirmWord;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta ha sido eliminada.'**
  String get deleteAccountSuccess;

  /// No description provided for @usernameTaken.
  ///
  /// In es, this message translates to:
  /// **'Ese nombre de usuario ya está en uso.'**
  String get usernameTaken;

  /// No description provided for @currentPasswordWrong.
  ///
  /// In es, this message translates to:
  /// **'La contraseña actual no es correcta.'**
  String get currentPasswordWrong;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo actualizar el perfil. Inténtalo nuevamente.'**
  String get profileUpdateFailed;

  /// No description provided for @plantsLoadFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar tus plantas.'**
  String get plantsLoadFailed;

  /// No description provided for @plantAddFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo añadir la planta.'**
  String get plantAddFailed;

  /// No description provided for @plantDeleteFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo eliminar la planta.'**
  String get plantDeleteFailed;

  /// No description provided for @nicknameEmpty.
  ///
  /// In es, this message translates to:
  /// **'El apodo no puede estar vacío.'**
  String get nicknameEmpty;

  /// No description provided for @nicknameUpdateFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo actualizar el apodo.'**
  String get nicknameUpdateFailed;

  /// No description provided for @missionsLoadFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron cargar las misiones.'**
  String get missionsLoadFailed;

  /// No description provided for @careLogFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo registrar el cuidado.'**
  String get careLogFailed;

  /// No description provided for @nicknameUpdated.
  ///
  /// In es, this message translates to:
  /// **'Apodo actualizado.'**
  String get nicknameUpdated;

  /// No description provided for @noSpeciesMatchFilters.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron especies con estos filtros'**
  String get noSpeciesMatchFilters;

  /// No description provided for @noPlantsInCategory.
  ///
  /// In es, this message translates to:
  /// **'No tienes plantas en esta categoría todavía'**
  String get noPlantsInCategory;

  /// No description provided for @daysOverdueLabel.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 día de retraso} other{{count} días de retraso}}'**
  String daysOverdueLabel(int count);

  /// No description provided for @noWateringLoggedEvery.
  ///
  /// In es, this message translates to:
  /// **'Sin riego registrado · c/{days}d'**
  String noWateringLoggedEvery(int days);

  /// No description provided for @daysWithoutWaterEvery.
  ///
  /// In es, this message translates to:
  /// **'{days}d sin riego · c/{freq}d'**
  String daysWithoutWaterEvery(int days, int freq);

  /// No description provided for @identifyConnectionError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo conectar para identificar la planta. Verifica tu conexión e inténtalo de nuevo.'**
  String get identifyConnectionError;

  /// No description provided for @plantAlreadyRegistered.
  ///
  /// In es, this message translates to:
  /// **'Planta ya registrada'**
  String get plantAlreadyRegistered;

  /// No description provided for @plantAlreadyRegisteredBody.
  ///
  /// In es, this message translates to:
  /// **'Ya tienes esta planta registrada en tu jardín. Te sugerimos ponerle un apodo (diferenciador) para no confundirla.'**
  String get plantAlreadyRegisteredBody;

  /// No description provided for @addThisPlantQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Desea añadir esta planta a su jardín?'**
  String get addThisPlantQuestion;

  /// No description provided for @addThisPlantBody.
  ///
  /// In es, this message translates to:
  /// **'Se añadirá a tu colección de plantas.'**
  String get addThisPlantBody;

  /// No description provided for @redeemMore.
  ///
  /// In es, this message translates to:
  /// **'Canjear más'**
  String get redeemMore;

  /// No description provided for @plantAddedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Planta añadida con éxito'**
  String get plantAddedSuccess;

  /// No description provided for @historyLoadFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar el historial.'**
  String get historyLoadFailed;

  /// No description provided for @noScansYet.
  ///
  /// In es, this message translates to:
  /// **'Todavía no has escaneado ninguna planta.'**
  String get noScansYet;

  /// No description provided for @toMyGarden.
  ///
  /// In es, this message translates to:
  /// **'A mi jardín'**
  String get toMyGarden;

  /// No description provided for @aiNotAvailable.
  ///
  /// In es, this message translates to:
  /// **'La identificación por IA todavía no está disponible en esta versión.'**
  String get aiNotAvailable;

  /// No description provided for @tourGalleryDescription.
  ///
  /// In es, this message translates to:
  /// **'Sube una foto de tu galería para analizar.'**
  String get tourGalleryDescription;

  /// No description provided for @shutter.
  ///
  /// In es, this message translates to:
  /// **'Obturador'**
  String get shutter;

  /// No description provided for @tourShutterDescription.
  ///
  /// In es, this message translates to:
  /// **'Presiona aquí para escanear una planta y continuar.'**
  String get tourShutterDescription;

  /// No description provided for @enterUsername.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa tu nombre de usuario'**
  String get enterUsername;

  /// No description provided for @usernameTooShort.
  ///
  /// In es, this message translates to:
  /// **'El nombre de usuario debe tener al menos 3 caracteres'**
  String get usernameTooShort;

  /// No description provided for @enterValidEmail.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa un correo válido'**
  String get enterValidEmail;

  /// No description provided for @confirmYourPassword.
  ///
  /// In es, this message translates to:
  /// **'Por favor confirma tu contraseña'**
  String get confirmYourPassword;

  /// No description provided for @estimatedValueNote.
  ///
  /// In es, this message translates to:
  /// **'{measured, plural, other{Valor estimado: {measured} de {total} plantas se apoyan en una medición publicada.}}'**
  String estimatedValueNote(int measured, int total);

  /// No description provided for @footprintShareEmpty.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tengo plantas en mi jardín ECO2.'**
  String get footprintShareEmpty;

  /// No description provided for @footprintShareSummary.
  ///
  /// In es, this message translates to:
  /// **'Mi jardín ECO2: {plants} plantas y {perDay} g de CO₂ al día ({total} g acumulados).'**
  String footprintShareSummary(int plants, String perDay, String total);

  /// No description provided for @addPlantsToSeeContribution.
  ///
  /// In es, this message translates to:
  /// **'Añade plantas a tu jardín para ver cuánto aporta cada una.'**
  String get addPlantsToSeeContribution;

  /// No description provided for @storeBestsellers.
  ///
  /// In es, this message translates to:
  /// **'Más vendidos'**
  String get storeBestsellers;

  /// No description provided for @storeAvatars.
  ///
  /// In es, this message translates to:
  /// **'Avatares'**
  String get storeAvatars;

  /// No description provided for @storePots.
  ///
  /// In es, this message translates to:
  /// **'Macetas'**
  String get storePots;

  /// No description provided for @storeO2Plus2wTitle.
  ///
  /// In es, this message translates to:
  /// **'Cosecha tu jardín pro'**
  String get storeO2Plus2wTitle;

  /// No description provided for @storeO2Plus2wSubtitle.
  ///
  /// In es, this message translates to:
  /// **'2 semanas de O2 Plus'**
  String get storeO2Plus2wSubtitle;

  /// No description provided for @storePotRentalTitle.
  ///
  /// In es, this message translates to:
  /// **'Alquila una maceta'**
  String get storePotRentalTitle;

  /// No description provided for @storePotRentalSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Espacio temporal · 2 semanas'**
  String get storePotRentalSubtitle;

  /// No description provided for @storeAvatarExplorerTitle.
  ///
  /// In es, this message translates to:
  /// **'Avatar Explorador Verde'**
  String get storeAvatarExplorerTitle;

  /// No description provided for @storeAvatarGuardianTitle.
  ///
  /// In es, this message translates to:
  /// **'Avatar Guardián del Bosque'**
  String get storeAvatarGuardianTitle;

  /// No description provided for @storePermanentUnlock.
  ///
  /// In es, this message translates to:
  /// **'Desbloqueo permanente'**
  String get storePermanentUnlock;

  /// No description provided for @storePotPack3Title.
  ///
  /// In es, this message translates to:
  /// **'Pack de 3 macetas'**
  String get storePotPack3Title;

  /// No description provided for @storePotPack3Subtitle.
  ///
  /// In es, this message translates to:
  /// **'+3 espacios permanentes'**
  String get storePotPack3Subtitle;

  /// No description provided for @storeO2Plus4wTitle.
  ///
  /// In es, this message translates to:
  /// **'O2 Plus mensual'**
  String get storeO2Plus4wTitle;

  /// No description provided for @storeO2Plus4wSubtitle.
  ///
  /// In es, this message translates to:
  /// **'4 semanas de O2 Plus'**
  String get storeO2Plus4wSubtitle;

  /// No description provided for @newBadgeLabel.
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get newBadgeLabel;

  /// No description provided for @noItemsFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron artículos'**
  String get noItemsFound;

  /// No description provided for @confirmPurchaseTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Confirmar compra?'**
  String get confirmPurchaseTitle;

  /// No description provided for @confirmPurchaseBody.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas canjear \"{item}\" por {cost} semillas?'**
  String confirmPurchaseBody(String item, int cost);

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @purchaseFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo completar la compra.'**
  String get purchaseFailed;

  /// No description provided for @boostGardenPremium.
  ///
  /// In es, this message translates to:
  /// **'Impulsa tu jardín con beneficios premium'**
  String get boostGardenPremium;

  /// No description provided for @moreSpaceForPlants.
  ///
  /// In es, this message translates to:
  /// **'Consigue más espacio para tus plantas'**
  String get moreSpaceForPlants;

  /// No description provided for @customizeYourProfile.
  ///
  /// In es, this message translates to:
  /// **'Personaliza tu perfil'**
  String get customizeYourProfile;

  /// No description provided for @speciesDescription.
  ///
  /// In es, this message translates to:
  /// **'Especie {category} que prefiere luz {light} y humedad {humidity}. Riega aproximadamente cada {days} días, dejando secar el sustrato entre riegos, y se adapta bien a temperaturas entre {minTemp}°C y {maxTemp}°C.'**
  String speciesDescription(
    String category,
    String light,
    String humidity,
    int days,
    int minTemp,
    int maxTemp,
  );

  /// No description provided for @purifierExcellent.
  ///
  /// In es, this message translates to:
  /// **'Es una excelente purificadora de aire.'**
  String get purifierExcellent;

  /// No description provided for @purifierGood.
  ///
  /// In es, this message translates to:
  /// **'Ayuda a mejorar la calidad del aire de tu hogar.'**
  String get purifierGood;

  /// No description provided for @humidityRangeLow.
  ///
  /// In es, this message translates to:
  /// **'30-40%'**
  String get humidityRangeLow;

  /// No description provided for @humidityRangeMedium.
  ///
  /// In es, this message translates to:
  /// **'40-60%'**
  String get humidityRangeMedium;

  /// No description provided for @humidityRangeHigh.
  ///
  /// In es, this message translates to:
  /// **'60-80%'**
  String get humidityRangeHigh;

  /// No description provided for @airPurification.
  ///
  /// In es, this message translates to:
  /// **'Purificación de aire'**
  String get airPurification;

  /// No description provided for @purificationLevel.
  ///
  /// In es, this message translates to:
  /// **'Nivel de purificación'**
  String get purificationLevel;

  /// No description provided for @idealRequirements.
  ///
  /// In es, this message translates to:
  /// **'Requisitos ideales para esta especie'**
  String get idealRequirements;

  /// No description provided for @everyNDaysShort.
  ///
  /// In es, this message translates to:
  /// **'c/{days} días'**
  String everyNDaysShort(int days);

  /// No description provided for @absorbsPerDay.
  ///
  /// In es, this message translates to:
  /// **'Absorbe ~{grams}g de CO₂/día'**
  String absorbsPerDay(String grams);

  /// No description provided for @addToMyGarden.
  ///
  /// In es, this message translates to:
  /// **'Añadir a mi jardín'**
  String get addToMyGarden;

  /// No description provided for @gramsPerDayValue.
  ///
  /// In es, this message translates to:
  /// **'{grams} g/día'**
  String gramsPerDayValue(String grams);

  /// No description provided for @noNotesYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no has agregado notas para esta planta.'**
  String get noNotesYet;

  /// No description provided for @airPurifierTag.
  ///
  /// In es, this message translates to:
  /// **'Aire purificador'**
  String get airPurifierTag;

  /// No description provided for @humidityWithPrefix.
  ///
  /// In es, this message translates to:
  /// **'Humedad {level}'**
  String humidityWithPrefix(String level);

  /// No description provided for @watering.
  ///
  /// In es, this message translates to:
  /// **'Riego'**
  String get watering;

  /// No description provided for @lightLabelShort.
  ///
  /// In es, this message translates to:
  /// **'Luz'**
  String get lightLabelShort;

  /// No description provided for @temperature.
  ///
  /// In es, this message translates to:
  /// **'Temperatura'**
  String get temperature;

  /// No description provided for @humidityLabelShort.
  ///
  /// In es, this message translates to:
  /// **'Humedad'**
  String get humidityLabelShort;

  /// No description provided for @whenSoilDry.
  ///
  /// In es, this message translates to:
  /// **'Cuando la tierra esté seca'**
  String get whenSoilDry;

  /// No description provided for @redeemSeedsOrSubscribe.
  ///
  /// In es, this message translates to:
  /// **'Canjea tus semillas o suscríbete a O₂₊'**
  String get redeemSeedsOrSubscribe;

  /// No description provided for @viewMyAchievements.
  ///
  /// In es, this message translates to:
  /// **'Ver mis logros y misiones'**
  String get viewMyAchievements;

  /// No description provided for @exploreBotanicalSpecies.
  ///
  /// In es, this message translates to:
  /// **'Ver especies'**
  String get exploreBotanicalSpecies;

  /// No description provided for @appTour.
  ///
  /// In es, this message translates to:
  /// **'Recorrido de la app'**
  String get appTour;

  /// No description provided for @appTourSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ver de nuevo'**
  String get appTourSubtitle;

  /// No description provided for @rewardDiscountTitle.
  ///
  /// In es, this message translates to:
  /// **'Dto. 15% Vivero El Helecho'**
  String get rewardDiscountTitle;

  /// No description provided for @rewardDiscountDesc.
  ///
  /// In es, this message translates to:
  /// **'Cupón aplicable a tu próxima compra.'**
  String get rewardDiscountDesc;

  /// No description provided for @rewardBadgeTitle.
  ///
  /// In es, this message translates to:
  /// **'Insignia \"Guardián de la Tierra\"'**
  String get rewardBadgeTitle;

  /// No description provided for @rewardBadgeDesc.
  ///
  /// In es, this message translates to:
  /// **'Muestra tu compromiso en tu perfil.'**
  String get rewardBadgeDesc;

  /// No description provided for @rewardPotsTitle.
  ///
  /// In es, this message translates to:
  /// **'Macetas personalizadas (3D)'**
  String get rewardPotsTitle;

  /// No description provided for @rewardPotsDesc.
  ///
  /// In es, this message translates to:
  /// **'Desbloquea diseños interactivos.'**
  String get rewardPotsDesc;

  /// No description provided for @redeemRewardTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Canjear premio?'**
  String get redeemRewardTitle;

  /// No description provided for @redeemRewardBody.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres canjear \"{reward}\" por {cost} semillas?'**
  String redeemRewardBody(String reward, int cost);

  /// No description provided for @redeemSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Canje exitoso!: {reward} 🎁'**
  String redeemSuccess(String reward);

  /// No description provided for @tourWateringStatusDesc.
  ///
  /// In es, this message translates to:
  /// **'Aquí ves si ya toca regarla, cuántos días lleva sin riego y cuántos días faltan (o cuántos de retraso lleva) según la frecuencia de la especie.'**
  String get tourWateringStatusDesc;

  /// No description provided for @tourLogCareDesc.
  ///
  /// In es, this message translates to:
  /// **'Cada vez que la riegues, fertilices, podes o trasplantes, regístralo aquí — así el estado de riego y tu historial quedan al día de verdad.'**
  String get tourLogCareDesc;

  /// No description provided for @speciesCare.
  ///
  /// In es, this message translates to:
  /// **'Cuidados de la especie'**
  String get speciesCare;

  /// No description provided for @speciesSpecSheet.
  ///
  /// In es, this message translates to:
  /// **'Ficha técnica de la especie'**
  String get speciesSpecSheet;

  /// No description provided for @tourSpeciesGridDesc.
  ///
  /// In es, this message translates to:
  /// **'Riego, luz, temperatura y humedad ideales para esta especie en particular.'**
  String get tourSpeciesGridDesc;

  /// No description provided for @howToCareForThisPlant.
  ///
  /// In es, this message translates to:
  /// **'Cómo cuidar esta planta'**
  String get howToCareForThisPlant;

  /// No description provided for @plantNicknameHint.
  ///
  /// In es, this message translates to:
  /// **'Apodo de la planta'**
  String get plantNicknameHint;

  /// No description provided for @howToCareForYourPlant.
  ///
  /// In es, this message translates to:
  /// **'Cómo cuidar tu planta'**
  String get howToCareForYourPlant;

  /// No description provided for @careCalendar.
  ///
  /// In es, this message translates to:
  /// **'Calendario de cuidados'**
  String get careCalendar;

  /// No description provided for @tourCareCalendarDesc.
  ///
  /// In es, this message translates to:
  /// **'La frecuencia de riego es real, según la especie. Fertilización, poda y trasplante son buenas prácticas generales — la app aún no calcula una frecuencia exacta para esas.'**
  String get tourCareCalendarDesc;

  /// No description provided for @whenToDoEachCare.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo hacer cada cuidado?'**
  String get whenToDoEachCare;

  /// No description provided for @scheduleFertilizing.
  ///
  /// In es, this message translates to:
  /// **'Cada 4-6 semanas, en primavera y verano'**
  String get scheduleFertilizing;

  /// No description provided for @schedulePruning.
  ///
  /// In es, this message translates to:
  /// **'Retira hojas secas, amarillas o dañadas en cuanto las notes'**
  String get schedulePruning;

  /// No description provided for @scheduleRepotting.
  ///
  /// In es, this message translates to:
  /// **'Cada 1-2 años, o cuando las raíces llenen la maceta'**
  String get scheduleRepotting;

  /// No description provided for @tourStoreDesc.
  ///
  /// In es, this message translates to:
  /// **'Canjea tus semillas por macetas extra y funciones especiales.'**
  String get tourStoreDesc;

  /// No description provided for @yourGarden.
  ///
  /// In es, this message translates to:
  /// **'Tu Jardín'**
  String get yourGarden;

  /// No description provided for @tourGardenDesc.
  ///
  /// In es, this message translates to:
  /// **'Explora el catálogo de especies o gestiona las plantas que ya tienes.'**
  String get tourGardenDesc;

  /// No description provided for @aiScanner.
  ///
  /// In es, this message translates to:
  /// **'Escáner IA'**
  String get aiScanner;

  /// No description provided for @tourScannerDesc.
  ///
  /// In es, this message translates to:
  /// **'Identifica una planta apuntando la cámara — la IA reconoce la especie.'**
  String get tourScannerDesc;

  /// No description provided for @yourProfile.
  ///
  /// In es, this message translates to:
  /// **'Tu Perfil'**
  String get yourProfile;

  /// No description provided for @tourProfileDesc.
  ///
  /// In es, this message translates to:
  /// **'Revisa tu progreso, ajustes de la cuenta y más.'**
  String get tourProfileDesc;

  /// No description provided for @premiumTitle.
  ///
  /// In es, this message translates to:
  /// **'Potencia tu jardín'**
  String get premiumTitle;

  /// No description provided for @premiumSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Desbloquea el potencial completo de ECO2 y lleva tu experiencia botánica al siguiente nivel.'**
  String get premiumSubtitle;

  /// No description provided for @premiumIncludes.
  ///
  /// In es, this message translates to:
  /// **'Todo lo que incluye'**
  String get premiumIncludes;

  /// No description provided for @premiumUnlimitedPots.
  ///
  /// In es, this message translates to:
  /// **'Macetas ilimitadas'**
  String get premiumUnlimitedPots;

  /// No description provided for @premiumUnlimitedPotsDesc.
  ///
  /// In es, this message translates to:
  /// **'Añade todas las plantas que quieras sin límites.'**
  String get premiumUnlimitedPotsDesc;

  /// No description provided for @premiumBetterSearch.
  ///
  /// In es, this message translates to:
  /// **'Búsqueda mejorada por descripción'**
  String get premiumBetterSearch;

  /// No description provided for @premiumBetterSearchDesc.
  ///
  /// In es, this message translates to:
  /// **'Encuentra plantas describiendo su aspecto con IA.'**
  String get premiumBetterSearchDesc;

  /// No description provided for @premiumUnlimitedScans.
  ///
  /// In es, this message translates to:
  /// **'Escaneos ilimitados'**
  String get premiumUnlimitedScans;

  /// No description provided for @premiumUnlimitedScansDesc.
  ///
  /// In es, this message translates to:
  /// **'Identifica cualquier planta, cuando quieras.'**
  String get premiumUnlimitedScansDesc;

  /// No description provided for @premiumAiTreatment.
  ///
  /// In es, this message translates to:
  /// **'Tratamiento asistido con IA'**
  String get premiumAiTreatment;

  /// No description provided for @premiumAiTreatmentDesc.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico personalizado de plagas y cuidados.'**
  String get premiumAiTreatmentDesc;

  /// No description provided for @premiumNurseryDiscounts.
  ///
  /// In es, this message translates to:
  /// **'Descuentos en viveros aliados'**
  String get premiumNurseryDiscounts;

  /// No description provided for @premiumNurseryDiscountsDesc.
  ///
  /// In es, this message translates to:
  /// **'Hasta 20% off en especies de aliados selectos.'**
  String get premiumNurseryDiscountsDesc;

  /// No description provided for @noCompletedAchievements.
  ///
  /// In es, this message translates to:
  /// **'No hay logros completados aún'**
  String get noCompletedAchievements;

  /// No description provided for @noLockedAchievements.
  ///
  /// In es, this message translates to:
  /// **'No hay logros bloqueados por ahora'**
  String get noLockedAchievements;

  /// No description provided for @lockedAchievementsNote.
  ///
  /// In es, this message translates to:
  /// **'Estos logros dependen de funciones que todavía no están disponibles en la app.'**
  String get lockedAchievementsNote;

  /// No description provided for @plantIdentification.
  ///
  /// In es, this message translates to:
  /// **'Identificación de plantas'**
  String get plantIdentification;

  /// No description provided for @scannerTabHint.
  ///
  /// In es, this message translates to:
  /// **'Apunta con la cámara a la planta o sube una foto de tu galería.'**
  String get scannerTabHint;

  /// No description provided for @recentAnalyses.
  ///
  /// In es, this message translates to:
  /// **'Análisis recientes'**
  String get recentAnalyses;

  /// No description provided for @careTypeWatering.
  ///
  /// In es, this message translates to:
  /// **'Riego'**
  String get careTypeWatering;

  /// No description provided for @careTypeFertilizing.
  ///
  /// In es, this message translates to:
  /// **'Fertilización'**
  String get careTypeFertilizing;

  /// No description provided for @careTypePruning.
  ///
  /// In es, this message translates to:
  /// **'Poda'**
  String get careTypePruning;

  /// No description provided for @careTypeRepotting.
  ///
  /// In es, this message translates to:
  /// **'Trasplante'**
  String get careTypeRepotting;

  /// No description provided for @careLoggedToast.
  ///
  /// In es, this message translates to:
  /// **'Cuidado registrado: {type} 🌿'**
  String careLoggedToast(String type);

  /// No description provided for @inOneDay.
  ///
  /// In es, this message translates to:
  /// **'en 1 día'**
  String get inOneDay;

  /// No description provided for @daysAgoShort.
  ///
  /// In es, this message translates to:
  /// **'hace {count} días'**
  String daysAgoShort(int count);

  /// No description provided for @inNDays.
  ///
  /// In es, this message translates to:
  /// **'en {count} días'**
  String inNDays(int count);

  /// No description provided for @noCareLoggedForPlant.
  ///
  /// In es, this message translates to:
  /// **'Aún no has registrado cuidados para esta planta.'**
  String get noCareLoggedForPlant;

  /// No description provided for @noEventsForFilter.
  ///
  /// In es, this message translates to:
  /// **'No hay eventos para este filtro.'**
  String get noEventsForFilter;

  /// No description provided for @featureComingSoon.
  ///
  /// In es, this message translates to:
  /// **'Esta función estará disponible próximamente.'**
  String get featureComingSoon;

  /// No description provided for @thisPlant.
  ///
  /// In es, this message translates to:
  /// **'esta planta'**
  String get thisPlant;

  /// No description provided for @careTypeGeneric.
  ///
  /// In es, this message translates to:
  /// **'Cuidado'**
  String get careTypeGeneric;

  /// No description provided for @changePhotoComingSoon.
  ///
  /// In es, this message translates to:
  /// **'Cambiar la foto de perfil estará disponible próximamente 📸'**
  String get changePhotoComingSoon;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto de perfil'**
  String get changeProfilePhoto;

  /// No description provided for @personalInformation.
  ///
  /// In es, this message translates to:
  /// **'Información personal'**
  String get personalInformation;

  /// No description provided for @pickSpeciesToContinue.
  ///
  /// In es, this message translates to:
  /// **'Elige una especie de la lista para continuar.'**
  String get pickSpeciesToContinue;

  /// No description provided for @nameYourPlantToContinue.
  ///
  /// In es, this message translates to:
  /// **'Ponle un nombre a tu planta para continuar.'**
  String get nameYourPlantToContinue;

  /// No description provided for @noSpeciesAvailable.
  ///
  /// In es, this message translates to:
  /// **'No hay especies disponibles todavía.'**
  String get noSpeciesAvailable;

  /// No description provided for @noSpeciesFoundFor.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron especies para \"{query}\".'**
  String noSpeciesFoundFor(String query);

  /// No description provided for @tellUsAboutYou.
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos sobre ti'**
  String get tellUsAboutYou;

  /// No description provided for @usernameRequired.
  ///
  /// In es, this message translates to:
  /// **'El nombre de usuario es obligatorio'**
  String get usernameRequired;

  /// No description provided for @minThreeChars.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 3 caracteres'**
  String get minThreeChars;

  /// No description provided for @gender.
  ///
  /// In es, this message translates to:
  /// **'Género'**
  String get gender;

  /// No description provided for @activeMissionCard.
  ///
  /// In es, this message translates to:
  /// **'Misión activa'**
  String get activeMissionCard;

  /// No description provided for @redeemSeedsOrSubscribeShort.
  ///
  /// In es, this message translates to:
  /// **'Canjea tus semillas o suscríbete'**
  String get redeemSeedsOrSubscribeShort;

  /// No description provided for @welcomeToEco2Plus.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido a ECO2\nPlus!'**
  String get welcomeToEco2Plus;

  /// No description provided for @subscriptionActive.
  ///
  /// In es, this message translates to:
  /// **'Tu suscripción anual está activa. Disfruta de todas las funciones Plus desde ahora.'**
  String get subscriptionActive;

  /// No description provided for @addPlantsWithoutLimit.
  ///
  /// In es, this message translates to:
  /// **'Añade plantas sin límite'**
  String get addPlantsWithoutLimit;

  /// No description provided for @gardenCanGrow.
  ///
  /// In es, this message translates to:
  /// **'Tu jardín puede crecer todo lo que quieras'**
  String get gardenCanGrow;

  /// No description provided for @sessionExpired.
  ///
  /// In es, this message translates to:
  /// **'Sesión expirada. Inicia sesión nuevamente.'**
  String get sessionExpired;

  /// No description provided for @noNotificationsYet.
  ///
  /// In es, this message translates to:
  /// **'No tienes notificaciones por ahora.'**
  String get noNotificationsYet;

  /// No description provided for @needsAttention.
  ///
  /// In es, this message translates to:
  /// **'Necesitan atención'**
  String get needsAttention;

  /// No description provided for @overdueByDays.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{Vencido hace 1 día} other{Vencido hace {count} días}}'**
  String overdueByDays(int count);

  /// No description provided for @passwordMinSixChars.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 6 caracteres'**
  String get passwordMinSixChars;

  /// No description provided for @achievementUnlockedTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Logro desbloqueado!'**
  String get achievementUnlockedTitle;

  /// No description provided for @newPlantAddedTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva planta agregada'**
  String get newPlantAddedTitle;

  /// No description provided for @newPlantAddedBody.
  ///
  /// In es, this message translates to:
  /// **'Agregaste {name} a tu colección.'**
  String newPlantAddedBody(String name);

  /// No description provided for @lastWateredHelpShort.
  ///
  /// In es, this message translates to:
  /// **'Así calculamos cuándo toca el próximo riego. Si no lo sabes, empezamos a contar desde hoy.'**
  String get lastWateredHelpShort;

  /// No description provided for @conditionNotTracked.
  ///
  /// In es, this message translates to:
  /// **'Esta condición todavía no se rastrea en la app.'**
  String get conditionNotTracked;

  /// No description provided for @tourSeedsDesc.
  ///
  /// In es, this message translates to:
  /// **'Ganas semillas cuidando tus plantas y cumpliendo misiones. Úsalas en la Tienda.'**
  String get tourSeedsDesc;

  /// No description provided for @achievementsAndMissionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Logros y misiones'**
  String get achievementsAndMissionsTitle;

  /// No description provided for @tourTrophyDesc.
  ///
  /// In es, this message translates to:
  /// **'Aquí ves tus trofeos, el progreso de tus misiones y cuánto XP llevas.'**
  String get tourTrophyDesc;

  /// No description provided for @allNotificationsRead.
  ///
  /// In es, this message translates to:
  /// **'Todas las notificaciones marcadas como leídas.'**
  String get allNotificationsRead;

  /// No description provided for @aiSearch.
  ///
  /// In es, this message translates to:
  /// **'Búsqueda con IA'**
  String get aiSearch;

  /// No description provided for @achievementUnlockedToast.
  ///
  /// In es, this message translates to:
  /// **'🏆 ¡Logro desbloqueado! {name} ({reward})'**
  String achievementUnlockedToast(String name, String reward);

  /// No description provided for @xpAndSeedsReward.
  ///
  /// In es, this message translates to:
  /// **'+{xp} XP · +{seeds} semillas'**
  String xpAndSeedsReward(int xp, int seeds);

  /// No description provided for @xpReward.
  ///
  /// In es, this message translates to:
  /// **'+{xp} XP'**
  String xpReward(int xp);

  /// No description provided for @progressOfPlants.
  ///
  /// In es, this message translates to:
  /// **'{current} de {total} plantas'**
  String progressOfPlants(int current, int total);

  /// No description provided for @progressOfCares.
  ///
  /// In es, this message translates to:
  /// **'{current} de {total} cuidados'**
  String progressOfCares(int current, int total);

  /// No description provided for @completed.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get pending;

  /// No description provided for @gotIt.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get gotIt;

  /// No description provided for @accept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get accept;

  /// No description provided for @viewSpecSheet.
  ///
  /// In es, this message translates to:
  /// **'Ver ficha'**
  String get viewSpecSheet;

  /// No description provided for @history.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get history;

  /// No description provided for @tourHistoryDesc.
  ///
  /// In es, this message translates to:
  /// **'Consulta tus escaneos anteriores.'**
  String get tourHistoryDesc;

  /// No description provided for @plantNotFound.
  ///
  /// In es, this message translates to:
  /// **'Planta no encontrada'**
  String get plantNotFound;

  /// No description provided for @editNickname.
  ///
  /// In es, this message translates to:
  /// **'Editar apodo'**
  String get editNickname;

  /// No description provided for @takePhoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get takePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In es, this message translates to:
  /// **'Quitar foto'**
  String get removePhoto;

  /// No description provided for @photoRemoved.
  ///
  /// In es, this message translates to:
  /// **'Foto eliminada.'**
  String get photoRemoved;

  /// No description provided for @photoUpdated.
  ///
  /// In es, this message translates to:
  /// **'Foto actualizada.'**
  String get photoUpdated;

  /// No description provided for @genderMale.
  ///
  /// In es, this message translates to:
  /// **'Hombre'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In es, this message translates to:
  /// **'Mujer'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get genderOther;

  /// No description provided for @genderPreferNotToSay.
  ///
  /// In es, this message translates to:
  /// **'Prefiero no decir'**
  String get genderPreferNotToSay;

  /// No description provided for @birthDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de nacimiento'**
  String get birthDate;

  /// No description provided for @tempShort.
  ///
  /// In es, this message translates to:
  /// **'Temp.'**
  String get tempShort;

  /// No description provided for @o2co2.
  ///
  /// In es, this message translates to:
  /// **'O₂ CO₂'**
  String get o2co2;

  /// No description provided for @confirmPayment.
  ///
  /// In es, this message translates to:
  /// **'Confirmar pago'**
  String get confirmPayment;

  /// No description provided for @card.
  ///
  /// In es, this message translates to:
  /// **'Tarjeta'**
  String get card;

  /// No description provided for @tourScanFavourite.
  ///
  /// In es, this message translates to:
  /// **'Escanea tu planta favorita'**
  String get tourScanFavourite;

  /// No description provided for @tourScanFavouriteDesc.
  ///
  /// In es, this message translates to:
  /// **'Identifica cualquier especie con IA'**
  String get tourScanFavouriteDesc;

  /// No description provided for @exploreDiscounts.
  ///
  /// In es, this message translates to:
  /// **'Explora descuentos exclusivos'**
  String get exploreDiscounts;

  /// No description provided for @exploreDiscountsDesc.
  ///
  /// In es, this message translates to:
  /// **'Hasta 20% off en viveros aliados'**
  String get exploreDiscountsDesc;

  /// No description provided for @redeemSeedsCount.
  ///
  /// In es, this message translates to:
  /// **'Canjear {count} semillas'**
  String redeemSeedsCount(int count);

  /// No description provided for @waterings.
  ///
  /// In es, this message translates to:
  /// **'Riegos'**
  String get waterings;

  /// No description provided for @prunings.
  ///
  /// In es, this message translates to:
  /// **'Podas'**
  String get prunings;

  /// No description provided for @routeNotFound.
  ///
  /// In es, this message translates to:
  /// **'Ruta no encontrada: {route}'**
  String routeNotFound(String route);

  /// No description provided for @careNoteHint.
  ///
  /// In es, this message translates to:
  /// **'Agua tibia · ~200ml · tierra ya estaba seca'**
  String get careNoteHint;

  /// No description provided for @tourNotificationsDesc.
  ///
  /// In es, this message translates to:
  /// **'Avisos reales: riegos pendientes, logros desbloqueados y plantas nuevas.'**
  String get tourNotificationsDesc;

  /// No description provided for @wateringDueNotification.
  ///
  /// In es, this message translates to:
  /// **'Riego pendiente: {name} necesita agua ahora.'**
  String wateringDueNotification(String name);

  /// No description provided for @fullName.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get fullName;

  /// No description provided for @plantWatered.
  ///
  /// In es, this message translates to:
  /// **'{name} regada 💧'**
  String plantWatered(String name);

  /// No description provided for @nicknameExample.
  ///
  /// In es, this message translates to:
  /// **'ej. jardinero_verde'**
  String get nicknameExample;

  /// No description provided for @plantNameExample.
  ///
  /// In es, this message translates to:
  /// **'ej. Mi Monstera'**
  String get plantNameExample;

  /// No description provided for @unlockedOn.
  ///
  /// In es, this message translates to:
  /// **'Desbloqueado el {date}'**
  String unlockedOn(String date);

  /// No description provided for @agoMinutes.
  ///
  /// In es, this message translates to:
  /// **'Hace {n}m'**
  String agoMinutes(int n);

  /// No description provided for @agoHours.
  ///
  /// In es, this message translates to:
  /// **'Hace {n}h'**
  String agoHours(int n);

  /// No description provided for @agoDays.
  ///
  /// In es, this message translates to:
  /// **'Hace {n}d'**
  String agoDays(int n);

  /// No description provided for @wateringDueTitle.
  ///
  /// In es, this message translates to:
  /// **'Riego pendiente'**
  String get wateringDueTitle;

  /// No description provided for @muteReminders.
  ///
  /// In es, this message translates to:
  /// **'Silenciar recordatorios'**
  String get muteReminders;

  /// No description provided for @muteRemindersOn.
  ///
  /// In es, this message translates to:
  /// **'No recibirás avisos de riego de esta planta'**
  String get muteRemindersOn;

  /// No description provided for @muteRemindersOff.
  ///
  /// In es, this message translates to:
  /// **'Recibirás avisos cuando toque regarla'**
  String get muteRemindersOff;

  /// No description provided for @remindersMuted.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios silenciados para {name}'**
  String remindersMuted(String name);

  /// No description provided for @remindersUnmuted.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios reactivados para {name}'**
  String remindersUnmuted(String name);

  /// No description provided for @logCare.
  ///
  /// In es, this message translates to:
  /// **'Registrar cuidado'**
  String get logCare;

  /// No description provided for @achFirstSteps.
  ///
  /// In es, this message translates to:
  /// **'Primeros Pasos'**
  String get achFirstSteps;

  /// No description provided for @achBotanicalEye.
  ///
  /// In es, this message translates to:
  /// **'Ojo Botánico'**
  String get achBotanicalEye;

  /// No description provided for @achFirstRoom.
  ///
  /// In es, this message translates to:
  /// **'Mi Primer Espacio'**
  String get achFirstRoom;

  /// No description provided for @achHandsOn.
  ///
  /// In es, this message translates to:
  /// **'Manos a la Obra'**
  String get achHandsOn;

  /// No description provided for @achSteadyCarer.
  ///
  /// In es, this message translates to:
  /// **'Cuidador Constante'**
  String get achSteadyCarer;

  /// No description provided for @achGreenGuardian.
  ///
  /// In es, this message translates to:
  /// **'Guardián Verde'**
  String get achGreenGuardian;

  /// No description provided for @achCareMaster.
  ///
  /// In es, this message translates to:
  /// **'Maestro del Cuidado'**
  String get achCareMaster;

  /// No description provided for @achBotanicalLegend.
  ///
  /// In es, this message translates to:
  /// **'Leyenda Botánica'**
  String get achBotanicalLegend;

  /// No description provided for @achMyLittleGarden.
  ///
  /// In es, this message translates to:
  /// **'Mi Pequeño Jardín'**
  String get achMyLittleGarden;

  /// No description provided for @achCollector.
  ///
  /// In es, this message translates to:
  /// **'Coleccionista'**
  String get achCollector;

  /// No description provided for @achDescOnboarding.
  ///
  /// In es, this message translates to:
  /// **'Completa el onboarding de ECO2'**
  String get achDescOnboarding;

  /// No description provided for @achDescFirstScan.
  ///
  /// In es, this message translates to:
  /// **'Escanea tu primera planta con IA'**
  String get achDescFirstScan;

  /// No description provided for @achDescFirstRoom.
  ///
  /// In es, this message translates to:
  /// **'Crea tu primera habitación'**
  String get achDescFirstRoom;

  /// No description provided for @achDescFirstCare.
  ///
  /// In es, this message translates to:
  /// **'Realiza tu primer cuidado'**
  String get achDescFirstCare;

  /// No description provided for @achDescNCares.
  ///
  /// In es, this message translates to:
  /// **'Realiza {count} cuidados'**
  String achDescNCares(int count);

  /// No description provided for @achDescNPlants.
  ///
  /// In es, this message translates to:
  /// **'Registra {count} plantas en tu colección'**
  String achDescNPlants(int count);

  /// No description provided for @aboutThisPlant.
  ///
  /// In es, this message translates to:
  /// **'Sobre esta planta'**
  String get aboutThisPlant;

  /// No description provided for @difficulty.
  ///
  /// In es, this message translates to:
  /// **'Dificultad'**
  String get difficulty;

  /// No description provided for @beginner.
  ///
  /// In es, this message translates to:
  /// **'Principiante'**
  String get beginner;

  /// No description provided for @expert.
  ///
  /// In es, this message translates to:
  /// **'Experto'**
  String get expert;

  /// No description provided for @care.
  ///
  /// In es, this message translates to:
  /// **'Cuidados'**
  String get care;

  /// No description provided for @carEquivalent.
  ///
  /// In es, this message translates to:
  /// **'Equivalente a un auto recorriendo {meters}m'**
  String carEquivalent(String meters);

  /// No description provided for @securePayments.
  ///
  /// In es, this message translates to:
  /// **'Pagos seguros con cifrado SSL de 256 bits'**
  String get securePayments;

  /// No description provided for @selectedPlan.
  ///
  /// In es, this message translates to:
  /// **'★ PLAN SELECCIONADO'**
  String get selectedPlan;

  /// No description provided for @eco2PlusAnnual.
  ///
  /// In es, this message translates to:
  /// **'ECO2 Plus Anual'**
  String get eco2PlusAnnual;

  /// No description provided for @cancelAnytime.
  ///
  /// In es, this message translates to:
  /// **'Cancela en cualquier momento'**
  String get cancelAnytime;

  /// No description provided for @totalToPay.
  ///
  /// In es, this message translates to:
  /// **'Total a pagar'**
  String get totalToPay;

  /// No description provided for @payAmount.
  ///
  /// In es, this message translates to:
  /// **'Pagar {amount}'**
  String payAmount(String amount);

  /// No description provided for @perMonthPrice.
  ///
  /// In es, this message translates to:
  /// **'{amount}/mes'**
  String perMonthPrice(String amount);

  /// No description provided for @filters.
  ///
  /// In es, this message translates to:
  /// **'Filtros'**
  String get filters;

  /// No description provided for @clear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clear;

  /// No description provided for @applyFilters.
  ///
  /// In es, this message translates to:
  /// **'Aplicar filtros'**
  String get applyFilters;

  /// No description provided for @unlockO2Features.
  ///
  /// In es, this message translates to:
  /// **'Desbloquea funciones O₂₊'**
  String get unlockO2Features;

  /// No description provided for @done.
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get done;

  /// No description provided for @customizeYourEco2.
  ///
  /// In es, this message translates to:
  /// **'Personaliza tu experiencia ECO2'**
  String get customizeYourEco2;

  /// No description provided for @skipForNow.
  ///
  /// In es, this message translates to:
  /// **'Omitir por ahora'**
  String get skipForNow;

  /// No description provided for @optional.
  ///
  /// In es, this message translates to:
  /// **'(opcional)'**
  String get optional;

  /// No description provided for @continueAction.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueAction;

  /// No description provided for @newScan.
  ///
  /// In es, this message translates to:
  /// **'Nuevo escaneo'**
  String get newScan;

  /// No description provided for @matchPercent.
  ///
  /// In es, this message translates to:
  /// **'{pct}% coincidencia'**
  String matchPercent(int pct);

  /// No description provided for @takePhotoAction.
  ///
  /// In es, this message translates to:
  /// **'Hacer foto'**
  String get takePhotoAction;

  /// No description provided for @date.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get date;

  /// No description provided for @noteOptional.
  ///
  /// In es, this message translates to:
  /// **'Nota (opcional)'**
  String get noteOptional;

  /// No description provided for @scanHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de escaneos'**
  String get scanHistory;

  /// No description provided for @otherPossibilities.
  ///
  /// In es, this message translates to:
  /// **'Otras posibilidades'**
  String get otherPossibilities;

  /// No description provided for @viewO2Plus.
  ///
  /// In es, this message translates to:
  /// **'Ver O₂₊'**
  String get viewO2Plus;

  /// No description provided for @exportToCalendar.
  ///
  /// In es, this message translates to:
  /// **'Exportar a calendario'**
  String get exportToCalendar;

  /// No description provided for @eventsCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 evento} other{{count} eventos}}'**
  String eventsCount(int count);

  /// No description provided for @viewFullSheet.
  ///
  /// In es, this message translates to:
  /// **'ver ficha completa'**
  String get viewFullSheet;

  /// No description provided for @myPersonalNote.
  ///
  /// In es, this message translates to:
  /// **'Mi nota personal'**
  String get myPersonalNote;

  /// No description provided for @noPlantNeedsWater.
  ///
  /// In es, this message translates to:
  /// **'Ninguna planta necesita riego ahora mismo.'**
  String get noPlantNeedsWater;

  /// No description provided for @waterAction.
  ///
  /// In es, this message translates to:
  /// **'Regar'**
  String get waterAction;

  /// No description provided for @o2PlusLabel.
  ///
  /// In es, this message translates to:
  /// **'O₂ PLUS'**
  String get o2PlusLabel;

  /// No description provided for @subscribeToO2Plus.
  ///
  /// In es, this message translates to:
  /// **'Suscribirse a O₂₊'**
  String get subscribeToO2Plus;

  /// No description provided for @minCharsSuffix.
  ///
  /// In es, this message translates to:
  /// **' · mín. 8 caracteres'**
  String get minCharsSuffix;

  /// No description provided for @startUsingPlus.
  ///
  /// In es, this message translates to:
  /// **'Empezar a usar Plus'**
  String get startUsingPlus;

  /// No description provided for @seedsCost.
  ///
  /// In es, this message translates to:
  /// **'{count} semillas'**
  String seedsCost(int count);

  /// No description provided for @seedsShort.
  ///
  /// In es, this message translates to:
  /// **'{count} sem.'**
  String seedsShort(int count);

  /// No description provided for @species.
  ///
  /// In es, this message translates to:
  /// **'Especie'**
  String get species;

  /// No description provided for @gramsPerDayUnit.
  ///
  /// In es, this message translates to:
  /// **'g/día'**
  String get gramsPerDayUnit;

  /// No description provided for @everyNDaysCompact.
  ///
  /// In es, this message translates to:
  /// **'c/{days}d'**
  String everyNDaysCompact(int days);

  /// No description provided for @pendingMissionsCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Todo completado} =1{1 pendiente} other{{count} pendientes}}'**
  String pendingMissionsCount(int count);

  /// No description provided for @seedsCountShort.
  ///
  /// In es, this message translates to:
  /// **'{count} semillas'**
  String seedsCountShort(int count);

  /// No description provided for @unitCares.
  ///
  /// In es, this message translates to:
  /// **'cuidados'**
  String get unitCares;

  /// No description provided for @unitPlants.
  ///
  /// In es, this message translates to:
  /// **'plantas'**
  String get unitPlants;

  /// No description provided for @filterAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get filterAll;

  /// No description provided for @fertilizings.
  ///
  /// In es, this message translates to:
  /// **'Abonos'**
  String get fertilizings;

  /// No description provided for @tabActive.
  ///
  /// In es, this message translates to:
  /// **'Activa'**
  String get tabActive;

  /// No description provided for @tabCompleted.
  ///
  /// In es, this message translates to:
  /// **'Completadas'**
  String get tabCompleted;

  /// No description provided for @tabLocked.
  ///
  /// In es, this message translates to:
  /// **'Bloqueadas'**
  String get tabLocked;

  /// No description provided for @plantLimitReached.
  ///
  /// In es, this message translates to:
  /// **'Has llegado a tu tope de macetas. Con O₂₊ son ilimitadas.'**
  String get plantLimitReached;

  /// No description provided for @scanLimitReached.
  ///
  /// In es, this message translates to:
  /// **'Ya usaste tus 5 escaneos de hoy. Con O₂₊ son ilimitados.'**
  String get scanLimitReached;

  /// No description provided for @plusMember.
  ///
  /// In es, this message translates to:
  /// **'Miembro O₂₊'**
  String get plusMember;

  /// No description provided for @plusActiveUntil.
  ///
  /// In es, this message translates to:
  /// **'Activo hasta el {date}'**
  String plusActiveUntil(String date);

  /// No description provided for @potsUsedOfLimit.
  ///
  /// In es, this message translates to:
  /// **'{used} de {limit} macetas'**
  String potsUsedOfLimit(int used, int limit);

  /// No description provided for @potsUnlimited.
  ///
  /// In es, this message translates to:
  /// **'Macetas ilimitadas'**
  String get potsUnlimited;

  /// No description provided for @legacyPotsKept.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{Conservas 1 maceta de tu O₂₊ anterior} other{Conservas {count} macetas de tu O₂₊ anterior}}'**
  String legacyPotsKept(int count);

  /// No description provided for @legacyPotsExplainer.
  ///
  /// In es, this message translates to:
  /// **'Al terminar O₂₊ no se borra ninguna planta: conservas las que cuidabas y el tope solo afecta a las nuevas.'**
  String get legacyPotsExplainer;

  /// No description provided for @rentalPotsActive.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 maceta alquilada} other{{count} macetas alquiladas}}'**
  String rentalPotsActive(int count);

  /// No description provided for @rentalPotsExpiresIn.
  ///
  /// In es, this message translates to:
  /// **'{days, plural, =0{Vence hoy} =1{Vence mañana} other{Vence en {days} días}}'**
  String rentalPotsExpiresIn(int days);

  /// No description provided for @rentalPotsFreeSlot.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{Te queda 1 hueco libre en tu jardín} other{Te quedan {count} huecos libres en tu jardín}}'**
  String rentalPotsFreeSlot(int count);

  /// No description provided for @rentalPotsAllUsed.
  ///
  /// In es, this message translates to:
  /// **'Todas tus macetas están ocupadas'**
  String get rentalPotsAllUsed;

  /// No description provided for @avatarAlreadyOwned.
  ///
  /// In es, this message translates to:
  /// **'Ya tienes este avatar.'**
  String get avatarAlreadyOwned;

  /// No description provided for @avatarNotOwned.
  ///
  /// In es, this message translates to:
  /// **'Necesitas comprar este avatar primero.'**
  String get avatarNotOwned;

  /// No description provided for @avatarPurchased.
  ///
  /// In es, this message translates to:
  /// **'¡{name} desbloqueado!'**
  String avatarPurchased(String name);

  /// No description provided for @buyForSeeds.
  ///
  /// In es, this message translates to:
  /// **'Comprar por {cost} semillas'**
  String buyForSeeds(int cost);

  /// No description provided for @earlierLabel.
  ///
  /// In es, this message translates to:
  /// **'Anteriores'**
  String get earlierLabel;

  /// No description provided for @noNotificationsBody.
  ///
  /// In es, this message translates to:
  /// **'Aquí verás los riegos pendientes, los logros que desbloquees y las plantas que añadas.'**
  String get noNotificationsBody;

  /// No description provided for @noNotificationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Todo en orden'**
  String get noNotificationsTitle;

  /// No description provided for @notEnoughSeeds.
  ///
  /// In es, this message translates to:
  /// **'No tienes semillas suficientes.'**
  String get notEnoughSeeds;

  /// No description provided for @owned.
  ///
  /// In es, this message translates to:
  /// **'Ya lo tienes'**
  String get owned;

  /// No description provided for @storeAvatarSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Desbloqueo permanente'**
  String get storeAvatarSubtitle;

  /// No description provided for @storeCriadoraTitle.
  ///
  /// In es, this message translates to:
  /// **'Avatar Criadora'**
  String get storeCriadoraTitle;

  /// No description provided for @storeExploradorTitle.
  ///
  /// In es, this message translates to:
  /// **'Avatar Explorador'**
  String get storeExploradorTitle;

  /// No description provided for @storeJardineraTitle.
  ///
  /// In es, this message translates to:
  /// **'Avatar Jardinera'**
  String get storeJardineraTitle;

  /// No description provided for @storeNoctilanaTitle.
  ///
  /// In es, this message translates to:
  /// **'Avatar Noctilana'**
  String get storeNoctilanaTitle;

  /// No description provided for @thisWeekLabel.
  ///
  /// In es, this message translates to:
  /// **'Esta semana'**
  String get thisWeekLabel;

  /// No description provided for @unreadCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 sin leer} other{{count} sin leer}}'**
  String unreadCount(int count);

  /// No description provided for @rentalPotsExpiresInHours.
  ///
  /// In es, this message translates to:
  /// **'{hours, plural, =1{Vence en 1 hora} other{Vence en {hours} horas}}'**
  String rentalPotsExpiresInHours(int hours);

  /// No description provided for @rentalPotsExpiresInMinutes.
  ///
  /// In es, this message translates to:
  /// **'{minutes, plural, =1{Vence en 1 minuto} other{Vence en {minutes} minutos}}'**
  String rentalPotsExpiresInMinutes(int minutes);

  /// No description provided for @rentalExpiredTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu maceta alquilada venció'**
  String get rentalExpiredTitle;

  /// No description provided for @rentalExpiredOverLimit.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{{names} supera tu tope actual de macetas.} other{{count} plantas superan tu tope actual de macetas: {names}.}}'**
  String rentalExpiredOverLimit(int count, String names);

  /// No description provided for @rentalExpiredNothingHeld.
  ///
  /// In es, this message translates to:
  /// **'Ninguna planta dependía de ella: sigues con {used} de {limit} macetas.'**
  String rentalExpiredNothingHeld(int used, int limit);

  /// No description provided for @rentalExpiredNothingDeleted.
  ///
  /// In es, this message translates to:
  /// **'No se ha borrado ninguna planta. Puedes seguir cuidándolas todas; el tope solo afecta a las nuevas.'**
  String get rentalExpiredNothingDeleted;

  /// No description provided for @rentalExpiredRentAgain.
  ///
  /// In es, this message translates to:
  /// **'Alquilar otra'**
  String get rentalExpiredRentAgain;

  /// No description provided for @continueWithGoogle.
  ///
  /// In es, this message translates to:
  /// **'Continuar con Google'**
  String get continueWithGoogle;

  /// No description provided for @googleSignInFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo entrar con Google. Inténtalo de nuevo.'**
  String get googleSignInFailed;

  /// No description provided for @orSeparator.
  ///
  /// In es, this message translates to:
  /// **'o'**
  String get orSeparator;

  /// No description provided for @helpTitle.
  ///
  /// In es, this message translates to:
  /// **'Ayuda'**
  String get helpTitle;

  /// No description provided for @helpGreeting.
  ///
  /// In es, this message translates to:
  /// **'Hola 👋 Soy la ayuda de ECO2. Toca una pregunta y te respondo al momento.'**
  String get helpGreeting;

  /// No description provided for @helpSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar en la ayuda'**
  String get helpSearchHint;

  /// No description provided for @helpNoResults.
  ///
  /// In es, this message translates to:
  /// **'No encuentro nada con esas palabras. Prueba con otras, o mira las preguntas de abajo.'**
  String get helpNoResults;

  /// No description provided for @helpMoreQuestions.
  ///
  /// In es, this message translates to:
  /// **'¿Algo más?'**
  String get helpMoreQuestions;

  /// No description provided for @helpRelated.
  ///
  /// In es, this message translates to:
  /// **'También suelen preguntar'**
  String get helpRelated;

  /// No description provided for @helpBackToTopics.
  ///
  /// In es, this message translates to:
  /// **'Ver todas las preguntas'**
  String get helpBackToTopics;

  /// No description provided for @helpStillStuck.
  ///
  /// In es, this message translates to:
  /// **'¿No resolví tu duda?'**
  String get helpStillStuck;

  /// No description provided for @helpContact.
  ///
  /// In es, this message translates to:
  /// **'Escríbenos contando qué hacías, qué esperabas y qué pasó en su lugar.'**
  String get helpContact;

  /// No description provided for @helpCatPlants.
  ///
  /// In es, this message translates to:
  /// **'Plantas y escáner'**
  String get helpCatPlants;

  /// No description provided for @helpCatReminders.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios y avisos'**
  String get helpCatReminders;

  /// No description provided for @helpCatPlan.
  ///
  /// In es, this message translates to:
  /// **'Macetas, O₂₊ y tienda'**
  String get helpCatPlan;

  /// No description provided for @helpCatAccount.
  ///
  /// In es, this message translates to:
  /// **'Cuenta y ajustes'**
  String get helpCatAccount;

  /// No description provided for @helpQAddPlant.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo añado una planta?'**
  String get helpQAddPlant;

  /// No description provided for @helpAAddPlant.
  ///
  /// In es, this message translates to:
  /// **'Tienes tres caminos: el botón central de la barra inferior identifica la planta con la cámara; desde Jardín puedes abrir una especie del catálogo y pulsar «Añadir a mi jardín»; y en Mi Jardín tienes el botón «+ Añadir planta». Después puedes ponerle un apodo para distinguirla de otras iguales.'**
  String get helpAAddPlant;

  /// No description provided for @helpQLastWatered.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué me pregunta cuándo regué por última vez?'**
  String get helpQLastWatered;

  /// No description provided for @helpALastWatered.
  ///
  /// In es, this message translates to:
  /// **'Porque de ahí sale el primer recordatorio. Si no lo indicas, el ciclo empieza hoy, y una planta que llevaba días contigo recibiría el aviso de riego demasiado tarde.'**
  String get helpALastWatered;

  /// No description provided for @helpQScanLimit.
  ///
  /// In es, this message translates to:
  /// **'¿Cuántas plantas puedo identificar al día?'**
  String get helpQScanLimit;

  /// No description provided for @helpAScanLimit.
  ///
  /// In es, this message translates to:
  /// **'Cinco al día con el plan gratuito. El contador se reinicia a medianoche con la hora de tu propio teléfono. Con O₂₊ no hay límite.'**
  String get helpAScanLimit;

  /// No description provided for @helpQScanFails.
  ///
  /// In es, this message translates to:
  /// **'El escáner no reconoce mi planta'**
  String get helpQScanFails;

  /// No description provided for @helpAScanFails.
  ///
  /// In es, this message translates to:
  /// **'Prueba con más luz, acércate a una sola hoja y busca un fondo despejado. Si ya gastaste tus cinco identificaciones del día, tendrás que esperar a mañana o pasar a O₂₊.'**
  String get helpAScanFails;

  /// No description provided for @helpQWaterReminder.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo me avisa de regar?'**
  String get helpQWaterReminder;

  /// No description provided for @helpAWaterReminder.
  ///
  /// In es, this message translates to:
  /// **'Cuando la planta llega a su día de riego, según la frecuencia de su especie y el último riego que registraste. El aviso respeta la franja horaria que elijas en Ajustes.'**
  String get helpAWaterReminder;

  /// No description provided for @helpQNoNotifications.
  ///
  /// In es, this message translates to:
  /// **'No me llegan notificaciones'**
  String get helpQNoNotifications;

  /// No description provided for @helpANoNotifications.
  ///
  /// In es, this message translates to:
  /// **'Revisa cuatro cosas: que diste permiso de notificaciones, que están activadas en Ajustes con una franja horaria correcta, que esa planta no tenga los recordatorios silenciados, y que Android no tenga a ECO2 con la batería restringida.'**
  String get helpANoNotifications;

  /// No description provided for @helpQMutePlant.
  ///
  /// In es, this message translates to:
  /// **'¿Puedo silenciar solo una planta?'**
  String get helpQMutePlant;

  /// No description provided for @helpAMutePlant.
  ///
  /// In es, this message translates to:
  /// **'Sí. Abre esa planta y activa «Silenciar recordatorios». Las demás te seguirán avisando con normalidad.'**
  String get helpAMutePlant;

  /// No description provided for @helpQPotLimit.
  ///
  /// In es, this message translates to:
  /// **'¿Cuántas plantas puedo tener?'**
  String get helpQPotLimit;

  /// No description provided for @helpAPotLimit.
  ///
  /// In es, this message translates to:
  /// **'Diez macetas con el plan gratuito. Puedes ampliarlo comprando el pack de 3 macetas o alquilando una por 14 días, y con O₂₊ no hay tope.'**
  String get helpAPotLimit;

  /// No description provided for @helpQO2Plus.
  ///
  /// In es, this message translates to:
  /// **'¿Qué incluye O₂₊?'**
  String get helpQO2Plus;

  /// No description provided for @helpAO2Plus.
  ///
  /// In es, this message translates to:
  /// **'Macetas e identificaciones ilimitadas, la insignia de miembro visible en tu perfil y el código de descuento para viveros asociados.'**
  String get helpAO2Plus;

  /// No description provided for @helpQO2PlusEnds.
  ///
  /// In es, this message translates to:
  /// **'Se me acaba O₂₊, ¿pierdo mis plantas?'**
  String get helpQO2PlusEnds;

  /// No description provided for @helpAO2PlusEnds.
  ///
  /// In es, this message translates to:
  /// **'No. No se borra ninguna planta, nunca. Además conservas de forma permanente hasta 5 macetas por encima del tope gratuito, según las que llegaras a usar: si tenías 18 plantas, te quedas en 15 y no en 10. Puedes seguir cuidándolas todas; lo único que no podrás es añadir más hasta bajar de tu nuevo tope.'**
  String get helpAO2PlusEnds;

  /// No description provided for @helpQRental.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo funciona el alquiler de maceta?'**
  String get helpQRental;

  /// No description provided for @helpARental.
  ///
  /// In es, this message translates to:
  /// **'Te da una maceta extra durante 14 días por 150 semillas. Mientras dure verás un aviso en Mi Jardín con el tiempo que le queda, contado en días y, cuando esté cerca, en horas o minutos. Al vencer no se borra nada: solo baja tu tope.'**
  String get helpARental;

  /// No description provided for @helpQSeeds.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo consigo semillas?'**
  String get helpQSeeds;

  /// No description provided for @helpASeeds.
  ///
  /// In es, this message translates to:
  /// **'Completando misiones, desbloqueando logros y cuidando tus plantas con constancia. Se gastan en la tienda: O₂₊, macetas y avatares.'**
  String get helpASeeds;

  /// No description provided for @helpQAvatars.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo cambio mi avatar?'**
  String get helpQAvatars;

  /// No description provided for @helpAAvatars.
  ///
  /// In es, this message translates to:
  /// **'Desde tu perfil. Hay cuatro avatares gratuitos y cuatro que se compran con semillas. Los que ya tienes aparecen marcados como «Ya lo tienes» y no se pueden comprar dos veces.'**
  String get helpAAvatars;

  /// No description provided for @helpQPayment.
  ///
  /// In es, this message translates to:
  /// **'¿El pago de O₂₊ es real?'**
  String get helpQPayment;

  /// No description provided for @helpAPayment.
  ///
  /// In es, this message translates to:
  /// **'No. En esta versión O₂₊ se adquiere con semillas dentro de la app, y la pantalla de pago es una maqueta de demostración: no procesa cobros ni pide datos de tarjeta verdaderos.'**
  String get helpAPayment;

  /// No description provided for @helpQCo2.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo se calcula mi huella verde?'**
  String get helpQCo2;

  /// No description provided for @helpACo2.
  ///
  /// In es, this message translates to:
  /// **'Con los datos de absorción de cada especie del catálogo y el tiempo que lleva contigo cada planta. No son valores fijos: cambian según lo que tengas plantado.'**
  String get helpACo2;

  /// No description provided for @helpQPassword.
  ///
  /// In es, this message translates to:
  /// **'Olvidé mi contraseña'**
  String get helpQPassword;

  /// No description provided for @helpAPassword.
  ///
  /// In es, this message translates to:
  /// **'En la pantalla de inicio de sesión pulsa «¿Olvidaste tu contraseña?» y escribe tu correo. Recibirás un código de 8 caracteres que se pega en la app junto con la nueva contraseña. Caduca a los 30 minutos.'**
  String get helpAPassword;

  /// No description provided for @helpQGoogle.
  ///
  /// In es, this message translates to:
  /// **'¿Puedo entrar con Google?'**
  String get helpQGoogle;

  /// No description provided for @helpAGoogle.
  ///
  /// In es, this message translates to:
  /// **'Sí. En iniciar sesión y en registrarse tienes «Continuar con Google». Si es la primera vez, la cuenta se crea sola con ese correo; si ya existe, entras en ella.'**
  String get helpAGoogle;

  /// No description provided for @helpQBiometric.
  ///
  /// In es, this message translates to:
  /// **'¿Puedo proteger la app con mi huella?'**
  String get helpQBiometric;

  /// No description provided for @helpABiometric.
  ///
  /// In es, this message translates to:
  /// **'Sí, actívalo en Ajustes. A partir de entonces te pedirá huella o rostro al abrir la app. Ese dato nunca sale del sistema de tu teléfono: la app solo recibe un sí o un no.'**
  String get helpABiometric;

  /// No description provided for @helpQOffline.
  ///
  /// In es, this message translates to:
  /// **'¿Funciona sin conexión?'**
  String get helpQOffline;

  /// No description provided for @helpAOffline.
  ///
  /// In es, this message translates to:
  /// **'No. Tus plantas y tu progreso se guardan en el servidor para que no se pierdan si cambias de teléfono, así que hace falta conexión.'**
  String get helpAOffline;

  /// No description provided for @helpQLanguage.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo cambio el idioma?'**
  String get helpQLanguage;

  /// No description provided for @helpALanguage.
  ///
  /// In es, this message translates to:
  /// **'En Ajustes puedes elegir español o inglés. Por defecto la app sigue el idioma de tu teléfono.'**
  String get helpALanguage;

  /// No description provided for @freePlanLabel.
  ///
  /// In es, this message translates to:
  /// **'Plan gratuito'**
  String get freePlanLabel;

  /// No description provided for @potsUsage.
  ///
  /// In es, this message translates to:
  /// **'{used} de {limit} macetas'**
  String potsUsage(int used, int limit);

  /// No description provided for @scansUsage.
  ///
  /// In es, this message translates to:
  /// **'{used} de {limit} escaneos hoy'**
  String scansUsage(int used, int limit);

  /// No description provided for @unlimited.
  ///
  /// In es, this message translates to:
  /// **'Ilimitado'**
  String get unlimited;

  /// No description provided for @activatePlus.
  ///
  /// In es, this message translates to:
  /// **'Activar O₂₊'**
  String get activatePlus;

  /// No description provided for @plusActivated.
  ///
  /// In es, this message translates to:
  /// **'¡O₂₊ activado! Macetas y escaneos ilimitados.'**
  String get plusActivated;

  /// No description provided for @cancelPlus.
  ///
  /// In es, this message translates to:
  /// **'Cancelar O₂₊'**
  String get cancelPlus;

  /// No description provided for @plusCancelled.
  ///
  /// In es, this message translates to:
  /// **'Has vuelto al plan gratuito.'**
  String get plusCancelled;

  /// No description provided for @simulatedPayment.
  ///
  /// In es, this message translates to:
  /// **'Pago simulado: esta app es un trabajo universitario y no realiza ningún cobro.'**
  String get simulatedPayment;

  /// No description provided for @nurseryDiscount.
  ///
  /// In es, this message translates to:
  /// **'Descuento en viveros'**
  String get nurseryDiscount;

  /// No description provided for @nurseryDiscountIntro.
  ///
  /// In es, this message translates to:
  /// **'Muestra este código en los viveros asociados para aplicar tu descuento.'**
  String get nurseryDiscountIntro;

  /// No description provided for @yourCode.
  ///
  /// In es, this message translates to:
  /// **'Tu código'**
  String get yourCode;

  /// No description provided for @codeCopied.
  ///
  /// In es, this message translates to:
  /// **'Código copiado'**
  String get codeCopied;

  /// No description provided for @plusOnlyFeature.
  ///
  /// In es, this message translates to:
  /// **'Disponible con O₂₊'**
  String get plusOnlyFeature;

  /// No description provided for @copyCode.
  ///
  /// In es, this message translates to:
  /// **'Copiar código'**
  String get copyCode;

  /// No description provided for @plusUnlimitedSummary.
  ///
  /// In es, this message translates to:
  /// **'Macetas y escaneos ilimitados'**
  String get plusUnlimitedSummary;

  /// No description provided for @manage.
  ///
  /// In es, this message translates to:
  /// **'Gestionar'**
  String get manage;

  /// No description provided for @chooseAvatar.
  ///
  /// In es, this message translates to:
  /// **'Elige tu avatar'**
  String get chooseAvatar;

  /// No description provided for @avatarUpdated.
  ///
  /// In es, this message translates to:
  /// **'Avatar actualizado'**
  String get avatarUpdated;

  /// No description provided for @noAvatar.
  ///
  /// In es, this message translates to:
  /// **'Sin avatar'**
  String get noAvatar;

  /// No description provided for @avatarAgronomist.
  ///
  /// In es, this message translates to:
  /// **'Agrónoma'**
  String get avatarAgronomist;

  /// No description provided for @avatarFarmer.
  ///
  /// In es, this message translates to:
  /// **'Granjero'**
  String get avatarFarmer;

  /// No description provided for @avatarGardener.
  ///
  /// In es, this message translates to:
  /// **'Jardinera'**
  String get avatarGardener;

  /// No description provided for @avatarTechnologist.
  ///
  /// In es, this message translates to:
  /// **'Tecnólogo'**
  String get avatarTechnologist;

  /// No description provided for @avatarBreeder.
  ///
  /// In es, this message translates to:
  /// **'Criadora'**
  String get avatarBreeder;

  /// No description provided for @avatarExplorer.
  ///
  /// In es, this message translates to:
  /// **'Explorador'**
  String get avatarExplorer;

  /// No description provided for @avatarScientist.
  ///
  /// In es, this message translates to:
  /// **'Científico'**
  String get avatarScientist;

  /// No description provided for @avatarFlorist.
  ///
  /// In es, this message translates to:
  /// **'Floricultora'**
  String get avatarFlorist;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
