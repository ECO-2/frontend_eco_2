import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/services/biometric_service.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/routing/sign_out.dart';
import 'package:frontend_eco_2/screens/profile/change_password_screen.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';
import 'package:frontend_eco_2/widgets/common/settings_option_tile.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/widgets/common/user_avatar.dart';

/// Versión de la app. Debe seguir a `version:` en pubspec.yaml — antes aquí
/// había un "2.4.1" fijo que no correspondía a ninguna versión real.
const String kAppVersion = '1.0.0';

/// Correo de soporte que se ofrece en "Ayuda y soporte".
const String kSupportEmail = 'soporte@eco2.app';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _biometrics = BiometricService();

  bool _biometricLock = false;
  bool _biometricAvailable = false;
  bool _loadedPrefs = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPrefs());
  }

  Future<void> _loadPrefs() async {
    final storage = context.read<SecureStorage>();
    final enabled = await storage.isBiometricLockEnabled();
    final available = await _biometrics.isAvailable();
    if (!mounted) return;
    setState(() {
      _biometricLock = enabled;
      _biometricAvailable = available;
      _loadedPrefs = true;
    });
  }

  // ── Idioma ─────────────────────────────────────────────────────────────

  /// Etiqueta del idioma activo. Si el usuario no ha elegido ninguno, la app
  /// sigue el del sistema y se indica así en vez de mentir con "Español".
  String _currentLanguageLabel(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final chosen = context.watch<LocaleProvider>().locale;
    if (chosen == null) return l.systemLanguage;
    return chosen.languageCode == 'en' ? l.english : l.spanish;
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final provider = context.read<LocaleProvider>();
    final current = provider.locale?.languageCode;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _SheetShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetTitle(l.language),
            RadioListTile<String?>(
              value: 'es',
              groupValue: current,
              title: Text(l.spanish),
              onChanged: (_) {
                provider.setLocale(const Locale('es'));
                Navigator.pop(sheetContext);
              },
            ),
            RadioListTile<String?>(
              value: 'en',
              groupValue: current,
              title: Text(l.english),
              onChanged: (_) {
                provider.setLocale(const Locale('en'));
                Navigator.pop(sheetContext);
              },
            ),
            RadioListTile<String?>(
              value: null,
              groupValue: current,
              title: Text(l.systemLanguage),
              onChanged: (_) {
                provider.useSystemLocale();
                Navigator.pop(sheetContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Biometría ──────────────────────────────────────────────────────────

  Future<void> _toggleBiometricLock(bool value) async {
    final l = AppLocalizations.of(context)!;
    final storage = context.read<SecureStorage>();

    if (value) {
      // Se exige pasar la huella antes de activar. Sin esto, alguien con el
      // teléfono desbloqueado podría activar un bloqueo con SU huella y dejar
      // fuera a la dueña de la cuenta.
      final outcome = await _biometrics.authenticate(l.biometricPromptReason);
      if (!mounted) return;
      if (outcome != BiometricOutcome.success) {
        showAppToast(
          context,
          outcome == BiometricOutcome.unavailable
              ? l.biometricUnavailable
              : l.appLockFailed,
          type: ToastType.error,
        );
        return;
      }
    }

    await storage.setBiometricLockEnabled(value);
    if (!mounted) return;
    setState(() => _biometricLock = value);
    showAppToast(
      context,
      value ? l.biometricEnabled : l.biometricDisabled,
      type: ToastType.success,
    );
  }

  // ── Notificaciones ─────────────────────────────────────────────────────

  Future<void> _togglePushNotifications(bool value) async {
    final l = AppLocalizations.of(context)!;
    final userProvider = context.read<UserProvider>();
    final ok = await userProvider.updateProfile(notificationsEnabled: value);
    if (!mounted) return;
    if (!ok) {
      showAppToast(
        context,
        userProvider.errorText(context) ?? l.connectionError,
        type: ToastType.error,
      );
    }
  }

  Future<void> _showReminderWindowPicker() async {
    final l = AppLocalizations.of(context)!;
    final userProvider = context.read<UserProvider>();
    final user = userProvider.currentUser;

    // El backend acepta 6–22 y exige inicio < fin (update-profile.usecase.ts).
    int start = user?.reminderStartHour ?? 8;
    int end = user?.reminderEndHour ?? 21;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final invalid = start >= end;
          return _SheetShell(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SheetTitle(l.reminderWindowSheetTitle),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    l.reminderWindowIntro,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.textSecondary,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _HourDropdown(
                        label: l.reminderStart,
                        value: start,
                        onChanged: (v) => setSheetState(() => start = v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _HourDropdown(
                        label: l.reminderEnd,
                        value: end,
                        onChanged: (v) => setSheetState(() => end = v),
                      ),
                    ),
                  ],
                ),
                if (invalid)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      l.reminderWindowInvalid,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE53935),
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed:
                      invalid ? null : () => Navigator.pop(sheetContext, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(l.save),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (saved != true || !mounted) return;

    final ok = await userProvider.updateProfile(
      reminderStartHour: start,
      reminderEndHour: end,
    );
    if (!mounted) return;
    showAppToast(
      context,
      ok
          ? l.reminderWindowSaved
          : (userProvider.errorText(context) ?? l.connectionError),
      type: ok ? ToastType.success : ToastType.error,
    );
  }

  // ── Privacidad, datos y ayuda ──────────────────────────────────────────

  Future<void> _showInfoSheet(String title, String body, {Widget? action}) {
    final l = AppLocalizations.of(context)!;
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _SheetShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SheetTitle(title),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Text(
                body,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
            if (action != null) action,
            TextButton(
              onPressed: () => Navigator.pop(sheetContext),
              child: Text(l.close),
            ),
          ],
        ),
      ),
    );
  }

  /// Exporta un resumen real de la cuenta al portapapeles. Antes esta opción
  /// solo mostraba "Exportando datos... 💾" y no exportaba nada.
  Future<void> _exportData() async {
    final l = AppLocalizations.of(context)!;
    final user = context.read<UserProvider>().currentUser;
    final plantsProvider = context.read<PlantsProvider>();

    if (user == null) {
      showAppToast(context, l.exportDataFailed, type: ToastType.error);
      return;
    }

    final payload = <String, dynamic>{
      'exported_at': DateTime.now().toIso8601String(),
      'account': {
        'email': user.email,
        'username': user.username,
        'created_at': user.createdAt.toIso8601String(),
        'notifications_enabled': user.notificationsEnabled,
        'reminder_start_hour': user.reminderStartHour,
        'reminder_end_hour': user.reminderEndHour,
      },
      'plants': plantsProvider.userPlants
          .map((p) => {
                'nickname': p.nickname,
                'species_id': p.speciesId,
                'acquired_at': p.acquiredAt?.toIso8601String(),
                'last_watered_at': p.lastWateredAt?.toIso8601String(),
                'created_at': p.createdAt.toIso8601String(),
              })
          .toList(),
    };

    final json = const JsonEncoder.withIndent('  ').convert(payload);
    await Clipboard.setData(ClipboardData(text: json));
    if (!mounted) return;
    showAppToast(context, l.exportDataCopied, type: ToastType.success);
  }

  // ── Zona de riesgo ─────────────────────────────────────────────────────

  Future<void> _confirmDeleteAccount() async {
    final l = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final word = l.deleteAccountConfirmWord;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final matches = controller.text.trim().toUpperCase() == word;
          return AlertDialog(
            title: Text(l.deleteAccountTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.deleteAccountBody),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: l.deleteAccountConfirmHint,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setDialogState(() {}),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l.cancel),
              ),
              // Solo se habilita al escribir la palabra completa: es
              // irreversible y borra también las plantas y su historial.
              FilledButton(
                onPressed:
                    matches ? () => Navigator.pop(dialogContext, true) : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                ),
                child: Text(l.deleteAccount),
              ),
            ],
          );
        },
      ),
    );

    controller.dispose();
    if (confirmed != true || !mounted) return;

    final userProvider = context.read<UserProvider>();
    final ok = await userProvider.deleteAccount();
    if (!mounted) return;

    if (!ok) {
      showAppToast(
        context,
        userProvider.errorText(context) ?? l.connectionError,
        type: ToastType.error,
      );
      return;
    }

    showAppToast(context, l.deleteAccountSuccess, type: ToastType.success);
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.welcome,
      (route) => false,
    );
  }

  // ── Perfil ─────────────────────────────────────────────────────────────

  /// "@usuario · Nivel 3 Retoño" con datos reales. Si no hay username todavía
  /// se omite esa parte en vez de mostrar el "@carlos_eco" de ejemplo.
  String _profileSubtitle(BuildContext context, User? user, MissionsProvider mp) {
    final l = AppLocalizations.of(context)!;
    final progress = mp.progress;
    final level = progress?.level ?? 1;
    final name = progress?.levelName;
    final levelText =
        name == null ? l.levelLabel(level) : l.levelWithName(level, name);

    final hasUsername =
        user != null && user.username.isNotEmpty && user.username != 'usuario';
    return hasUsername ? '@${user.username} · $levelText' : levelText;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    final missionsProvider = Provider.of<MissionsProvider>(context);
    final user = userProvider.currentUser;

    final pushEnabled = user?.notificationsEnabled ?? true;
    final startHour = user?.reminderStartHour ?? 8;
    final endHour = user?.reminderEndHour ?? 21;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: l.settings),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        children: [
          // ── Resumen del perfil ──────────────────────────────────────
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E7E4), width: 1),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: UserAvatar(avatarId: user?.avatarUrl, size: 50),
              title: Text(
                // Sin "Carlos Eco" de relleno: si aún no hay nombre elegido se
                // muestra el correo, que sí es real.
                user != null &&
                        user.username.isNotEmpty &&
                        user.username != 'usuario'
                    ? user.username
                    : (user?.email ?? ''),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
              subtitle: Text(
                _profileSubtitle(context, user, missionsProvider),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textSecondary),
              onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            ),
          ),

          // ── CUENTA ──────────────────────────────────────────────────
          _SectionHeader(l.account),
          _Card(children: [
            SettingsOptionTile(
              icon: Icons.person_outline_rounded,
              title: l.editProfile,
              subtitle: l.editProfileSubtitle,
              useIconContainer: true,
              onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            ),
            const _Line(),
            SettingsOptionTile(
              icon: Icons.lock_outline_rounded,
              title: l.changePassword,
              useIconContainer: true,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ChangePasswordScreen(),
                ),
              ),
            ),
            const _Line(),
            SettingsOptionTile(
              icon: Icons.fingerprint_rounded,
              title: l.biometricLock,
              subtitle: _loadedPrefs && !_biometricAvailable
                  ? l.biometricUnavailable
                  : l.biometricLockSubtitle,
              useIconContainer: true,
              showArrow: false,
              trailing: _Toggle(
                value: _biometricLock,
                // Sin sensor o sin huella registrada no se puede ofrecer:
                // activarlo dejaría la app imposible de abrir.
                onChanged: _loadedPrefs && _biometricAvailable
                    ? _toggleBiometricLock
                    : null,
              ),
            ),
            const _Line(),
            SettingsOptionTile(
              icon: Icons.star_outline_rounded,
              title: l.managePlus,
              subtitle: l.managePlusFree,
              useIconContainer: true,
              showArrow: false,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l.view,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textSecondary),
                ],
              ),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.premiumUpgrade),
            ),
          ]),
          const SizedBox(height: 16),

          // ── NOTIFICACIONES ──────────────────────────────────────────
          _SectionHeader(l.notifications),
          _Card(children: [
            SettingsOptionTile(
              icon: Icons.notifications_none_rounded,
              title: l.pushNotifications,
              subtitle: l.pushNotificationsSubtitle,
              useIconContainer: true,
              showArrow: false,
              trailing: _Toggle(
                value: pushEnabled,
                onChanged: userProvider.isLoading
                    ? null
                    : _togglePushNotifications,
              ),
            ),
            const _Line(),
            // Sustituye a "Recordatorios de riego" y "Logros y misiones", que
            // eran interruptores sin nada detrás: el backend no guarda
            // preferencias por categoría, solo esta franja horaria.
            SettingsOptionTile(
              icon: Icons.schedule_rounded,
              title: l.reminderWindow,
              useIconContainer: true,
              showArrow: false,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l.reminderWindowValue(startHour, endHour),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textSecondary),
                ],
              ),
              onTap: _showReminderWindowPicker,
            ),
          ]),
          const SizedBox(height: 16),

          // ── PREFERENCIAS ────────────────────────────────────────────
          // "Tema y colores" se retiró: la app tiene una sola paleta, así que
          // la fila prometía algo que no existe.
          _SectionHeader(l.preferences),
          _Card(children: [
            SettingsOptionTile(
              icon: Icons.language_rounded,
              title: l.language,
              useIconContainer: true,
              showArrow: false,
              iconColor: const Color(0xFF8FA89F),
              iconBgColor: const Color(0xFFEFF3F1),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentLanguageLabel(context),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textSecondary),
                ],
              ),
              onTap: () => _showLanguagePicker(context),
            ),
          ]),
          const SizedBox(height: 16),

          // ── PRIVACIDAD Y DATOS ──────────────────────────────────────
          _SectionHeader(l.privacyAndData),
          _Card(children: [
            SettingsOptionTile(
              icon: Icons.shield_outlined,
              title: l.privacy,
              subtitle: l.privacySubtitle,
              useIconContainer: true,
              iconColor: const Color(0xFF26A69A),
              iconBgColor: const Color(0xFFE0F2F1),
              onTap: () =>
                  _showInfoSheet(l.privacySheetTitle, l.privacySheetBody),
            ),
            const _Line(),
            SettingsOptionTile(
              icon: Icons.storage_rounded,
              title: l.exportMyData,
              subtitle: l.exportDataSubtitle,
              useIconContainer: true,
              iconColor: const Color(0xFF8D6E63),
              iconBgColor: const Color(0xFFF5F0ED),
              onTap: _exportData,
            ),
          ]),
          const SizedBox(height: 16),

          // ── APLICACIÓN ──────────────────────────────────────────────
          _SectionHeader(l.application),
          _Card(children: [
            SettingsOptionTile(
              icon: Icons.help_outline_rounded,
              title: l.helpAndSupport,
              subtitle: l.helpSupportSubtitle,
              useIconContainer: true,
              iconColor: const Color(0xFF78909C),
              iconBgColor: const Color(0xFFECEFF1),
              // Antes abria una hoja con un parrafo y el correo. Ahora lleva
              // al centro de ayuda: la duda se resuelve en un toque en vez de
              // obligar a escribir un correo y esperar respuesta.
              onTap: () => Navigator.pushNamed(context, AppRoutes.help),
            ),
            const _Line(),
            SettingsOptionTile(
              icon: Icons.info_outline_rounded,
              title: l.aboutEco2,
              subtitle: l.appVersion(kAppVersion),
              useIconContainer: true,
              iconColor: const Color(0xFF78909C),
              iconBgColor: const Color(0xFFECEFF1),
              onTap: () => _showInfoSheet(
                l.aboutEco2,
                '${l.aboutSheetBody}\n\n${l.appVersion(kAppVersion)}',
              ),
            ),
          ]),
          const SizedBox(height: 16),

          // ── ZONA DE RIESGO ──────────────────────────────────────────
          _SectionHeader(l.dangerZone, isRisk: true),
          _Card(children: [
            SettingsOptionTile(
              icon: Icons.logout_rounded,
              title: l.signOut,
              useIconContainer: true,
              iconColor: const Color(0xFF757575),
              iconBgColor: const Color(0xFFF5F5F5),
              titleColor: const Color(0xFF212121),
              onTap: () => signOutAndGoToWelcome(context),
            ),
            const _Line(),
            SettingsOptionTile(
              icon: Icons.delete_outline_rounded,
              title: l.deleteAccount,
              subtitle: l.deleteAccountSubtitle,
              useIconContainer: true,
              iconColor: const Color(0xFFE53935),
              iconBgColor: const Color(0xFFFFEBEE),
              titleColor: const Color(0xFFE53935),
              onTap: _confirmDeleteAccount,
            ),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ── Piezas de presentación ────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isRisk;

  const _SectionHeader(this.title, {this.isRisk = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 8.0, top: 16.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isRisk ? const Color(0xFFE53935) : AppColors.textSecondary,
          letterSpacing: 1.2,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;

  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E7E4), width: 1),
      ),
      child: Column(children: children),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) => const Divider(
        height: 1,
        indent: 68,
        endIndent: 16,
        color: Color(0xFFE2E7E4),
      );
}

class _Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _Toggle({required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: AppColors.primary,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFFE2E7E4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _SheetShell extends StatelessWidget {
  final Widget child;

  const _SheetShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  final String text;

  const _SheetTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

/// Selector de hora limitado a 6–22, que es el rango que valida el backend.
class _HourDropdown extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _HourDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          items: [
            for (int h = 6; h <= 22; h++)
              DropdownMenuItem(
                value: h,
                child: Text('${h.toString().padLeft(2, '0')}:00'),
              ),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
