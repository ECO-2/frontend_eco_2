import 'dart:async';
import 'package:flutter/material.dart';

/// Tipo de toast — determina color e ícono.
enum ToastType { info, success, error }

/// Notificación ligera tipo "toast": aparece flotando cerca de la parte
/// inferior de la pantalla con una animación breve (fade + slide), se
/// queda un par de segundos y desaparece sola. Reemplaza al SnackBar
/// clásico de Material (pesado, ancho completo) en toda la app.
///
/// Uso: `showAppToast(context, 'Apodo actualizado.', type: ToastType.success);`
void showAppToast(
  BuildContext context,
  String message, {
  ToastType type = ToastType.info,
  Duration duration = const Duration(seconds: 2, milliseconds: 200),
}) {
  _AppToastController.show(context, message, type: type, duration: duration);
}

class _AppToastController {
  static OverlayEntry? _currentEntry;
  static Timer? _currentTimer;

  static void show(
    BuildContext context,
    String message, {
    required ToastType type,
    required Duration duration,
  }) {
    _currentTimer?.cancel();
    _currentEntry?.remove();
    _currentEntry = null;

    final overlayState = Overlay.maybeOf(context, rootOverlay: true);
    if (overlayState == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AppToastWidget(message: message, type: type),
    );
    _currentEntry = entry;
    overlayState.insert(entry);

    _currentTimer = Timer(duration, () {
      if (_currentEntry == entry) {
        entry.remove();
        _currentEntry = null;
      }
    });
  }
}

class _AppToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;

  const _AppToastWidget({required this.message, required this.type});

  @override
  State<_AppToastWidget> createState() => _AppToastWidgetState();
}

class _AppToastWidgetState extends State<_AppToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _bg => switch (widget.type) {
        ToastType.success => const Color(0xFF10454F),
        ToastType.error => const Color(0xFFC62828),
        ToastType.info => const Color(0xFF2E2E2E),
      };

  IconData get _icon => switch (widget.type) {
        ToastType.success => Icons.check_circle_rounded,
        ToastType.error => Icons.error_rounded,
        ToastType.info => Icons.info_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Positioned(
      left: 20,
      right: 20,
      bottom: bottomInset + 88,
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _bg,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_icon, color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
