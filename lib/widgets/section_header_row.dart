import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

class SectionHeaderRow extends StatelessWidget {
  const SectionHeaderRow({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!, style: AppTextStyles.link),
            ),
        ],
      ),
    );
  }
}
