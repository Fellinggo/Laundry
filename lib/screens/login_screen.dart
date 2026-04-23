import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/constants/app_colors.dart';
import 'package:wushlaundry/constants/app_spacing.dart';
import 'package:wushlaundry/constants/app_text_styles.dart';
import 'package:wushlaundry/widgets/curved_navy_header.dart';
import 'package:wushlaundry/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;
  bool _staySignedIn = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  Future<void> handleLogin() async {
    final prefs = await SharedPreferences.getInstance();

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      emailError = null;
      passwordError = null;
    });

    bool hasError = false;

    // ================= EMAIL VALIDASI =================
    bool isEmailValid = RegExp(
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

    if (!isEmailValid) {
      emailError = "Email tidak valid";
      hasError = true;
    }

    // ================= PASSWORD VALIDASI =================
    bool hasMinLength = password.length >= 6;
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));

    if (!(hasMinLength && hasUppercase && hasLowercase && hasNumber)) {
      passwordError =
          "Min 6 karakter, huruf besar, kecil, dan angka wajib ada";
      hasError = true;
    }

    // ❌ STOP JIKA ADA ERROR (TAPI TIDAK RETURN PER FIELD)
    if (hasError) {
      setState(() {});
      return;
    }

    // ================= SUCCESS LOGIN =================
    String namaUser = email.split('@')[0];

    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', namaUser);
    await prefs.setString('userEmail', email);

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main',
      (route) => false,
    );
  }

  // ================= FIELD STYLE ERROR =================
  OutlineInputBorder _border(bool error) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: error ? Colors.red : AppColors.borderLight,
        width: 1.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Column(
        children: [
          const CurvedNavyHeader(
            heightFraction: 0.40,
            subtitle: 'Masuk dan nikmati layanan laundry',
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // ================= EMAIL =================
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Masukkan Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: _border(emailError != null),
                        enabledBorder: _border(emailError != null),
                        focusedBorder: _border(emailError != null),
                      ),
                    ),

                    if (emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          emailError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: AppSpacing.lg),

                    // ================= PASSWORD =================
                    TextField(
                      controller: passwordController,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Masukkan Password",
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: _border(passwordError != null),
                        enabledBorder: _border(passwordError != null),
                        focusedBorder: _border(passwordError != null),
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscure = !_obscure,
                          ),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),

                    if (passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          passwordError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: AppSpacing.md),

                    // ================= OPTIONS =================
                    Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => setState(
                            () => _staySignedIn = !_staySignedIn,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _staySignedIn
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: _staySignedIn
                                    ? AppColors.primaryNavy
                                    : AppColors.textSecondary,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tetap masuk',
                                style: AppTextStyles.body.copyWith(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Lupa password',
                            style: AppTextStyles.link,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ================= LOGIN BUTTON =================
                    PrimaryButton(
                      label: 'Masuk',
                      onPressed: handleLogin,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ================= REGISTER =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: AppTextStyles.bodyMuted,
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(
                            context,
                            '/register',
                          ),
                          child: Text(
                            'Daftar',
                            style: AppTextStyles.link,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}