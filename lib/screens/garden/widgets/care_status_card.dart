import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/utils/watering_status.dart';
import 'species_data.dart';

class CareStatusCard extends StatelessWidget {
  final UserPlant plant;
  final SpeciesData sp;

  const CareStatusCard({
    super.key,
    required this.plant,
    required this.sp,
  });

  @override
  Widget build(BuildContext context) {
    // Mismo cálculo que la tarjeta del jardín (WateringStatus). Antes esta
    // pantalla inventaba "regada hace 8 días" cuando no había riego
    // registrado, lo que hacía que una planta recién añadida se viera con el
    // aviso rojo en la lista y como "Al día" aquí dentro.
    final status = WateringStatus.of(plant, sp.waterFreqDays);
    final daysSinceWater = status.daysSinceReference;
    final isOverdue = status.needsWater;
    final overdueDays = status.daysOverdue;
    final daysRemaining = status.daysRemaining;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0D2B31), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.careStatus,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF0D2B31),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (isOverdue)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF56B1C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(AppLocalizations.of(context)!.urgentWatering,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4EB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF8A9A65)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        // Sin riego registrado no podemos afirmar "Al día":
                        // solo sabemos que el ciclo aún no ha vencido.
                        status.neverWatered
                            ? Icons.schedule_rounded
                            : Icons.check_rounded,
                        size: 12,
                        color: const Color(0xFF10454F),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        wateringStatusLabel(context, status),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10454F),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$daysSinceWater',
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xFF0D2B31),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      // Si nunca se registró un riego, el contador va desde que
                      // se añadió la planta: decir "sin riego" sería afirmar
                      // algo que no sabemos.
                      status.neverWatered
                          ? AppLocalizations.of(context)!.daysInYourGarden
                          : AppLocalizations.of(context)!.daysWithoutWater,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF807F7F)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      // Forma compacta: en ingles `sp.waterFreq` es
                      // "every 7 days" y a 22px no cabia en un tercio del
                      // ancho, asi que la fila se desbordaba.
                      child: Text(
                        AppLocalizations.of(context)!.everyNDaysCompact(sp.waterFreqDays),
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xFF0D2B31),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context)!.frequency,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF807F7F)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        isOverdue ? '+$overdueDays\u{0064}' : '${daysRemaining}d',
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xFF0D2B31),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isOverdue ? AppLocalizations.of(context)!.overdue : AppLocalizations.of(context)!.remaining,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF807F7F)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              // status.progress ya protege contra una frecuencia de 0 días,
              // que aquí habría producido una división por cero (NaN) y roto
              // el indicador.
              value: status.progress,
              backgroundColor: const Color(0xFFEBF0EE),
              color: const Color(0xFF0D2B31),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
