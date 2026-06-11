import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../main_shell/controllers/main_shell_controller.dart';
import '../../shared/widgets/curved_navy_header.dart';
import '../../shared/widgets/labeled_text_field.dart';
import '../../shared/widgets/phone_input_field.dart';
import '../../shared/widgets/primary_button.dart';
import '../controllers/register_controller.dart';// Tambah import ini

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterController>(
      create: (_) => RegisterController(),
      child: const _RegisterContent(),
    );
  }
}

class _RegisterContent extends StatefulWidget {
  const _RegisterContent();

  @override
  State<_RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<_RegisterContent> {
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final controller = context.read<RegisterController>();
    final success = await controller.register(context);
    if (success && mounted) {
      context.read<MainShellController>().goToHomeTab(); // Tambah baris ini
      controller.navigateToMain(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RegisterController>();

    final isLoading = context.select<RegisterController, bool>(
      (c) => c.isLoading,
    );
    final obscurePassword = context.select<RegisterController, bool>(
      (c) => c.obscurePassword,
    );
    final obscureConfirmPassword = context.select<RegisterController, bool>(
      (c) => c.obscureConfirmPassword,
    );

    final emailError = context.select<RegisterController, String?>(
      (c) => c.emailError,
    );
    final phoneError = context.select<RegisterController, String?>(
      (c) => c.phoneError,
    );
    final passwordError = context.select<RegisterController, String?>(
      (c) => c.passwordError,
    );
    final confirmPasswordError = context.select<RegisterController, String?>(
      (c) => c.confirmPasswordError,
    );

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
                        onChanged: (value) => controller.updateName(value),
                      ),
                      const SizedBox(height: 10),
                      LabeledTextField(
                        label: 'Email',
                        hint: 'Masukkan Email',
                        prefixIcon: Icons.email_outlined,
                        errorText: emailError,
                        onChanged: (value) => controller.updateEmail(value),
                      ),
                      const SizedBox(height: 10),
                      PhoneInputField(
                        controller: _phoneController,
                        errorText: phoneError,
                        onChanged: (value) => controller.updatePhone(value),
                      ),
                      const SizedBox(height: 10),
                      LabeledTextField(
                        label: 'Password',
                        hint: 'Masukkan Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscure: obscurePassword,
                        errorText: passwordError,
                        onChanged: (value) => controller.updatePassword(value),
                        suffix: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            obscurePassword
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
                        obscure: obscureConfirmPassword,
                        errorText: confirmPasswordError,
                        onChanged: (value) =>
                            controller.updateConfirmPassword(value),
                        suffix: IconButton(
                          onPressed: controller.toggleConfirmPasswordVisibility,
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      PrimaryButton(
                        label: isLoading ? 'Memproses...' : 'Daftar',
                        onPressed: isLoading ? null : _handleRegister,
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
