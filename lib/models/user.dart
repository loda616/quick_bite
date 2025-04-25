class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final List<String> favoriteItems;
  final List<String> addresses;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.favoriteItems = const [],
    this.addresses = const [],
    this.profileImageUrl,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      favoriteItems: (json['favoriteItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'favoriteItems': favoriteItems,
      'addresses': addresses,
      'profileImageUrl': profileImageUrl,
    };
  }

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    List<String>? favoriteItems,
    List<String>? addresses,
    String? profileImageUrl,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      favoriteItems: favoriteItems ?? this.favoriteItems,
      addresses: addresses ?? this.addresses,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  bool isFavorite(String itemId) {
    return favoriteItems.contains(itemId);
  }

  User addFavorite(String itemId) {
    if (!favoriteItems.contains(itemId)) {
      return copyWith(
        favoriteItems: [...favoriteItems, itemId],
      );
    }
    return this;
  }

  User removeFavorite(String itemId) {
    return copyWith(
      favoriteItems: favoriteItems.where((id) => id != itemId).toList(),
    );
  }

  User addAddress(String address) {
    if (!addresses.contains(address)) {
      return copyWith(
        addresses: [...addresses, address],
      );
    }
    return this;
  }

  User removeAddress(String address) {
    return copyWith(
      addresses: addresses.where((a) => a != address).toList(),
    );
  }
}
