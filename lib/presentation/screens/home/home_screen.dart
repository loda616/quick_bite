import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/data/models/food_item.dart';
import 'package:quick_bite/presentation/screens/profile_screen.dart';
import 'package:quick_bite/presentation/view_models/cubit/auth_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';
import 'package:quick_bite/presentation/widgets/food_item_card.dart';
import '../../../data/datasources/remote/food_service.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../cart/cart_screen.dart';
import '../food_details/food_item_details_screen.dart';

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
            content: Text('${AppLocalizations.of(context)!.error}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
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
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with theme-aware styling
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // App title and welcome text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, authState) {
                            return Text(
                              l10n.welcomeBackUser(authState.userName ?? 'Guest'),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Action Icons with theme support
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Cart Icon with Badge
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, cartState) {
                          return Stack(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: theme.colorScheme.primary,
                                  size: 28,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const CartScreen(),
                                    ),
                                  );
                                },
                              ),
                              if (cartState.itemCount > 0)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.primary.withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 20,
                                      minHeight: 20,
                                    ),
                                    child: Text(
                                      '${cartState.itemCount}',
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.black : Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar with theme support
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.searchForFood,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  onChanged: (value) {
                    // TODO: Implement search
                  },
                ),
              ),
            ),

            // Categories with theme support
            if (_categories != null)
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories!.length,
                  itemBuilder: (context, index) {
                    final category = _categories![index];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: FilterChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? (isDarkMode ? Colors.black : Colors.white)
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.surface,
                        checkmarkColor: isDarkMode ? Colors.black : Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withOpacity(0.3),
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

            // Food Items Grid with theme support
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
                    Text(
                      l10n.loadingDeliciousFood,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )
                  : _items == null || _items!.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noItemsFound,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.tryDifferentCategory,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          builder: (context) =>
                              FoodItemDetailsScreen(item: item),
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