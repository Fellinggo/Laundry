import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/constants/app_text_styles.dart';
import 'package:wushlaundry/widgets/curved_navy_header.dart';
import 'package:wushlaundry/widgets/labeled_text_field.dart';
import 'package:wushlaundry/widgets/primary_button.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscure1 = true;
  bool _obscure2 = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;

  bool _isValidEmail(String email) {
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

  bool _isPhoneValid(String phone) {
    return phone.length >= 11 && RegExp(r'^[0-9]+$').hasMatch(phone);
  }

  bool _isStrongPassword(String pass) {
    return pass.length >= 6 &&
        pass.contains(RegExp(r'[A-Z]')) &&
        pass.contains(RegExp(r'[a-z]')) &&
        pass.contains(RegExp(r'[0-9]'));
  }

  Future<void> handleRegister() async {
    final prefs = await SharedPreferences.getInstance();

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    setState(() {
      emailError = null;
      phoneError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    bool hasError = false;

    if (!_isValidEmail(email)) {
      emailError = "Email tidak valid";
      hasError = true;
    }

    if (!_isPhoneValid(phone)) {
      phoneError = "Nomor HP tidak valid";
      hasError = true;
    }

    if (!_isStrongPassword(password)) {
      passwordError = "Min 6 karakter + huruf besar, kecil, dan angka";
      hasError = true;
    }

    if (password != confirmPassword) {
      confirmPasswordError = "Password tidak sama";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    await prefs.setBool('isLoggedIn', true);
    await prefs.setBool('isSignup', true);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);

    await prefs.setString('login_method', 'signup');

    await prefs.remove('userAddresses');
    await prefs.remove('userAddressTitles');

    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Column(
        children: [
          const CurvedNavyHeader(
            heightFraction: 0.40,
            subtitle:
                'Daftar untuk pengalaman laundry yang lebih personal dan praktis',
          ),

          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -50),
              child: ScrollConfiguration(
                behavior: const _NoOverscrollBehavior(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LabeledTextField(
                        label: 'Nama Lengkap',
                        hint: 'Masukkan Nama Lengkap',
                        prefixIcon: Icons.person_outline_rounded,
                        controller: nameController,
                      ),

                      const SizedBox(height: 10),

                      LabeledTextField(
                        label: 'Email',
                        hint: 'Masukkan Email',
                        prefixIcon: Icons.email_outlined,
                        controller: emailController,
                        errorText: emailError,
                      ),

                      const SizedBox(height: 10),

                      _phoneField(),

                      const SizedBox(height: 10),

                      LabeledTextField(
                        label: 'Password',
                        hint: 'Masukkan Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        controller: passwordController,
                        obscure: _obscure1,
                        errorText: passwordError,
                        suffix: IconButton(
                          onPressed: () => setState(() {
                            _obscure1 = !_obscure1;
                          }),
                          icon: Icon(
                            _obscure1
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      LabeledTextField(
                        label: 'Konfirmasi Password',
                        hint: 'Masukkan Konfirmasi Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        controller: confirmPasswordController,
                        obscure: _obscure2,
                        errorText: confirmPasswordError,
                        suffix: IconButton(
                          onPressed: () => setState(() {
                            _obscure2 = !_obscure2;
                          }),
                          icon: Icon(
                            _obscure2
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      PrimaryButton(label: 'Daftar', onPressed: handleRegister),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _phoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'No. HP',
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 8),

        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: '08XX XXXX XXXX',
            filled: true,
            fillColor: AppColors.white,
            errorText: phoneError,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
              borderSide: const BorderSide(
                color: AppColors.primaryNavy,
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
              borderSide: const BorderSide(color: Colors.red, width: 1.4),
            ),
            prefixIcon: const Icon(Icons.phone),
          ),
        ),
      ],
    );
  }
}

class _NoOverscrollBehavior extends ScrollBehavior {
  const _NoOverscrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
