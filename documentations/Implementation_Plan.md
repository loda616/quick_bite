# QuickBite Implementation Plan

This document outlines the step-by-step implementation details required to resolve existing bugs and apply the proposed UI/UX enhancements.

## 1. Authentication Navigation Bug Fix

**Issue:** Authenticated users who navigate to the `LoginScreen` remain stuck because `BlocConsumer` only reacts to state *changes*.

**Implementation Steps:**
1. **Modify `lib/presentation/screens/auth/login_screen.dart`**:
   - Inside the `build` method, wrap the `Scaffold` (or use the existing `BlocConsumer`'s `builder` optimally) to read the current state.
   - However, the best approach to handle an already-authenticated state without throwing "setState during build" errors is to perform the check in `initState` or right after the frame renders.
   - *Code Change:*
     ```dart
     @override
     void initState() {
       super.initState();
       WidgetsBinding.instance.addPostFrameCallback((_) {
         if (context.read<AuthCubit>().state.isAuthenticated) {
           Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
         }
       });
     }
     ```
2. **Update Route Guarding in `lib/core/routs/routes.dart`**:
   - Access the `AuthCubit` before allowing navigation to `/auth`.
   - Wait, `AppRoutes.generateRoute` does not have context to read providers easily. The navigation fix in `LoginScreen`'s `initState` is the safest, standard approach for Flutter.

## 2. Token Expiry Handling

**Issue:** Token expiration is not handled globally, leading to potential silent failures or 401 errors.

**Implementation Steps:**
1. **Modify `lib/core/network/dio_client.dart`**:
   - Add an `Interceptor` to handle 401 Unauthorized responses.
   - *Code Change:*
     ```dart
     dio.interceptors.add(InterceptorsWrapper(
       onError: (DioException e, handler) async {
         if (e.response?.statusCode == 401) {
           // Optionally, attempt to refresh the token here.
           // If refresh fails or is not implemented, force logout.

           // Assuming navigatorKey is available to dispatch global events:
           navigatorKey.currentContext?.read<AuthCubit>().forceReauth();
         }
         return handler.next(e);
       },
     ));
     ```
2. **Modify `AuthCubit`**:
   - Implement `forceReauth()` to call `logout()` and immediately redirect the user to the `LoginScreen`.

## 3. UI/UX Enhancements

### A. Cart Badge Notification
**Issue:** Users cannot see how many items are in their cart from the navigation bar.

**Implementation Steps:**
1. **Modify `lib/presentation/screens/main_screen.dart`**:
   - Wrap the `Cart` icon in a `Badge` widget.
   - Use `BlocBuilder<CartCubit, CartState>` just around the `Badge` to listen for item counts.
   - *Code Change:*
     ```dart
     NavigationDestination(
       icon: BlocBuilder<CartCubit, CartState>(
         builder: (context, state) {
           return Badge(
             isLabelVisible: state.items.isNotEmpty,
             label: Text('${state.items.length}'),
             child: const Icon(Icons.shopping_cart_outlined),
           );
         },
       ),
       selectedIcon: const Icon(Icons.shopping_cart),
       label: l10n.cart,
     ),
     ```

### B. Smooth Navigation Transitions
**Issue:** The `IndexedStack` changes tabs abruptly.

**Implementation Steps:**
1. **Modify `lib/presentation/screens/main_screen.dart`**:
   - Replace the `IndexedStack` with an `AnimatedSwitcher` or an `IndexedStack` paired with a `FadeTransition` for smooth cross-fading.
   - *Code Change Summary:* Manage an `AnimationController` and fade between the `_screens[_currentIndex]`.

### C. Refined Splash Screen Timing
**Issue:** The splash screen animation relies on static timers.

**Implementation Steps:**
1. **Modify `lib/main.dart` -> `SplashScreen`**:
   - Instead of static timers, listen to the `AuthCubit` initialization state.
   - Ensure the animation finishes its required sequence, but do not dismiss the splash screen until `authState.isLoading == false`.

## 4. Error Handling Optimization

**Issue:** Generic error messages are shown for specific failures.

**Implementation Steps:**
1. **Modify `lib/data/repository/auth_repository_impl.dart`**:
   - In the `catch (dioError)` block, parse the `response.data['errors']` mapping provided by the ASP.NET Core backend.
   - Extract the specific property errors (e.g., `Password requires a non-alphanumeric character`) and pass them into the custom exceptions to be displayed in the UI via the `SnackBar`.
