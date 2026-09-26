class SnapshotScore {
  final String id;
  final String snapshotId;
  final String scoreId;

  SnapshotScore({
    required this.id,
    required this.snapshotId,
    required this.scoreId,
  });

  factory SnapshotScore.fromJson(Map<String, dynamic> json) {
    return SnapshotScore(
      id: json['id'] as String,
      snapshotId: json['snapshot_id'] as String,
      scoreId: json['score_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'snapshot_id': snapshotId,
      'score_id': scoreId,
    };
  }

  SnapshotScore copyWith({
    String? id,
    String? snapshotId,
    String? scoreId,
  }) {
    return SnapshotScore(
      id: id ?? this.id,
      snapshotId: snapshotId ?? this.snapshotId,
      scoreId: scoreId ?? this.scoreId,
    );
  }
}
