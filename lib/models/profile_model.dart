import 'address_model.dart';

class ProfileModel {
  final String name;
  final String email;
  final bool isLoggedIn;
  final List<AddressModel> addresses;

  ProfileModel({
    required this.name,
    required this.email,
    required this.isLoggedIn,
    required this.addresses,
  });

  factory ProfileModel.guest() {
    return ProfileModel(
      name: 'Belum Login',
      email: 'Silakan login terlebih dahulu',
      isLoggedIn: false,
      addresses: [],
    );
  }

  factory ProfileModel.loggedIn({
    required String name,
    required String email,
    required List<AddressModel> addresses,
  }) {
    return ProfileModel(
      name: name,
      email: email,
      isLoggedIn: true,
      addresses: addresses,
    );
  }

  ProfileModel copyWith({
    String? name,
    String? email,
    bool? isLoggedIn,
    List<AddressModel>? addresses,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      addresses: addresses ?? this.addresses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'isLoggedIn': isLoggedIn,
      'addresses': addresses.map((e) => e.toMap()).toList(),
    };
  }
}
