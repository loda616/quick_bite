// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'QuickBite';

  @override
  String get appTagline => 'Fast food, faster delivery';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get signInToContinue => 'Sign in to continue to QuickBite';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get signIn => 'Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get or => 'OR';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinQuickBite => 'Join QuickBite';

  @override
  String get createAccountToGetStarted => 'Create your account to get started';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get iAgreeToThe => 'I agree to the ';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get required => 'Required';

  @override
  String get tooShort => 'Too short';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterPhone => 'Please enter your phone number';

  @override
  String get pleaseEnterValidPhone => 'Please enter a valid phone number';

  @override
  String get pleaseEnterPassword => 'Please enter a password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get forgotPasswordDesc =>
      'Enter your email address and we will send you a password reset link.';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get resetLinkSent => 'Reset Link Sent!';

  @override
  String get resetLinkSentDesc =>
      'We\'ve sent a password reset link to your email address.\\nPlease check your inbox and follow the instructions.';

  @override
  String get home => 'Home';

  @override
  String get cart => 'Cart';

  @override
  String get orders => 'Orders';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get searchForFood => 'Search for food...';

  @override
  String welcomeBackUser(String userName) {
    return 'Welcome back, $userName!';
  }

  @override
  String get shoppingCart => 'Shopping Cart';

  @override
  String get clear => 'Clear';

  @override
  String itemsInCart(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Items',
      one: 'Item',
    );
    return '$count $_temp0 in Cart';
  }

  @override
  String get swipeToRemove => 'Swipe to remove items';

  @override
  String get yourCartIsEmpty => 'Your cart is empty';

  @override
  String get addDeliciousItems => 'Add some delicious items to get started';

  @override
  String get browseMenu => 'Browse Menu';

  @override
  String subtotal(int count) {
    return 'Subtotal ($count items)';
  }

  @override
  String get deliveryFee => 'Delivery Fee';

  @override
  String get total => 'Total';

  @override
  String get free => 'FREE';

  @override
  String addMoreForFreeDelivery(String amount) {
    return 'Add \$$amount more for free delivery!';
  }

  @override
  String get addMore => 'Add More';

  @override
  String get checkout => 'Checkout';

  @override
  String get clearCart => 'Clear Cart';

  @override
  String get clearCartConfirm =>
      'Are you sure you want to remove all items from your cart?';

  @override
  String get cancel => 'Cancel';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get notAvailable => 'Not Available';

  @override
  String get available => 'Available';

  @override
  String get description => 'Description';

  @override
  String get customizations => 'Customizations';

  @override
  String get quantity => 'Quantity';

  @override
  String addedToCart(String itemName) {
    return '$itemName added to cart';
  }

  @override
  String get viewCart => 'View Cart';

  @override
  String get noOrdersYet => 'No Orders Yet';

  @override
  String get orderHistoryWillAppear => 'Your order history will appear here';

  @override
  String get filterOrders => 'Filter Orders';

  @override
  String get allOrders => 'All Orders';

  @override
  String get recentOrders => 'Recent Orders';

  @override
  String get completed => 'Completed';

  @override
  String get close => 'Close';

  @override
  String orderNumber(String orderId) {
    return 'Order #$orderId';
  }

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusPreparing => 'Preparing';

  @override
  String get orderStatusReady => 'Ready';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get appPreferences => 'App Preferences';

  @override
  String get accountStatus => 'Account Status';

  @override
  String get userId => 'User ID';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get role => 'Role';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Address';

  @override
  String get notProvided => 'Not provided';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get theme => 'Theme';

  @override
  String get enabled => 'Enabled';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get status => 'Status';

  @override
  String get active => 'Active';

  @override
  String get memberSince => 'Member Since';

  @override
  String get lastLogin => 'Last Login';

  @override
  String get today => 'Today';

  @override
  String get logout => 'Logout';

  @override
  String get loadingProfile => 'Loading profile...';

  @override
  String get refreshProfile => 'Refresh Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editContactInformation => 'Edit Contact Information';

  @override
  String get save => 'Save';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get online => 'Online';

  @override
  String get account => 'Account';

  @override
  String get appearance => 'Appearance';

  @override
  String get about => 'About';

  @override
  String get receiveNotifications => 'Receive push notifications';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get alwaysLight => 'Always use light theme';

  @override
  String get alwaysDark => 'Always use dark theme';

  @override
  String get followSystem => 'Follow system settings';

  @override
  String get system => 'System';

  @override
  String get appVersion => 'App Version';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get builtWithFlutter => 'Built with Flutter and love ❤️';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get loginSuccessful => 'Login successful! Welcome back.';

  @override
  String get registrationSuccessful =>
      'Registration successful! Please login to continue.';

  @override
  String get passwordResetSent => 'Password reset link sent to your email.';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get serverError => 'Server error. Please try again later.';

  @override
  String get loadingDeliciousFood => 'Loading delicious food...';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get tryDifferentCategory => 'Try selecting a different category';

  @override
  String shareText(String itemName) {
    return 'Check out this delicious $itemName on QuickBite!';
  }

  @override
  String get favorites => 'Favorites';

  @override
  String get noFavoritesYet => 'You have no favorites yet.';

  @override
  String get favoritesError => 'Something went wrong. Please try again.';
}
