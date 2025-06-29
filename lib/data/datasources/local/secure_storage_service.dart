import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _tokenExpirationKey = 'token_expiration';
  static const String _userIdKey = 'user_id';

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

  // Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Check if user data exists
  Future<bool> hasUserData() async {
    final token = await getToken();
    final userId = await getUserId();
    return token != null && userId != null;
  }
}