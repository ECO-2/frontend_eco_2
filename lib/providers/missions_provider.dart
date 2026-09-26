import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'app_error.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'plan_provider.dart';

/// Tipo de condición usada por los logros sembrados en el backend
/// (Achievement.conditionType). Centralizado acá porque tanto el conteo
/// como el chequeo de desbloqueo dependen de conocer estos valores.
class AchievementConditions {
  static const onboardingCompleted = 'onboarding_completed';
  static const userPlants = 'user_plants';
  static const careLogs = 'care_logs';
  static const plantScans = 'plant_scans';
  static const roomsCreated = 'rooms_created';
}

/// action_type usado al otorgar XP por registrar un cuidado — se reutiliza
/// para reconstruir cuántos cuidados reales se han hecho a partir del
/// historial de XP (GET /progress/xp-logs), sin necesitar un endpoint de
/// conteo aparte en el backend.
const _kCareLogActionType = 'care_log';

class MissionsProvider with ChangeNotifier {
  final GamificationService _gamificationService;
  final CareService _careService;

  List<Achievement> _achievements = [];
  List<UserAchievement> _unlockedAchievements = [];
  UserProgress? _progress;
  int _careLogCount = 0;
  bool _isLoading = false;
  String? _errorMessage;
  AppError? _errorCode;

  MissionsProvider({
    required GamificationService gamificationService,
    required CareService careService,
  })  : _gamificationService = gamificationService,
        _careService = careService;

  List<Achievement> get achievements => _achievements;
  List<UserAchievement> get unlockedAchievements => _unlockedAchievements;
  UserProgress? get progress => _progress;
  int get careLogCount => _careLogCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Texto de error ya traducido. Prefiere el código propio; si el fallo vino
  /// del backend con un mensaje concreto, devuelve ese. Null si no hay error.
  String? errorText(BuildContext context) {
    final code = _errorCode;
    if (code != null) return code.localize(context);
    if (_errorMessage == kSessionExpired) {
      return AppLocalizations.of(context)!.sessionExpired;
    }
    // Topes del plan: el backend manda un codigo para que la app pueda
    // ofrecer O2+ en vez de un error generico.
    final planMessage = planLimitMessage(context, _errorMessage);
    if (planMessage != null) return planMessage;
    return _errorMessage;
  }

  /// IDs de logros ya desbloqueados por el usuario.
  List<String> get completedAchievementIds =>
      _unlockedAchievements.map((ua) => ua.achievementId).toList();

  /// Logros aún no desbloqueados, ordenados por qué tan cerca está el
  /// usuario de cumplir la condición — útil para mostrar "el próximo logro"
  /// como si fuera una misión activa, sin necesitar un backend de misiones.
  List<Achievement> get lockedAchievements =>
      _achievements.where((a) => !isAchievementCompleted(a.id)).toList();

  /// Semillas actuales del usuario (0 si no ha cargado aún).
  int get userSeeds => _progress?.seeds ?? 0;

  /// Número de logros ya desbloqueados. El Perfil mostraba un "(12)" fijo.
  int get unlockedCount =>
      _achievements.where((a) => isAchievementCompleted(a.id)).length;

  bool isAchievementCompleted(String id) =>
      completedAchievementIds.contains(id);

  /// Fecha en la que se desbloqueó un logro, o null si no está desbloqueado.
  DateTime? unlockedAtFor(String achievementId) {
    for (final ua in _unlockedAchievements) {
      if (ua.achievementId == achievementId) return ua.unlockedAt;
    }
    return null;
  }

  /// Progreso actual (0-N) hacia la condición de un logro, para barras de
  /// progreso reales en vez de porcentajes inventados.
  int progressFor(Achievement achievement) {
    switch (achievement.conditionType) {
      case AchievementConditions.userPlants:
        return _userPlantsCount;
      case AchievementConditions.careLogs:
        return _careLogCount;
      case AchievementConditions.onboardingCompleted:
        return isAchievementCompleted(achievement.id) ? 1 : 0;
      default:
        return 0; // plant_scans / rooms_created: sin dato real todavía.
    }
  }

  int _userPlantsCount = 0;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Carga inicial
  // ---------------------------------------------------------------------------

