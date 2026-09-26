import 'package:flutter/widgets.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

/// Errores que los providers pueden producir, como código y no como texto.
///
/// Los providers son lógica sin `BuildContext`, así que no pueden resolver
/// traducciones: antes escribían el mensaje en español a mano y la app lo
/// mostraba tal cual, también en inglés. Aquí se guarda qué falló, y la
/// pantalla —que sí tiene contexto— decide cómo decirlo.
enum AppError {
  connection,
  wrongCredentials,
  emailTaken,
  usernameTaken,
  currentPasswordWrong,
  profileUpdateFailed,
  plantsLoadFailed,
  plantAddFailed,
  plantDeleteFailed,
  nicknameEmpty,
  nicknameUpdateFailed,
  missionsLoadFailed,
  careLogFailed,
  googleSignIn,
}

extension AppErrorText on AppError {
  String localize(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    switch (this) {
      case AppError.connection:
        return l.connectionError;
      case AppError.wrongCredentials:
        return l.wrongCredentials;
      case AppError.emailTaken:
        return l.emailAlreadyUsed;
      case AppError.usernameTaken:
        return l.usernameTaken;
      case AppError.currentPasswordWrong:
        return l.currentPasswordWrong;
      case AppError.profileUpdateFailed:
        return l.profileUpdateFailed;
      case AppError.plantsLoadFailed:
        return l.plantsLoadFailed;
      case AppError.plantAddFailed:
        return l.plantAddFailed;
      case AppError.plantDeleteFailed:
        return l.plantDeleteFailed;
      case AppError.nicknameEmpty:
        return l.nicknameEmpty;
      case AppError.nicknameUpdateFailed:
        return l.nicknameUpdateFailed;
      case AppError.missionsLoadFailed:
        return l.missionsLoadFailed;
      case AppError.careLogFailed:
        return l.careLogFailed;
      case AppError.googleSignIn:
        return l.googleSignInFailed;
    }
  }
}
