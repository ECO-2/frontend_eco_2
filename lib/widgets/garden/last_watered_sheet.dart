import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/cloudinary_transform.dart';

/// Respuesta a "¿cuándo regaste esta planta por última vez?".
///
/// [date] nulo significa que el usuario no lo sabe o nunca la regó: en ese
/// caso el ciclo de riego empieza hoy.
class LastWateredAnswer {
  final DateTime? date;
  const LastWateredAnswer(this.date);
}

/// Pregunta cuándo se regó la planta por última vez ANTES de registrarla.
///
/// Sin este dato el primer recordatorio se cuenta desde el momento en que se
/// añade, lo que retrasa el aviso en plantas que el usuario ya llevaba tiempo
/// cuidando (y que quizá ya tocaba regar hoy mismo).
///
/// Devuelve `null` si el usuario cierra la hoja sin elegir, para que quien
/// llame pueda cancelar el alta en vez de asumir una respuesta.
Future<LastWateredAnswer?> askLastWatered(
  BuildContext context, {
  required String plantName,
  String? imageUrl,
}) {
  return showModalBottomSheet<LastWateredAnswer>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) =>
        _LastWateredSheet(plantName: plantName, imageUrl: imageUrl),
  );
}

class _LastWateredSheet extends StatelessWidget {
  final String plantName;
  final String? imageUrl;

  const _LastWateredSheet({required this.plantName, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Acompañamiento visual: deja claro de qué planta hablamos,
              // sobre todo cuando se añaden varias seguidas.
              _PlantThumb(imageUrl: imageUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.lastWateredQuestion(plantName),
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.lastWateredHelpShort,
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
          ),
          const SizedBox(height: 24),
          _Option(
            label: AppLocalizations.of(context)!.today,
            icon: Icons.today_rounded,
            onTap: () => Navigator.pop(context, LastWateredAnswer(now)),
          ),
          _Option(
            label: AppLocalizations.of(context)!.yesterday,
            icon: Icons.history_rounded,
            onTap: () => Navigator.pop(
              context,
              LastWateredAnswer(now.subtract(const Duration(days: 1))),
            ),
          ),
          _Option(
            label: AppLocalizations.of(context)!.someDaysAgo,
            icon: Icons.calendar_month_rounded,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: now.subtract(const Duration(days: 3)),
                // Un riego de hace más de un año no aporta nada al cálculo.
                firstDate: now.subtract(const Duration(days: 365)),
                lastDate: now,
                helpText: AppLocalizations.of(context)!.lastWatering,
              );
              if (picked == null) return;
              if (!context.mounted) return;
              Navigator.pop(context, LastWateredAnswer(picked));
            },
          ),
          _Option(
            label: AppLocalizations.of(context)!.neverOrDontRemember,
            icon: Icons.help_outline_rounded,
            onTap: () => Navigator.pop(context, const LastWateredAnswer(null)),
          ),
        ],
      ),
    );
  }
}

/// Miniatura de la especie. Cae en un icono neutro si no hay foto o si la
/// descarga falla, para que la hoja nunca se rompa por una imagen ausente.
class _PlantThumb extends StatelessWidget {
  final String? imageUrl;

  const _PlantThumb({this.imageUrl});

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4EF),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: url == null || url.isEmpty
          ? const Icon(Icons.local_florist_rounded,
              color: AppColors.primary, size: 30)
          : CachedNetworkImage(
              imageUrl: withTransparentBackground(url),
              fit: BoxFit.contain,
              placeholder: (_, _) => const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, _, _) => const Icon(
                Icons.local_florist_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
    );
  }
}

class _Option extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _Option({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: const Color(0xFFF5F7F4),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon, size: 22, color: AppColors.primary),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
