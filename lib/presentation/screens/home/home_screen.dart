// Updated home_screen.dart with fixed navigation
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/core/utilz/colors.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/presentation/view_models/cubit/auth_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';
import 'package:quick_bite/presentation/widgets/food_item_card.dart';
import '../../../core/routs/routes.dart';
import '../../../data/datasources/remote/food_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FoodService _foodService = FoodService();
  String? _selectedCategory;
  List<FoodItem>? _items;
  List<String>? _categories;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await _foodService.getAllCategories();
      final items = _selectedCategory != null
          ? await _foodService.getItemsByCategory(_selectedCategory!)
          : await _foodService.getPopularItems();

      if (mounted) {
        setState(() {
          _categories = categories;
          _items = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QuickBite',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          return Text(
                            'Welcome back, ${authState.userName ?? 'Guest'}!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Cart Icon with Badge
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, cartState) {
                          return IconButton(
                            icon: Stack(
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: theme.colorScheme.primary,
                                  size: 28,
                                ),
                                if (cartState.itemCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: AppColors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        '${cartState.itemCount}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.cart);
                            },
                            tooltip: 'Cart',
                          );
                        },
                      ),
                      // Profile Icon
                      IconButton(
                        icon: Icon(
                          Icons.person_outline,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.profile);
                        },
                        tooltip: 'Profile',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for food...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  // TODO: Implement search functionality
                },
              ),
            ),

            const SizedBox(height: 16),

            // Categories
            if (_categories != null && _categories!.isNotEmpty)
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _categories!.length + 1, // +1 for "All" option
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // "All" option
                      final isSelected = _selectedCategory == null;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ChoiceChip(
                          label: const Text('All'),
                          selected: isSelected,
                          selectedColor: theme.colorScheme.primary,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = null;
                            });
                            _loadData();
                          },
                        ),
                      );
                    }

                    final category = _categories![index - 1];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: theme.colorScheme.primary,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                          _loadData();
                        },
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            // Food Items Grid
            Expanded(
              child: _isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    const Text('Loading delicious food...'),
                  ],
                ),
              )
                  : _items == null || _items!.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No items found',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try selecting a different category',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: _loadData,
                color: theme.colorScheme.primary,
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _items!.length,
                  itemBuilder: (context, index) {
                    final item = _items![index];
                    return FoodItemCard(
                      item: item,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.foodDetails,
                          arguments: item,
                        );
                      },
                      onAddToCart: () {
                        context.read<CartCubit>().addItem(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.name} added to cart'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'View Cart',
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.cart);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}