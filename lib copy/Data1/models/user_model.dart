class UserModel {
  final bool isLoggedIn;
  final String? firstName;

  UserModel({required this.isLoggedIn, this.firstName});

  factory UserModel.fromPreferences(bool isLoggedIn, String? fullName) {
    String? firstName;
    if (isLoggedIn && fullName != null) {
      firstName = fullName.split(' ').first;
    }
    return UserModel(isLoggedIn: isLoggedIn, firstName: firstName);
  }
}
