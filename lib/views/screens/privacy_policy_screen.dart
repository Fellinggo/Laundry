// views/privacy_policy_screen_provider.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/controllers/privacy_controller.dart';
import 'package:wushlaundry/models/privacy_policy_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import '../widgets/navy_app_bar.dart';
import '../widgets/rounded_white_panel.dart';
import '../widgets/policy_bullet_widget.dart';

class PrivacyPolicyScreen
    extends
        StatelessWidget {
  const PrivacyPolicyScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ChangeNotifierProvider(
      create:
          (
            _,
          ) => PrivacyPolicyController(),
      child: const _PrivacyPolicyContent(),
    );
  }
}

class _PrivacyPolicyContent
    extends
        StatelessWidget {
  const _PrivacyPolicyContent();

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller =
        Provider.of<
          PrivacyPolicyController
        >(
          context,
        );
    final policyModel = controller.policyModel;
    final isLoading = controller.isLoading;
    final errorMessage = controller.errorMessage;

    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Kebijakan Privasi',
        onBack: () => controller.goBack(
          context,
        ),
      ),
      body: _buildBody(
        context,
        controller,
        policyModel,
        isLoading,
        errorMessage,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PrivacyPolicyController controller,
    PrivacyPolicyModel policyModel,
    bool isLoading,
    String? errorMessage,
  ) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.profileNavy,
        ),
      );
    }

    if (errorMessage !=
        null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Terjadi kesalahan: $errorMessage',
              style: AppTextStyles.bodyMuted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () => controller.refreshPolicy(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.profileNavy,
              ),
              child: const Text(
                'Coba Lagi',
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox.expand(
      child: RoundedWhitePanel(
        topRadius: 28,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                policyModel.mainTitle,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                policyModel.mainContent,
                style: AppTextStyles.bodyMuted,
                textAlign: TextAlign.justify,
              ),
              ...policyModel.sections.map(
                (
                  section,
                ) => _buildSection(
                  context,
                  controller,
                  section,
                  policyModel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    PrivacyPolicyController controller,
    PrivacyPolicySection section,
    PrivacyPolicyModel policyModel,
  ) {
    final int sectionIndex = policyModel.sections.indexOf(
      section,
    );
    final bool isLastSection =
        sectionIndex ==
        policyModel.sections.length -
            1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppSpacing.xl,
        ),
        Text(
          section.title,
          style: AppTextStyles.sectionTitle,
        ),
        const SizedBox(
          height: 8,
        ),
        ...section.items.asMap().entries.map(
          (
            entry,
          ) {
            final index = entry.key;
            final item = entry.value;
            final bool isLastItem =
                index ==
                section.items.length -
                    1;

            return PolicyBulletWidget(
              text: item,
              isLastItem: isLastItem,
            );
          },
        ).toList(),
        if (section.hasLearnMoreButton) ...[
          const SizedBox(
            height: 8,
          ),
          TextButton(
            onPressed: () => controller.onLearnMorePressed(
              context,
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Text(
              'Pelajari lebih lanjut tentang cookie',
              style: AppTextStyles.link.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
        if (!isLastSection)
          const SizedBox(
            height: AppSpacing.lg,
          ),
      ],
    );
  }
}
