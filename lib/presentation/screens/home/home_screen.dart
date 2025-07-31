import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bite/presentation/screens/profile_screen.dart';
import 'package:quick_bite/presentation/view_models/cubit/auth_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/cart_cubit.dart';
import 'package:quick_bite/presentation/view_models/cubit/menu_cubit.dart';
import 'package:quick_bite/presentation/view_models/stats/auth_stat.dart';
import 'package:quick_bite/presentation/view_models/stats/cart_state.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../view_models/stats/menu_stat.dart';
import '../../widgets/minimal_foodItem_card.dart';
import '../cart/cart_screen.dart';
import '../food_details/food_item_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load initial menu data when screen opens
    context.read<MenuCubit>().loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  controller: _searchController,
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
                    context.read<MenuCubit>().searchItems(value);
                  },
                ),
              ),
            ),

            // Categories with theme support
            BlocBuilder<MenuCubit, MenuState>(
              builder: (context, menuState) {
                if (menuState.hasCategories) {
                  return Container(
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: menuState.categories.length + 1, // +1 for "All" option
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // "All" category option
                          final isSelected = menuState.isShowingAllItems;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: FilterChip(
                              label: Text(
                                'All',
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
                                if (selected && !isSelected) {
                                  // Clear search when selecting "All"
                                  _searchController.clear();
                                  context.read<MenuCubit>().selectCategory(null);
                                }
                              },
                            ),
                          );
                        }

                        final category = menuState.categories[index - 1];
                        final isSelected = menuState.selectedCategoryId == category.id;

                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: FilterChip(
                            label: Text(
                              category.name,
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
                              if (selected && !isSelected) {
                                // Clear search when selecting a category
                                _searchController.clear();
                                context.read<MenuCubit>().selectCategory(category);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Food Items Grid with theme support
            Expanded(
              child: BlocConsumer<MenuCubit, MenuState>(
                listener: (context, state) {
                  if (state.hasError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: theme.colorScheme.error,
                        action: SnackBarAction(
                          label: l10n.retry,
                          textColor: Colors.white,
                          onPressed: () {
                            context.read<MenuCubit>().refreshData();
                          },
                        ),
                      ),
                    );
                    context.read<MenuCubit>().clearError();
                  }
                },
                builder: (context, menuState) {
                  if (menuState.isLoading) {
                    return Center(
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
                    );
                  }

                  if (!menuState.hasFilteredItems) {
                    return Center(
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
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<MenuCubit>().refreshData();
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.retry),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => context.read<MenuCubit>().refreshData(),
                    color: theme.colorScheme.primary,
                    child: Stack(
                      children: [
                        GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8, // Adjusted ratio for better fit
                            crossAxisSpacing: 12, // Reduced spacing
                            mainAxisSpacing: 12,  // Reduced spacing
                          ),
                          itemCount: menuState.filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = menuState.filteredItems[index];
                            return MinimalFoodItemCard( // Using minimal version
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

                        // Loading overlay for category changes
                        if (menuState.isLoadingCategory)
                          Container(
                            color: theme.scaffoldBackgroundColor.withOpacity(0.8),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Loading ${menuState.selectedCategoryName ?? 'items'}...',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
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