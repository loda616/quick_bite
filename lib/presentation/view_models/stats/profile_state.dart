class ProfileState {
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}