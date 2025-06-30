import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Keys for secure storage
  static const String _tokenKey = 'auth_token';
  static const String _tokenExpirationKey = 'token_expiration';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_role';

  // Keys for shared preferences (fast access)
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _quickUserNameKey = 'quick_user_name';
  static const String _quickUserEmailKey = 'quick_user_email';
  static const String _lastLoginTimeKey = 'last_login_time';

  final SharedPreferences _prefs;

  SecureStorageService(this._prefs);

  // =============================================================================
  // FAST LOGIN STATUS CHECK (SharedPreferences)
  // =============================================================================

  /// Quick check if user is logged in (no async secure storage access)
  bool isQuickLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Save quick login status
  Future<void> saveQuickLoginStatus(bool isLoggedIn) async {
    await _prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  /// Get quick access user info for UI
  String? getQuickUserName() {
    return _prefs.getString(_quickUserNameKey);
  }

  String? getQuickUserEmail() {
    return _prefs.getString(_quickUserEmailKey);
  }

  /// Save quick access user info
  Future<void> saveQuickUserInfo({
    String? userName,
    String? userEmail,
  }) async {
    if (userName != null) {
      await _prefs.setString(_quickUserNameKey, userName);
    }
    if (userEmail != null) {
      await _prefs.setString(_quickUserEmailKey, userEmail);
    }
    await _prefs.setInt(_lastLoginTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Get last login time
  DateTime? getLastLoginTime() {
    final timestamp = _prefs.getInt(_lastLoginTimeKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  // =============================================================================
  // SECURE TOKEN MANAGEMENT (FlutterSecureStorage)
  // =============================================================================

  /// Save complete authentication data
  Future<void> saveAuthenticationData({
    required String token,
    required DateTime expiration,
    String? userId,
    String? userName,
    String? userEmail,
    String? userRole,
  }) async {
    // Save to secure storage
    await Future.wait([
      _storage.write(key: _tokenKey, value: token),
      _storage.write(key: _tokenExpirationKey, value: expiration.toIso8601String()),
      if (userId != null) _storage.write(key: _userIdKey, value: userId),
      if (userName != null) _storage.write(key: _userNameKey, value: userName),
      if (userEmail != null) _storage.write(key: _userEmailKey, value: userEmail),
      if (userRole != null) _storage.write(key: _userRoleKey, value: userRole),
    ]);

    // Save quick access data
    await Future.wait([
      saveQuickLoginStatus(true),
      saveQuickUserInfo(userName: userName, userEmail: userEmail),
    ]);
  }

  // Token management
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Token expiration management
  Future<void> saveTokenExpiration(DateTime expirationTime) async {
    await _storage.write(
      key: _tokenExpirationKey,
      value: expirationTime.toIso8601String(),
    );
  }

  Future<DateTime?> getTokenExpiration() async {
    final expirationString = await _storage.read(key: _tokenExpirationKey);
    if (expirationString != null) {
      return DateTime.parse(expirationString);
    }
    return null;
  }

  Future<void> deleteTokenExpiration() async {
    await _storage.delete(key: _tokenExpirationKey);
  }

  // User ID management
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  Future<void> deleteUserId() async {
    await _storage.delete(key: _userIdKey);
  }

  // User name management
  Future<void> saveUserName(String userName) async {
    await _storage.write(key: _userNameKey, value: userName);
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }

  // User email management
  Future<void> saveUserEmail(String userEmail) async {
    await _storage.write(key: _userEmailKey, value: userEmail);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  // User role management
  Future<void> saveUserRole(String userRole) async {
    await _storage.write(key: _userRoleKey, value: userRole);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  // =============================================================================
  // COMPREHENSIVE AUTH STATUS CHECK
  // =============================================================================

  /// Comprehensive check (validates token expiration)
  Future<bool> hasValidToken() async {
    // Quick check first
    if (!isQuickLoggedIn()) return false;

    // Then validate actual token
    final token = await getToken();
    if (token == null) {
      await clearAll(); // Clean up inconsistent state
      return false;
    }

    // Check expiration from secure storage
    final expiration = await getTokenExpiration();
    if (expiration != null && DateTime.now().isAfter(expiration)) {
      await clearAll(); // Token expired
      return false;
    }

    return true;
  }

  // =============================================================================
  // CLEAR DATA
  // =============================================================================

  /// Clear all stored data (logout)
  Future<void> clearAll() async {
    // Clear secure storage
    await _storage.deleteAll();

    // Clear shared preferences auth data
    await Future.wait([
      _prefs.remove(_isLoggedInKey),
      _prefs.remove(_quickUserNameKey),
      _prefs.remove(_quickUserEmailKey),
      _prefs.remove(_lastLoginTimeKey),
    ]);
  }

  /// Clear only quick access data (keep secure data)
  Future<void> clearQuickData() async {
    await Future.wait([
      _prefs.remove(_isLoggedInKey),
      _prefs.remove(_quickUserNameKey),
      _prefs.remove(_quickUserEmailKey),
    ]);
  }

  // =============================================================================
  // UTILITY METHODS
  // =============================================================================

  /// Check if user data exists
  Future<bool> hasUserData() async {
    final token = await getToken();
    final userId = await getUserId();
    return token != null && userId != null;
  }

  /// Get all user info at once (for profile screen)
  Future<Map<String, String?>> getAllUserInfo() async {
    return {
      'userId': await getUserId(),
      'userName': await getUserName(),
      'userEmail': await getUserEmail(),
      'userRole': await getUserRole(),
      'quickUserName': getQuickUserName(),
      'quickUserEmail': getQuickUserEmail(),
    };
  }

  /// Validate consistency between quick and secure data
  Future<bool> validateDataConsistency() async {
    final isQuickLoggedIn = this.isQuickLoggedIn();
    final hasSecureToken = await getToken() != null;

    if (isQuickLoggedIn != hasSecureToken) {
      // Inconsistent state - clear everything
      await clearAll();
      return false;
    }

    return true;
  }
}