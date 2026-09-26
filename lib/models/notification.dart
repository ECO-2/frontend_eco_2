class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String? referenceId;
  final DateTime? readAt;
  final DateTime sentAt;

  /// Para las notificaciones que sintetiza la app (logro desbloqueado, planta
  /// añadida): qué clase de aviso es y el nombre que va dentro. Se guardan por
  /// separado del [title] porque el texto visible depende del idioma, y el
  /// provider que las crea no tiene BuildContext con el que traducir.
  final String? localKind;
  final String? localSubject;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.referenceId,
    this.readAt,
    required this.sentAt,
    this.localKind,
    this.localSubject,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      referenceId: json['reference_id'] as String?,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at'] as String) : null,
      sentAt: DateTime.parse(json['sent_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'reference_id': referenceId,
      'read_at': readAt?.toIso8601String(),
      'sent_at': sentAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? referenceId,
    DateTime? readAt,
    DateTime? sentAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      referenceId: referenceId ?? this.referenceId,
      readAt: readAt ?? this.readAt,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}
