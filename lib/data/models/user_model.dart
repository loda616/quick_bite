import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}


//  Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'firstName': firstName,
//       'lastName': lastName,
//       'email': email,
//       'phoneNumber': phoneNumber,

//      'favoriteItems': favoriteItems,
//       'addresses': addresses,
//       'profileImageUrl': profileImageUrl,
//    };
//   }

//  User copyWith({
//     String? id,
//     String? firstName,
//     String? lastName,
//     String? email,
//     String? phoneNumber,
//     List<String>? favoriteItems,
//     List<String>? addresses,
//     String? profileImageUrl,
//   }) {
//     return User(
//       id: id ?? this.id,
//       firstName: firstName ?? this.firstName,
//       lastName: lastName ?? this.lastName,
//       email: email ?? this.email,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
// //      favoriteItems: favoriteItems ?? this.favoriteItems,
// //       addresses: addresses ?? this.addresses,
// //       profileImageUrl: profileImageUrl ?? this.profileImageUrl,
//     );
//   }

//  bool isFavorite(String itemId) {
//     return favoriteItems.contains(itemId);
//   }

//  User addFavorite(String itemId) {
//     if (!favoriteItems.contains(itemId)) {
//       return copyWith(
//         favoriteItems: [...favoriteItems, itemId],
//       );
//     }
//     return this;
//   }

//  User removeFavorite(String itemId) {
//     return copyWith(
//       favoriteItems: favoriteItems.where((id) => id != itemId).toList(),
//     );
//   }

//  User addAddress(String address) {
//     if (!addresses.contains(address)) {
//       return copyWith(
//         addresses: [...addresses, address],
//       );
//     }
//     return this;
//   }
//
//   User removeAddress(String address) {
//     return copyWith(
//       addresses: addresses.where((a) => a != address).toList(),
//     );
//   }
//
