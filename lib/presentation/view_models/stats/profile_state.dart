class ProfileState {
  final String? userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? role;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.role,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? role,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}