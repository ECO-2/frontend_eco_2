import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_text_field.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/widgets/common/user_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser;

    _usernameController = TextEditingController(
      // Solo datos reales. Antes venía precargado '@carlos_eco', y teléfono,
      // ciudad y fecha de nacimiento traían valores inventados que el usuario
      // podía acabar guardando como suyos.
      text: user != null && user.username.isNotEmpty && user.username != 'usuario'
          ? '@${user.username}'
          : '',
    );
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _saving = false;

  /// Guarda contra el backend de verdad.
  ///
  /// Antes esto solo actualizaba el estado local (el propio código lo decía:
  /// "Simulate saving changes") y aun así mostraba "¡Perfil guardado con
  /// éxito!". Al reiniciar la app los cambios desaparecían, porque nunca
  /// llegaban al servidor.
  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    var username = _usernameController.text.trim();
    if (username.startsWith('@')) username = username.substring(1);

    if (username.isEmpty) {
      showAppToast(context, l.enterYourEmail, type: ToastType.error);
      return;
    }

    setState(() => _saving = true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ok = await userProvider.updateProfile(username: username);
    if (!mounted) return;
    setState(() => _saving = false);

    if (!ok) {
      // Mensaje real del backend (p. ej. nombre de usuario ya en uso).
      showAppToast(
        context,
        userProvider.errorText(context) ?? l.genericError,
        type: ToastType.error,
      );
      return;
    }

    showAppToast(context, l.save, type: ToastType.success);
    Navigator.of(context).pop();
  }

  /// Abre el selector de avatar y guarda el elegido.
  ///
  /// Antes ambos botones solo mostraban un toast de "próximamente"; ahora la
  /// elección se persiste en el perfil (campo avatar_url, que ya existía).
  Future<void> _pickAvatar() async {
    final l = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final chosen = await showAvatarPicker(
      context,
      current: userProvider.currentUser?.avatarUrl,
      title: l.chooseAvatar,
    );
    if (chosen == null || !mounted) return;

    final ok = await userProvider.updateProfile(avatarId: chosen);
    if (!mounted) return;
    showAppToast(
      context,
      ok ? l.avatarUpdated : (userProvider.errorText(context) ?? l.connectionError),
      type: ok ? ToastType.success : ToastType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.editProfile,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent, // Lime green
                foregroundColor: AppColors.primary, // Dark green text
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              onPressed: _saving ? null : _save,
              child: Text(
                AppLocalizations.of(context)!.save,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                  // White Avatar Container
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            UserAvatar(
                              avatarId: context
                                  .watch<UserProvider>()
                                  .currentUser
                                  ?.avatarUrl,
                              size: 120,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _pickAvatar,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.accent, // Lime green
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _pickAvatar,
                          child: Text(
                            AppLocalizations.of(context)!.chooseAvatar,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Horizontal spacer/divider strip
                  Container(
                    height: 8,
                    width: double.infinity,
                    color: const Color(0xFFF1F4F3),
                  ),
                  
                  // Form Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.personalInformation,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // El campo "Nombre completo" se retiro: no existe
                          // en el modelo de usuario ni lo guardaba ningun
                          // endpoint, y venia precargado con "Carlos Eco", que
                          // alguien podia acabar guardando como suyo.
                          // Username
                          CustomTextField(
                            controller: _usernameController,
                            labelText: AppLocalizations.of(context)!.username,
                            customLabel: _buildCustomLabel(AppLocalizations.of(context)!.username),
                            // No prefix icon as in Figma mockup!
                          ),
                          const SizedBox(height: 20),

                          // Email
                          CustomTextField(
                            controller: _emailController,
                            labelText: AppLocalizations.of(context)!.email,
                            customLabel: _buildCustomLabel(AppLocalizations.of(context)!.email),
                            prefixIcon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

                          // Teléfono, ubicación y fecha de nacimiento se
                          // eliminaron: no existen en el modelo de usuario ni
                          // los guarda ningún endpoint, así que eran campos
                          // decorativos con datos de ejemplo dentro.
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCustomLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        fontFamily: 'Inter',
      ),
    );
  }
}
