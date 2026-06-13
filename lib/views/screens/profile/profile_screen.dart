import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/rounded_white_panel.dart';
import '../../widgets/profile_header_widget.dart';
import '../../widgets/address_card_widget.dart';
import '../../widgets/address_empty_widget.dart';
import '../../../controllers/profile/profile_controller.dart';

class ProfileScreen
    extends
        StatelessWidget {
  final bool embedded;

  const ProfileScreen({
    super.key,
    this.embedded = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // Menginisialisasi controller menggunakan ChangeNotifierProvider jika belum di-provide di root atasnya
    return ChangeNotifierProvider<
      ProfileController
    >(
      create:
          (
            _,
          ) => ProfileController(),
      child: const _ProfileContent(),
    );
  }
}

class _ProfileContent
    extends
        StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller = context
        .read<
          ProfileController
        >();

    // Menyeleksi data secara reaktif agar komponen rebuild hanya jika field spesifik ini berubah
    final profile =
        context.select<
          ProfileController,
          dynamic
        >(
          (
            c,
          ) => c.profile,
        );
    final isLoggedIn =
        context.select<
          ProfileController,
          bool
        >(
          (
            c,
          ) => c.isLoggedIn,
        );
    final addresses =
        context.select<
          ProfileController,
          List<
            dynamic
          >
        >(
          (
            c,
          ) => c.addresses,
        );

    final top = ProfileHeaderWidget(
      name: profile.name,
      email: profile.email,
      isLoggedIn: isLoggedIn,
      onEditName: () => controller.handleProtectedAction(
        context,
        () => controller.editName(
          context,
        ),
      ),
      onSettingsTap: () => controller.navigateToSettings(
        context,
      ),
    );

    final sheet = RoundedWhitePanel(
      topRadius: 28,
      padding: const EdgeInsets.all(
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Alamat Pengantaran',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 15,
                ),
              ),
              IconButton(
                onPressed: () => controller.handleProtectedAction(
                  context,
                  () => controller.addNewAddress(
                    context,
                  ),
                ),
                icon: const Icon(
                  Icons.add,
                  color: AppColors.primaryNavy,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          if (isLoggedIn &&
              addresses.isNotEmpty)
            ...List.generate(
              addresses.length,
              (
                i,
              ) {
                final address = addresses[i];
                return Column(
                  children: [
                    AddressCardWidget(
                      index: i,
                      title: address.title,
                      address: address.address,
                      onEdit: () => controller.handleProtectedAction(
                        context,
                        () => controller.editAddress(
                          context,
                          i,
                        ),
                      ),
                      onDelete: () => controller.handleProtectedAction(
                        context,
                        () => controller.deleteAddress(
                          i,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              },
            )
          else
            AddressEmptyWidget(
              isLoggedIn: isLoggedIn,
              onLoginTap: () => controller.navigateToLogin(
                context,
              ),
              onAddAddressTap: () => controller.handleProtectedAction(
                context,
                () => controller.addNewAddress(
                  context,
                ),
              ),
            ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      body: Column(
        children: [
          top,
          const SizedBox(
            height: 24,
          ),
          Expanded(
            child: sheet,
          ),
        ],
      ),
    );
  }
}
