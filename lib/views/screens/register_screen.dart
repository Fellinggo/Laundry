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

  // Buat TextEditingController di sini, bukan di build
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController();
    _controller.addListener(
      _onControllerChanged,
    );

    // Inisialisasi controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    // Setup listeners untuk sync dengan controller
    _nameController.addListener(
      () {
        if (_nameController.text !=
            _controller.data.name) {
          _controller.updateName(
            _nameController.text,
          );
        }
      },
    );
    _emailController.addListener(
      () {
        if (_emailController.text !=
            _controller.data.email) {
          _controller.updateEmail(
            _emailController.text,
          );
        }
      },
    );
    _phoneController.addListener(
      () {
        if (_phoneController.text !=
            _controller.data.phone) {
          _controller.updatePhone(
            _phoneController.text,
          );
        }
      },
    );
    _passwordController.addListener(
      () {
        if (_passwordController.text !=
            _controller.data.password) {
          _controller.updatePassword(
            _passwordController.text,
          );
        }
      },
    );
    _confirmPasswordController.addListener(
      () {
        if (_confirmPasswordController.text !=
            _controller.data.confirmPassword) {
          _controller.updateConfirmPassword(
            _confirmPasswordController.text,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onControllerChanged,
    );
    _controller.dispose();

    // Dispose semua controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      // Update text controllers jika data berubah dari luar
      if (_nameController.text !=
          _controller.data.name) {
        _nameController.text = _controller.data.name;
      }
      if (_emailController.text !=
          _controller.data.email) {
        _emailController.text = _controller.data.email;
      }
      if (_phoneController.text !=
          _controller.data.phone) {
        _phoneController.text = _controller.data.phone;
      }
      if (_passwordController.text !=
          _controller.data.password) {
        _passwordController.text = _controller.data.password;
      }
      if (_confirmPasswordController.text !=
          _controller.data.confirmPassword) {
        _confirmPasswordController.text = _controller.data.confirmPassword;
      }
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
                        controller: _nameController, // Gunakan controller yang sudah dibuat
                        onChanged:
                            (
                              value,
                            ) => _controller.updateName(
                              value,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LabeledTextField(
                        label: 'Email',
                        hint: 'Masukkan Email',
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController, // Gunakan controller yang sudah dibuat
                        errorText: _controller.emailError,
                        onChanged:
                            (
                              value,
                            ) => _controller.updateEmail(
                              value,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PhoneInputField(
                        controller: _phoneController, // Gunakan controller yang sudah dibuat
                        errorText: _controller.phoneError,
                        onChanged:
                            (
                              value,
                            ) => _controller.updatePhone(
                              value,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LabeledTextField(
                        label: 'Password',
                        hint: 'Masukkan Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        controller: _passwordController, // Gunakan controller yang sudah dibuat
                        obscure: _controller.obscurePassword,
                        errorText: _controller.passwordError,
                        onChanged:
                            (
                              value,
                            ) => _controller.updatePassword(
                              value,
                            ),
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
                        controller: _confirmPasswordController, // Gunakan controller yang sudah dibuat
                        obscure: _controller.obscureConfirmPassword,
                        errorText: _controller.confirmPasswordError,
                        onChanged:
                            (
                              value,
                            ) => _controller.updateConfirmPassword(
                              value,
                            ),
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
