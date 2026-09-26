import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/catalog_labels.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';
import 'package:frontend_eco_2/utils/watering_status.dart';
import 'package:frontend_eco_2/utils/cloudinary_transform.dart';
import 'package:frontend_eco_2/widgets/garden/needs_water_badge.dart';
import 'tag_chips_row.dart';

// ── Species metadata ──────────────────────────────────────────────────────────
class PlantSpeciesInfo {
  final String scientificName;
  final List<String> tags;
  final Color imageBackgroundColor;
  final String? assetImage;
  final String? imageUrl;
  final IconData placeholderIcon;
  final Color placeholderIconColor;

  const PlantSpeciesInfo({
    required this.scientificName,
    required this.tags,
    this.imageBackgroundColor = const Color(0xFFEAF3EC),
    this.assetImage,
    this.imageUrl,
    this.placeholderIcon = Icons.local_florist_rounded,
    this.placeholderIconColor = const Color(0xFF10454F),
  });

  // Real catalog species (real UUID from el backend) tienen su propia foto
  // real (imageUrl); solo caen al ícono por categoría si no la tienen.
  factory PlantSpeciesInfo.fromReal(PlantSpecies species) {
    final visual = visualForCategory(species.category);
    return PlantSpeciesInfo(
      scientificName: species.scientificName,
      tags: const [], // se resuelven traducidos en el widget
      imageBackgroundColor: visual.background,
      imageUrl: species.imageUrl,
      placeholderIcon: visual.icon,
      placeholderIconColor: visual.color,
    );
  }
}

// _legacySpeciesInfo (mocks s1-s5) eliminado: sus IDs no existen en el
// catálogo real, que usa UUID, así que nunca se resolvían.

PlantSpeciesInfo _infoFor(String speciesId, PlantSpecies species) =>
    PlantSpeciesInfo.fromReal(species);

// ── Dashboard vertical card ───────────────────────────────────────────────────
class PlantCard extends StatelessWidget {
  final UserPlant plant;
  final PlantSpecies species;
  final File? customPhoto;
  final VoidCallback onTap;

  const PlantCard({
    super.key,
    required this.plant,
    required this.species,
    this.customPhoto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Mismo cálculo que el resto de la app. Antes esta tarjeta usaba su
    // propia regla (7 días fijos, y 10 inventados si no había riego), así
    // que podía contradecir a la lista y al detalle.
    final needsWater =
        WateringStatus.of(plant, species.waterFrequencyDays).needsWater;
    final info = _infoFor(plant.speciesId, species);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE5EAE7),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image area ────────────────────────────────────────
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // Sin foto: fondo de color de la categoría, para que el
                      // ícono resalte. Con foto (propia o real): sin fondo —
                      // transparente — y BoxFit.contain, para que se vea
                      // completa, sin recortarla ni deformarla.
                      color: (customPhoto != null || info.imageUrl != null)
                          ? Colors.transparent
                          : info.imageBackgroundColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: customPhoto != null
                          ? Image.file(customPhoto!, fit: BoxFit.contain)
                          : info.imageUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: withTransparentBackground(info.imageUrl!),
                                  fit: BoxFit.contain,
                                  placeholder: (_, _) => const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                  errorWidget: (_, _, _) => Icon(
                                    info.placeholderIcon,
                                    size: 48,
                                    color: info.placeholderIconColor.withValues(alpha: 0.55),
                                  ),
                                )
                              : info.assetImage != null
                                  ? Image.asset(
                                      info.assetImage!,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, _, _) => Icon(
                                        info.placeholderIcon,
                                        size: 48,
                                        color: info.placeholderIconColor.withValues(alpha: 0.55),
                                      ),
                                    )
                                  : Icon(
                                      info.placeholderIcon,
                                      size: 48,
                                      color: info.placeholderIconColor.withValues(alpha: 0.55),
                                    ),
                    ),
                  ),
                  // Cartel de riego — solo cuando hace falta. Antes se pintaba
                  // siempre con el texto "! Riego" y solo cambiaba el color,
                  // así que una planta al día también parecía necesitar agua.
                  Positioned(
                    top: 10,
                    right: 10,
                    child: NeedsWaterBadge(needsWater: needsWater),
                  ),
                ],
              ),
            ),

            // ── Info area ─────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.nickname,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontFamily: 'DM Sans',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    info.scientificName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontFamily: 'DM Sans',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Tag chips — una sola línea con scroll horizontal para no
                  // deformar el área de la imagen si hay varios tags o son
                  // largos (ver tag_chips_row.dart).
                  TagChipsRow(
                    tags: speciesTags(
                      context,
                      category: species.category,
                      lightRequirement: species.lightRequirement,
                      waterFrequencyDays: species.waterFrequencyDays,
                    ).take(3).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
