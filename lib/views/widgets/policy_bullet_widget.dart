import 'package:flutter/material.dart';
import '../../../constants/app_text_styles.dart';

class PolicyBulletWidget
    extends
        StatelessWidget {
  final String text;
  final bool isLastItem;

  const PolicyBulletWidget({
    super.key,
    required this.text,
    this.isLastItem = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLastItem
            ? 0
            : 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTextStyles.bodyMuted,
          ),
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
