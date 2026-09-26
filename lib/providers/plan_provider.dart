import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'app_error.dart';

/// Plan del usuario (gratuito u O2+) y cuánto lleva consumido.
///
/// Se mantiene aparte de [UserProvider] porque el consumo cambia con cada
/// planta añadida y cada escaneo, mientras que el perfil casi nunca cambia:
/// mezclarlos obligaría a repintar media app en cada refresco.
class PlanProvider with ChangeNotifier {
  final UserService _userService;

  PlanProvider({required UserService userService}) : _userService = userService;

  PlanStatus _status = PlanStatus.unknown();
  bool _isLoading = false;
  AppError? _errorCode;
  String? _errorMessage;

  PlanStatus get status => _status;
  bool get isLoading => _isLoading;
  bool get isPlusActive => _status.isPlusActive;

  String? errorText(BuildContext context) {
    final code = _errorCode;
    if (code != null) return code.localize(context);
    return _errorMessage;
  }

  Future<void> refresh() async {
    try {
      _status = await _userService.getPlan();
      notifyListeners();
    } catch (_) {
      // Un fallo al refrescar no debe romper la pantalla: se conserva el
      // último estado conocido y los topes se siguen aplicando en el backend,
      // que es donde importan.
    }
  }

  /// Activa O2+. El cobro es simulado; ver [UserService.activatePlus].
  Future<bool> activatePlus({int months = 12}) async {
    _isLoading = true;
    _errorCode = null;
    _errorMessage = null;
    notifyListeners();
    try {
      _status = await _userService.activatePlus(months: months);
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _errorCode = AppError.connection;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Canjea un artículo de la tienda. Devuelve las semillas restantes, o null
  /// si falló. Refresca el plan, porque el canje puede activar O2+ o añadir
  /// macetas.
  Future<int?> redeem(String itemId) async {
    _isLoading = true;
    _errorCode = null;
    _errorMessage = null;
    notifyListeners();
    try {
      final seeds = await _userService.redeemStoreItem(itemId);
      _status = await _userService.getPlan();
      _isLoading = false;
      notifyListeners();
      return seeds;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (_) {
      _errorCode = AppError.connection;
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> cancelPlus() async {
    _isLoading = true;
    notifyListeners();
    try {
      _status = await _userService.cancelPlus();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _errorCode = AppError.connection;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

}

/// Texto de la advertencia de tope alcanzado, según lo que devuelva el backend.
///
/// El backend manda un código (`plant_limit_reached`, `scan_limit_reached`) y
/// no una frase, para que la app pueda ofrecer O2+ en vez de mostrar un error
/// genérico — y para que el texto salga en el idioma de quien lo lee.
String? planLimitMessage(BuildContext context, String? backendError) {
  final l = AppLocalizations.of(context)!;
  switch (backendError) {
    case 'plant_limit_reached':
      return l.plantLimitReached;
    case 'scan_limit_reached':
      return l.scanLimitReached;
    default:
      return null;
  }
}
