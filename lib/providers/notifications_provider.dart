import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';

class NotificationsProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => n.readAt == null).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && _notifications[index].readAt == null) {
      _notifications[index] = _notifications[index].copyWith(readAt: DateTime.now());
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (_notifications[i].readAt == null) {
        _notifications[i] = _notifications[i].copyWith(readAt: DateTime.now());
      }
    }
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  /// Reconstruye la lista de notificaciones a partir de estado real de la
  /// app (plantas con riego pendiente, logros recién desbloqueados, plantas
  /// agregadas recientemente) — antes esto era una lista de 6 notificaciones
  /// inventadas, sin relación con los datos reales del usuario ni con
  /// ninguna acción al tocarlas.
  ///
  /// [referenceId] queda como el id de la planta/logro relacionado, para que
  /// la UI pueda navegar directo a él al tocar la notificación. El estado
  /// leído/no-leído se conserva entre llamadas por id.
  void syncFromAppState({
    required List<({String plantId, String plantNickname})> plantsNeedingWater,
    required List<({String achievementId, String title, DateTime unlockedAt})> recentAchievements,
    required List<({String plantId, String plantNickname, DateTime addedAt})> recentlyAddedPlants,
  }) {
    final next = <NotificationModel>[];

    for (final p in plantsNeedingWater) {
      next.add(NotificationModel(
        id: 'water:${p.plantId}',
        userId: '',
        type: 'warning',
        referenceId: p.plantId,
        title: p.plantNickname,
        localKind: 'watering_due',
        localSubject: p.plantNickname,
        sentAt: DateTime.now(),
      ));
    }
    for (final a in recentAchievements) {
      next.add(NotificationModel(
        id: 'achv:${a.achievementId}',
        userId: '',
        type: 'achievement',
        referenceId: a.achievementId,
        title: a.title,
        localKind: 'achievement_unlocked',
        localSubject: a.title,
        sentAt: a.unlockedAt,
      ));
    }
    for (final p in recentlyAddedPlants) {
      next.add(NotificationModel(
        id: 'newplant:${p.plantId}',
        userId: '',
        type: 'info',
        referenceId: p.plantId,
        title: p.plantNickname,
        localKind: 'plant_added',
        localSubject: p.plantNickname,
        sentAt: p.addedAt,
      ));
    }

    // Conserva readAt para notificaciones que ya existían con el mismo id.
    for (var i = 0; i < next.length; i++) {
      final previous = _notifications.where((n) => n.id == next[i].id);
      if (previous.isNotEmpty && previous.first.readAt != null) {
        next[i] = next[i].copyWith(readAt: previous.first.readAt);
      }
    }
    next.sort((a, b) => b.sentAt.compareTo(a.sentAt));

    _notifications
      ..clear()
      ..addAll(next);
    notifyListeners();
  }
}
