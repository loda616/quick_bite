import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final bool isLoading;
  final String? userName;
  final String? userEmail;
  final String? userId;
  final String? userRole;
  final String? errorMessage;
  final String? successMessage;
  final DateTime? lastLoginTime;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.userName,
    this.userEmail,
    this.userId,
    this.userRole,
    this.errorMessage,
    this.successMessage,
    this.lastLoginTime,
  });

  /// Quick check if user has basic authentication info
  bool get hasUserInfo => userName != null || userEmail != null;

  /// Check if user has complete profile data
  bool get hasCompleteProfile => userName != null && userEmail != null && userId != null;

  /// Get display name for UI
  String get displayName {
    if (userName != null && userName!.isNotEmpty) {
      return userName!;
    }
    if (userEmail != null && userEmail!.isNotEmpty) {
      return userEmail!.split('@')[0]; // Use email prefix if no name
    }
    return 'Guest';
  }

  /// Get user initials for avatar
  String get userInitials {
    if (userName != null && userName!.isNotEmpty) {
      final parts = userName!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return userName![0].toUpperCase();
    }
    if (userEmail != null && userEmail!.isNotEmpty) {
      return userEmail![0].toUpperCase();
    }
    return 'G';
  }

  /// Check if user is admin
  bool get isAdmin => userRole?.toLowerCase() == 'admin';

  /// Check if authentication is in progress
  bool get isAuthenticating => isLoading;

  /// Check if there's an active error
  bool get hasError => errorMessage != null;

  /// Check if there's a success message
  bool get hasSuccess => successMessage != null;

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? userName,
    String? userEmail,
    String? userId,
    String? userRole,
    String? errorMessage,
    String? successMessage,
    DateTime? lastLoginTime,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
      errorMessage: errorMessage,
      successMessage: successMessage,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
    );
  }

  /// Clear all user data (for logout)
  AuthState clearUserData() {
    return const AuthState();
  }

  /// Update user info only
  AuthState updateUserInfo({
    String? userName,
    String? userEmail,
    String? userId,
    String? userRole,
  }) {
    return copyWith(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
    );
  }

  /// Set loading state
  AuthState setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  /// Set error message
  AuthState setError(String error) {
    return copyWith(
      isLoading: false,
      errorMessage: error,
      successMessage: null,
    );
  }

  /// Set success message
  AuthState setSuccess(String success) {
    return copyWith(
      isLoading: false,
      errorMessage: null,
      successMessage: success,
    );
  }

  /// Clear messages
  AuthState clearMessages() {
    return copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }

  @override
  List<Object?> get props => [
    isAuthenticated,
    isLoading,
    userName,
    userEmail,
    userId,
    userRole,
    errorMessage,
    successMessage,
    lastLoginTime,
  ];

  @override
  String toString() {
    return '''AuthState(
  isAuthenticated: $isAuthenticated,
  isLoading: $isLoading,
  userName: $userName,
  userEmail: $userEmail,
  userId: $userId,
  userRole: $userRole,
  hasError: $hasError,
  hasSuccess: $hasSuccess,
  lastLoginTime: $lastLoginTime,
)''';
  }

  /// Convert to Map for debugging
  Map<String, dynamic> toMap() {
    return {
      'isAuthenticated': isAuthenticated,
      'isLoading': isLoading,
      'userName': userName,
      'userEmail': userEmail,
      'userId': userId,
      'userRole': userRole,
      'errorMessage': errorMessage,
      'successMessage': successMessage,
      'lastLoginTime': lastLoginTime?.toIso8601String(),
      'hasUserInfo': hasUserInfo,
      'hasCompleteProfile': hasCompleteProfile,
      'displayName': displayName,
      'userInitials': userInitials,
      'isAdmin': isAdmin,
    };
  }
}