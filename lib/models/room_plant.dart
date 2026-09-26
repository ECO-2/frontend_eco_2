class RoomPlant {
  final String roomId;
  final String userPlantId;

  RoomPlant({
    required this.roomId,
    required this.userPlantId,
  });

  factory RoomPlant.fromJson(Map<String, dynamic> json) {
    return RoomPlant(
      roomId: json['room_id'] as String,
      userPlantId: json['user_plant_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'user_plant_id': userPlantId,
    };
  }

  RoomPlant copyWith({
    String? roomId,
    String? userPlantId,
  }) {
    return RoomPlant(
      roomId: roomId ?? this.roomId,
      userPlantId: userPlantId ?? this.userPlantId,
    );
  }
}
