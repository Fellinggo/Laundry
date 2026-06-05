import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/controllers/terms_controller.dart';
import 'package:wushlaundry/models/terms_model.dart';
import 'package:wushlaundry/views/widgets/navy_app_bar.dart';
import 'package:wushlaundry/views/widgets/rounded_white_panel.dart';
import 'package:wushlaundry/views/widgets/terms_bullet_widget.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';

class TermsConditionsScreen
    extends
        StatelessWidget {
  const TermsConditionsScreen({
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
          ) => TermsController(),
      child: const _TermsConditionsContent(),
    );
  }
}

class _TermsConditionsContent
    extends
        StatelessWidget {
  const _TermsConditionsContent();

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller =
        Provider.of<
          TermsController
        >(
          context,
        );
    final termsModel = controller.termsModel;

    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Syarat dan Ketentuan',
        onBack: () => controller.goBack(
          context,
        ),
      ),
      body: _buildBody(
        controller,
        termsModel,
      ),
    );
  }

  Widget _buildBody(
    TermsController controller,
    TermsModel termsModel,
  ) {
    // Tampilkan loading indicator jika sedang loading
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.profileNavy,
        ),
      );
    }

    // Tampilkan pesan error jika ada
    if (controller.errorMessage !=
        null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Terjadi kesalahan: ${controller.errorMessage}',
              style: AppTextStyles.bodyMuted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () => controller.refreshTerms(),
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

    // Tampilkan konten utama
    return SizedBox.expand(
      child: RoundedWhitePanel(
        topRadius: 28,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: termsModel.sections.map(
              (
                section,
              ) {
                return _buildSection(
                  section,
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    TermsSection section,
  ) {
    final int sectionIndex =
        section.title ==
            'Syarat Layanan'
        ? 0
        : (section.title ==
                  'Kerusakan & Kehilangan'
              ? 1
              : 2);
    final bool isLastSection =
        sectionIndex ==
        2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionIndex >
            0)
          const SizedBox(
            height: AppSpacing.lg,
          ),
        Text(
          section.title,
          style:
              sectionIndex ==
                  0
              ? AppTextStyles.sectionTitle.copyWith(
                  fontSize: 18,
                )
              : AppTextStyles.sectionTitle,
        ),
        const SizedBox(
          height: 12,
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

            return TermsBulletWidget(
              text: item,
              isLastItem: isLastItem,
            );
          },
        ).toList(),
        if (!isLastSection)
          const SizedBox(
            height: AppSpacing.lg,
          ),
      ],
    );
  }
}
