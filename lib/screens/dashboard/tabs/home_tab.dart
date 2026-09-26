import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/utils/pot_labels.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/plant_card.dart';
import 'package:frontend_eco_2/widgets/garden/add_plant_modal.dart';
import 'package:frontend_eco_2/utils/achievement_ui.dart';
import 'package:frontend_eco_2/utils/co2_estimate.dart';
import 'package:frontend_eco_2/utils/achievement_labels.dart';
import 'package:frontend_eco_2/widgets/common/plus_badge.dart';

/// Estilo unico de los titulos de seccion del dashboard.
///
/// Estaban escritos a mano en cada sitio y habian divergido: "Mi Jardin" y
/// "Mi Huella Verde" iban a 22 en DM Sans, mientras "Mision Activa" se habia
/// quedado en 16 con Inter, asi que la pantalla se veia despareja.
const TextStyle kDashboardSectionTitle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: AppColors.textPrimary,
  fontFamily: 'DM Sans',
);


class HomeTab extends StatelessWidget {
  final VoidCallback onViewAll;

  const HomeTab({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final user = Provider.of<UserProvider>(context).currentUser;
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final missionsProvider = Provider.of<MissionsProvider>(context);
    final plants = plantsProvider.userPlants;

    final screenWidth = MediaQuery.of(context).size.width;
    final childAspectRatio = screenWidth < 360 ? 0.75 : 0.83;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 35;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 2,
        bottom: bottomPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Mi Jardín section ─────────────────────────
          _buildSectionHeader(
            title: l.myGarden,
            actionLabel: '${l.viewAll}  →',
            onAction: onViewAll,
            showGardenIcon: true,
          ),
          const SizedBox(height: 14),

          // ── Plants Grid ───────────────────────────────
          if (plants.isEmpty)
            _buildEmptyGarden(context)
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: plants.length >= 4 ? 4 : plants.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                if (index < plants.length) {
                  final plant = plants[index];
                  return PlantCard(
                    plant: plant,
                    species: plantsProvider.speciesCatalog.firstWhere(
                      (s) => s.id == plant.speciesId,
                      orElse: () => PlantSpecies(
                        id: plant.speciesId,
                        scientificName: 'Especie desconocida',
                        commonName: 'Planta',
                        waterFrequencyDays: 7,
                        createdAt: DateTime.now(),
                      ),
                    ),
                    customPhoto: plantsProvider.customPhotoFor(plant.id),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.plantDetail,
                      arguments: plant,
                    ),
                  );
                } else {
                  return _buildGridAddPlantCard(context, plants.length);
                }
              },
            ),
          const SizedBox(height: 24),

          // ── O2+ Banner ────────────────────────────────
          _buildO2Banner(context),
          const SizedBox(height: 16),

          // ── Mi Huella Verde header ────────────────────
          Row(
            children: [
              Text(l.greenFootprint, style: kDashboardSectionTitle),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF99A477),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'CO₂',
                  style: TextStyle(
                    color: Color(0xFF0D2B31),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── CO2 Block ─────────────────────────────────
          _buildCO2Block(context, plantsProvider),
          const SizedBox(height: 24),

          // ── Misión Activa ─────────────────────────────
          Text(
            AppLocalizations.of(context)!.activeMissionCard,
            style: kDashboardSectionTitle,
          ),
          const SizedBox(height: 12),
          _buildMissionCard(context, missionsProvider),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionLabel,
    required VoidCallback onAction,
    // Antes se comparaba el título con el literal 'Mi Jardín', lo que dejaba
    // de funcionar en cuanto el texto se traduce.
    bool showGardenIcon = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(title, style: kDashboardSectionTitle),
            if (showGardenIcon) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textPrimary, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.spa_rounded,
                  color: AppColors.textPrimary,
                  size: 14,
                ),
              ),
            ],
          ],
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8FA89F),
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyGarden(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.eco_outlined, color: AppColors.primary, size: 32),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.gardenEmpty,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontFamily: 'Inter',
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const AddPlantModal(),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+ ${AppLocalizations.of(context)!.addPlant}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildO2Banner(BuildContext context) {
    final plan = context.watch<PlanProvider>();
    final isPlus = plan.isPlusActive;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        isPlus ? AppLocalizations.of(context)!.plusMember : AppLocalizations.of(context)!.unlockO2Features,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    if (isPlus) ...[
                      const SizedBox(width: 8),
                      const PlusBadge(compact: true),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isPlus
                      ? AppLocalizations.of(context)!.plusUnlimitedSummary
                      : AppLocalizations.of(context)!.redeemSeedsOrSubscribeShort,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.premiumUpgrade),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent, width: 1),
              ),
              child: Row(
                children: [
                  Text(isPlus ? AppLocalizations.of(context)!.manage : AppLocalizations.of(context)!.view,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '→',
                    style: TextStyle(color: AppColors.accent, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCO2Block(BuildContext context, PlantsProvider plantsProvider) {
    // Estimación real a partir de las plantas del usuario. Antes este
    // bloque mostraba "12.4 g/dia" escrito a mano: el mismo número para
    // todo el mundo, tuviera 0 o 20 plantas.
    final co2 = Co2Estimate.forPlants(
      plantsProvider.userPlants,
      speciesById: {for (final s in plantsProvider.speciesCatalog) s.id: s},
    );
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.greenFootprint),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF10454F), Color(0xFF99A477)],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            // Left: label + value
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'CO₂',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          fontFamily: 'DM Sans',
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'hoy',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${co2.gramsPerDay.toStringAsFixed(1)} ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.gramsPerDayUnit,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Right: CO2 circular badge
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFF10454F).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF99A477),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'CO₂',
                  style: TextStyle(
                    color: Color(0xFF0D2B31),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, MissionsProvider mp) {
    // Sin backend de "misiones" real, se muestra el logro rastreable más
    // cercano a completarse (mismo criterio que Misiones/Trofeos) en vez de
    // un progreso inventado a partir de las semillas.
    final candidates = mp.lockedAchievements
        .where((a) => kTrackableAchievementConditions.contains(a.conditionType))
        .toList()
      ..sort((a, b) =>
          (a.conditionValue - mp.progressFor(a)).compareTo(b.conditionValue - mp.progressFor(b)));

    if (candidates.isEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25), width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.emoji_events_rounded, color: AppColors.primary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.allAchievementsDone,
                style: const TextStyle(color: AppColors.textPrimary, fontFamily: 'Inter'),
              ),
            ),
          ],
        ),
      );
    }

    final achievement = candidates.first;
    final current = mp.progressFor(achievement);
    final clampedProgress =
        achievement.conditionValue == 0 ? 1.0 : (current / achievement.conditionValue).clamp(0.0, 1.0);
    final unitLabel = achievement.conditionType == AchievementConditions.careLogs
        ? AppLocalizations.of(context)!.unitCares
        : AppLocalizations.of(context)!.unitPlants;

    return PressableCard(
      onTap: () => showAchievementDetailSheet(
        context,
        achievement: achievement,
        unlocked: false,
        currentProgress: current,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
        children: [
          Row(
            children: [
              // Mission info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // El nombre llega del backend en espanol; se traduce por
                      // condicion + valor, igual que en Misiones y Trofeos.
                      achievementName(context, achievement),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColors.textPrimary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      achievement.conditionType == AchievementConditions.onboardingCompleted
                          ? (current >= achievement.conditionValue
                              ? AppLocalizations.of(context)!.completed
                              : AppLocalizations.of(context)!.pending)
                          : '$current/${achievement.conditionValue} $unitLabel',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              // Mission trophy icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: clampedProgress,
              minHeight: 10,
              backgroundColor: const Color(0xFFE8ECE9),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Reward badge
          Align(
            alignment: Alignment.centerRight,
            child: RewardBadges(xp: achievement.xpReward, seeds: achievement.seedReward),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildGridAddPlantCard(BuildContext context, int plantCount) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const AddPlantModal(),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned.fill(
              child: CustomPaint(
                painter: _DashedCornerPainter(color: Color(0xFF8FA89F)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '+',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF8FA89F),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.spa_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.addPlant,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    potsCaption(context, context.watch<PlanProvider>().status, plantCount),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 11,
                      color: Color(0xFF8FA89F),
                      height: 1.2,
                    ),
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

class _DashedCornerPainter extends CustomPainter {
  final Color color;
  const _DashedCornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final double r = 16.0; // Corner radius
    final double l = 8.0; // Extension length
    final double w = size.width;
    final double h = size.height;

    final path = Path();

    // Top-left
    path.moveTo(r + l, 0);
    path.lineTo(r, 0);
    path.arcToPoint(Offset(0, r), radius: Radius.circular(r), clockwise: false);
    path.lineTo(0, r + l);

    // Top-right
    path.moveTo(w - (r + l), 0);
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r), clockwise: true);
    path.lineTo(w, r + l);

    // Bottom-left
    path.moveTo(0, h - (r + l));
    path.lineTo(0, h - r);
    path.arcToPoint(Offset(r, h), radius: Radius.circular(r), clockwise: false);
    path.lineTo(r + l, h);

    // Bottom-right
    path.moveTo(w, h - (r + l));
    path.lineTo(w, h - r);
    path.arcToPoint(
      Offset(w - r, h),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(w - (r + l), h);

    _drawDashedPath(canvas, path, paint, 3.0, 3.0);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double dashLength,
    double gapLength,
  ) {
    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final length = dashLength;
        final drawLength = (distance + length < pathMetric.length)
            ? length
            : pathMetric.length - distance;
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + drawLength),
          paint,
        );
        distance += length + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCornerPainter oldDelegate) =>
      color != oldDelegate.color;
}
