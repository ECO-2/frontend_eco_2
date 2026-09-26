import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

/// Aviso permanente del alquiler de macetas en Mi Jardín.
///
/// Una maceta alquilada se paga y empieza a correr en ese momento, pero hasta
/// ahora nada en la app decía que existiera ni cuándo vencía: el usuario se
/// enteraba el día que le faltaba sitio. Aquí se mantiene a la vista mientras
/// dure, con los días restantes y un empujón para usarla si le sobra hueco,
/// que es justo lo que se pierde si se olvida.
class RentalPotBanner extends StatelessWidget {
  /// Se llama al tocar el aviso cuando todavía quedan huecos libres.
  final VoidCallback? onUseSlot;

  const RentalPotBanner({super.key, this.onUseSlot});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<PlanProvider>().status;
    final left = status.rentalTimeLeft;
    if (left == null) return const SizedBox.shrink();

    final l = AppLocalizations.of(context)!;
    final soon = status.rentalEndsSoon;

    // El ultimo dia se cuenta en horas y la ultima hora en minutos: decir
    // "vence manana" cuando quedan diez minutos no le sirve a nadie.
    final String remaining;
    if (left.inHours >= 24) {
      remaining = l.rentalPotsExpiresIn(status.rentalDaysLeft!);
    } else if (left.inMinutes >= 60) {
      remaining = l.rentalPotsExpiresInHours(left.inHours);
    } else {
      remaining = l.rentalPotsExpiresInMinutes(left.inMinutes);
    }

    // Huecos libres reales. Con O2+ el tope es ilimitado, así que el alquiler
    // no aporta nada ahora mismo: se sigue mostrando el aviso (sigue corriendo
    // y vence igual) pero sin insistir en aprovecharlo.
    final free = status.plantSlotsLeft;
    final hasFree = free != null && free > 0;

    final accent = soon ? const Color(0xFFB4531F) : AppColors.primaryDark;
    final background = soon ? const Color(0xFFFDF0E6) : const Color(0xFFEAF3EC);
    final border = soon ? const Color(0xFFF0CDB2) : const Color(0xFFC9E0D0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: hasFree && onUseSlot != null
              ? onUseSlot
              : () => Navigator.pushNamed(context, AppRoutes.store),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Icon(
                    soon ? Icons.hourglass_bottom_rounded : Icons.local_florist_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l.rentalPotsActive(status.rentalPots)} · $remaining',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          color: accent,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        hasFree
                            ? l.rentalPotsFreeSlot(free)
                            : l.rentalPotsAllUsed,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.chevron_right_rounded, color: accent, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
