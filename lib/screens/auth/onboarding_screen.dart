import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/achievement_feedback.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';
import 'package:frontend_eco_2/widgets/common/custom_text_field.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

/// Pantalla de onboarding: el usuario completa su perfil después del registro.
/// Llama a PATCH /user/onboarding con username, género y fecha de nacimiento.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;

  // Solo el valor que espera el backend y el icono: la etiqueta visible se
  // resuelve al pintar, porque esta lista es `const` y ahi no hay contexto.
  static const _genderOptions = [
    _GenderOption(value: 'male', icon: Icons.man),
    _GenderOption(value: 'female', icon: Icons.woman),
    _GenderOption(value: 'other', icon: Icons.person),
    _GenderOption(value: 'prefer_not_to_say', icon: Icons.person_off),
  ];

  String _genderLabel(BuildContext context, String value) {
    final l = AppLocalizations.of(context)!;
    switch (value) {
      case 'male':
        return l.genderMale;
      case 'female':
        return l.genderFemale;
      case 'other':
        return l.genderOther;
      default:
        return l.genderPreferNotToSay;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final minDate = DateTime(now.year - 100);
    final maxDate = DateTime(now.year - 5);
    final initial = _selectedDate ?? DateTime(now.year - 20);

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (_) => Container(
          height: 280,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text(AppLocalizations.of(context)!.cancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: Text(AppLocalizations.of(context)!.done,
                      style: TextStyle(color: AppColors.primary),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initial,
                  minimumDate: minDate,
                  maximumDate: maxDate,
                  onDateTimeChanged: (dt) {
                    setState(() => _selectedDate = dt);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      final picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: minDate,
        lastDate: maxDate,
        locale: const Locale('es'),
        builder: (ctx, child) => Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        ),
      );
      if (picked != null) setState(() => _selectedDate = picked);
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.completeOnboarding(
      username: _usernameController.text.trim(),
      gender: _selectedGender,
      birthDay: _selectedDate,
    );

    if (!mounted) return;

    if (success) {
      // Cargar datos del dashboard en paralelo antes de navegar
      final plantsProvider = context.read<PlantsProvider>();
      final missionsProvider = context.read<MissionsProvider>();
      await Future.wait([plantsProvider.init(), missionsProvider.init()]);
      missionsProvider.syncUserPlantsCount(plantsProvider.userPlants.length);
      final unlocked = await missionsProvider.onOnboardingCompleted();

      if (!mounted) return;
      showAchievementUnlockedSnackbars(context, unlocked);
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (route) => false,
      );
    } else if (userProvider.errorText(context) != null) {
      showAppToast(context, userProvider.errorText(context)!, type: ToastType.error);
    }
  }

  void _skip() async {
    // El usuario omite el onboarding — ir directo al dashboard. No se
    // desbloquea el logro "Primeros Pasos" acá porque, al saltar, nunca se
    // llamó completeOnboarding() — el usuario no completó el onboarding de
    // verdad, así que el backend tampoco marca onboarding_completed.
    final plantsProvider = context.read<PlantsProvider>();
    final missionsProvider = context.read<MissionsProvider>();
    await Future.wait([plantsProvider.init(), missionsProvider.init()]);
    missionsProvider.syncUserPlantsCount(plantsProvider.userPlants.length);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.dashboard,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header decorativo adaptable
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.welcomeGradient,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco_rounded,
                        color: AppColors.accent,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.tellUsAboutYou,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(AppLocalizations.of(context)!.customizeYourEco2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Formulario principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Nombre de usuario ──────────────────────────────
                    _SectionLabel(
                      icon: Icons.person_outline_rounded,
                      label: AppLocalizations.of(context)!.username,
                      required: true,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _usernameController,
                      labelText: AppLocalizations.of(context)!.username,
                      hintText: AppLocalizations.of(context)!.nicknameExample,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return AppLocalizations.of(context)!.usernameRequired;
                        }
                        if (v.trim().length < 3) {
                          return AppLocalizations.of(context)!.minThreeChars;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // ── Género ─────────────────────────────────────────
                    _SectionLabel(
                      icon: Icons.wc_rounded,
                      label: AppLocalizations.of(context)!.gender,
                      required: false,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _genderOptions.map((opt) {
                        final selected = _selectedGender == opt.value;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedGender = selected ? null : opt.value;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.background,
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textSecondary.withValues(
                                        alpha: 0.3,
                                      ),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(opt.icon, size: 24),
                                const SizedBox(width: 6),
                                Text(
                                  _genderLabel(context, opt.value),
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),

                    // ── Fecha de nacimiento ────────────────────────────
                    _SectionLabel(
                      icon: Icons.cake_rounded,
                      label: AppLocalizations.of(context)!.birthDate,
                      required: false,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          border: Border.all(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: _selectedDate != null
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDate != null
                                  ? _formatDate(_selectedDate!)
                                  : 'Seleccionar fecha',
                              style: TextStyle(
                                color: _selectedDate != null
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontFamily: 'Inter',
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            if (_selectedDate != null)
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedDate = null),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: AppColors.textSecondary,
                                  size: 18,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ── Botón continuar ────────────────────────────────
                    Consumer<UserProvider>(
                      builder: (_, up, _) => SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: AppLocalizations.of(context)!.continueAction,
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          isLoading: up.isLoading,
                          onPressed: _submit,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Omitir ─────────────────────────────────────────
                    Center(
                      child: TextButton(
                        onPressed: _skip,
                        child: Text(AppLocalizations.of(context)!.skipForNow,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers internos
// ─────────────────────────────────────────────────────────────────────────────

class _GenderOption {
  final String value;
  final IconData icon;
  const _GenderOption({
    required this.value,
    required this.icon,
  });
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool required;

  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.required,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
            fontSize: 14,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ] else ...[
          const SizedBox(width: 6),
          Text(AppLocalizations.of(context)!.optional,
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
              fontSize: 12,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ],
    );
  }
}
