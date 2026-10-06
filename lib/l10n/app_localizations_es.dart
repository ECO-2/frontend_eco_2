// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTagline => 'Cuidado de plantas con IA';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get signInAction => 'Iniciar sesión';

  @override
  String get welcomeBack => 'Bienvenido de vuelta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailHint => 'correo@ejemplo.com';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordMinChars => 'min. 8 caracteres';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get confirmPassword => 'Confirma contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get register => 'Registrarse';

  @override
  String get noAccountYet => '¿No tienes cuenta? ';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get enterYourEmail => 'Por favor ingresa tu correo';

  @override
  String get enterYourPassword => 'Por favor ingresa tu contraseña';

  @override
  String get termsNotice =>
      'Al registrarte aceptas los Términos de Uso y la Política de Privacidad de ECO2.';

  @override
  String get navStore => 'Tienda';

  @override
  String get navGarden => 'Jardín';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navScanner => 'Escáner';

  @override
  String get navProfile => 'Perfil';

  @override
  String get myGarden => 'Mi Jardín';

  @override
  String get viewAll => 'ver todas';

  @override
  String get addPlant => 'Añadir Planta';

  @override
  String get gardenEmpty => 'Tu jardín está vacío';

  @override
  String get needsWater => 'Riego';

  @override
  String get upToDate => 'Al día';

  @override
  String get noWateringYet => 'Sin riego aún';

  @override
  String get wateringToday => 'Riego hoy';

  @override
  String get wateringOverdue => 'Riego vencido';

  @override
  String get daysWithoutWater => 'días sin riego';

  @override
  String get daysInYourGarden => 'días en tu jardín';

  @override
  String get frequency => 'frecuencia';

  @override
  String get remaining => 'restantes';

  @override
  String get overdue => 'vencido';

  @override
  String get careStatus => 'Estado de cuidado';

  @override
  String get urgentWatering => 'Riego Urgente';

  @override
  String get deletePlantTitle => '¿Eliminar planta?';

  @override
  String deletePlantBody(String plantName) {
    return 'Se eliminará \"$plantName\" de tu jardín. Esta acción no se puede deshacer.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String lastWateredQuestion(String plantName) {
    return '¿Cuándo regaste $plantName por última vez?';
  }

  @override
  String get lastWateredHelp =>
      'Así calculamos cuándo toca el próximo riego. Si no lo sabes, empezamos a contar desde hoy.';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get someDaysAgo => 'Hace unos días…';

  @override
  String get neverOrDontRemember => 'Nunca / no lo recuerdo';

  @override
  String get lastWatering => 'Último riego';

  @override
  String get settings => 'Ajustes';

  @override
  String get account => 'CUENTA';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get editProfileSubtitle => 'Nombre de usuario';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get biometricAuth => 'Autenticación biométrica';

  @override
  String get notifications => 'NOTIFICACIONES';

  @override
  String get pushNotifications => 'Notificaciones push';

  @override
  String get wateringReminders => 'Recordatorios de riego';

  @override
  String get achievementsAndMissions => 'Logros y misiones';

  @override
  String get preferences => 'PREFERENCIAS';

  @override
  String get systemLanguage => 'Idioma del sistema';

  @override
  String get language => 'Idioma';

  @override
  String get themeAndColors => 'Tema y colores';

  @override
  String get privacyAndData => 'PRIVACIDAD Y DATOS';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacySubtitle => 'Qué datos guarda ECO2';

  @override
  String get exportMyData => 'Exportar mis datos';

  @override
  String get application => 'APLICACIÓN';

  @override
  String get helpAndSupport => 'Ayuda y soporte';

  @override
  String get aboutEco2 => 'Sobre ECO2';

  @override
  String get dangerZone => 'ZONA DE RIESGO';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountSubtitle => 'Esta acción es permanente';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String get profile => 'Perfil';

  @override
  String get plants => 'Plantas';

  @override
  String get seeds => 'Semillas';

  @override
  String get co2Total => 'CO₂ total';

  @override
  String levelLabel(int level) {
    return 'Nivel $level';
  }

  @override
  String levelWithName(int level, String name) {
    return 'Nivel $level · $name';
  }

  @override
  String get myTrophies => 'Mis Trofeos';

  @override
  String get trophies => 'Trofeos';

  @override
  String get missions => 'Misiones';

  @override
  String get achievements => 'Logros';

  @override
  String get obtained => 'Obtenidos';

  @override
  String get available => 'Disponibles';

  @override
  String get completedPercent => 'Completado';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días seguidos',
      one: '1 día seguido',
    );
    return '$_temp0';
  }

  @override
  String xpPoints(int xp) {
    return '$xp XP';
  }

  @override
  String seedsCount(int count) {
    return '$count semillas';
  }

  @override
  String get greenFootprint => 'Mi Huella Verde';

  @override
  String get co2AbsorbedToday => 'CO₂ absorbido hoy';

  @override
  String get gramsPerDay => 'gramos / día';

  @override
  String get contributionPerPlant => 'Aporte por planta';

  @override
  String get weeklyEvolution => 'Evolución semanal';

  @override
  String get weeklyEvolutionHelp =>
      'Refleja cuándo entró cada planta a tu jardín.';

  @override
  String get copyMyFootprint => 'Copiar mi huella verde';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String accumulated(String kg) {
    return 'Acumulado: $kg kg';
  }

  @override
  String get noPlantsYet => 'Aún no tienes plantas en tu jardín';

  @override
  String get footprintError => 'No pudimos calcular tu huella verde.';

  @override
  String get retry => 'Reintentar';

  @override
  String get scannerPointAtPlant => 'Apunta a una planta';

  @override
  String get scannerAnalyzing => 'Analizando...';

  @override
  String get scannerNotInCatalog =>
      'La reconocimos, pero todavía no está en el catálogo de ECO2 — no podemos añadirla a tu jardín todavía.';

  @override
  String get scannerLowConfidence =>
      'No pudimos reconocerla con suficiente confianza. Prueba con más luz o de más cerca.';

  @override
  String get connectionError => 'Error de conexión. Verifica tu internet.';

  @override
  String get wrongCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get emailAlreadyUsed => 'Este correo ya tiene una cuenta registrada.';

  @override
  String get save => 'Guardar';

  @override
  String get close => 'Cerrar';

  @override
  String get greeting => 'Namasté';

  @override
  String get yourSeeds => 'Tus semillas';

  @override
  String get activeMission => 'Misión Activa';

  @override
  String get searchSpecies => 'Buscar especie...';

  @override
  String get searchMyPlant => 'Buscar mi planta...';

  @override
  String get exploreSpecies => 'Explorar especies';

  @override
  String get trendingThisWeek => 'Tendencias esta semana';

  @override
  String get allCategory => 'Todas';

  @override
  String plantsCount(int count) {
    return '$count plantas';
  }

  @override
  String needsAttentionToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plantas necesitan atención hoy',
      one: '1 planta necesita atención hoy',
    );
    return '$_temp0';
  }

  @override
  String get view => 'Ver';

  @override
  String get add => 'Añadir';

  @override
  String get allUpToDate => '¡Todo al día!';

  @override
  String get wateringStatus => 'Estado de riego';

  @override
  String get logEveryCare => 'Registra cada cuidado';

  @override
  String get viewHistory => 'Ver historial';

  @override
  String get latestCare => 'Últimos cuidados';

  @override
  String get careType => 'Tipo de cuidado';

  @override
  String get suggestedNextWatering => 'Próximo riego sugerido';

  @override
  String get inMyCollectionSince => 'En mi colección desde';

  @override
  String get howToCareTitle => 'Cómo cuidar tu planta';

  @override
  String everyNDays(int days) {
    return 'Cada $days días';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String get noCareLogged => 'Aún no has registrado cuidados.';

  @override
  String get scannerHint => 'Apunta a una planta';

  @override
  String get analyzing => 'Analizando...';

  @override
  String get notIdentified => 'No identificada con certeza';

  @override
  String potsRemaining(int count) {
    return 'Macetas restantes: $count';
  }

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get markedAsRead => 'Marcada como leída';

  @override
  String get markAllRead => 'Marcar todas como leídas';

  @override
  String get todayLabel => 'HOY';

  @override
  String get thatsAllForNow => 'Eso es todo por ahora';

  @override
  String get noNotifications => 'No tienes notificaciones';

  @override
  String get wateringPending => 'Riego pendiente';

  @override
  String achievementUnlocked(String title) {
    return '¡Logro desbloqueado!: $title';
  }

  @override
  String newPlantAdded(String name) {
    return 'Nueva planta agregada: Agregaste $name a tu colección.';
  }

  @override
  String get seedbed => 'Semillero';

  @override
  String get redeemSeeds => 'Canjea tus semillas por recompensas';

  @override
  String get search => 'Buscar...';

  @override
  String get communityFavorites => 'Los favoritos de la comunidad';

  @override
  String get newBadge => 'Nuevo';

  @override
  String get yourImpactEquals => 'Tu impacto equivale a:';

  @override
  String treesEquivalent(int count) {
    return '$count Árboles';
  }

  @override
  String kilometersEquivalent(int count) {
    return '$count Kilómetros';
  }

  @override
  String levelAndTrophies(int level, int trophies) {
    return 'Nivel $level · $trophies trofeos';
  }

  @override
  String get noAchievementsYet => 'No has completado logros todavía.';

  @override
  String get allAchievementsDone =>
      '¡Completaste todos los logros disponibles!';

  @override
  String get noAchievementsConfigured => 'Todavía no hay logros configurados.';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get reward => 'Recompensa';

  @override
  String get achievementUnlockedLabel => 'Logro desbloqueado';

  @override
  String get achievementLockedLabel => 'Logro bloqueado';

  @override
  String get activeMissions => 'Misiones activas';

  @override
  String get plantCatalog => 'Catálogo de plantas';

  @override
  String get seedStore => 'Tienda de Semillas';

  @override
  String get freePlanActive => 'Plan gratuito activo';

  @override
  String get user => 'Usuario';

  @override
  String get loading => 'Cargando...';

  @override
  String get genericError => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get catTropical => 'Tropical';

  @override
  String get catSucculent => 'Suculenta';

  @override
  String get catCactus => 'Cactus';

  @override
  String get catFern => 'Helecho';

  @override
  String get catFlowering => 'Con flores';

  @override
  String get catHerb => 'Aromática';

  @override
  String get catTree => 'Árbol';

  @override
  String get catOther => 'Planta';

  @override
  String get lightLow => 'Baja';

  @override
  String get lightMedium => 'Media';

  @override
  String get lightHigh => 'Alta';

  @override
  String get lightIndirect => 'Indirecta';

  @override
  String lightPrefix(String level) {
    return 'Luz $level';
  }

  @override
  String get difficultyVeryEasy => 'Muy fácil';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Media';

  @override
  String wateringEveryDays(int days) {
    return 'Riego c/${days}d';
  }

  @override
  String get humidityLow => 'Baja';

  @override
  String get humidityMedium => 'Media';

  @override
  String get humidityHigh => 'Alta';

  @override
  String impactCarTitle(String km) {
    return '$km km en coche';
  }

  @override
  String get impactCarSubtitle =>
      'Que no haría falta conducir para emitir ese CO₂.';

  @override
  String impactBulbTitle(String hours) {
    return '$hours h de bombilla LED';
  }

  @override
  String get impactBulbSubtitle => 'De consumo eléctrico equivalente.';

  @override
  String impactTreeTitle(String days) {
    return '$days días de un árbol';
  }

  @override
  String get impactTreeSubtitle =>
      'Lo que tarda un árbol adulto en absorber lo mismo.';

  @override
  String get impactApproxNote =>
      'Equivalencias aproximadas, calculadas a partir del CO₂ de tu jardín.';

  @override
  String get impactTooSmall =>
      'Tu jardín aún no acumula CO₂ suficiente para una equivalencia útil.';

  @override
  String accumulatedGrams(String grams) {
    return 'Acumulado: $grams g';
  }

  @override
  String get category => 'Categoría';

  @override
  String get gallery => 'Galería';

  @override
  String get chooseFromGallery => 'Elegir de la galería';

  @override
  String get cameraPermissionError =>
      'No se pudo acceder a la cámara o galería. Revisa los permisos de la app.';

  @override
  String get flashAutoHint =>
      'El flash se activará de forma automática solo al realizar la captura.';

  @override
  String get showThisGuide => 'Muestra esta guía.';

  @override
  String get upcomingAchievements => 'Próximos logros';

  @override
  String get closest => '• MÁS CERCANO';

  @override
  String get paymentMethod => 'Método de pago';

  @override
  String get quickPay => 'Pago rápido';

  @override
  String get oneYearPlus => '1 año de ECO2 Plus';

  @override
  String get whatToDoNow => 'Qué hacer ahora';

  @override
  String get uploadFromGallery => 'Subir de Galería';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Mié';

  @override
  String get dayThu => 'Jue';

  @override
  String get dayFri => 'Vie';

  @override
  String get daySat => 'Sáb';

  @override
  String get daySun => 'Dom';

  @override
  String careEveryNDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cada $count días',
      one: 'Cada día',
    );
    return '$_temp0';
  }

  @override
  String timeAgoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace 1 día',
      zero: 'Hoy',
    );
    return '$_temp0';
  }

  @override
  String achievementUnlockedNamed(String name) {
    return '¡Logro desbloqueado!: $name';
  }

  @override
  String purchaseSuccess(String item) {
    return '¡Compra exitosa!: $item';
  }

  @override
  String plantAddedToGarden(String name) {
    return '¡$name añadida a tu jardín! 🌿';
  }

  @override
  String get couldNotAddPlant => 'No se pudo agregar la planta.';

  @override
  String get addNewPlant => 'Añadir nueva planta';

  @override
  String get yourPlantName => 'Nombre de tu planta';

  @override
  String gramsPerDayShort(String grams) {
    return '$grams g/día';
  }

  @override
  String get difficultyAll => 'Todas';

  @override
  String get lightHintLow => 'Rincones con poca luz';

  @override
  String get lightHintHigh => 'Cerca de la ventana';

  @override
  String get lightHintIndirect => 'Sin sol directo';

  @override
  String get lightHintDefault => 'Luz filtrada';

  @override
  String get filterByCategory => 'Filtrar por categoría';

  @override
  String get speciesNotFound => 'Especie no encontrada';

  @override
  String get forgotPasswordTitle => 'Recuperar contraseña';

  @override
  String get forgotPasswordBody =>
      'Escribe tu correo y te enviaremos un código para restablecer la contraseña.';

  @override
  String get forgotPasswordSent =>
      'Si existe una cuenta con ese correo, te hemos enviado un código.';

  @override
  String get send => 'Enviar';

  @override
  String get emailRequired => 'Escribe tu correo primero';

  @override
  String get resetPasswordTitle => 'Restablecer contraseña';

  @override
  String get resetPasswordIntro =>
      'Pega aquí el código que te enviamos por correo y elige tu nueva contraseña.';

  @override
  String get resetCodeLabel => 'Código de recuperación';

  @override
  String get resetCodeHint => 'ABCD-2345';

  @override
  String get resetCodeRequired => 'Escribe el código que recibiste';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get resetPasswordSubmit => 'Cambiar contraseña';

  @override
  String get resetPasswordSuccess =>
      'Contraseña actualizada. Ya puedes iniciar sesión.';

  @override
  String get resetCodeExpiredHint =>
      'El código vence a los 30 minutos. Pide uno nuevo si ya caducó.';

  @override
  String get changePasswordIntro =>
      'Escribe tu contraseña actual y elige una nueva.';

  @override
  String get changePasswordSubmit => 'Guardar contraseña';

  @override
  String get changePasswordSuccess => 'Contraseña actualizada.';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get currentPasswordRequired => 'Escribe tu contraseña actual';

  @override
  String get passwordMustDiffer =>
      'La nueva contraseña debe ser distinta de la actual';

  @override
  String get biometricLock => 'Bloqueo con huella';

  @override
  String get biometricLockSubtitle => 'Pide tu huella al abrir la app';

  @override
  String get biometricUnavailable =>
      'Este dispositivo no tiene huella registrada';

  @override
  String get biometricPromptReason => 'Confirma tu identidad para abrir ECO2';

  @override
  String get biometricEnabled => 'Bloqueo con huella activado';

  @override
  String get biometricDisabled => 'Bloqueo con huella desactivado';

  @override
  String get appLockTitle => 'ECO2 está bloqueado';

  @override
  String get appLockSubtitle => 'Usa tu huella para continuar.';

  @override
  String get appLockFailed => 'No se pudo confirmar tu identidad.';

  @override
  String get appLockRetry => 'Reintentar';

  @override
  String get appLockSignOut => 'Cerrar sesión';

  @override
  String get managePlus => 'Gestionar ECO2 Plus';

  @override
  String get managePlusFree => 'Plan gratuito activo';

  @override
  String get pushNotificationsSubtitle => 'Avisos de riego y logros';

  @override
  String get reminderWindow => 'Horario de recordatorios';

  @override
  String reminderWindowValue(int start, int end) {
    return 'De $start:00 a $end:00';
  }

  @override
  String get reminderWindowSheetTitle => '¿Cuándo quieres los avisos?';

  @override
  String get reminderWindowIntro =>
      'Los recordatorios solo se envían dentro de esta franja.';

  @override
  String get reminderStart => 'Desde';

  @override
  String get reminderEnd => 'Hasta';

  @override
  String get reminderWindowInvalid =>
      'La hora de inicio debe ser anterior a la de fin';

  @override
  String get reminderWindowSaved => 'Horario de recordatorios actualizado';

  @override
  String get privacySheetTitle => 'Tus datos en ECO2';

  @override
  String get privacySheetBody =>
      'ECO2 guarda tu correo, tu nombre de usuario, las plantas de tu jardín y su historial de cuidados. Las fotos que tomas se guardan solo en este dispositivo. Puedes exportar todo o borrar la cuenta cuando quieras.';

  @override
  String get exportDataSubtitle => 'Copia un resumen al portapapeles';

  @override
  String get exportDataCopied => 'Datos copiados al portapapeles';

  @override
  String get exportDataFailed => 'No se pudieron reunir tus datos';

  @override
  String get helpSupportSubtitle => 'Escríbenos si algo falla';

  @override
  String get helpSheetTitle => '¿Necesitas ayuda?';

  @override
  String get helpSheetBody =>
      'Escríbenos contando qué ocurrió y desde qué pantalla. Copia el correo y mándanos un mensaje.';

  @override
  String get copyEmail => 'Copiar correo';

  @override
  String get emailCopied => 'Correo copiado';

  @override
  String appVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get aboutSheetBody =>
      'ECO2 te ayuda a cuidar tus plantas y a ver cuánto CO₂ absorben.';

  @override
  String get deleteAccountTitle => '¿Eliminar tu cuenta?';

  @override
  String get deleteAccountBody =>
      'Se borrarán tu perfil, tus plantas y todo su historial de cuidados. No se puede deshacer.';

  @override
  String get deleteAccountConfirmHint => 'Escribe ELIMINAR para confirmar';

  @override
  String get deleteAccountConfirmWord => 'ELIMINAR';

  @override
  String get deleteAccountSuccess => 'Tu cuenta ha sido eliminada.';

  @override
  String get usernameTaken => 'Ese nombre de usuario ya está en uso.';

  @override
  String get currentPasswordWrong => 'La contraseña actual no es correcta.';

  @override
  String get profileUpdateFailed =>
      'No se pudo actualizar el perfil. Inténtalo nuevamente.';

  @override
  String get plantsLoadFailed => 'No se pudieron cargar tus plantas.';

  @override
  String get plantAddFailed => 'No se pudo añadir la planta.';

  @override
  String get plantDeleteFailed => 'No se pudo eliminar la planta.';

  @override
  String get nicknameEmpty => 'El apodo no puede estar vacío.';

  @override
  String get nicknameUpdateFailed => 'No se pudo actualizar el apodo.';

  @override
  String get missionsLoadFailed => 'No se pudieron cargar las misiones.';

  @override
  String get careLogFailed => 'No se pudo registrar el cuidado.';

  @override
  String get nicknameUpdated => 'Apodo actualizado.';

  @override
  String get noSpeciesMatchFilters =>
      'No se encontraron especies con estos filtros';

  @override
  String get noPlantsInCategory =>
      'No tienes plantas en esta categoría todavía';

  @override
  String daysOverdueLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días de retraso',
      one: '1 día de retraso',
    );
    return '$_temp0';
  }

  @override
  String noWateringLoggedEvery(int days) {
    return 'Sin riego registrado · c/${days}d';
  }

  @override
  String daysWithoutWaterEvery(int days, int freq) {
    return '${days}d sin riego · c/${freq}d';
  }

  @override
  String get identifyConnectionError =>
      'No se pudo conectar para identificar la planta. Verifica tu conexión e inténtalo de nuevo.';

  @override
  String get plantAlreadyRegistered => 'Planta ya registrada';

  @override
  String get plantAlreadyRegisteredBody =>
      'Ya tienes esta planta registrada en tu jardín. Te sugerimos ponerle un apodo (diferenciador) para no confundirla.';

  @override
  String get addThisPlantQuestion => '¿Desea añadir esta planta a su jardín?';

  @override
  String get addThisPlantBody => 'Se añadirá a tu colección de plantas.';

  @override
  String get redeemMore => 'Canjear más';

  @override
  String get plantAddedSuccess => 'Planta añadida con éxito';

  @override
  String get historyLoadFailed => 'No se pudo cargar el historial.';

  @override
  String get noScansYet => 'Todavía no has escaneado ninguna planta.';

  @override
  String get toMyGarden => 'A mi jardín';

  @override
  String get aiNotAvailable =>
      'La identificación por IA todavía no está disponible en esta versión.';

  @override
  String get uncommonPlantEscalating =>
      'Planta poco común, haciendo búsqueda profunda...';

  @override
  String get scanLimitReached =>
      'Ya usaste tus 5 escaneos de hoy. Con O₂₊ son ilimitados.';

  @override
  String get tourGalleryDescription =>
      'Sube una foto de tu galería para analizar.';

  @override
  String get shutter => 'Obturador';

  @override
  String get tourShutterDescription =>
      'Presiona aquí para escanear una planta y continuar.';

  @override
  String get enterUsername => 'Por favor ingresa tu nombre de usuario';

  @override
  String get usernameTooShort =>
      'El nombre de usuario debe tener al menos 3 caracteres';

  @override
  String get enterValidEmail => 'Por favor ingresa un correo válido';

  @override
  String get confirmYourPassword => 'Por favor confirma tu contraseña';

  @override
  String estimatedValueNote(int measured, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      measured,
      locale: localeName,
      other:
          'Valor estimado: $measured de $total plantas se apoyan en una medición publicada.',
    );
    return '$_temp0';
  }

  @override
  String get footprintShareEmpty =>
      'Todavía no tengo plantas en mi jardín ECO2.';

  @override
  String footprintShareSummary(int plants, String perDay, String total) {
    return 'Mi jardín ECO2: $plants plantas y $perDay g de CO₂ al día ($total g acumulados).';
  }

  @override
  String get addPlantsToSeeContribution =>
      'Añade plantas a tu jardín para ver cuánto aporta cada una.';

  @override
  String get storeBestsellers => 'Más vendidos';

  @override
  String get storeAvatars => 'Avatares';

  @override
  String get storePots => 'Macetas';

  @override
  String get storeO2Plus2wTitle => 'Cosecha tu jardín pro';

  @override
  String get storeO2Plus2wSubtitle => '2 semanas de O2 Plus';

  @override
  String get storePotRentalTitle => 'Alquila una maceta';

  @override
  String get storePotRentalSubtitle => 'Espacio temporal · 2 semanas';

  @override
  String get storeAvatarExplorerTitle => 'Avatar Explorador Verde';

  @override
  String get storeAvatarGuardianTitle => 'Avatar Guardián del Bosque';

  @override
  String get storePermanentUnlock => 'Desbloqueo permanente';

  @override
  String get storePotPack3Title => 'Pack de 3 macetas';

  @override
  String get storePotPack3Subtitle => '+3 espacios permanentes';

  @override
  String get storeO2Plus4wTitle => 'O2 Plus mensual';

  @override
  String get storeO2Plus4wSubtitle => '4 semanas de O2 Plus';

  @override
  String get newBadgeLabel => 'Nuevo';

  @override
  String get noItemsFound => 'No se encontraron artículos';

  @override
  String get confirmPurchaseTitle => '¿Confirmar compra?';

  @override
  String confirmPurchaseBody(String item, int cost) {
    return '¿Deseas canjear \"$item\" por $cost semillas?';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String get purchaseFailed => 'No se pudo completar la compra.';

  @override
  String get boostGardenPremium => 'Impulsa tu jardín con beneficios premium';

  @override
  String get moreSpaceForPlants => 'Consigue más espacio para tus plantas';

  @override
  String get customizeYourProfile => 'Personaliza tu perfil';

  @override
  String speciesDescription(
    String category,
    String light,
    String humidity,
    int days,
    int minTemp,
    int maxTemp,
  ) {
    return 'Especie $category que prefiere luz $light y humedad $humidity. Riega aproximadamente cada $days días, dejando secar el sustrato entre riegos, y se adapta bien a temperaturas entre $minTemp°C y $maxTemp°C.';
  }

  @override
  String get purifierExcellent => 'Es una excelente purificadora de aire.';

  @override
  String get purifierGood => 'Ayuda a mejorar la calidad del aire de tu hogar.';

  @override
  String get humidityRangeLow => '30-40%';

  @override
  String get humidityRangeMedium => '40-60%';

  @override
  String get humidityRangeHigh => '60-80%';

  @override
  String get airPurification => 'Purificación de aire';

  @override
  String get purificationLevel => 'Nivel de purificación';

  @override
  String get idealRequirements => 'Requisitos ideales para esta especie';

  @override
  String everyNDaysShort(int days) {
    return 'c/$days días';
  }

  @override
  String absorbsPerDay(String grams) {
    return 'Absorbe ~${grams}g de CO₂/día';
  }

  @override
  String get addToMyGarden => 'Añadir a mi jardín';

  @override
  String gramsPerDayValue(String grams) {
    return '$grams g/día';
  }

  @override
  String get noNotesYet => 'Aún no has agregado notas para esta planta.';

  @override
  String get airPurifierTag => 'Aire purificador';

  @override
  String humidityWithPrefix(String level) {
    return 'Humedad $level';
  }

  @override
  String get watering => 'Riego';

  @override
  String get lightLabelShort => 'Luz';

  @override
  String get temperature => 'Temperatura';

  @override
  String get humidityLabelShort => 'Humedad';

  @override
  String get whenSoilDry => 'Cuando la tierra esté seca';

  @override
  String get redeemSeedsOrSubscribe => 'Canjea tus semillas o suscríbete a O₂₊';

  @override
  String get viewMyAchievements => 'Ver mis logros y misiones';

  @override
  String get exploreBotanicalSpecies => 'Ver especies';

  @override
  String get appTour => 'Recorrido de la app';

  @override
  String get appTourSubtitle => 'Ver de nuevo';

  @override
  String get rewardDiscountTitle => 'Dto. 15% Vivero El Helecho';

  @override
  String get rewardDiscountDesc => 'Cupón aplicable a tu próxima compra.';

  @override
  String get rewardBadgeTitle => 'Insignia \"Guardián de la Tierra\"';

  @override
  String get rewardBadgeDesc => 'Muestra tu compromiso en tu perfil.';

  @override
  String get rewardPotsTitle => 'Macetas personalizadas (3D)';

  @override
  String get rewardPotsDesc => 'Desbloquea diseños interactivos.';

  @override
  String get redeemRewardTitle => '¿Canjear premio?';

  @override
  String redeemRewardBody(String reward, int cost) {
    return '¿Seguro que quieres canjear \"$reward\" por $cost semillas?';
  }

  @override
  String redeemSuccess(String reward) {
    return '¡Canje exitoso!: $reward 🎁';
  }

  @override
  String get tourWateringStatusDesc =>
      'Aquí ves si ya toca regarla, cuántos días lleva sin riego y cuántos días faltan (o cuántos de retraso lleva) según la frecuencia de la especie.';

  @override
  String get tourLogCareDesc =>
      'Cada vez que la riegues, fertilices, podes o trasplantes, regístralo aquí — así el estado de riego y tu historial quedan al día de verdad.';

  @override
  String get speciesCare => 'Cuidados de la especie';

  @override
  String get speciesSpecSheet => 'Ficha técnica de la especie';

  @override
  String get tourSpeciesGridDesc =>
      'Riego, luz, temperatura y humedad ideales para esta especie en particular.';

  @override
  String get howToCareForThisPlant => 'Cómo cuidar esta planta';

  @override
  String get plantNicknameHint => 'Apodo de la planta';

  @override
  String get howToCareForYourPlant => 'Cómo cuidar tu planta';

  @override
  String get careCalendar => 'Calendario de cuidados';

  @override
  String get tourCareCalendarDesc =>
      'La frecuencia de riego es real, según la especie. Fertilización, poda y trasplante son buenas prácticas generales — la app aún no calcula una frecuencia exacta para esas.';

  @override
  String get whenToDoEachCare => '¿Cuándo hacer cada cuidado?';

  @override
  String get scheduleFertilizing => 'Cada 4-6 semanas, en primavera y verano';

  @override
  String get schedulePruning =>
      'Retira hojas secas, amarillas o dañadas en cuanto las notes';

  @override
  String get scheduleRepotting =>
      'Cada 1-2 años, o cuando las raíces llenen la maceta';

  @override
  String get tourStoreDesc =>
      'Canjea tus semillas por macetas extra y funciones especiales.';

  @override
  String get yourGarden => 'Tu Jardín';

  @override
  String get tourGardenDesc =>
      'Explora el catálogo de especies o gestiona las plantas que ya tienes.';

  @override
  String get aiScanner => 'Escáner IA';

  @override
  String get tourScannerDesc =>
      'Identifica una planta apuntando la cámara — la IA reconoce la especie.';

  @override
  String get yourProfile => 'Tu Perfil';

  @override
  String get tourProfileDesc =>
      'Revisa tu progreso, ajustes de la cuenta y más.';

  @override
  String get premiumTitle => 'Potencia tu jardín';

  @override
  String get premiumSubtitle =>
      'Desbloquea el potencial completo de ECO2 y lleva tu experiencia botánica al siguiente nivel.';

  @override
  String get premiumIncludes => 'Todo lo que incluye';

  @override
  String get premiumUnlimitedPots => 'Macetas ilimitadas';

  @override
  String get premiumUnlimitedPotsDesc =>
      'Añade todas las plantas que quieras sin límites.';

  @override
  String get premiumBetterSearch => 'Búsqueda mejorada por descripción';

  @override
  String get premiumBetterSearchDesc =>
      'Encuentra plantas describiendo su aspecto con IA.';

  @override
  String get premiumUnlimitedScans => 'Escaneos ilimitados';

  @override
  String get premiumUnlimitedScansDesc =>
      'Identifica cualquier planta, cuando quieras.';

  @override
  String get premiumAiTreatment => 'Tratamiento asistido con IA';

  @override
  String get premiumAiTreatmentDesc =>
      'Diagnóstico personalizado de plagas y cuidados.';

  @override
  String get premiumNurseryDiscounts => 'Descuentos en viveros aliados';

  @override
  String get premiumNurseryDiscountsDesc =>
      'Hasta 20% off en especies de aliados selectos.';

  @override
  String get noCompletedAchievements => 'No hay logros completados aún';

  @override
  String get noLockedAchievements => 'No hay logros bloqueados por ahora';

  @override
  String get lockedAchievementsNote =>
      'Estos logros dependen de funciones que todavía no están disponibles en la app.';

  @override
  String get plantIdentification => 'Identificación de plantas';

  @override
  String get scannerTabHint =>
      'Apunta con la cámara a la planta o sube una foto de tu galería.';

  @override
  String get recentAnalyses => 'Análisis recientes';

  @override
  String get careTypeWatering => 'Riego';

  @override
  String get careTypeFertilizing => 'Fertilización';

  @override
  String get careTypePruning => 'Poda';

  @override
  String get careTypeRepotting => 'Trasplante';

  @override
  String careLoggedToast(String type) {
    return 'Cuidado registrado: $type 🌿';
  }

  @override
  String get inOneDay => 'en 1 día';

  @override
  String daysAgoShort(int count) {
    return 'hace $count días';
  }

  @override
  String inNDays(int count) {
    return 'en $count días';
  }

  @override
  String get noCareLoggedForPlant =>
      'Aún no has registrado cuidados para esta planta.';

  @override
  String get noEventsForFilter => 'No hay eventos para este filtro.';

  @override
  String get featureComingSoon =>
      'Esta función estará disponible próximamente.';

  @override
  String get thisPlant => 'esta planta';

  @override
  String get careTypeGeneric => 'Cuidado';

  @override
  String get changePhotoComingSoon =>
      'Cambiar la foto de perfil estará disponible próximamente 📸';

  @override
  String get changeProfilePhoto => 'Cambiar foto de perfil';

  @override
  String get personalInformation => 'Información personal';

  @override
  String get pickSpeciesToContinue =>
      'Elige una especie de la lista para continuar.';

  @override
  String get nameYourPlantToContinue =>
      'Ponle un nombre a tu planta para continuar.';

  @override
  String get noSpeciesAvailable => 'No hay especies disponibles todavía.';

  @override
  String noSpeciesFoundFor(String query) {
    return 'No se encontraron especies para \"$query\".';
  }

  @override
  String get tellUsAboutYou => 'Cuéntanos sobre ti';

  @override
  String get usernameRequired => 'El nombre de usuario es obligatorio';

  @override
  String get minThreeChars => 'Mínimo 3 caracteres';

  @override
  String get gender => 'Género';

  @override
  String get activeMissionCard => 'Misión activa';

  @override
  String get redeemSeedsOrSubscribeShort => 'Canjea tus semillas o suscríbete';

  @override
  String get welcomeToEco2Plus => '¡Bienvenido a ECO2\nPlus!';

  @override
  String get subscriptionActive =>
      'Tu suscripción anual está activa. Disfruta de todas las funciones Plus desde ahora.';

  @override
  String get addPlantsWithoutLimit => 'Añade plantas sin límite';

  @override
  String get gardenCanGrow => 'Tu jardín puede crecer todo lo que quieras';

  @override
  String get sessionExpired => 'Sesión expirada. Inicia sesión nuevamente.';

  @override
  String get noNotificationsYet => 'No tienes notificaciones por ahora.';

  @override
  String get needsAttention => 'Necesitan atención';

  @override
  String overdueByDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vencido hace $count días',
      one: 'Vencido hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String get passwordMinSixChars =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get achievementUnlockedTitle => '¡Logro desbloqueado!';

  @override
  String get newPlantAddedTitle => 'Nueva planta agregada';

  @override
  String newPlantAddedBody(String name) {
    return 'Agregaste $name a tu colección.';
  }

  @override
  String get lastWateredHelpShort =>
      'Así calculamos cuándo toca el próximo riego. Si no lo sabes, empezamos a contar desde hoy.';

  @override
  String get conditionNotTracked =>
      'Esta condición todavía no se rastrea en la app.';

  @override
  String get tourSeedsDesc =>
      'Ganas semillas cuidando tus plantas y cumpliendo misiones. Úsalas en la Tienda.';

  @override
  String get achievementsAndMissionsTitle => 'Logros y misiones';

  @override
  String get tourTrophyDesc =>
      'Aquí ves tus trofeos, el progreso de tus misiones y cuánto XP llevas.';

  @override
  String get allNotificationsRead =>
      'Todas las notificaciones marcadas como leídas.';

  @override
  String get aiSearch => 'Búsqueda con IA';

  @override
  String achievementUnlockedToast(String name, String reward) {
    return '🏆 ¡Logro desbloqueado! $name ($reward)';
  }

  @override
  String xpAndSeedsReward(int xp, int seeds) {
    return '+$xp XP · +$seeds semillas';
  }

  @override
  String xpReward(int xp) {
    return '+$xp XP';
  }

  @override
  String progressOfPlants(int current, int total) {
    return '$current de $total plantas';
  }

  @override
  String progressOfCares(int current, int total) {
    return '$current de $total cuidados';
  }

  @override
  String get completed => 'Completado';

  @override
  String get pending => 'Pendiente';

  @override
  String get gotIt => 'Entendido';

  @override
  String get accept => 'Aceptar';

  @override
  String get viewSpecSheet => 'Ver ficha';

  @override
  String get history => 'Historial';

  @override
  String get tourHistoryDesc => 'Consulta tus escaneos anteriores.';

  @override
  String get plantNotFound => 'Planta no encontrada';

  @override
  String get editNickname => 'Editar apodo';

  @override
  String get takePhoto => 'Tomar foto';

  @override
  String get removePhoto => 'Quitar foto';

  @override
  String get photoRemoved => 'Foto eliminada.';

  @override
  String get photoUpdated => 'Foto actualizada.';

  @override
  String get genderMale => 'Hombre';

  @override
  String get genderFemale => 'Mujer';

  @override
  String get genderOther => 'Otro';

  @override
  String get genderPreferNotToSay => 'Prefiero no decir';

  @override
  String get birthDate => 'Fecha de nacimiento';

  @override
  String get tempShort => 'Temp.';

  @override
  String get o2co2 => 'O₂ CO₂';

  @override
  String get confirmPayment => 'Confirmar pago';

  @override
  String get card => 'Tarjeta';

  @override
  String get tourScanFavourite => 'Escanea tu planta favorita';

  @override
  String get tourScanFavouriteDesc => 'Identifica cualquier especie con IA';

  @override
  String get exploreDiscounts => 'Explora descuentos exclusivos';

  @override
  String get exploreDiscountsDesc => 'Hasta 20% off en viveros aliados';

  @override
  String redeemSeedsCount(int count) {
    return 'Canjear $count semillas';
  }

  @override
  String get waterings => 'Riegos';

  @override
  String get prunings => 'Podas';

  @override
  String routeNotFound(String route) {
    return 'Ruta no encontrada: $route';
  }

  @override
  String get careNoteHint => 'Agua tibia · ~200ml · tierra ya estaba seca';

  @override
  String get tourNotificationsDesc =>
      'Avisos reales: riegos pendientes, logros desbloqueados y plantas nuevas.';

  @override
  String wateringDueNotification(String name) {
    return 'Riego pendiente: $name necesita agua ahora.';
  }

  @override
  String get fullName => 'Nombre completo';

  @override
  String plantWatered(String name) {
    return '$name regada 💧';
  }

  @override
  String get nicknameExample => 'ej. jardinero_verde';

  @override
  String get plantNameExample => 'ej. Mi Monstera';

  @override
  String unlockedOn(String date) {
    return 'Desbloqueado el $date';
  }

  @override
  String agoMinutes(int n) {
    return 'Hace ${n}m';
  }

  @override
  String agoHours(int n) {
    return 'Hace ${n}h';
  }

  @override
  String agoDays(int n) {
    return 'Hace ${n}d';
  }

  @override
  String get wateringDueTitle => 'Riego pendiente';

  @override
  String get muteReminders => 'Silenciar recordatorios';

  @override
  String get muteRemindersOn => 'No recibirás avisos de riego de esta planta';

  @override
  String get muteRemindersOff => 'Recibirás avisos cuando toque regarla';

  @override
  String remindersMuted(String name) {
    return 'Recordatorios silenciados para $name';
  }

  @override
  String remindersUnmuted(String name) {
    return 'Recordatorios reactivados para $name';
  }

  @override
  String get logCare => 'Registrar cuidado';

  @override
  String get achFirstSteps => 'Primeros Pasos';

  @override
  String get achBotanicalEye => 'Ojo Botánico';

  @override
  String get achFirstRoom => 'Mi Primer Espacio';

  @override
  String get achHandsOn => 'Manos a la Obra';

  @override
  String get achSteadyCarer => 'Cuidador Constante';

  @override
  String get achGreenGuardian => 'Guardián Verde';

  @override
  String get achCareMaster => 'Maestro del Cuidado';

  @override
  String get achBotanicalLegend => 'Leyenda Botánica';

  @override
  String get achMyLittleGarden => 'Mi Pequeño Jardín';

  @override
  String get achCollector => 'Coleccionista';

  @override
  String get achDescOnboarding => 'Completa el onboarding de ECO2';

  @override
  String get achDescFirstScan => 'Escanea tu primera planta con IA';

  @override
  String get achDescFirstRoom => 'Crea tu primera habitación';

  @override
  String get achDescFirstCare => 'Realiza tu primer cuidado';

  @override
  String achDescNCares(int count) {
    return 'Realiza $count cuidados';
  }

  @override
  String achDescNPlants(int count) {
    return 'Registra $count plantas en tu colección';
  }

  @override
  String get aboutThisPlant => 'Sobre esta planta';

  @override
  String get difficulty => 'Dificultad';

  @override
  String get beginner => 'Principiante';

  @override
  String get expert => 'Experto';

  @override
  String get care => 'Cuidados';

  @override
  String carEquivalent(String meters) {
    return 'Equivalente a un auto recorriendo ${meters}m';
  }

  @override
  String get securePayments => 'Pagos seguros con cifrado SSL de 256 bits';

  @override
  String get selectedPlan => '★ PLAN SELECCIONADO';

  @override
  String get eco2PlusAnnual => 'ECO2 Plus Anual';

  @override
  String get cancelAnytime => 'Cancela en cualquier momento';

  @override
  String get totalToPay => 'Total a pagar';

  @override
  String payAmount(String amount) {
    return 'Pagar $amount';
  }

  @override
  String perMonthPrice(String amount) {
    return '$amount/mes';
  }

  @override
  String get filters => 'Filtros';

  @override
  String get clear => 'Limpiar';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String get unlockO2Features => 'Desbloquea funciones O₂₊';

  @override
  String get done => 'Listo';

  @override
  String get customizeYourEco2 => 'Personaliza tu experiencia ECO2';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String get optional => '(opcional)';

  @override
  String get continueAction => 'Continuar';

  @override
  String get newScan => 'Nuevo escaneo';

  @override
  String matchPercent(int pct) {
    return '$pct% coincidencia';
  }

  @override
  String get takePhotoAction => 'Hacer foto';

  @override
  String get date => 'Fecha';

  @override
  String get noteOptional => 'Nota (opcional)';

  @override
  String get scanHistory => 'Historial de escaneos';

  @override
  String get otherPossibilities => 'Otras posibilidades';

  @override
  String get viewO2Plus => 'Ver O₂₊';

  @override
  String get exportToCalendar => 'Exportar a calendario';

  @override
  String eventsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eventos',
      one: '1 evento',
    );
    return '$_temp0';
  }

  @override
  String get viewFullSheet => 'ver ficha completa';

  @override
  String get myPersonalNote => 'Mi nota personal';

  @override
  String get noPlantNeedsWater => 'Ninguna planta necesita riego ahora mismo.';

  @override
  String get waterAction => 'Regar';

  @override
  String get o2PlusLabel => 'O₂ PLUS';

  @override
  String get subscribeToO2Plus => 'Suscribirse a O₂₊';

  @override
  String get minCharsSuffix => ' · mín. 8 caracteres';

  @override
  String get startUsingPlus => 'Empezar a usar Plus';

  @override
  String seedsCost(int count) {
    return '$count semillas';
  }

  @override
  String seedsShort(int count) {
    return '$count sem.';
  }

  @override
  String get species => 'Especie';

  @override
  String get gramsPerDayUnit => 'g/día';

  @override
  String everyNDaysCompact(int days) {
    return 'c/${days}d';
  }

  @override
  String pendingMissionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pendientes',
      one: '1 pendiente',
      zero: 'Todo completado',
    );
    return '$_temp0';
  }

  @override
  String seedsCountShort(int count) {
    return '$count semillas';
  }

  @override
  String get unitCares => 'cuidados';

  @override
  String get unitPlants => 'plantas';

  @override
  String get filterAll => 'Todos';

  @override
  String get fertilizings => 'Abonos';

  @override
  String get tabActive => 'Activa';

  @override
  String get tabCompleted => 'Completadas';

  @override
  String get tabLocked => 'Bloqueadas';

  @override
  String get plantLimitReached =>
      'Has llegado a tu tope de macetas. Con O₂₊ son ilimitadas.';

  @override
  String get plusMember => 'Miembro O₂₊';

  @override
  String plusActiveUntil(String date) {
    return 'Activo hasta el $date';
  }

  @override
  String potsUsedOfLimit(int used, int limit) {
    return '$used de $limit macetas';
  }

  @override
  String get potsUnlimited => 'Macetas ilimitadas';

  @override
  String legacyPotsKept(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Conservas $count macetas de tu O₂₊ anterior',
      one: 'Conservas 1 maceta de tu O₂₊ anterior',
    );
    return '$_temp0';
  }

  @override
  String get legacyPotsExplainer =>
      'Al terminar O₂₊ no se borra ninguna planta: conservas las que cuidabas y el tope solo afecta a las nuevas.';

  @override
  String rentalPotsActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count macetas alquiladas',
      one: '1 maceta alquilada',
    );
    return '$_temp0';
  }

  @override
  String rentalPotsExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Vence en $days días',
      one: 'Vence mañana',
      zero: 'Vence hoy',
    );
    return '$_temp0';
  }

  @override
  String rentalPotsFreeSlot(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Te quedan $count huecos libres en tu jardín',
      one: 'Te queda 1 hueco libre en tu jardín',
    );
    return '$_temp0';
  }

  @override
  String get rentalPotsAllUsed => 'Todas tus macetas están ocupadas';

  @override
  String get avatarAlreadyOwned => 'Ya tienes este avatar.';

  @override
  String get avatarNotOwned => 'Necesitas comprar este avatar primero.';

  @override
  String avatarPurchased(String name) {
    return '¡$name desbloqueado!';
  }

  @override
  String buyForSeeds(int cost) {
    return 'Comprar por $cost semillas';
  }

  @override
  String get earlierLabel => 'Anteriores';

  @override
  String get noNotificationsBody =>
      'Aquí verás los riegos pendientes, los logros que desbloquees y las plantas que añadas.';

  @override
  String get noNotificationsTitle => 'Todo en orden';

  @override
  String get notEnoughSeeds => 'No tienes semillas suficientes.';

  @override
  String get owned => 'Ya lo tienes';

  @override
  String get storeAvatarSubtitle => 'Desbloqueo permanente';

  @override
  String get storeCriadoraTitle => 'Avatar Criadora';

  @override
  String get storeExploradorTitle => 'Avatar Explorador';

  @override
  String get storeJardineraTitle => 'Avatar Jardinera';

  @override
  String get storeNoctilanaTitle => 'Avatar Noctilana';

  @override
  String get thisWeekLabel => 'Esta semana';

  @override
  String unreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sin leer',
      one: '1 sin leer',
    );
    return '$_temp0';
  }

  @override
  String rentalPotsExpiresInHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'Vence en $hours horas',
      one: 'Vence en 1 hora',
    );
    return '$_temp0';
  }

  @override
  String rentalPotsExpiresInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Vence en $minutes minutos',
      one: 'Vence en 1 minuto',
    );
    return '$_temp0';
  }

  @override
  String get rentalExpiredTitle => 'Tu maceta alquilada venció';

  @override
  String rentalExpiredOverLimit(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plantas superan tu tope actual de macetas: $names.',
      one: '$names supera tu tope actual de macetas.',
    );
    return '$_temp0';
  }

  @override
  String rentalExpiredNothingHeld(int used, int limit) {
    return 'Ninguna planta dependía de ella: sigues con $used de $limit macetas.';
  }

  @override
  String get rentalExpiredNothingDeleted =>
      'No se ha borrado ninguna planta. Puedes seguir cuidándolas todas; el tope solo afecta a las nuevas.';

  @override
  String get rentalExpiredRentAgain => 'Alquilar otra';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get googleSignInFailed =>
      'No se pudo entrar con Google. Inténtalo de nuevo.';

  @override
  String get orSeparator => 'o';

  @override
  String get helpTitle => 'Ayuda';

  @override
  String get helpGreeting =>
      'Hola 👋 Soy la ayuda de ECO2. Toca una pregunta y te respondo al momento.';

  @override
  String get helpSearchHint => 'Buscar en la ayuda';

  @override
  String get helpNoResults =>
      'No encuentro nada con esas palabras. Prueba con otras, o mira las preguntas de abajo.';

  @override
  String get helpMoreQuestions => '¿Algo más?';

  @override
  String get helpRelated => 'También suelen preguntar';

  @override
  String get helpBackToTopics => 'Ver todas las preguntas';

  @override
  String get helpStillStuck => '¿No resolví tu duda?';

  @override
  String get helpContact =>
      'Escríbenos contando qué hacías, qué esperabas y qué pasó en su lugar.';

  @override
  String get helpCatPlants => 'Plantas y escáner';

  @override
  String get helpCatReminders => 'Recordatorios y avisos';

  @override
  String get helpCatPlan => 'Macetas, O₂₊ y tienda';

  @override
  String get helpCatAccount => 'Cuenta y ajustes';

  @override
  String get helpQAddPlant => '¿Cómo añado una planta?';

  @override
  String get helpAAddPlant =>
      'Tienes tres caminos: el botón central de la barra inferior identifica la planta con la cámara; desde Jardín puedes abrir una especie del catálogo y pulsar «Añadir a mi jardín»; y en Mi Jardín tienes el botón «+ Añadir planta». Después puedes ponerle un apodo para distinguirla de otras iguales.';

  @override
  String get helpQLastWatered =>
      '¿Por qué me pregunta cuándo regué por última vez?';

  @override
  String get helpALastWatered =>
      'Porque de ahí sale el primer recordatorio. Si no lo indicas, el ciclo empieza hoy, y una planta que llevaba días contigo recibiría el aviso de riego demasiado tarde.';

  @override
  String get helpQScanLimit => '¿Cuántas plantas puedo identificar al día?';

  @override
  String get helpAScanLimit =>
      'Cinco al día con el plan gratuito. El contador se reinicia a medianoche con la hora de tu propio teléfono. Con O₂₊ no hay límite.';

  @override
  String get helpQScanFails => 'El escáner no reconoce mi planta';

  @override
  String get helpAScanFails =>
      'Prueba con más luz, acércate a una sola hoja y busca un fondo despejado. Si ya gastaste tus cinco identificaciones del día, tendrás que esperar a mañana o pasar a O₂₊.';

  @override
  String get helpQWaterReminder => '¿Cuándo me avisa de regar?';

  @override
  String get helpAWaterReminder =>
      'Cuando la planta llega a su día de riego, según la frecuencia de su especie y el último riego que registraste. El aviso respeta la franja horaria que elijas en Ajustes.';

  @override
  String get helpQNoNotifications => 'No me llegan notificaciones';

  @override
  String get helpANoNotifications =>
      'Revisa cuatro cosas: que diste permiso de notificaciones, que están activadas en Ajustes con una franja horaria correcta, que esa planta no tenga los recordatorios silenciados, y que Android no tenga a ECO2 con la batería restringida.';

  @override
  String get helpQMutePlant => '¿Puedo silenciar solo una planta?';

  @override
  String get helpAMutePlant =>
      'Sí. Abre esa planta y activa «Silenciar recordatorios». Las demás te seguirán avisando con normalidad.';

  @override
  String get helpQPotLimit => '¿Cuántas plantas puedo tener?';

  @override
  String get helpAPotLimit =>
      'Diez macetas con el plan gratuito. Puedes ampliarlo comprando el pack de 3 macetas o alquilando una por 14 días, y con O₂₊ no hay tope.';

  @override
  String get helpQO2Plus => '¿Qué incluye O₂₊?';

  @override
  String get helpAO2Plus =>
      'Macetas e identificaciones ilimitadas, la insignia de miembro visible en tu perfil y el código de descuento para viveros asociados.';

  @override
  String get helpQO2PlusEnds => 'Se me acaba O₂₊, ¿pierdo mis plantas?';

  @override
  String get helpAO2PlusEnds =>
      'No. No se borra ninguna planta, nunca. Además conservas de forma permanente hasta 5 macetas por encima del tope gratuito, según las que llegaras a usar: si tenías 18 plantas, te quedas en 15 y no en 10. Puedes seguir cuidándolas todas; lo único que no podrás es añadir más hasta bajar de tu nuevo tope.';

  @override
  String get helpQRental => '¿Cómo funciona el alquiler de maceta?';

  @override
  String get helpARental =>
      'Te da una maceta extra durante 14 días por 150 semillas. Mientras dure verás un aviso en Mi Jardín con el tiempo que le queda, contado en días y, cuando esté cerca, en horas o minutos. Al vencer no se borra nada: solo baja tu tope.';

  @override
  String get helpQSeeds => '¿Cómo consigo semillas?';

  @override
  String get helpASeeds =>
      'Completando misiones, desbloqueando logros y cuidando tus plantas con constancia. Se gastan en la tienda: O₂₊, macetas y avatares.';

  @override
  String get helpQAvatars => '¿Cómo cambio mi avatar?';

  @override
  String get helpAAvatars =>
      'Desde tu perfil. Hay cuatro avatares gratuitos y cuatro que se compran con semillas. Los que ya tienes aparecen marcados como «Ya lo tienes» y no se pueden comprar dos veces.';

  @override
  String get helpQPayment => '¿El pago de O₂₊ es real?';

  @override
  String get helpAPayment =>
      'No. En esta versión O₂₊ se adquiere con semillas dentro de la app, y la pantalla de pago es una maqueta de demostración: no procesa cobros ni pide datos de tarjeta verdaderos.';

  @override
  String get helpQCo2 => '¿Cómo se calcula mi huella verde?';

  @override
  String get helpACo2 =>
      'Con los datos de absorción de cada especie del catálogo y el tiempo que lleva contigo cada planta. No son valores fijos: cambian según lo que tengas plantado.';

  @override
  String get helpQPassword => 'Olvidé mi contraseña';

  @override
  String get helpAPassword =>
      'En la pantalla de inicio de sesión pulsa «¿Olvidaste tu contraseña?» y escribe tu correo. Recibirás un código de 8 caracteres que se pega en la app junto con la nueva contraseña. Caduca a los 30 minutos.';

  @override
  String get helpQGoogle => '¿Puedo entrar con Google?';

  @override
  String get helpAGoogle =>
      'Sí. En iniciar sesión y en registrarse tienes «Continuar con Google». Si es la primera vez, la cuenta se crea sola con ese correo; si ya existe, entras en ella.';

  @override
  String get helpQBiometric => '¿Puedo proteger la app con mi huella?';

  @override
  String get helpABiometric =>
      'Sí, actívalo en Ajustes. A partir de entonces te pedirá huella o rostro al abrir la app. Ese dato nunca sale del sistema de tu teléfono: la app solo recibe un sí o un no.';

  @override
  String get helpQOffline => '¿Funciona sin conexión?';

  @override
  String get helpAOffline =>
      'No. Tus plantas y tu progreso se guardan en el servidor para que no se pierdan si cambias de teléfono, así que hace falta conexión.';

  @override
  String get helpQLanguage => '¿Cómo cambio el idioma?';

  @override
  String get helpALanguage =>
      'En Ajustes puedes elegir español o inglés. Por defecto la app sigue el idioma de tu teléfono.';

  @override
  String get freePlanLabel => 'Plan gratuito';

  @override
  String potsUsage(int used, int limit) {
    return '$used de $limit macetas';
  }

  @override
  String scansUsage(int used, int limit) {
    return '$used de $limit escaneos hoy';
  }

  @override
  String get unlimited => 'Ilimitado';

  @override
  String get activatePlus => 'Activar O₂₊';

  @override
  String get plusActivated => '¡O₂₊ activado! Macetas y escaneos ilimitados.';

  @override
  String get cancelPlus => 'Cancelar O₂₊';

  @override
  String get plusCancelled => 'Has vuelto al plan gratuito.';

  @override
  String get simulatedPayment =>
      'Pago simulado: esta app es un trabajo universitario y no realiza ningún cobro.';

  @override
  String get nurseryDiscount => 'Descuento en viveros';

  @override
  String get nurseryDiscountIntro =>
      'Muestra este código en los viveros asociados para aplicar tu descuento.';

  @override
  String get yourCode => 'Tu código';

  @override
  String get codeCopied => 'Código copiado';

  @override
  String get plusOnlyFeature => 'Disponible con O₂₊';

  @override
  String get copyCode => 'Copiar código';

  @override
  String get plusUnlimitedSummary => 'Macetas y escaneos ilimitados';

  @override
  String get manage => 'Gestionar';

  @override
  String get chooseAvatar => 'Elige tu avatar';

  @override
  String get avatarUpdated => 'Avatar actualizado';

  @override
  String get noAvatar => 'Sin avatar';

  @override
  String get avatarAgronomist => 'Agrónoma';

  @override
  String get avatarFarmer => 'Granjero';

  @override
  String get avatarGardener => 'Jardinera';

  @override
  String get avatarTechnologist => 'Tecnólogo';

  @override
  String get avatarBreeder => 'Criadora';

  @override
  String get avatarExplorer => 'Explorador';

  @override
  String get avatarScientist => 'Científico';

  @override
  String get avatarFlorist => 'Floricultora';

  @override
  String scansRemainingToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Te quedan $count escaneos hoy',
      one: 'Te queda 1 escaneo hoy',
      zero: 'No te quedan más escaneos hoy',
    );
    return '$_temp0';
  }

  @override
  String get airQuality => 'Calidad del aire';

  @override
  String get currentCo2Level => 'Nivel de CO2 actual';

  @override
  String get airQualityGood => 'Buena';

  @override
  String get airQualityModerate => 'Moderada — considera ventilar';

  @override
  String get airQualityPoor => 'Mala — ventila ahora';

  @override
  String get co2SummaryError => 'No se pudo cargar la calidad del aire.';

  @override
  String get co2WeeklyEvolutionHelp => 'Promedio diario de los últimos 7 días';

  @override
  String get noReadingsYet => 'Aún no hay lecturas';

  @override
  String get viewAirQuality => 'Ver calidad del aire';
}
