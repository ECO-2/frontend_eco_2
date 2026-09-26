import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/achievement_feedback.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'care_sheet_content.dart';
import 'species_data.dart';

/// Hoja de "plantas que necesitan atención" — abierta desde el banner de
/// alerta de Mi Jardín. A diferencia del banner (que solo mostraba el
/// nombre de la primera planta), esto lista TODAS las plantas con riego
/// pendiente, con progreso real hacia su próximo riego y una acción rápida
/// para regarlas sin salir del modal.
void showNeedsCareModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _NeedsCareSheet(),
  );
}

class _NeedsCareSheet extends StatefulWidget {
  const _NeedsCareSheet();

  @override
  State<_NeedsCareSheet> createState() => _NeedsCareSheetState();
}

class _NeedsCareSheetState extends State<_NeedsCareSheet> {
  // IDs regadas dentro de esta sesión del modal, para sacarlas de la lista
  // sin tener que cerrar y reabrir el modal.
  final Set<String> _justWatered = {};
  final Set<String> _watering = {};

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);

    final needsCare = plantsProvider.userPlants.where((p) {
      if (_justWatered.contains(p.id)) return false;
      final species = _speciesFor(plantsProvider, p);
      final daysSince = p.lastWateredAt == null
          ? 999
          : DateTime.now().difference(p.lastWateredAt!).inDays;
      return daysSince >= species.waterFrequencyDays;
    }).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.needsAttention,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xFF0D2B31),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        needsCare.isEmpty
                            ? AppLocalizations.of(context)!.allUpToDate
                            : '${needsCare.length} planta${needsCare.length == 1 ? '' : 's'} con riego pendiente',
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 13,
                          color: Color(0xFF807F7F),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F5F4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: Color(0xFF0D2B31)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (needsCare.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 40),
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context)!.noPlantNeedsWater,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'DM Sans', color: Color(0xFF807F7F)),
                      ),
                    ],
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: needsCare.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final plant = needsCare[i];
                    final species = _speciesFor(plantsProvider, plant);
                    return _NeedsCareRow(
                      plant: plant,
                      species: species,
                      isWatering: _watering.contains(plant.id),
                      onWaterNow: () => _waterNow(plant, species, plantsProvider, missionsProvider),
                      onOpenCareSheet: () => _openCareSheet(plant, species),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  PlantSpecies _speciesFor(PlantsProvider plantsProvider, UserPlant plant) {
    return plantsProvider.speciesCatalog.firstWhere(
      (s) => s.id == plant.speciesId,
      orElse: () => PlantSpecies(
        id: plant.speciesId,
        scientificName: 'Especie desconocida',
        commonName: 'Planta',
        waterFrequencyDays: 7,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _waterNow(
    UserPlant plant,
    PlantSpecies species,
    PlantsProvider plantsProvider,
    MissionsProvider missionsProvider,
  ) async {
    setState(() => _watering.add(plant.id));

    final unlocked = await missionsProvider.logCare(userPlantId: plant.id, taskType: 'watering');
    if (unlocked == null) {
      if (!mounted) return;
      setState(() => _watering.remove(plant.id));
      showAppToast(
        context,
        missionsProvider.errorText(context) ??
            AppLocalizations.of(context)!.careLogFailed,
        type: ToastType.error,
      );
      return;
    }

    await plantsProvider.waterPlant(plant.id);
    if (!mounted) return;

    setState(() {
      _watering.remove(plant.id);
      _justWatered.add(plant.id);
    });

    showAppToast(context, AppLocalizations.of(context)!.plantWatered(plant.nickname), type: ToastType.success);
    showAchievementUnlockedSnackbars(context, unlocked);
  }

  void _openCareSheet(UserPlant plant, PlantSpecies species) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CareSheetContent(plant: plant, sp: SpeciesData.fromReal(context, species)),
    );
  }
}

class _NeedsCareRow extends StatelessWidget {
  final UserPlant plant;
  final PlantSpecies species;
  final bool isWatering;
  final VoidCallback onWaterNow;
  final VoidCallback onOpenCareSheet;

  const _NeedsCareRow({
    required this.plant,
    required this.species,
    required this.isWatering,
    required this.onWaterNow,
    required this.onOpenCareSheet,
  });

  @override
  Widget build(BuildContext context) {
    final visual = visualForCategory(species.category);
    final neverWatered = plant.lastWateredAt == null;
    final daysSince =
        neverWatered ? null : DateTime.now().difference(plant.lastWateredAt!).inDays;
    final overdueBy = daysSince == null ? null : daysSince - species.waterFrequencyDays;
    // Progreso hacia el riego: 1.0 = justo en la fecha, puede pasar de 1.0
    // (vencido) — se clampea solo para el ancho de la barra, no para el texto.
    // Sin registro de riego previo se muestra siempre lleno (100% vencido).
    final progress = neverWatered || species.waterFrequencyDays == 0
        ? 1.0
        : (daysSince! / species.waterFrequencyDays).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onOpenCareSheet,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFDFC2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: visual.background,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(visual.icon, color: visual.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.nickname,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF0D2B31),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFF0E2D2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF56B1C)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    neverWatered
                        ? 'Nunca registrada — necesita riego'
                        : overdueBy! > 0
                            ? AppLocalizations.of(context)!.overdueByDays(overdueBy)
                            : 'Necesita riego hoy',
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB94E13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: isWatering ? null : onWaterNow,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2B31),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: isWatering
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.water_drop_rounded, size: 13, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(AppLocalizations.of(context)!.waterAction,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
