import 'package:flutter/material.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';
import 'package:frontend_eco_2/utils/catalog_labels.dart';

/// Fila de chips de tags en una sola línea, con scroll horizontal en vez de
/// envolver a una segunda línea. Se usa en tarjetas de tamaño fijo (imagen +
/// pie de info) donde un `Wrap` que crece a 2 líneas empuja/deforma el resto
/// del layout (por ejemplo, achica el área de la imagen). Con esto la altura
/// de la tarjeta es siempre predecible sin importar cuántos tags haya.
class TagChipsRow extends StatelessWidget {
  final List<SpeciesTag> tags;
  final double fontSize;
  final double iconSize;
  final EdgeInsets padding;
  final double spacing;

  const TagChipsRow({
    super.key,
    required this.tags,
    this.fontSize = 9,
    this.iconSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (int i = 0; i < tags.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            _chip(tags[i]),
          ],
        ],
      ),
    );
  }

  Widget _chip(SpeciesTag tag) {
    final text = tag.text;
    final style = styleForTagKind(tag.kind);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: iconSize, color: style.color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: style.color,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
