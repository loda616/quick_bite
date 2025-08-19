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
}
