import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

/// Ícono y color para un `task_type` real del backend
/// (enum TaskType de Prisma: watering/fertilizing/pruning/repotting/...).
/// Centralizado acá porque tanto CareSheetContent (registrar) como
/// CareHistoryList (mostrar historial real) necesitan el mismo mapeo.
class CareTaskVisual {
  final IconData icon;
  final Color color;
  final Color background;

  const CareTaskVisual({
    required this.icon,
    required this.color,
    required this.background,
  });
}

const Map<String, CareTaskVisual> _kCareTaskVisuals = {
  'watering': CareTaskVisual(
    icon: Icons.water_drop_rounded,
    color: Color(0xFF4A90D9),
    background: Color(0xFFEAF3FC),
  ),
  'fertilizing': CareTaskVisual(
    icon: Icons.grain_rounded,
    color: Color(0xFF8A9A65),
    background: Color(0xFFEFF5E4),
  ),
  'pruning': CareTaskVisual(
    icon: Icons.content_cut_rounded,
    color: Color(0xFFF56B1C),
    background: Color(0xFFFFF0EC),
  ),
  'repotting': CareTaskVisual(
    icon: Icons.upload_rounded,
    color: Color(0xFF808E89),
    background: Color(0xFFF0F2F1),
  ),
};

const CareTaskVisual _kDefaultCareTaskVisual = CareTaskVisual(
  icon: Icons.eco_rounded,
  color: Color(0xFF10454F),
  background: Color(0xFFEFF2F1),
);

CareTaskVisual careTaskVisual(String taskType) =>
    _kCareTaskVisuals[taskType] ?? _kDefaultCareTaskVisual;

/// Etiqueta visible del tipo de cuidado. Antes vivía dentro de
/// [CareTaskVisual] como texto fijo en español, que es dato de UI y no puede
/// resolverse sin `BuildContext`.
String careTaskLabel(BuildContext context, String taskType) {
  final l = AppLocalizations.of(context)!;
  switch (taskType) {
    case 'watering':
      return l.careTypeWatering;
    case 'fertilizing':
      return l.careTypeFertilizing;
    case 'pruning':
      return l.careTypePruning;
    case 'repotting':
      return l.careTypeRepotting;
    default:
      return l.careTypeGeneric;
  }
}
