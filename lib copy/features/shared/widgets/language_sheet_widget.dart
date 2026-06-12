import 'package:flutter/material.dart';

import '../../../Data1/models/static/setting_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';


class LanguageSheetWidget extends StatelessWidget {
  final int selectedIndex;
  final List<LanguageOption> languageOptions;
  final Function(int) onLanguageSelected;

  const LanguageSheetWidget({
    super.key,
    required this.selectedIndex,
    required this.languageOptions,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(languageOptions.length, (index) {
          final option = languageOptions[index];

          return ListTile(
            title: Text(option.name),
            subtitle: !option.isAvailable && option.comingSoonText != null
                ? Text(
                    option.comingSoonText!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.danger,
                      fontSize: 11,
                    ),
                  )
                : null,
            trailing: selectedIndex == index && option.isAvailable
                ? const Icon(Icons.check_circle, color: AppColors.primaryNavy)
                : null,
            onTap: () {
              if (option.isAvailable) {
                onLanguageSelected(index);
                Navigator.pop(context);
              }
            },
          );
        }),
      ),
    );
  }
}
