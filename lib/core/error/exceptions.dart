/// A base class for all server-related exceptions.
abstract class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  @override
  String toString() => message;
}

/// Thrown when the server returns a 400 Bad Request error.
/// This typically means the client sent invalid data.
class BadRequestException extends ServerException {
  const BadRequestException(String message) : super(message);
}

/// Thrown when the server returns a 401 Unauthorized error.
/// This means the user's credentials are not valid.
class InvalidCredentialsException extends ServerException {
  const InvalidCredentialsException(String message) : super(message);
}

/// Thrown when the server returns a 404 Not Found error.
/// This means the requested endpoint does not exist.
class NotFoundException extends ServerException {
  const NotFoundException(String message) : super(message);
}

/// Thrown when the server returns a 409 Conflict error.
/// This is often used during registration if the email already exists.
class ConflictException extends ServerException {
  const ConflictException(String message) : super(message);
}

/// Thrown when the server returns a 5xx error.
/// This indicates a problem with the server itself.
class InternalServerErrorException extends ServerException {
  const InternalServerErrorException(String message) : super(message);
}

/// Thrown when a network error occurs (e.g., no internet connection).
class NetworkException extends ServerException {
  const NetworkException(String message) : super(message);
}

/// Thrown for any other unexpected server errors.
class UnknownServerException extends ServerException {
  const UnknownServerException(String message) : super(message);
}