  /// Carga progreso y logros del usuario desde la API.
  Future<void> init() async {
    _setLoading(true);
    _errorMessage = null;
    _errorCode = null;
    try {
      final results = await Future.wait([
        _gamificationService.getProgress(),
        _gamificationService.getAchievements(),
        _gamificationService.getMyAchievements(),
        _gamificationService.getXpLogs(),
      ]);
      _progress = results[0] as UserProgress;
      _achievements = results[1] as List<Achievement>;
      _unlockedAchievements = results[2] as List<UserAchievement>;
      final xpLogs = results[3] as List<XpLog>;
      _careLogCount =
          xpLogs.where((log) => log.actionType == _kCareLogActionType).length;
    } on ApiException catch (e) {
      _errorCode = null;
      _errorMessage = e.message;
    } catch (_) {
      _errorCode = AppError.missionsLoadFailed;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------------------------
  // XP y semillas
  // ---------------------------------------------------------------------------

  Future<void> addSeeds(int amount, {String reason = 'reward'}) async {
    try {
      _progress = await _gamificationService.updateSeeds(amount, reason);
      notifyListeners();
    } catch (_) {
      // Actualización local como fallback
      if (_progress != null) {
        _progress = _progress!.copyWith(seeds: _progress!.seeds + amount);
        notifyListeners();
      }
    }
  }

  Future<bool> spendSeeds(int amount) async {
    if (userSeeds < amount) return false;
    try {
      _progress = await _gamificationService.updateSeeds(-amount, 'purchase');
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> addXp(int amount, {String actionType = 'action'}) async {
    try {
      _progress = await _gamificationService.addXp(amount, actionType);
      notifyListeners();
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Acciones reales del usuario → XP + logros
  // ---------------------------------------------------------------------------

  /// Registra un cuidado real (POST /care/logs), otorga XP, y desbloquea
  /// cualquier logro de tipo `care_logs` que se haya alcanzado.
  ///
  /// Devuelve `null` si falló (ver [errorMessage]), o la lista de logros
  /// recién desbloqueados (vacía si el registro fue exitoso pero no
  /// desbloqueó ninguno) — null en vez de una lista vacía en ambos casos
  /// para que la UI pueda distinguir "falló" de "no había nada que
  /// desbloquear" sin depender del estado previo de [errorMessage].
  Future<List<Achievement>?> logCare({
    required String userPlantId,
    required String taskType,
  }) async {
    _errorMessage = null;
    _errorCode = null;
    try {
      await _careService.createCareLog(userPlantId: userPlantId, taskType: taskType);
    } on ApiException catch (e) {
      _errorCode = null;
      _errorMessage = e.message;
      notifyListeners();
      return null;
    } catch (_) {
      _errorCode = AppError.careLogFailed;
      notifyListeners();
      return null;
    }

    _careLogCount++;
    await addXp(10, actionType: _kCareLogActionType);
    return _unlockEligible(AchievementConditions.careLogs, _careLogCount);
  }

  /// Debe llamarse justo después de agregar una planta exitosamente, con el
  /// total real de plantas del usuario (PlantsProvider.userPlants.length).
  /// Otorga XP y desbloquea logros de tipo `user_plants` alcanzados.
  Future<List<Achievement>> onPlantAdded(int totalPlantCount) async {
    _userPlantsCount = totalPlantCount;
    await addXp(15, actionType: 'plant_added');
    return _unlockEligible(AchievementConditions.userPlants, totalPlantCount);
  }

  /// Sincroniza el contador de plantas sin otorgar XP ni desbloquear nada —
  /// para usarse justo después de cargar PlantsProvider (login/onboarding/
  /// arranque de la app), así `progressFor()` muestra el progreso real desde
  /// el primer render en vez de arrancar en 0 hasta la próxima planta.
  void syncUserPlantsCount(int totalPlantCount) {
    if (_userPlantsCount == totalPlantCount) return;
    _userPlantsCount = totalPlantCount;
    notifyListeners();
  }

  /// Debe llamarse justo después de completar (o saltar) el onboarding.
  Future<List<Achievement>> onOnboardingCompleted() {
    return _unlockEligible(AchievementConditions.onboardingCompleted, 1);
  }

  /// Revisa los logros de [conditionType] cuyo `conditionValue` ya se
  /// alcanzó con [currentValue] y aún no están desbloqueados, los desbloquea
  /// contra la API real, y devuelve la lista de los que se desbloquearon
  /// ahora mismo (para que la UI pueda celebrarlo).
  Future<List<Achievement>> _unlockEligible(String conditionType, int currentValue) async {
    final eligible = _achievements.where((a) =>
        a.conditionType == conditionType &&
        currentValue >= a.conditionValue &&
        !isAchievementCompleted(a.id));

    final unlocked = <Achievement>[];
    for (final achievement in eligible) {
      try {
        final userAchievement =
            await _gamificationService.unlockAchievement(achievement.id);
        _unlockedAchievements.add(userAchievement);
        unlocked.add(achievement);
        // El backend acredita xp_reward/seed_reward atómicamente al
        // desbloquear; se refleja acá para no depender de un refetch.
        if (_progress != null) {
          _progress = _progress!.copyWith(
            xp: _progress!.xp + achievement.xpReward,
            seeds: _progress!.seeds + achievement.seedReward,
          );
        }
      } on ApiException catch (e) {
        // 409 = ya estaba desbloqueado (ej. otra sesión/dispositivo se
        // adelantó) — no es un error real, solo lo ignoramos.
        if (!e.isConflict) _errorCode = null;
 _errorMessage = e.message;
      } catch (_) {
        // Falla de red puntual: se reintentará la próxima vez que se
        // cumpla la condición (ej. al agregar la siguiente planta).
      }
    }
    if (unlocked.isNotEmpty) notifyListeners();
    return unlocked;
  }
}
