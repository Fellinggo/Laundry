import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../main_shell/controllers/main_shell_controller.dart';
import '../../shared/widgets/curved_navy_header.dart';
import '../../shared/widgets/primary_button.dart';
import '../controllers/login_controller.dart'; // <-- Pastikan ini diimport


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Menjalankan pengecekan auto-login setelah frame pertama selesai dirender
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAutoLogin());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkAutoLogin() async {
    final loginController = context.read<LoginController>();
    final canAutoLogin = await loginController.isAutoLoginAvailable();
    if (canAutoLogin && mounted) {
      _navigateToMain();
    }
  }

  Future<void> _handleLogin() async {
    final loginController = context.read<LoginController>();

    final success = await loginController.validateAndLogin(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (success && mounted) {
      await context.read<HomeController>().refreshData();

      _navigateToMain();
    }
  }

  void _navigateToMain() {
    context.read<MainShellController>().goToHomeTab(); // Tambah baris ini

    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }

  void _navigateToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

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
    // Memantau state LoginController secara reaktif
    final loginProvider = context.watch<LoginController>();

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
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => loginProvider.clearErrors(),
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Masukkan Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: _border(loginProvider.emailError != null),
                        enabledBorder: _border(
                          loginProvider.emailError != null,
                        ),
                        focusedBorder: _border(
                          loginProvider.emailError != null,
                        ),
                      ),
                    ),
                    if (loginProvider.emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          loginProvider.emailError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    TextField(
                      controller: passwordController,
                      obscureText: loginProvider.obscure,
                      onChanged: (_) => loginProvider.clearErrors(),
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Masukkan Password",
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: _border(loginProvider.passwordError != null),
                        enabledBorder: _border(
                          loginProvider.passwordError != null,
                        ),
                        focusedBorder: _border(
                          loginProvider.passwordError != null,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => loginProvider.toggleObscure(),
                          icon: Icon(
                            loginProvider.obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    if (loginProvider.passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          loginProvider.passwordError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => loginProvider.toggleStaySignedIn(),
                          child: Row(
                            children: [
                              Icon(
                                loginProvider.staySignedIn
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: loginProvider.staySignedIn
                                    ? AppColors.primaryNavy
                                    : AppColors.textSecondary,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tetap masuk',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () =>
                              loginProvider.showForgotPasswordMessage(context),
                          child: Text(
                            'Lupa password',
                            style: AppTextStyles.link,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      label: loginProvider.isLoading ? 'Memproses...' : 'Masuk',
                      onPressed: loginProvider.isLoading ? null : _handleLogin,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: AppTextStyles.bodyMuted,
                        ),
                        TextButton(
                          onPressed: _navigateToRegister,
                          child: Text('Daftar', style: AppTextStyles.link),
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
