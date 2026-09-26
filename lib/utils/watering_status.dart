import 'package:flutter/widgets.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/models/user_plant.dart';

/// Estado de riego de una planta, calculado en un único sitio.
///
/// Antes cada pantalla lo calculaba por su cuenta y se contradecían: la
/// tarjeta del Dashboard daba por vencida cualquier planta sin riego
/// registrado, mientras que la ficha de detalle sustituía esa fecha ausente
/// por un valor inventado (8 días atrás), de modo que una planta recién
/// añadida aparecía con el aviso rojo "¡Riego!" en la lista y como "Al día"
/// al abrirla.
///
/// La referencia correcta cuando nunca se ha regado es la fecha de
/// adquisición: si acabas de añadir la planta, todavía no toca regarla. Es
/// además el mismo criterio que usa el backend al programar la tarea de riego
/// (`next_due_at = ahora + frecuencia`).
class WateringStatus {
  /// Días transcurridos desde el último riego (o desde que se añadió la
  /// planta, si nunca se ha regado).
  final int daysSinceReference;

  /// Días que faltan para el próximo riego. 0 si ya toca.
  final int daysRemaining;

  /// Días de retraso. 0 si no está vencida.
  final int daysOverdue;

  /// La planta necesita agua ahora.
  final bool needsWater;

  /// Nunca se ha registrado un riego para esta planta.
  final bool neverWatered;

  /// Frecuencia de riego de la especie, en días.
  final int frequencyDays;

  const WateringStatus({
    required this.daysSinceReference,
    required this.daysRemaining,
    required this.daysOverdue,
    required this.needsWater,
    required this.neverWatered,
    required this.frequencyDays,
  });

  /// Progreso hacia el próximo riego, entre 0 y 1.
  double get progress => frequencyDays <= 0
      ? 0
      : (daysSinceReference / frequencyDays).clamp(0.0, 1.0);

  factory WateringStatus.of(
    UserPlant plant,
    int waterFrequencyDays, {
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final neverWatered = plant.lastWateredAt == null;

    // Si nunca se regó, contamos desde que entró a la colección. Si tampoco
    // hay fecha de adquisición (datos antiguos o incompletos), usamos
    // createdAt, que siempre existe — nunca un valor inventado.
    final reference =
        plant.lastWateredAt ?? plant.acquiredAt ?? plant.createdAt;

    // Días completos transcurridos; nunca negativo aunque el reloj del
    // dispositivo esté por detrás de la fecha guardada.
    final rawDays = current.difference(reference).inDays;
    final daysSinceReference = rawDays < 0 ? 0 : rawDays;

    final needsWater =
        waterFrequencyDays > 0 && daysSinceReference >= waterFrequencyDays;

    return WateringStatus(
      daysSinceReference: daysSinceReference,
      daysRemaining: needsWater ? 0 : waterFrequencyDays - daysSinceReference,
      daysOverdue: needsWater ? daysSinceReference - waterFrequencyDays : 0,
      needsWater: needsWater,
      neverWatered: neverWatered,
      frequencyDays: waterFrequencyDays,
    );
  }

}

/// Texto corto de estado para mostrar junto a la planta.
///
/// Estaba como getter en [WateringStatus], que es lógica pura sin
/// `BuildContext`: devolvía el texto en español y se mostraba así también con
/// la app en inglés.
String wateringStatusLabel(BuildContext context, WateringStatus status) {
  final l = AppLocalizations.of(context)!;
  if (status.needsWater) {
    return status.daysOverdue > 0 ? l.wateringOverdue : l.wateringToday;
  }
  if (status.neverWatered) return l.noWateringYet;
  return l.upToDate;
}
