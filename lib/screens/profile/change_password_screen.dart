import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';
import 'package:frontend_eco_2/widgets/common/custom_text_field.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';

/// Cambio de contraseña con sesión iniciada. Distinto del flujo de
/// recuperación: aquí se pide la contraseña actual en lugar de un código, y el
/// backend la verifica antes de aceptar la nueva.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final ok = await userProvider.changePassword(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
    );
    if (!mounted) return;

    if (!ok) {
      showAppToast(
        context,
        userProvider.errorText(context) ?? l.connectionError,
        type: ToastType.error,
      );
      return;
    }

    showAppToast(context, l.changePasswordSuccess, type: ToastType.success);
    Navigator.of(context).pop();
  }

  Widget _visibilityToggle({
    required bool obscured,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: AppColors.textSecondary,
        size: 20,
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(l.changePassword),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.changePasswordIntro,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.textSecondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _currentController,
                  labelText: l.currentPassword,
                  obscureText: _obscureCurrent,
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: _visibilityToggle(
                    obscured: _obscureCurrent,
                    onPressed: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? l.currentPasswordRequired
                      : null,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _newController,
                  labelText: l.newPassword,
                  obscureText: _obscureNew,
                  prefixIcon: Icons.lock_reset_rounded,
                  suffixIcon: _visibilityToggle(
                    obscured: _obscureNew,
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 8) return l.passwordTooShort;
                    if (v == _currentController.text) {
                      return l.passwordMustDiffer;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmController,
                  labelText: l.confirmPassword,
                  obscureText: _obscureConfirm,
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: _visibilityToggle(
                    obscured: _obscureConfirm,
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) =>
                      v != _newController.text ? l.passwordsDoNotMatch : null,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: l.changePasswordSubmit,
                  isLoading: userProvider.isLoading,
                  onPressed: userProvider.isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
