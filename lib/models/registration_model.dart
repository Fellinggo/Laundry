class RegistrationData {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  RegistrationData({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  bool get isNameValid => name.trim().isNotEmpty;

  bool get isEmailValid {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@('
      r'gmail\.com|'
      r'yahoo\.com|'
      r'yahoo\.co\.id|'
      r'hotmail\.com|'
      r'outlook\.com|'
      r'icloud\.com|'
      r'[a-zA-Z0-9-.]+\.ac\.id|'
      r'[a-zA-Z0-9-.]+\.edu'
      r')$',
    ).hasMatch(email);
  }

  bool get isPhoneValid {
    return phone.length >= 11 && RegExp(r'^[0-9]+$').hasMatch(phone);
  }

  bool get isStrongPassword {
    return password.length >= 6 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  bool get doPasswordsMatch => password == confirmPassword;

  String? get emailErrorMessage {
    if (email.isEmpty) return null;
    if (!isEmailValid) return "Email tidak valid";
    return null;
  }

  String? get phoneErrorMessage {
    if (phone.isEmpty) return null;
    if (!isPhoneValid) return "Nomor HP tidak valid";
    return null;
  }

  String? get passwordErrorMessage {
    if (password.isEmpty) return null;
    if (!isStrongPassword) {
      return "Min 6 karakter + huruf besar, kecil, dan angka";
    }
    return null;
  }

  String? get confirmPasswordErrorMessage {
    if (confirmPassword.isEmpty) return null;
    if (!doPasswordsMatch) return "Password tidak sama";
    return null;
  }

  bool get isValid {
    return isNameValid &&
        isEmailValid &&
        isPhoneValid &&
        isStrongPassword &&
        doPasswordsMatch;
  }

  RegistrationData copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
  }) {
    return RegistrationData(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
