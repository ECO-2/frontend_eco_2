import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// Lluvia de hojas para celebrar (subir de nivel, desbloquear un logro,
/// completar una compra).
///
/// Usa el mismo motor que el confeti pero dibujando una hoja en vez de
/// rectángulos de colores: en una app de plantas, papelillos de fiesta
/// desentonan y las hojas refuerzan el tema.
class LeafBurst extends StatelessWidget {
  final ConfettiController controller;

  /// Explosión radial (para una celebración centrada) o caída desde arriba.
  final bool falling;

  final int numberOfParticles;

  const LeafBurst({
    super.key,
    required this.controller,
    this.falling = false,
    this.numberOfParticles = 30,
  });

  /// Verdes de la app, más dos tonos cálidos de hoja madura para que la
  /// mezcla no se vea plana.
  static const _leafColors = [
    Color(0xFF4E9A51),
    Color(0xFF789D8C),
    Color(0xFFBDE038),
    Color(0xFF2F6B33),
    Color(0xFFD9A441),
  ];

  /// Silueta de hoja: dos curvas simétricas que se juntan en las puntas, con
  /// el nervio central marcado.
  static Path _drawLeaf(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w / 2, 0);
    // Lado derecho de la hoja.
    path.quadraticBezierTo(w, h * 0.30, w / 2, h);
    // Lado izquierdo, cerrando la silueta.
    path.quadraticBezierTo(0, h * 0.30, w / 2, 0);
    path.close();

    // Nervio central: una línea fina que da lectura de "hoja" incluso a
    // tamaño muy pequeño.
    path.moveTo(w / 2, h * 0.08);
    path.lineTo(w / 2, h * 0.92);

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: controller,
      blastDirectionality:
          falling ? BlastDirectionality.directional : BlastDirectionality.explosive,
      blastDirection: pi / 2, // hacia abajo, solo aplica si `falling`
      shouldLoop: false,
      colors: _leafColors,
      createParticlePath: _drawLeaf,
      numberOfParticles: numberOfParticles,
      // Las hojas caen más despacio que el confeti y ondean al bajar.
      gravity: 0.08,
      minBlastForce: 3,
      maxBlastForce: 7,
      emissionFrequency: 0.04,
      minimumSize: const Size(8, 12),
      maximumSize: const Size(14, 20),
    );
  }
}
