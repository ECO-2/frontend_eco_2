class StoreItem {
  final String id;
  final String name;
  final int seedCost;
  final String itemType;
  final bool active;

  StoreItem({
    required this.id,
    required this.name,
    required this.seedCost,
    required this.itemType,
    required this.active,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'] as String,
      name: json['name'] as String,
      seedCost: json['seed_cost'] as int,
      itemType: json['item_type'] as String,
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'seed_cost': seedCost,
      'item_type': itemType,
      'active': active,
    };
  }

  StoreItem copyWith({
    String? id,
    String? name,
    int? seedCost,
    String? itemType,
    bool? active,
  }) {
    return StoreItem(
      id: id ?? this.id,
      name: name ?? this.name,
      seedCost: seedCost ?? this.seedCost,
      itemType: itemType ?? this.itemType,
      active: active ?? this.active,
    );
  }
}
