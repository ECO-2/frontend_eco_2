import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/achievement_visuals.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/utils/date_labels.dart';
import 'package:frontend_eco_2/utils/achievement_labels.dart';

/// Condiciones para las que hoy existe un contador real en la app. El resto
/// (plant_scans, rooms_created) no tiene una feature real detrás todavía —
/// se muestran aparte como "próximamente" en vez de fingir progreso.
/// Compartido entre missions_tab.dart y trophies_screen.dart para no
/// duplicar el criterio en dos lugares.
const kTrackableAchievementConditions = {
  AchievementConditions.userPlants,
  AchievementConditions.careLogs,
  AchievementConditions.onboardingCompleted,
};

IconData iconForAchievementCondition(String conditionType) {
  switch (conditionType) {
    case AchievementConditions.userPlants:
      return Icons.park_rounded;
    case AchievementConditions.careLogs:
      return Icons.water_drop_rounded;
    case AchievementConditions.onboardingCompleted:
      return Icons.flag_rounded;
    case AchievementConditions.plantScans:
      return Icons.search_rounded;
    case AchievementConditions.roomsCreated:
      return Icons.home_rounded;
    default:
      return Icons.emoji_events_rounded;
  }
}

String achievementProgressLabel(
    BuildContext context, Achievement a, int current) {
  final l = AppLocalizations.of(context)!;
  switch (a.conditionType) {
    case AchievementConditions.userPlants:
      return l.progressOfPlants(current, a.conditionValue);
    case AchievementConditions.careLogs:
      return l.progressOfCares(current, a.conditionValue);
    case AchievementConditions.onboardingCompleted:
      return current >= a.conditionValue ? l.completed : l.pending;
    default:
      return l.comingSoon;
  }
}

/// Fila compacta de insignias "+XP" / "+semillas" — la misma pareja de
/// recompensas se repite en las tarjetas de misiones, trofeos y en la hoja
/// de detalle, así que se centraliza acá.
class RewardBadges extends StatelessWidget {
  final int xp;
  final int seeds;
  final double fontSize;
  final bool compact;

  const RewardBadges({
    super.key,
    required this.xp,
    required this.seeds,
    this.fontSize = 11,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _badge(
          icon: Icons.bolt_rounded,
          label: '+$xp XP',
          bg: AppColors.accent,
          fg: AppColors.textPrimary,
        ),
        if (seeds > 0)
          _badge(
            icon: Icons.spa_rounded,
            label: '+$seeds',
            bg: AppColors.gold.withValues(alpha: 0.18),
            fg: const Color(0xFF8A5A00),
          ),
      ],
    );
  }

  Widget _badge({required IconData icon, required String label, required Color bg, required Color fg}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: compact ? 4 : 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(compact ? 10 : 14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize + 1, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: fontSize,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

/// Envoltorio con feedback táctil (escala al presionar) para volver
/// "interactiva" cualquier tarjeta de logro/misión sin repetir el gesture
/// handling en cada pantalla.
class PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const PressableCard({super.key, required this.child, required this.onTap});

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}

/// Hoja de detalle de un logro/misión: descripción completa, progreso real
/// y desglose de recompensa (XP + semillas). Se abre al tocar cualquier
/// tarjeta en Misiones o Trofeos.
void showAchievementDetailSheet(
  BuildContext context, {
  required Achievement achievement,
  required bool unlocked,
  required int currentProgress,
  DateTime? unlockedAt,
}) {
  final trackable = kTrackableAchievementConditions.contains(achievement.conditionType);
  final progress = !trackable || achievement.conditionValue == 0
      ? (unlocked ? 1.0 : 0.0)
      : (currentProgress / achievement.conditionValue).clamp(0.0, 1.0);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + MediaQuery.of(context).padding.bottom),
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
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: unlocked ? const Color(0xFFFEF8E7) : const Color(0xFFECECEC),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    unlocked ? visualForAchievement(achievement).icon : Icons.lock_rounded,
                    color: unlocked
                        ? visualForAchievement(achievement).color
                        : const Color(0xFF909090),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievementName(context, achievement),
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unlocked ? 'Logro desbloqueado' : 'Logro bloqueado',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: unlocked ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (achievementDescription(context, achievement) != null) ...[
              const SizedBox(height: 16),
              Text(
                achievementDescription(context, achievement)!,
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 18),
            if (trackable) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    achievementProgressLabel(context, achievement, currentProgress),
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFECECEC),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                ),
              ),
            ] else
              Text(
                unlocked ? '' : AppLocalizations.of(context)!.conditionNotTracked,
                style: const TextStyle(fontFamily: 'DM Sans', fontSize: 12, color: AppColors.textSecondary),
              ),
            if (unlocked && unlockedAt != null) ...[
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!
                    .unlockedOn(formatMediumDate(context, unlockedAt)),
                style: const TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.reward,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            RewardBadges(xp: achievement.xpReward, seeds: achievement.seedReward, fontSize: 12),
          ],
        ),
      );
    },
  );
}

