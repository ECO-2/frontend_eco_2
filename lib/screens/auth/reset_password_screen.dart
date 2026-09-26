import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';
import 'package:frontend_eco_2/widgets/common/custom_text_field.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';

/// Segundo paso de la recuperación: la persona pega el código que le llegó por
/// correo y elige la contraseña nueva.
///
/// Se optó por código pegable en lugar de enlace porque la app no tiene deep
/// link configurado, así que un enlace no tendría a dónde abrir.
class ResetPasswordScreen extends StatefulWidget {
  /// Correo al que se envió el código. Solo se muestra, para que se vea a qué
  /// bandeja mirar; el backend identifica al usuario por el código.
  final String? email;

  const ResetPasswordScreen({super.key, this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final ok = await userProvider.resetPassword(
      code: _codeController.text.trim(),
      newPassword: _passwordController.text,
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

    showAppToast(context, l.resetPasswordSuccess, type: ToastType.success);
    // Vuelve al login, que es donde se usa la contraseña recién puesta.
    Navigator.of(context).pop();
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
        title: Text(l.resetPasswordTitle),
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
                  l.resetPasswordIntro,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.textSecondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
                if (widget.email != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.email!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _codeController,
                  labelText: l.resetCodeLabel,
                  hintText: l.resetCodeHint,
                  prefixIcon: Icons.vpn_key_rounded,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l.resetCodeRequired : null,
                ),
                const SizedBox(height: 8),
                Text(
                  l.resetCodeExpiredHint,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  labelText: l.newPassword,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) =>
                      (v == null || v.length < 8) ? l.passwordTooShort : null,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmController,
                  labelText: l.confirmPassword,
                  obscureText: _obscureConfirm,
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) => v != _passwordController.text
                      ? l.passwordsDoNotMatch
                      : null,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: l.resetPasswordSubmit,
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
