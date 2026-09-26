import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/services/google_auth_service.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';

/// Botón «Continuar con Google», compartido por iniciar sesión y registrarse.
///
/// Es el mismo botón en las dos pantallas a propósito: el backend crea la
/// cuenta si el correo no existe todavía, así que entrar y registrarse son la
/// misma operación y presentarlas distinto solo confundiría.
class GoogleSignInButton extends StatefulWidget {
  /// Se llama cuando la sesión ya está iniciada y el usuario cargado.
  final Future<void> Function() onSignedIn;

  const GoogleSignInButton({super.key, required this.onSignedIn});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _busy = false;

  Future<void> _handle() async {
    if (_busy) return;
    setState(() => _busy = true);

    final userProvider = context.read<UserProvider>();
    final result = await userProvider.loginWithGoogle(context.read<GoogleAuthService>());

    if (!mounted) return;
    setState(() => _busy = false);

    // null significa que el usuario cerró el diálogo de Google. No es un
    // fallo: no se le enseña ningún error por cambiar de idea.
    if (result == null) return;

    if (result) {
      await widget.onSignedIn();
      return;
    }

    final message = userProvider.errorText(context);
    if (message != null && mounted) {
      showAppToast(context, message, type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _busy ? null : _handle,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFDADCE0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _busy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryDark),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _GoogleMark(),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      l.continueWithGoogle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF3C4043),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// La «G» de Google, dibujada con sus cuatro colores oficiales.
///
/// Se dibuja en vez de usar una imagen para no anadir un recurso mas, y
/// porque asi escala sin perder nitidez en cualquier densidad de pantalla.
class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleGPainter()),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final stroke = size.width * 0.23;
    final inner = rect.deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    // Los cuatro arcos de la marca, en el orden y los angulos habituales.
    const arcs = <List<double>>[
      [-0.30, 1.20],
      [0.90, 1.30],
      [2.20, 1.20],
      [3.40, 1.45],
    ];
    const colors = <Color>[
      Color(0xFFEA4335),
      Color(0xFFFBBC05),
      Color(0xFF34A853),
      Color(0xFF4285F4),
    ];

    for (var i = 0; i < arcs.length; i++) {
      paint.color = colors[i];
      canvas.drawArc(inner, arcs[i][0], arcs[i][1], false, paint);
    }

    // El travesano horizontal de la G.
    final bar = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.52, size.height * 0.40,
          size.width * 0.48 - stroke / 2, stroke),
      bar,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
