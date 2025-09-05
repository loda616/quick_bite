import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/data/models/review.dart';
import 'package:quick_bite/data/datasources/mock/review_service_mock.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import '../../../core/routs/routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/food_details/food_details_app_bar.dart';
import '../../widgets/food_details/food_details_bottom_bar.dart';
import '../../widgets/food_details/food_details_content.dart';

class FoodItemDetailsScreen extends StatefulWidget {
  final FoodItem item;

  const FoodItemDetailsScreen({
    super.key,
    required this.item,
  });

  @override
  State<FoodItemDetailsScreen> createState() => _FoodItemDetailsScreenState();
}

class _FoodItemDetailsScreenState extends State<FoodItemDetailsScreen> {
  int _quantity = 1;
  final Set<String> _selectedCustomizations = {};
  late Future<List<Review>> _reviewsFuture;
  final ReviewServiceMock _reviewService = ReviewServiceMock();

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _reviewService.getReviews(widget.item.id);
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _toggleCustomization(String option) {
    setState(() {
      if (_selectedCustomizations.contains(option)) {
        _selectedCustomizations.remove(option);
      } else {
        _selectedCustomizations.add(option);
      }
    });
  }

  void _addToCart() {
    final l10n = AppLocalizations.of(context)!;
    final cart = context.read<CartCubit>();

    cart.addItem(
      widget.item,
      quantity: _quantity,
      customizations: _selectedCustomizations.toList(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.addedToCart(widget.item.name)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: l10n.viewCart,
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
        ),
      ),
    );
  }

  void _addReview() {
    showDialog(
      context: context,
      builder: (context) {
        double rating = 0;
        String review = '';
        return AlertDialog(
          title: Text('Add a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
              TextField(
                onChanged: (value) {
                  review = value;
                },
                decoration: InputDecoration(
                  hintText: 'Write your review here',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _reviewService.addReview(
                  foodItemId: widget.item.id,
                  rating: rating,
                  review: review,
                );
                Navigator.of(context).pop();
                setState(() {
                  _reviewsFuture = _reviewService.getReviews(widget.item.id);
                });
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          FoodDetailsAppBar(item: widget.item),
          SliverToBoxAdapter(
            child: FoodDetailsContent(
              item: widget.item,
              quantity: _quantity,
              selectedCustomizations: _selectedCustomizations,
              onQuantityIncrement: _incrementQuantity,
              onQuantityDecrement: _decrementQuantity,
              onCustomizationToggle: _toggleCustomization,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reviews',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: _addReview,
                        child: Text('Add Review'),
                      ),
                    ],
                  ),
                  FutureBuilder<List<Review>>(
                    future: _reviewsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No reviews yet.'));
                      }
                      final reviews = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.author,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4.0),
                                  RatingBarIndicator(
                                    rating: review.rating,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(review.review),
                                  SizedBox(height: 4.0),
                                  Text(
                                    '${review.createdAt.toLocal()}'.split(' ')[0],
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FoodDetailsBottomBar(
        item: widget.item,
        quantity: _quantity,
        onAddToCart: _addToCart,
      ),
    );
  }
}
