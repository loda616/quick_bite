class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? userEmail;
  final String? userName;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.userEmail,
    this.userName,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? userEmail,
    String? userName,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}