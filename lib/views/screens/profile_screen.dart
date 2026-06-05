import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/rounded_white_panel.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/address_card_widget.dart';
import '../widgets/address_empty_widget.dart';
import '../../controllers/profile_controller.dart';

class ProfileScreen
    extends
        StatefulWidget {
  const ProfileScreen({
    super.key,
    this.embedded = false,
  });

  final bool embedded;

  @override
  State<
    ProfileScreen
  >
  createState() => _ProfileScreenState();
}

class _ProfileScreenState
    extends
        State<
          ProfileScreen
        > {
  late ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController();
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

  @override
  Widget build(
    BuildContext context,
  ) {
    final profile = _controller.profile;
    final isLoggedIn = _controller.isLoggedIn;
    final addresses = _controller.addresses;

    final top = ProfileHeaderWidget(
      name: profile.name,
      email: profile.email,
      isLoggedIn: isLoggedIn,
      onEditName: () => _controller.handleProtectedAction(
        context,
        () => _controller.editName(
          context,
        ),
      ),
      onSettingsTap: () => _controller.navigateToSettings(
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
                onPressed: () => _controller.handleProtectedAction(
                  context,
                  () => _controller.addNewAddress(
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
                      onEdit: () => _controller.handleProtectedAction(
                        context,
                        () => _controller.editAddress(
                          context,
                          i,
                        ),
                      ),
                      onDelete: () => _controller.handleProtectedAction(
                        context,
                        () => _controller.deleteAddress(
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
              onLoginTap: () => _controller.navigateToLogin(
                context,
              ),
              onAddAddressTap: () => _controller.handleProtectedAction(
                context,
                () => _controller.addNewAddress(
                  context,
                ),
              ),
            ),
        ],
      ),
    );

    final bodyContent = Column(
      children: [
        top,
        const SizedBox(
          height: 24,
        ),
        Expanded(
          child: sheet,
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      body: bodyContent,
    );
  }
}
