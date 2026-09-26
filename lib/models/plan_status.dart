/// Estado del plan del usuario y cuánto lleva consumido.
///
/// Los topes llegan como `null` cuando son ilimitados (O2+ activo), no como un
/// número grande: así la app no tiene que conocer las cifras del plan gratuito
/// ni quedarse desfasada si cambian en el backend.
class PlanStatus {
  final String planType;
  final DateTime? expiresAt;
  final bool isPlusActive;

  final int plantsUsed;
  final int? plantsLimit;

  /// Macetas conservadas de un O2+ ya caducado (aterrizaje suave).
  final int legacyPots;

  /// Macetas de alquiler vigentes y cuando vencen.
  final int rentalPots;
  final DateTime? rentalExpiresAt;

  final int scansUsedToday;
  final int? scansLimit;

  const PlanStatus({
    required this.planType,
    this.expiresAt,
    required this.isPlusActive,
    required this.plantsUsed,
    this.plantsLimit,
    this.legacyPots = 0,
    this.rentalPots = 0,
    this.rentalExpiresAt,
    required this.scansUsedToday,
    this.scansLimit,
  });

  /// Estado por defecto mientras no ha cargado: se asume plan gratuito sin
  /// consumo, que es lo conservador — nunca muestra la insignia O2+ de más.
  factory PlanStatus.unknown() => const PlanStatus(
        planType: 'free',
        isPlusActive: false,
        plantsUsed: 0,
        scansUsedToday: 0,
      );

  factory PlanStatus.fromJson(Map<String, dynamic> json) {
    return PlanStatus(
      planType: json['plan_type'] as String? ?? 'free',
      expiresAt: json['plan_expires_at'] != null
          ? DateTime.tryParse(json['plan_expires_at'] as String)
          : null,
      isPlusActive: json['is_plus_active'] as bool? ?? false,
      plantsUsed: json['plants_used'] as int? ?? 0,
      plantsLimit: json['plants_limit'] as int?,
      legacyPots: json['legacy_pots'] as int? ?? 0,
      rentalPots: json['rental_pots'] as int? ?? 0,
      rentalExpiresAt: json['rental_expires_at'] != null
          ? DateTime.tryParse(json['rental_expires_at'] as String)
          : null,
      scansUsedToday: json['scans_used_today'] as int? ?? 0,
      scansLimit: json['scans_limit'] as int?,
    );
  }

  /// Escaneos que le quedan hoy, o null si son ilimitados.
  int? get scansLeftToday {
    final limit = scansLimit;
    if (limit == null) return null;
    final left = limit - scansUsedToday;
    return left < 0 ? 0 : left;
  }

  /// Macetas libres, o null si son ilimitadas.
  int? get plantSlotsLeft {
    final limit = plantsLimit;
    if (limit == null) return null;
    final left = limit - plantsUsed;
    return left < 0 ? 0 : left;
  }

  bool get hasReachedPlantLimit => plantSlotsLeft == 0;

  /// Lo que le queda al alquiler, o null si no hay ninguno vigente.
  Duration? get rentalTimeLeft {
    final until = rentalExpiresAt;
    if (rentalPots <= 0 || until == null) return null;
    final left = until.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  /// Dias que le quedan al alquiler, o null si no hay ninguno vigente.
  ///
  /// Se redondea hacia arriba: mientras quede algo de hoy, el usuario todavia
  /// tiene "1 dia", no cero.
  int? get rentalDaysLeft {
    final left = rentalTimeLeft;
    if (left == null) return null;
    return (left.inMinutes / (60 * 24)).ceil();
  }

  /// El alquiler esta a punto de vencer y conviene avisar con mas enfasis.
  bool get rentalEndsSoon {
    final days = rentalDaysLeft;
    return days != null && days <= 3;
  }
  bool get hasReachedScanLimit => scansLeftToday == 0;
}
