import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

/// Fondo decorativo de las tarjetas de la tienda: degradado por categoría más
/// un patrón vectorial sutil.
///
/// Antes las tarjetas eran blancas planas (o verde sólido la destacada), así
/// que se leían todas igual y la sección no llamaba la atención. El degradado
/// distingue las familias de un vistazo y el vector aporta textura sin usar
/// imágenes: se dibuja con `CustomPainter`, así que no pesa nada y escala a
/// cualquier tamaño.
class StoreCardBackdrop extends StatelessWidget {
  /// Categoría del artículo (`O2+`, `avatars`, `pots`).
  final String category;

  /// La tarjeta destacada usa la paleta oscura de marca.
  final bool featured;

  final Widget child;
  final double borderRadius;

  const StoreCardBackdrop({
    super.key,
    required this.category,
    required this.child,
    this.featured = false,
    this.borderRadius = 24,
  });

  /// Pareja de colores del degradado. Se mantienen dentro de la paleta de la
  /// app para que la tienda no parezca de otra aplicación.
  List<Color> get _gradient {
    if (featured) {
      return const [Color(0xFF135A64), Color(0xFF0B2429)];
    }
    switch (category) {
      case 'O2+':
        return const [Color(0xFFEFF8E4), Color(0xFFFBFDF7)];
      case 'avatars':
        return const [Color(0xFFE7F1F3), Color(0xFFFAFCFC)];
      case 'pots':
        return const [Color(0xFFF6EFE9), Color(0xFFFDFAF8)];
      default:
        return const [Color(0xFFF2F5F3), Colors.white];
    }
  }

  /// Color del vector: casi transparente, para que sea textura y no ruido.
  Color get _patternColor => featured
      ? AppColors.accent.withValues(alpha: 0.16)
      : AppColors.primary.withValues(alpha: 0.07);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradient,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _StorePatternPainter(
                  category: category,
                  color: _patternColor,
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

/// Patrón vectorial por familia de producto.
class _StorePatternPainter extends CustomPainter {
  final String category;
  final Color color;

  const _StorePatternPainter({required this.category, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    switch (category) {
      case 'O2+':
        _paintLeaves(canvas, size, paint);
      case 'pots':
        _paintArcs(canvas, size, paint);
      default:
        _paintBubbles(canvas, size, paint);
    }
  }

  /// Hojas: dos curvas espejo que se cruzan, como en el logo.
  void _paintLeaves(Canvas canvas, Size size, Paint paint) {
    void leaf(Offset center, double length, double angle) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      final w = length * 0.52;
      final path = Path()
        ..moveTo(0, -length / 2)
        ..quadraticBezierTo(w, 0, 0, length / 2)
        ..quadraticBezierTo(-w, 0, 0, -length / 2)
        ..close();
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    leaf(Offset(size.width * 0.88, size.height * 0.22), size.height * 0.85, 0.5);
    leaf(Offset(size.width * 0.72, size.height * 0.86), size.height * 0.55, -0.9);
  }

  /// Arcos concéntricos: sugieren el borde de una maceta vista de frente.
  void _paintArcs(Canvas canvas, Size size, Paint paint) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.06;

    final center = Offset(size.width * 0.92, size.height * 0.95);
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, size.height * 0.28 * i, stroke);
    }
  }

  /// Burbujas: para avatares y todo lo demás.
  void _paintBubbles(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(
        Offset(size.width * 0.9, size.height * 0.2), size.height * 0.34, paint);
    canvas.drawCircle(
        Offset(size.width * 0.74, size.height * 0.9), size.height * 0.2, paint);
    canvas.drawCircle(
        Offset(size.width * 1.02, size.height * 0.66), size.height * 0.16, paint);
  }

  @override
  bool shouldRepaint(_StorePatternPainter old) =>
      old.category != category || old.color != color;
}

/// Marco circular del icono, con un halo suave detrás.
class StoreItemIcon extends StatelessWidget {
  final IconData icon;
  final bool featured;

  const StoreItemIcon({super.key, required this.icon, this.featured = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: featured
              ? const [AppColors.accent, Color(0xFF9BC22B)]
              : const [Colors.white, Color(0xFFEDF2EF)],
        ),
        boxShadow: [
          BoxShadow(
            color: (featured ? AppColors.accent : AppColors.primary)
                .withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Transform.rotate(
        // Ligera inclinación: rompe la simetría y da algo de dinamismo sin
        // llegar a verse torcido.
        angle: -math.pi / 36,
        child: Icon(
          icon,
          color: featured ? AppColors.primaryDark : AppColors.primary,
          size: 24,
        ),
      ),
    );
  }
}
