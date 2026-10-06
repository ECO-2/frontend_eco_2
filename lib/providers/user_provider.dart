import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/services/google_auth_service.dart';
import 'app_error.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'plan_provider.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService;
  final UserService _userService;
  final SecureStorage _storage;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  AppError? _errorCode;

  UserProvider({
    required AuthService authService,
    required UserService userService,
    required SecureStorage storage,
  })  : _authService = authService,
        _userService = userService,
        _storage = storage;

  User? get currentUser => _currentUser;
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
  bool get isAuthenticated => _currentUser != null;

  void setUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Inicialización — restaurar sesión al arrancar la app
  // ---------------------------------------------------------------------------

  /// Intenta cargar el usuario desde la API si hay un token guardado.
  Future<void> loadCurrentUser() async {
    final hasTokens = await _storage.hasTokens();
    if (!hasTokens) return;

    _setLoading(true);
    try {
      _currentUser = await _userService.getMe();
    } catch (_) {
      // Token expirado o error de red — limpiar tokens silenciosamente.
      await _storage.clearTokens();
      _currentUser = null;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------

  /// Inicia sesión con email y contraseña. Retorna true si fue exitoso.
  /// Entra con Google. Devuelve null si el usuario cerro el dialogo, para que
  /// la pantalla sepa que no debe mostrar ningun error: cancelar no es fallar.
  ///
  /// A proposito NO toca `_isLoading`. Ese indicador lo comparten todos los
  /// botones de la pantalla, y CustomButton se desactiva mientras este
  /// encendido: si la llamada a Google tardaba o se colgaba, el boton de
  /// registrar se quedaba muerto tambien y la pantalla entera dejaba de
  /// responder. El boton de Google lleva su propio estado de ocupado.
  Future<bool?> loginWithGoogle(GoogleAuthService google) async {
    _errorMessage = null;
    _errorCode = null;

    final result = await google.signIn();
    if (result.outcome == GoogleAuthOutcome.cancelled) return null;
    if (result.outcome == GoogleAuthOutcome.failed) {
      _errorCode = AppError.googleSignIn;
      notifyListeners();
      return false;
    }

    try {
      await _authService.loginWithFirebase(result.idToken!);
      _currentUser = await _userService.getMe();
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

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    _errorCode = null;
    try {
      await _authService.login(email, password);
      _currentUser = await _userService.getMe();
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorCode = e.isUnauthorized ? AppError.wrongCredentials : null;
      _errorMessage = e.isUnauthorized ? null : e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorCode = AppError.connection;
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Register
  // ---------------------------------------------------------------------------

  /// Registra un nuevo usuario y luego inicia sesión automáticamente.
  Future<bool> register(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    _errorCode = null;
    try {
      await _authService.register(email, password);
      // Después de registrar, hacer login para obtener los tokens.
      await _authService.login(email, password);
      _currentUser = await _userService.getMe();
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorCode = e.isConflict ? AppError.emailTaken : null;
      _errorMessage = e.isConflict ? null : e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorCode = AppError.connection;
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Profile update
  // ---------------------------------------------------------------------------

  Future<bool> updateProfile({
    String? username,
    String? avatarId,
    bool? notificationsEnabled,
    int? reminderStartHour,
    int? reminderEndHour,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    _errorCode = null;
    try {
      _currentUser = await _userService.updateProfile(
        username: username,
        avatarId: avatarId,
        notificationsEnabled: notificationsEnabled,
        reminderStartHour: reminderStartHour,
        reminderEndHour: reminderEndHour,
      );
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorCode = e.isConflict ? AppError.usernameTaken : null;
      _errorMessage = e.isConflict ? null : e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorCode = AppError.connection;
      _setLoading(false);
      return false;
    }
  }

  /// Cambia la contraseña del usuario autenticado. El backend verifica la
  /// actual, así que un 401 aquí significa "la contraseña actual no es esa",
  /// no que la sesión haya caducado.
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    _errorCode = null;
    try {
      await _userService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorCode = e.isUnauthorized ? AppError.currentPasswordWrong : null;
      _errorMessage = e.isUnauthorized ? null : e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorCode = AppError.connection;
      _setLoading(false);
      return false;
    }
  }

  /// Borra la cuenta y su contenido en el servidor, y limpia la sesión local.
  Future<bool> deleteAccount() async {
    _setLoading(true);
    _errorMessage = null;
    _errorCode = null;
    try {
      await _userService.deleteAccount();
      await logout();
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorCode = null;
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorCode = AppError.connection;
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Onboarding
  // ---------------------------------------------------------------------------

  /// Envía los datos del perfil inicial y marca onboarding_completed = true.
  Future<bool> completeOnboarding({
    String? username,
    String? gender,
    DateTime? birthDay,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    _errorCode = null;
    try {
      final updatedUser = await _userService.completeOnboarding(
        username: username,
        gender: gender,
        birthDay: birthDay,
      );
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          username: updatedUser.username,
          gender: updatedUser.gender,
          birthDay: updatedUser.birthDay,
          onboardingCompleted: true,
        );
      } else {
        _currentUser = updatedUser;
      }
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorCode = e.isConflict ? AppError.usernameTaken : null;
      _errorMessage = e.isConflict ? null : e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      debugPrint('Error en completeOnboarding: $e');
      _errorCode = AppError.profileUpdateFailed;
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Recuperación de contraseña
  // ---------------------------------------------------------------------------

  /// Pide al backend que envíe el correo de recuperación.
  ///
  /// Devuelve true si la petición se cursó. No distingue si el correo existe:
  /// el backend responde igual en ambos casos a propósito, para no permitir
  /// enumerar usuarios, y la app mantiene esa ambigüedad.
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;
    _errorCode = null;
    try {
      await _authService.forgotPassword(email);
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorCode = null;
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorCode = AppError.connection;
      _setLoading(false);
      return false;
    }
  }

  /// Aplica la nueva contraseña usando el código recibido por correo.
  /// A diferencia de [forgotPassword], aquí sí interesa distinguir el fallo:
  /// un código inválido o vencido tiene que decirlo — no hay nada que filtrar,
  /// porque quien lo usa ya tiene el código en la mano.
  Future<bool> resetPassword({
    required String code,
    required String newPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    _errorCode = null;
    try {
      await _authService.resetPassword(code: code, newPassword: newPassword);
      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorCode = null;
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorCode = AppError.connection;
      _setLoading(false);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Logout
  // ---------------------------------------------------------------------------

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();
  }
}
