import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/utils/app_tour.dart';
import 'package:frontend_eco_2/widgets/common/plus_badge.dart';

class DashboardHeader extends StatelessWidget implements PreferredSizeWidget {
  // Solo se pasan desde DashboardScreen, para el recorrido guiado.
  final GlobalKey? seedsKey;
  final GlobalKey? trophyKey;
  final GlobalKey? bellKey;

  const DashboardHeader({super.key, this.seedsKey, this.trophyKey, this.bellKey});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final userProvider = Provider.of<UserProvider>(context);
    final missionsProvider = Provider.of<MissionsProvider>(context);
    final notificationsProvider = Provider.of<NotificationsProvider>(context);

    final username = userProvider.currentUser?.username ?? 'Usuario';
    final seeds = missionsProvider.userSeeds;
    final unreadNotifications = notificationsProvider.unreadCount;
    final hasCompletedAchievements =
        missionsProvider.completedAchievementIds.isNotEmpty;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          children: [
            // Status bar area (darker teal)
            Container(height: statusBarHeight, color: AppColors.primaryDark),
            // Greeting area (lighter teal)
            Container(
              color: AppColors.primary,
              padding: const EdgeInsets.only(
                top: 10,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.greeting,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Insignia O2+ junto al nombre: es lo primero que
                            // se ve al abrir la app, asi que el dashboard deja
                            // de no dar ninguna senal de la suscripcion.
                            if (context.watch<PlanProvider>().isPlusActive) ...[
                              const SizedBox(width: 8),
                              const PlusBadge(compact: true),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Seed balance pill
                  wrapWithTourStep(
                    key: seedsKey,
                    title: AppLocalizations.of(context)!.yourSeeds,
                    description: AppLocalizations.of(context)!.tourSeedsDesc,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.spa_rounded,
                              color: AppColors.accent,
                              size: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$seeds Semillas',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── BOTTOM WHITE SECTION ────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5EAE7), width: 1.2),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // Trophy icon with badge
                  wrapWithTourStep(
                    key: trophyKey,
                    title: AppLocalizations.of(context)!.achievementsAndMissionsTitle,
                    description: AppLocalizations.of(context)!.tourTrophyDesc,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.trophies);
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.emoji_events_outlined,
                            color: AppColors.textPrimary,
                            size: 28,
                          ),
                          if (hasCompletedAchievements)
                            Positioned(
                              top: -1,
                              right: -1,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Bell icon with badge
                  wrapWithTourStep(
                    key: bellKey,
                    title: AppLocalizations.of(context)!.notificationsTitle,
                    description: AppLocalizations.of(context)!.tourNotificationsDesc,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.notifications);
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.textPrimary,
                            size: 28,
                          ),
                          if (unreadNotifications > 0)
                            Positioned(
                              top: -1,
                              right: -1,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                        ],
                      ),
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

  @override
  Size get preferredSize => const Size.fromHeight(160.0);
}
