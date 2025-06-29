import 'dart:convert';

class JwtHelper {
  static Map<String, dynamic>? decodeToken(String token) {
    try {
      // Split the JWT token
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Decode the payload (middle part)
      final payload = parts[1];

      // Add padding if needed
      String normalizedPayload = payload.replaceAll('-', '+').replaceAll('_', '/');
      switch (normalizedPayload.length % 4) {
        case 0:
          break;
        case 2:
          normalizedPayload += '==';
          break;
        case 3:
          normalizedPayload += '=';
          break;
        default:
          throw Exception('Invalid JWT token');
      }

      // Decode base64
      final decoded = base64Decode(normalizedPayload);
      final decodedString = utf8.decode(decoded);

      return json.decode(decodedString) as Map<String, dynamic>;
    } catch (e) {
      print('Error decoding JWT: $e');
      return null;
    }
  }

  static String? getUserId(String token) {
    final decoded = decodeToken(token);
    return decoded?['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
  }

  static String? getUserName(String token) {
    final decoded = decodeToken(token);
    return decoded?['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'];
  }

  static String? getUserRole(String token) {
    final decoded = decodeToken(token);
    return decoded?['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
  }

  static DateTime? getExpirationDate(String token) {
    final decoded = decodeToken(token);
    final exp = decoded?['exp'];
    if (exp != null) {
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    }
    return null;
  }

  static bool isTokenExpired(String token) {
    final expiration = getExpirationDate(token);
    if (expiration == null) return true;
    return DateTime.now().isAfter(expiration);
  }
}