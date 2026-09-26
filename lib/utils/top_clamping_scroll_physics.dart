import 'package:flutter/widgets.dart';

/// Bloquea el rebote hacia abajo en la parte superior del scroll — usado en
/// pantallas de detalle con una imagen fija de fondo (Mi Jardín, ficha de
/// especie), para que el "elastic bounce" no descuadre la imagen fija al
/// tirar hacia abajo desde arriba del todo.
class TopClampingScrollPhysics extends ScrollPhysics {
  const TopClampingScrollPhysics({super.parent});

  @override
  TopClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return TopClampingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels && position.pixels <= 0.0) {
      return value - position.pixels; // Block scroll below 0.0 (dragging down at top)
    }
    if (value < 0.0 && 0.0 < position.pixels) {
      return value; // Clamp exactly at 0.0
    }
    return super.applyBoundaryConditions(position, value);
  }
}
