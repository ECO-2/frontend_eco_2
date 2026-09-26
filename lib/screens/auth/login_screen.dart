import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/routing/post_sign_in.dart';
import 'package:frontend_eco_2/widgets/auth/google_sign_in_button.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';
import 'package:frontend_eco_2/widgets/common/custom_text_field.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final success = await userProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        await completeSignIn(context);
      } else if (mounted && userProvider.errorText(context) != null) {
        showAppToast(
          context,
          userProvider.errorText(context)!,
          type: ToastType.error,
        );
      }
    }
  }

  /// Pide el correo de recuperación al backend.
  ///
  /// Antes esto solo mostraba "Simulación: Recuperación de contraseña
  /// enviada" y no llamaba a nada, pese a que POST /auth/forgot-password ya
  /// existe y funciona.
  Future<void> _handleForgotPassword() async {
    final l = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showAppToast(context, l.emailRequired, type: ToastType.error);
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ok = await userProvider.forgotPassword(email);
    if (!mounted) return;

    if (!ok) {
      showAppToast(
        context,
        userProvider.errorText(context) ?? l.connectionError,
        type: ToastType.error,
      );
      return;
    }

    // Mensaje deliberadamente ambiguo: confirmar si el correo existe
    // permitiría enumerar cuentas.
    showAppToast(context, l.forgotPasswordSent, type: ToastType.success);

    // Se abre el paso 2 en cualquier caso, por lo mismo: si solo apareciera
    // cuando el correo existe, la propia navegación delataría las cuentas.
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResetPasswordScreen(email: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomStatusBar(),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/Icono Principal.png',
                          height: 130,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.welcomeBack,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.signIn,
                          style: const TextStyle(
                            fontSize: 32,

                            color: AppColors.primary,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        labelText: AppLocalizations.of(context)!.email,
                        hintText: AppLocalizations.of(context)!.emailHint,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.enterYourEmail;
                          }
                          if (!value.contains('@')) {
                            return AppLocalizations.of(
                              context,
                            )!.enterValidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        labelText: AppLocalizations.of(context)!.password,
                        hintText: '••••••',
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.enterYourPassword;
                          }
                          if (value.length < 6) {
                            return AppLocalizations.of(
                              context,
                            )!.passwordMinSixChars;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Forgot Password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _handleForgotPassword,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.forgotPassword,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: AppLocalizations.of(context)!.signInAction,
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          isLoading: userProvider.isLoading,
                          onPressed: _submit,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Separador y entrada con Google. El mismo boton en las
                      // dos pantallas: el backend crea la cuenta si el correo
                      // no existe, asi que entrar y registrarse son lo mismo.
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: Color(0xFFDDE3E0)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              AppLocalizations.of(context)!.orSeparator,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontFamily: 'Inter',
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: Color(0xFFDDE3E0)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      GoogleSignInButton(
                        onSignedIn: () => completeSignIn(context),
                      ),
                      const SizedBox(height: 24),

                      // Bottom Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.noAccountYet,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: 'Inter',
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.register,
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.createAccount,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
