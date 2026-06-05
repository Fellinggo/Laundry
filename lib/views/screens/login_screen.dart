import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/curved_navy_header.dart';
import '../widgets/primary_button.dart';
import '../../controllers/login_controller.dart';

class LoginScreen
    extends
        StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<
    LoginScreen
  >
  createState() => _LoginScreenState();
}

class _LoginScreenState
    extends
        State<
          LoginScreen
        > {
  late LoginController _controller;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = LoginController();
    _controller.addListener(
      _onControllerChanged,
    );
    _controller.checkAutoLogin(
      context,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onControllerChanged,
    );
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(
        () {},
      );
    }
  }

  Future<
    void
  >
  _handleLogin() async {
    final success = await _controller.validateAndLogin(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (success &&
        mounted) {
      _controller.navigateToMain(
        context,
      );
    }
  }

  OutlineInputBorder _border(
    bool error,
  ) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        12,
      ),
      borderSide: BorderSide(
        color: error
            ? Colors.red
            : AppColors.borderLight,
        width: 1.2,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
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
                padding: const EdgeInsets.all(
                  AppSpacing.xl,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.05,
                      ),
                      blurRadius: 12,
                      offset: const Offset(
                        0,
                        6,
                      ),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged:
                          (
                            _,
                          ) => _controller.clearErrors(),
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Masukkan Email",
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        border: _border(
                          _controller.emailError !=
                              null,
                        ),
                        enabledBorder: _border(
                          _controller.emailError !=
                              null,
                        ),
                        focusedBorder: _border(
                          _controller.emailError !=
                              null,
                        ),
                      ),
                    ),
                    if (_controller.emailError !=
                        null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 6,
                        ),
                        child: Text(
                          _controller.emailError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: AppSpacing.lg,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: _controller.obscure,
                      onChanged:
                          (
                            _,
                          ) => _controller.clearErrors(),
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Masukkan Password",
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                        ),
                        border: _border(
                          _controller.passwordError !=
                              null,
                        ),
                        enabledBorder: _border(
                          _controller.passwordError !=
                              null,
                        ),
                        focusedBorder: _border(
                          _controller.passwordError !=
                              null,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => _controller.toggleObscure(),
                          icon: Icon(
                            _controller.obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    if (_controller.passwordError !=
                        null)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 6,
                        ),
                        child: Text(
                          _controller.passwordError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                    Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                          onTap: () => _controller.toggleStaySignedIn(),
                          child: Row(
                            children: [
                              Icon(
                                _controller.staySignedIn
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: _controller.staySignedIn
                                    ? AppColors.primaryNavy
                                    : AppColors.textSecondary,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
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
                          onPressed: () => _controller.showForgotPasswordMessage(
                            context,
                          ),
                          child: Text(
                            'Lupa password',
                            style: AppTextStyles.link,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.xl,
                    ),
                    PrimaryButton(
                      label: _controller.isLoading
                          ? 'Memproses...'
                          : 'Masuk',
                      onPressed: _controller.isLoading
                          ? null
                          : _handleLogin,
                    ),
                    const SizedBox(
                      height: AppSpacing.xl,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: AppTextStyles.bodyMuted,
                        ),
                        TextButton(
                          onPressed: () => _controller.navigateToRegister(
                            context,
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
