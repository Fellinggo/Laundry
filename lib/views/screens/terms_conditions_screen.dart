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
    return ChangeNotifierProvider<
      TermsController
    >(
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
    final controller = context
        .read<
          TermsController
        >();

    return Scaffold(
      backgroundColor: AppColors.profileNavy,
      appBar: NavyBackAppBar(
        title: 'Syarat dan Ketentuan',
        onBack: () => controller.goBack(
          context,
        ),
      ),
      body: const _TermsConditionsBody(),
    );
  }
}

class _TermsConditionsBody
    extends
        StatelessWidget {
  const _TermsConditionsBody();

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller = context
        .read<
          TermsController
        >();

    // Pemilihan state atomik: Hanya mendengarkan variabel spesifik yang dibutuhkan
    final isLoading =
        context.select<
          TermsController,
          bool
        >(
          (
            c,
          ) => c.isLoading,
        );
    final errorMessage =
        context.select<
          TermsController,
          String?
        >(
          (
            c,
          ) => c.errorMessage,
        );
    final sections =
        context.select<
          TermsController,
          List<
            TermsSection
          >
        >(
          (
            c,
          ) => c.termsModel.sections,
        );

    // 1. State Menampilkan Loading Indicator
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.profileNavy,
        ),
      );
    }

    // 2. State Menampilkan Pesan Error
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

    // 3. State Menampilkan Konten Utama (Data Sukses Dimuat)
    return SizedBox.expand(
      child: RoundedWhitePanel(
        topRadius: 28,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sections.map(
              (
                section,
              ) {
                return _TermsSectionItem(
                  section: section,
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}

class _TermsSectionItem
    extends
        StatelessWidget {
  final TermsSection section;

  const _TermsSectionItem({
    required this.section,
  });

  @override
  Widget build(
    BuildContext context,
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
        ),
        if (!isLastSection)
          const SizedBox(
            height: AppSpacing.lg,
          ),
      ],
    );
  }
}
