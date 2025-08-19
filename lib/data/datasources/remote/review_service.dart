import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_bite/data/models/review.dart';

class ReviewService {
  final String _baseUrl = 'https://api.quickbite.com/v1';

  Future<List<Review>> getReviews(String foodItemId) async {
    final response = await http.get(Uri.parse('$_baseUrl/reviews/$foodItemId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> reviewList = data['data']['reviews'];
      return reviewList.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<bool> addReview({
    required String foodItemId,
    required double rating,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/reviews'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, dynamic>{
        'foodItemId': foodItemId,
        'rating': rating,
        'review': review,
      }),
    );

    return response.statusCode == 201;
  }
}
