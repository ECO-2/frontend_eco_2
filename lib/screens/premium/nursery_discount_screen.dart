import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/widgets/common/plus_badge.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Código de descuento para enseñar en los viveros asociados.
///
/// El código se deriva del id del usuario, así que es **estable** —el mismo hoy
/// y mañana— y distinto para cada persona, sin necesitar una tabla nueva ni una
/// llamada al servidor.
///
/// Nada lo valida todavía: no hay integración con ningún vivero. Es un
/// identificador para enseñar en pantalla, no un cupón canjeable, y la propia
/// pantalla lo dice para que nadie lo confunda con un descuento real.
class NurseryDiscountScreen extends StatelessWidget {
  /// Id del usuario, del que se deriva el código.
  final String userId;

  const NurseryDiscountScreen({super.key, required this.userId});

  /// Alfabeto sin caracteres ambiguos: el código se lee a ojo desde la
  /// pantalla del teléfono, igual que el de recuperación de contraseña.
  static const _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// `ECO2-XXXX-XXXX` derivado del id. Determinista: mismo usuario, mismo
  /// código, sin guardarlo en ninguna parte.
  String get code {
    var hash = 0;
    for (final unit in userId.codeUnits) {
      // Hash sencillo y estable (variante de djb2). No necesita ser seguro:
      // solo identificar de forma consistente.
      hash = (hash * 33 + unit) & 0x7fffffff;
    }
    final buffer = StringBuffer();
    var value = hash;
    for (var i = 0; i < 8; i++) {
      buffer.write(_alphabet[value % _alphabet.length]);
      value = value ~/ _alphabet.length + (i + 1) * 7;
    }
    final raw = buffer.toString();
    return 'ECO2-${raw.substring(0, 4)}-${raw.substring(4)}';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(l.nurseryDiscount),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(alignment: Alignment.centerLeft, child: PlusBadge()),
              const SizedBox(height: 16),
              Text(
                l.nurseryDiscountIntro,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.textSecondary,
                  fontFamily: 'DM Sans',
                ),
              ),
              const SizedBox(height: 24),

              // Tarjeta con el QR y el código escrito: el vivero puede
              // escanearlo o teclearlo, según con qué cuente.
              Container(
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E7E4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: code,
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: AppColors.primaryDark,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l.yourCode,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      code,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: AppColors.primaryDark,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text(l.copyCode),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: code));
                  if (!context.mounted) return;
                  showAppToast(context, l.codeCopied, type: ToastType.success);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
