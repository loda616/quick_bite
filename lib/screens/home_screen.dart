import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/food_service.dart';
import '../widgets/food_item_card.dart';
import '../models/food_item.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';
import 'food_item_details_screen.dart';

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
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'QuickBite',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Stack(
                          children: [
                            const Icon(Icons.shopping_cart),
                            Consumer<CartProvider>(
                              builder: (context, cart, _) {
                                if (cart.itemCount == 0)
                                  return const SizedBox();
                                return Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '${cart.itemCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () {
                          // TODO: Navigate to profile
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Welcome back, ${authProvider.userName ?? "Guest"}!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for meals...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  // TODO: Implement search
                },
              ),
            ),
            if (_categories != null)
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _categories!.length,
                  itemBuilder: (context, index) {
                    final category = _categories![index];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
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
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _items == null || _items!.isEmpty
                      ? const Center(child: Text('No items found'))
                      : GridView.builder(
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FoodItemDetailsScreen(
                                      item: item,
                                    ),
                                  ),
                                );
                              },
                              onAddToCart: () {
                                final cart = context.read<CartProvider>();
                                cart.addItem(item);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${item.name} added to cart'),
                                    action: SnackBarAction(
                                      label: 'VIEW CART',
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const CartScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
