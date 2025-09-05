class Review {
  final String id;
  final String author;
  final double rating;
  final String review;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.author,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      author: json['author'] as String,
      rating: (json['rating'] as num).toDouble(),
      review: json['review'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'rating': rating,
      'review': review,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Review copyWith({
    String? id,
    String? author,
    double? rating,
    String? review,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      author: author ?? this.author,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
