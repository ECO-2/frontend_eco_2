import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

/// Cartel de "necesita riego" que se muestra sobre la foto de la planta.
///
/// Solo aparece cuando la planta realmente necesita agua: cuando está al día
/// no se pinta nada. Antes existía además una versión verde ("✓ Riego") que
/// competía visualmente con la naranja y hacía ruido, porque el estado normal
/// de una planta es estar al día — señalarlo constantemente no aporta.
///
/// Devuelve un widget vacío en lugar de null para poder usarlo directamente
/// dentro de un `Stack` sin condicionales en cada sitio.
class NeedsWaterBadge extends StatelessWidget {
  /// Si es false, el cartel no se dibuja.
  final bool needsWater;

  /// Tamaño compacto para tarjetas pequeñas (cuadrícula).
  final bool compact;

  const NeedsWaterBadge({
    super.key,
    required this.needsWater,
    this.compact = false,
  });

  static const Color _bg = Color(0xFFF56B1C);

  @override
  Widget build(BuildContext context) {
    if (!needsWater) return const SizedBox.shrink();

    final fontSize = compact ? 9.0 : 10.0;
    final iconSize = compact ? 11.0 : 13.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 9,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gota: comunica el "qué" de un vistazo, antes incluso de leer.
          Icon(Icons.water_drop_rounded, size: iconSize, color: Colors.white),
          SizedBox(width: compact ? 3 : 4),
          Text(AppLocalizations.of(context)!.needsWater,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
