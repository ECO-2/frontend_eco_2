import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/services/secure_storage.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

/// Aviso de que una maceta de alquiler ha vencido.
///
/// Sale una sola vez por alquiler y su unico trabajo es que el usuario no se
/// entere por sorpresa: dice que venció, qué plantas quedan por encima del
/// tope y, sobre todo, que ninguna se ha borrado.
///
/// Las macetas no se asignan a plantas concretas, son huecos. Así que aquí no
/// se inventa cuál "iba dentro": se nombran las que ahora mismo sobrepasan el
/// tope —las más recientes, que son las que el alquiler sostenía— y si no
/// sobra ninguna se dice tal cual, en vez de señalar una planta al azar.
Future<void> showRentalExpiredDialog(
  BuildContext context, {
  required PlanStatus status,
  required List<UserPlant> plants,
}) {
  final l = AppLocalizations.of(context)!;
  final limit = status.plantsLimit;
  final overage = limit == null ? 0 : status.plantsUsed - limit;

  // Las que sobran son las últimas en llegar.
  final newest = [...plants]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  final displaced = overage > 0
      ? newest.take(overage).map((p) => p.nickname.isNotEmpty ? p.nickname : p.name).toList()
      : const <String>[];

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFB4531F),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.hourglass_disabled_rounded,
                color: Colors.white, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l.rentalExpiredTitle,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displaced.isEmpty
                ? l.rentalExpiredNothingHeld(status.plantsUsed, limit ?? status.plantsUsed)
                : l.rentalExpiredOverLimit(displaced.length, displaced.join(', ')),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.5,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.spa_rounded, color: AppColors.primaryDark, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.rentalExpiredNothingDeleted,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5,
                      height: 1.35,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(
            l.gotIt,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.primaryDark),
          onPressed: () {
            Navigator.of(dialogContext).pop();
            Navigator.pushNamed(context, AppRoutes.store);
          },
          child: Text(
            l.rentalExpiredRentAgain,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Decide si toca avisar y lo hace una sola vez por alquiler.
///
/// El alquiler vencido se reconoce porque el backend deja de contarlo
/// (`rentalPots` a cero) pero conserva la fecha: eso permite distinguir "se
/// acabó" de "nunca tuvo ninguno", que es lo que hace falta para no avisar a
/// quien jamás alquiló nada.
Future<void> maybeShowRentalExpired(BuildContext context) async {
  final status = context.read<PlanProvider>().status;
  final expiry = status.rentalExpiresAt;
  if (expiry == null || status.rentalPots > 0) return;
  if (expiry.isAfter(DateTime.now())) return;

  final storage = context.read<SecureStorage>();
  final iso = expiry.toIso8601String();
  if (await storage.getRentalNoticeShownFor() == iso) return;
  await storage.markRentalNoticeShown(iso);

  if (!context.mounted) return;
  await showRentalExpiredDialog(
    context,
    status: status,
    plants: context.read<PlantsProvider>().userPlants,
  );
}
