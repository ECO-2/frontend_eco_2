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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        showAppToast(
          context,
          AppLocalizations.of(context)!.passwordsDoNotMatch,
          type: ToastType.error,
        );
        return;
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final success = await userProvider.register(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        // Usuario recién registrado → siempre va al onboarding.
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.onboarding,
          (route) => false,
        );
      } else if (mounted && userProvider.errorText(context) != null) {
        showAppToast(
          context,
          userProvider.errorText(context)!,
          type: ToastType.error,
        );
      }
    }
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
                  vertical: 12.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.createAccount,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Username Field
                      CustomTextField(
                        controller: _usernameController,
                        labelText: AppLocalizations.of(context)!.username,
                        hintText: AppLocalizations.of(context)!.nicknameExample,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.enterUsername;
                          }
                          if (value.length < 3) {
                            return AppLocalizations.of(
                              context,
                            )!.usernameTooShort;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

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

                      // Password Field (with Rich Text label and suffixText)
                      CustomTextField(
                        controller: _passwordController,
                        labelText: AppLocalizations.of(context)!.password,
                        customLabel: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!.password,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(
                                  context,
                                )!.minCharsSuffix,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        hintText: '•••••',
                        suffixText: AppLocalizations.of(
                          context,
                        )!.passwordMinChars,
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.enterYourPassword;
                          }
                          if (value.length < 8) {
                            return AppLocalizations.of(
                              context,
                            )!.passwordTooShort;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppLocalizations.of(context)!.passwordTooShort,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password Field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: AppLocalizations.of(
                          context,
                        )!.confirmPassword,
                        hintText: '••••••••',
                        suffixText: AppLocalizations.of(
                          context,
                        )!.passwordMinChars,
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.confirmYourPassword;
                          }
                          if (value != _passwordController.text) {
                            return AppLocalizations.of(
                              context,
                            )!.passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: AppLocalizations.of(context)!.register,
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

                      // Bottom Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.alreadyHaveAccount,
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
                                AppRoutes.login,
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.signInAction,
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
                      const SizedBox(height: 24),

                      // Centered implicit terms acceptance footnote
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            AppLocalizations.of(context)!.termsNotice,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
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
