class Co2DailyAverage {
  final String date;
  final int avgPpm;

  Co2DailyAverage({required this.date, required this.avgPpm});

  factory Co2DailyAverage.fromJson(Map<String, dynamic> json) {
    return Co2DailyAverage(
      date: json['date'] as String,
      avgPpm: json['avg_ppm'] as int,
    );
  }
}

class Co2Summary {
  final int? currentPpm;
  final String? recordedAt;
  final List<Co2DailyAverage> last7Days;

  Co2Summary({
    required this.currentPpm,
    required this.recordedAt,
    required this.last7Days,
  });

  factory Co2Summary.fromJson(Map<String, dynamic> json) {
    return Co2Summary(
      currentPpm: json['current_ppm'] as int?,
      recordedAt: json['recorded_at'] as String?,
      last7Days: (json['last7Days'] as List<dynamic>)
          .map((e) => Co2DailyAverage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}