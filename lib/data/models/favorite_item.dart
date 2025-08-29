class FavoriteItem {
  final String id;
  final String foodItemId;
  final String userId;
  final DateTime createdAt;

  FavoriteItem({
    required this.id,
    required this.foodItemId,
    required this.userId,
    required this.createdAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String,
      foodItemId: json['foodItemId'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodItemId': foodItemId,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  FavoriteItem copyWith({
    String? id,
    String? foodItemId,
    String? userId,
    DateTime? createdAt,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      foodItemId: foodItemId ?? this.foodItemId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteItem &&
        other.id == id &&
        other.foodItemId == foodItemId &&
        other.userId == userId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        foodItemId.hashCode ^
        userId.hashCode ^
        createdAt.hashCode;
  }
}
