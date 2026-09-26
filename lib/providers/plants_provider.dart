import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'app_error.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'plan_provider.dart';

class PlantsProvider with ChangeNotifier {
  final PlantsService _plantsService;
  final PlantPhotoStorage _photoStorage;

  List<UserPlant> _userPlants = [];
  List<PlantSpecies> _speciesCatalog = [];
  Map<String, File> _customPhotos = {};
  bool _isLoading = false;
  bool _showCatalogTab = true;
  String? _errorMessage;
  AppError? _errorCode;

  PlantsProvider({
    required PlantsService plantsService,
    PlantPhotoStorage? photoStorage,
  })  : _plantsService = plantsService,
        _photoStorage = photoStorage ?? PlantPhotoStorage();

  List<UserPlant> get userPlants => _userPlants;
  List<PlantSpecies> get speciesCatalog => _speciesCatalog;
  bool get isLoading => _isLoading;
  bool get showCatalogTab => _showCatalogTab;
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

  /// Foto que el propio usuario le puso a esta planta (guardada solo en el
  /// dispositivo), o null si todavía usa la foto de la especie / un ícono.
  File? customPhotoFor(String plantId) => _customPhotos[plantId];

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setShowCatalogTab(bool value) {
    _showCatalogTab = value;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Carga inicial
  // ---------------------------------------------------------------------------

  /// Carga en paralelo el catálogo de especies, la colección del usuario y
  /// las fotos personalizadas que ya haya guardado localmente.
  Future<void> init() async {
    _setLoading(true);
    _errorMessage = null;
    _errorCode = null;
    try {
      final results = await Future.wait([
        _plantsService.getSpecies(),
        _plantsService.getUserPlants(),
        _photoStorage.loadAll(),
      ]);
      _speciesCatalog = results[0] as List<PlantSpecies>;
      _userPlants = results[1] as List<UserPlant>;
      _customPhotos = results[2] as Map<String, File>;
    } on ApiException catch (e) {
      _errorCode = null;
      _errorMessage = e.message;
    } catch (_) {
      _errorCode = AppError.plantsLoadFailed;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadSpecies() async {
    try {
      _speciesCatalog = await _plantsService.getSpecies();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadUserPlants() async {
    try {
      _userPlants = await _plantsService.getUserPlants();
      notifyListeners();
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Agregar planta
  // ---------------------------------------------------------------------------

  Future<bool> addPlantFromSpecies(
    PlantSpecies species, {
    String? nickname,
    DateTime? lastWateredAt,
  }) {
    return addPlant(
      nickname ?? species.commonName,
      species.id,
      species.commonName,
      lastWateredAt: lastWateredAt,
    );
  }

  /// Devuelve true si la planta se agregó correctamente, false si falló
  /// (con [errorMessage] explicando por qué), para que la UI que llama
  /// pueda mostrar feedback real en vez de asumir éxito.
  ///
  /// [lastWateredAt] es cuándo el usuario regó la planta por última vez antes
  /// de registrarla; el backend programa el primer recordatorio desde ahí.
  Future<bool> addPlant(
    String nickname,
    String speciesId,
    String name, {
    DateTime? lastWateredAt,
  }) async {
    try {
      final newPlant = await _plantsService.addPlant(
        speciesId: speciesId,
        nickname: nickname,
        healthStatus: 'good',
        lastWateredAt: lastWateredAt,
      );
      _userPlants.add(newPlant);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorCode = null;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorCode = AppError.plantAddFailed;
      notifyListeners();
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Regar planta
  // ---------------------------------------------------------------------------

  Future<void> waterPlant(String id, {DateTime? date}) async {
    final wateredAt = date ?? DateTime.now();
    // Actualización optimista local
    final index = _userPlants.indexWhere((p) => p.id == id);
    if (index != -1) {
      _userPlants[index] = _userPlants[index].copyWith(
        lastWateredAt: wateredAt,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
    // Persistir en API
    try {
      await _plantsService.updatePlant(id, lastWateredAt: wateredAt);
    } catch (_) {
      // Si falla, recargar desde la API para tener el estado correcto.
      await loadUserPlants();
    }
  }

  // ---------------------------------------------------------------------------
  // Eliminar planta
  // ---------------------------------------------------------------------------

  /// Devuelve true si se eliminó bien. La quita de la lista local de una
  /// vez (igual que [waterPlant]) para que un widget tipo Dismissible que ya
  /// terminó su animación de swipe no se quede "fantasma" en el árbol
  /// esperando el resultado de la red; si el borrado falla en el backend,
  /// la restauramos y avisamos del error.
  Future<bool> deletePlant(String id) async {
    final index = _userPlants.indexWhere((p) => p.id == id);
    if (index == -1) return false;
    final removed = _userPlants[index];

    _userPlants.removeAt(index);
    notifyListeners();

    try {
      await _plantsService.deletePlant(id);
      return true;
    } on ApiException catch (e) {
      _userPlants.insert(index, removed);
      _errorCode = null;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _userPlants.insert(index, removed);
      _errorCode = AppError.plantDeleteFailed;
      notifyListeners();
      return false;
    }
  }

  void setLoading(bool value) => _setLoading(value);

  // ---------------------------------------------------------------------------
  // Apodo — PATCH /plants/:id (nickname)
  // ---------------------------------------------------------------------------

  /// Renombra una planta de la colección. Devuelve true si se guardó bien.
  /// Silencia o reactiva los recordatorios de UNA planta. El resto del jardín
  /// sigue avisando; para apagarlo todo está el interruptor de Ajustes.
  Future<bool> setRemindersMuted(String plantId, bool muted) async {
    _errorCode = null;
    _errorMessage = null;
    try {
      final updated =
          await _plantsService.updatePlant(plantId, remindersMuted: muted);
      final index = _userPlants.indexWhere((p) => p.id == plantId);
      if (index != -1) _userPlants[index] = updated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorCode = AppError.connection;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateNickname(String plantId, String nickname) async {
    final trimmed = nickname.trim();
    if (trimmed.isEmpty) {
      _errorCode = AppError.nicknameEmpty;
      notifyListeners();
      return false;
    }
    try {
      final updated = await _plantsService.updatePlant(plantId, nickname: trimmed);
      final index = _userPlants.indexWhere((p) => p.id == plantId);
      if (index != -1) _userPlants[index] = updated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorCode = null;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorCode = AppError.nicknameUpdateFailed;
      notifyListeners();
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Foto personalizada — solo local, nunca se sube al backend
  // ---------------------------------------------------------------------------

  /// Guarda [pickedPath] (elegida de la galería o la cámara) como la foto de
  /// esta planta, reemplazando la anterior si existía. Solo vive en este
  /// dispositivo.
  Future<void> setCustomPhoto(String plantId, String pickedPath) async {
    final saved = await _photoStorage.savePhoto(plantId, pickedPath);
    // FileImage (lo que usa Image.file) cachea por ruta de archivo, no por
    // contenido — como el nombre del archivo no cambia al reemplazar la
    // foto de una planta, sin este evict seguiría mostrando la versión
    // vieja en memoria hasta reiniciar la app.
    PaintingBinding.instance.imageCache.evict(FileImage(saved));
    _customPhotos = {..._customPhotos, plantId: saved};
    notifyListeners();
  }

  /// Quita la foto personalizada y vuelve a mostrar la de la especie.
  Future<void> removeCustomPhoto(String plantId) async {
    final existing = _customPhotos[plantId];
    await _photoStorage.deletePhoto(plantId);
    if (existing != null) {
      PaintingBinding.instance.imageCache.evict(FileImage(existing));
    }
    _customPhotos = {..._customPhotos}..remove(plantId);
    notifyListeners();
  }
}
