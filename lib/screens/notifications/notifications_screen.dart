import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/achievement_labels.dart';

const _kDark = Color(0xFF10454F);
const _kBg = Color(0xFFF8FAF9);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  /// Reconstruye las notificaciones a partir del estado real de la app cada
  /// vez que se abre esta pantalla — antes eran 6 notificaciones fijas sin
  /// relación con los datos del usuario.
  void _sync() {
    if (!mounted) return;
    final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);
    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
    final notifProvider = Provider.of<NotificationsProvider>(context, listen: false);

    final plantsNeedingWater = plantsProvider.userPlants.where((p) {
      final species = plantsProvider.speciesCatalog.firstWhere(
        (s) => s.id == p.speciesId,
        orElse: () => PlantSpecies(
          id: p.speciesId,
          scientificName: '',
          commonName: '',
          waterFrequencyDays: 7,
          createdAt: DateTime.now(),
        ),
      );
      if (p.lastWateredAt == null) return true;
      return DateTime.now().difference(p.lastWateredAt!).inDays >= species.waterFrequencyDays;
    }).map((p) => (plantId: p.id, plantNickname: p.nickname)).toList();

    final l = AppLocalizations.of(context)!;
    final recentAchievements = missionsProvider.unlockedAchievements.map((ua) {
      final achievement = missionsProvider.achievements
          .where((a) => a.id == ua.achievementId);
      // El nombre pasa por el traductor de logros: el que viene del backend
      // esta en espanol. Antes tambien se pegaba " semillas" a mano, que en
      // ingles quedaba mezclado.
      final title = achievement.isEmpty
          ? l.achievementUnlockedTitle
          : achievementName(context, achievement.first);
      return (achievementId: ua.achievementId, title: title, unlockedAt: ua.unlockedAt);
    }).toList();

    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    final recentlyAddedPlants = plantsProvider.userPlants
        .where((p) => p.createdAt.isAfter(cutoff))
        .map((p) => (plantId: p.id, plantNickname: p.nickname, addedAt: p.createdAt))
        .toList();

    notifProvider.syncFromAppState(
      plantsNeedingWater: plantsNeedingWater,
      recentAchievements: recentAchievements,
      recentlyAddedPlants: recentlyAddedPlants,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifProvider = Provider.of<NotificationsProvider>(context);

    // Antes solo habia dos grupos, partidos por 12 horas, y el segundo se
    // titulaba "esta semana" aunque contuviera cosas de hace meses.
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfWeek = startOfToday.subtract(const Duration(days: 7));

    final ordered = [...notifProvider.notifications]
      ..sort((a, b) => b.sentAt.compareTo(a.sentAt));

    final todayNotifications =
        ordered.where((n) => !n.sentAt.isBefore(startOfToday)).toList();
    final weekNotifications = ordered
        .where((n) =>
            n.sentAt.isBefore(startOfToday) && !n.sentAt.isBefore(startOfWeek))
        .toList();
    final earlierNotifications =
        ordered.where((n) => n.sentAt.isBefore(startOfWeek)).toList();

    return Scaffold(
      backgroundColor: _kBg,
      body: Column(
        children: [
          // ── Dark teal header ──────────────────────────────────
          _NotifHeader(
            unreadCount: notifProvider.unreadCount,
            onMarkAllRead: () {
              notifProvider.markAllAsRead();
              showAppToast(
                context,
                AppLocalizations.of(context)!.allNotificationsRead,
                duration: const Duration(seconds: 1, milliseconds: 400),
              );
            },
          ),
          // ── Lista ────────────────────────────────────────────
          Expanded(
            child: notifProvider.notifications.isEmpty
                ? _buildEmptyState(context)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    children: [
                      if (todayNotifications.isNotEmpty) ...[
                        _sectionLabel(AppLocalizations.of(context)!.todayLabel),
                        ...todayNotifications.map((n) => _buildNotifItem(context, n)),
                      ],
                      if (weekNotifications.isNotEmpty) ...[
                        _sectionLabel(AppLocalizations.of(context)!.thisWeekLabel),
                        ...weekNotifications.map((n) => _buildNotifItem(context, n)),
                      ],
                      if (earlierNotifications.isNotEmpty) ...[
                        _sectionLabel(AppLocalizations.of(context)!.earlierLabel),
                        ...earlierNotifications.map((n) => _buildNotifItem(context, n)),
                      ],
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.thatsAllForNow,
                          style: const TextStyle(
                            color: _kTextMuted,
                            fontSize: 13,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// Estado vacio: antes era un icono gris y una linea de texto tambien gris,
  /// que se leia como un error. Ahora explica que aparecera aqui.
  Widget _buildEmptyState(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.18),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 44,
                color: _kDark,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l.noNotificationsTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: _kTextDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.noNotificationsBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 13,
                height: 1.5,
                color: _kTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Encabezado de grupo. Antes era una banda gris con un divisor encima, que
  /// es lo que daba el aire de lista antigua.
  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: _kTextMuted,
        ),
      ),
    );
  }

  Widget _buildNotifItem(BuildContext context, dynamic notification) {
    final isUnread = notification.readAt == null;

    // Icon config per notification type
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (notification.type) {
      case 'warning':
        icon = Icons.water_drop_rounded;
        iconColor = const Color(0xFF2196F3);
        iconBg = const Color(0xFFE3F2FD);
        break;
      case 'achievement':
        icon = Icons.emoji_events_rounded;
        iconColor = const Color(0xFFFABF2E);
        iconBg = const Color(0xFFFFF8E1);
        break;
      default:
        icon = Icons.info_rounded;
        iconColor = Colors.grey;
        iconBg = const Color(0xFFF0F0F0);
    }

    // Las notificaciones locales traen su tipo y su sujeto por separado, así
    // que se traducen aquí. Las que llegan del backend siguen partiendo el
    // texto por ': ', que es como vienen formadas.
    final l = AppLocalizations.of(context)!;
    final String titleText;
    final String bodyText;
    switch (notification.localKind) {
      case 'achievement_unlocked':
        titleText = l.achievementUnlockedTitle;
        bodyText = notification.localSubject ?? '';
      case 'watering_due':
        titleText = l.wateringDueTitle;
        bodyText = l.wateringDueNotification(notification.localSubject ?? '');
      case 'plant_added':
        titleText = l.newPlantAddedTitle;
        bodyText = l.newPlantAddedBody(notification.localSubject ?? '');
      default:
        final parts = notification.title.split(': ');
        titleText = parts[0];
        bodyText = parts.length > 1 ? parts[1] : '';
    }

    // Tarjeta redondeada en vez de una fila plana. Las no leidas llevan una
    // barra de acento a la izquierda: se distingue de un vistazo sin recurrir a
    // un fondo tintado que ensuciaba la lista.
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ValueKey('notif-${notification.id}'),
        direction: isUnread
            ? DismissDirection.endToStart
            : DismissDirection.none,
        // Deslizar marca como leida, no borra: la lista se reconstruye del
        // estado real de la app al abrirla, asi que una notificacion borrada
        // reaparecería y el gesto se sentiría roto.
        //
        // Por eso se usa confirmDismiss devolviendo false y no onDismissed:
        // onDismissed obliga a que el widget salga del arbol, y aqui la
        // tarjeta se queda -solo cambia a leida-, asi que Flutter lanzaba
        // "A dismissed Dismissible widget is still part of the tree". Al
        // devolver false la tarjeta vuelve a su sitio y el gesto queda hecho.
        confirmDismiss: (_) async {
          Provider.of<NotificationsProvider>(context, listen: false)
              .markAsRead(notification.id);
          showAppToast(
            context,
            AppLocalizations.of(context)!.markedAsRead,
            duration: const Duration(seconds: 1),
          );
          return false;
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: _kDark.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.mark_email_read_rounded,
              color: _kDark, size: 22),
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Provider.of<NotificationsProvider>(context, listen: false)
                  .markAsRead(notification.id);
              _handleNotificationTap(context, notification);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUnread
                      ? AppColors.accent.withValues(alpha: 0.9)
                      : const Color(0xFFE2E7E4),
                  width: isUnread ? 1.4 : 1,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration:
                        BoxDecoration(color: iconBg, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Icon(icon, color: iconColor, size: 21),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                titleText,
                                style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontWeight: isUnread
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  fontSize: 14,
                                  color: _kTextDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatTimeAgo(context, notification.sentAt),
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 11,
                                color: _kTextMuted,
                              ),
                            ),
                            if (isUnread) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(top: 4),
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (bodyText.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            bodyText,
                            style: const TextStyle(
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                              fontSize: 12.5,
                              height: 1.4,
                              color: _kTextMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, dynamic notification) {
    final referenceId = notification.referenceId as String?;
    if (referenceId == null) return;

    if (notification.type == 'warning' || notification.type == 'info') {
      final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);
      final plant = plantsProvider.userPlants.where((p) => p.id == referenceId);
      if (plant.isNotEmpty) {
        Navigator.pushNamed(context, AppRoutes.plantDetail, arguments: plant.first);
      }
    } else if (notification.type == 'achievement') {
      Navigator.pushNamed(context, AppRoutes.trophies);
    }
  }

  String _formatTimeAgo(BuildContext context, DateTime date) {
    final l = AppLocalizations.of(context)!;
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return l.yesterday;
    // El nombre del día lo da intl según el locale activo, en vez de una
    // lista fija en español que habría que mantener por idioma.
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.E(locale).format(date);
  }
}

// ── Notifications header with settings icon ──────────────────────────────
class _NotifHeader extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;

  const _NotifHeader({
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 10,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.notificationsTitle,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          // El contador pasa a ser un boton: antes era una bolita con el
          // numero y la accion de marcar todas vivia suelta sobre la lista.
          if (unreadCount > 0)
            GestureDetector(
              onTap: onMarkAllRead,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.done_all_rounded,
                        size: 14, color: _kTextDark),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.of(context)!.unreadCount(unreadCount),
                      style: const TextStyle(
                        color: _kTextDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
    );
  }
}
