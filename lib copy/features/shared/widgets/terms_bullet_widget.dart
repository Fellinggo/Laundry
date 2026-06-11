import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';

class TermsBulletWidget extends StatelessWidget {
  final String text;
  final bool isLastItem;

  const TermsBulletWidget({
    super.key,
    required this.text,
    this.isLastItem = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLastItem ? 0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: AppTextStyles.bodyMuted),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMuted,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
