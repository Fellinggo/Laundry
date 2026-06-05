class LoginCredentials {
  final String email;
  final String password;
  final bool staySignedIn;

  LoginCredentials({
    required this.email,
    required this.password,
    required this.staySignedIn,
  });

  String get userName => email.split(
    '@',
  )[0];
  bool get isEmailValid => _isValidEmail(
    email,
  );
  bool get isPasswordValid => _isValidPassword(
    password,
  );

  static bool _isValidEmail(
    String email,
  ) {
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
    ).hasMatch(
      email,
    );
  }

  static bool _isValidPassword(
    String password,
  ) {
    bool hasMinLength =
        password.length >=
        6;
    bool hasUppercase = password.contains(
      RegExp(
        r'[A-Z]',
      ),
    );
    bool hasLowercase = password.contains(
      RegExp(
        r'[a-z]',
      ),
    );
    bool hasNumber = password.contains(
      RegExp(
        r'[0-9]',
      ),
    );

    return hasMinLength &&
        hasUppercase &&
        hasLowercase &&
        hasNumber;
  }

  String? get emailErrorMessage {
    if (email.isEmpty) return "Email tidak boleh kosong";
    if (!isEmailValid) return "Email tidak valid";
    return null;
  }

  String? get passwordErrorMessage {
    if (password.isEmpty) return "Password tidak boleh kosong";
    if (!isPasswordValid) {
      return "Min 6 karakter, huruf besar, kecil, dan angka wajib ada";
    }
    return null;
  }

  bool get isValid =>
      isEmailValid &&
      isPasswordValid;
}

class LoginResult {
  final bool success;
  final String? message;
  final String? userName;
  final String? userEmail;

  LoginResult({
    required this.success,
    this.message,
    this.userName,
    this.userEmail,
  });
}
