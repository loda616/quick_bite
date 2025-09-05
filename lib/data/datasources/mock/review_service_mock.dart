import 'dart:convert';
import 'package:quick_bite/data/models/review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ReviewServiceMock {
  final Map<int, List<Review>> _mockReviews = {
    1: [
      Review(
        id: '1',
        author: 'John Doe',
        rating: 4.5,
        review: 'Delicious! Best burger I have ever had.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Review(
        id: '2',
        author: 'Jane Smith',
        rating: 5.0,
        review: 'Absolutely amazing! Will definitely order again.',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ],
    2: [
      Review(
        id: '3',
        author: 'Peter Jones',
        rating: 4.0,
        review: 'Very good, but a bit too spicy for my taste.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ],
  };

  Future<List<Review>> getReviews(int foodItemId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'reviews_$foodItemId';
    final reviewsJson = prefs.getString(key);

    if (reviewsJson != null) {
      final List<dynamic> decoded = json.decode(reviewsJson);
      return decoded.map((json) => Review.fromJson(json)).toList();
    } else {
      return _mockReviews[foodItemId] ?? [];
    }
  }

  Future<bool> addReview({
    required int foodItemId,
    required double rating,
    required String review,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'reviews_$foodItemId';
    final reviews = await getReviews(foodItemId);

    final newReview = Review(
      id: const Uuid().v4(),
      author: 'New User', // In a real app, you'd get the current user
      rating: rating,
      review: review,
      createdAt: DateTime.now(),
    );

    reviews.add(newReview);
    final reviewsJson = json.encode(reviews.map((r) => r.toJson()).toList());
    return await prefs.setString(key, reviewsJson);
  }
}
