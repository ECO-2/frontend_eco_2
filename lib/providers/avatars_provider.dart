import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'app_error.dart';

/// Qué avatares tiene el usuario y cuáles puede comprar.
///
/// La propiedad la manda el backend y no se deduce en la app: el precio y el
/// saldo se validan allí, así que aquí solo se guarda el resultado para pintar
/// los candados.
class AvatarsProvider with ChangeNotifier {
  final UserService _userService;

  AvatarsProvider({required UserService userService})
      : _userService = userService;

  Set<String> _owned = {};
  bool _isLoading = false;
  AppError? _errorCode;
  String? _errorMessage;

  Set<String> get owned => _owned;
  bool get isLoading => _isLoading;

  bool isOwned(String avatarId) => _owned.contains(avatarId);

  String? errorText(BuildContext context) {
    final code = _errorCode;
    if (code != null) return code.localize(context);
    return _errorMessage;
  }

  Future<void> refresh() async {
    try {
      _owned = (await _userService.getOwnedAvatars()).toSet();
      notifyListeners();
    } catch (_) {
      // Si falla, se conserva lo último conocido: el backend rechaza igualmente
      // cualquier avatar no comprado al guardar el perfil.
    }
  }

  /// Compra un avatar con semillas. Devuelve el saldo restante, o null si falló.
  Future<int?> purchase(String avatarId) async {
    _isLoading = true;
    _errorCode = null;
    _errorMessage = null;
    notifyListeners();
    try {
      final seeds = await _userService.purchaseAvatar(avatarId);
      _owned = {..._owned, avatarId};
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
}

/// Traduce los códigos que devuelve el backend al comprar.
///
/// Se mandan códigos y no frases para que la app pueda decidir qué ofrecer
/// —conseguir más semillas, por ejemplo— y para que el texto salga en el idioma
/// de quien lo lee.
String? avatarPurchaseMessage(BuildContext context, String? backendError) {
  final l = AppLocalizations.of(context)!;
  switch (backendError) {
    case 'not_enough_seeds':
      return l.notEnoughSeeds;
    case 'avatar_already_owned':
      return l.avatarAlreadyOwned;
    case 'avatar_not_owned':
      return l.avatarNotOwned;
    default:
      return null;
  }
}
