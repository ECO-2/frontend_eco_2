import 'package:flutter/material.dart';
import 'package:frontend_eco_2/services/secure_storage.dart';

/// Idioma de la app, elegido por el usuario y recordado entre sesiones.
///
/// Si nunca lo ha elegido, `locale` es null y MaterialApp resuelve el idioma
/// del sistema contra `supportedLocales`: un teléfono en inglés abre la app en
/// inglés sin que el usuario tenga que tocar nada.
class LocaleProvider with ChangeNotifier {
  final SecureStorage _storage;

  Locale? _locale;

  LocaleProvider(this._storage);

  Locale? get locale => _locale;

  /// Idiomas entre los que puede elegir el usuario.
  static const supported = [Locale('es'), Locale('en')];

  Future<void> load() async {
    final code = await _storage.getLanguageCode();
    if (code != null && supported.any((l) => l.languageCode == code)) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale?.languageCode == locale.languageCode) return;
    _locale = locale;
    notifyListeners();
    await _storage.saveLanguageCode(locale.languageCode);
  }

  /// Vuelve a seguir el idioma del sistema.
  Future<void> useSystemLocale() async {
    _locale = null;
    notifyListeners();
    await _storage.clearLanguageCode();
  }
}
