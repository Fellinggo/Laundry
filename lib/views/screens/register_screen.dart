import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../widgets/curved_navy_header.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/phone_input_field.dart';
import '../../controllers/register_controller.dart';

class RegisterScreen
    extends
        StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<
    RegisterScreen
  >
  createState() => _RegisterScreenState();
}

class _RegisterScreenState
    extends
        State<
          RegisterScreen
        > {
  late RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController();
    _controller.addListener(
      _onControllerChanged,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onControllerChanged,
    );
    _controller.dispose();
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
  _handleRegister() async {
    final success = await _controller.register(
      context,
    );
    if (success &&
        mounted) {
      _controller.navigateToMain(
        context,
      );
    }
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
            subtitle: 'Daftar untuk pengalaman laundry yang lebih personal dan praktis',
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(
                0,
                -50,
              ),
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
                        controller: TextEditingController(
                          text: _controller.data.name,
                        ),
                        onChanged:
                            (
                              value,
                            ) => _controller.updateName(
                              value,
                            ), // ← Sekarang tidak merah
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LabeledTextField(
                        label: 'Email',
                        hint: 'Masukkan Email',
                        prefixIcon: Icons.email_outlined,
                        controller: TextEditingController(
                          text: _controller.data.email,
                        ),
                        errorText: _controller.emailError,
                        onChanged:
                            (
                              value,
                            ) => _controller.updateEmail(
                              value,
                            ), // ← Sekarang tidak merah
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PhoneInputField(
                        controller: TextEditingController(
                          text: _controller.data.phone,
                        ),
                        errorText: _controller.phoneError,
                        onChanged:
                            (
                              value,
                            ) => _controller.updatePhone(
                              value,
                            ), // ← PhoneInputField harus punya onChanged juga
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LabeledTextField(
                        label: 'Password',
                        hint: 'Masukkan Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        controller: TextEditingController(
                          text: _controller.data.password,
                        ),
                        obscure: _controller.obscurePassword,
                        errorText: _controller.passwordError,
                        onChanged:
                            (
                              value,
                            ) => _controller.updatePassword(
                              value,
                            ), // ← Sekarang tidak merah
                        suffix: IconButton(
                          onPressed: _controller.togglePasswordVisibility,
                          icon: Icon(
                            _controller.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LabeledTextField(
                        label: 'Konfirmasi Password',
                        hint: 'Masukkan Konfirmasi Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        controller: TextEditingController(
                          text: _controller.data.confirmPassword,
                        ),
                        obscure: _controller.obscureConfirmPassword,
                        errorText: _controller.confirmPasswordError,
                        onChanged:
                            (
                              value,
                            ) => _controller.updateConfirmPassword(
                              value,
                            ), // ← Sekarang tidak merah
                        suffix: IconButton(
                          onPressed: _controller.toggleConfirmPasswordVisibility,
                          icon: Icon(
                            _controller.obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      PrimaryButton(
                        label: _controller.isLoading
                            ? 'Memproses...'
                            : 'Daftar',
                        onPressed: _controller.isLoading
                            ? null
                            : _handleRegister,
                      ),
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
}

class _NoOverscrollBehavior
    extends
        ScrollBehavior {
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
  ScrollPhysics getScrollPhysics(
    BuildContext context,
  ) {
    return const ClampingScrollPhysics();
  }
}
