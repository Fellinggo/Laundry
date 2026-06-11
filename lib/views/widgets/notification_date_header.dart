import 'package:flutter/material.dart';
import '../../../constants/app_text_styles.dart';

class NotificationDateHeader extends StatelessWidget {
  final String title;
  final double fontSize;

  const NotificationDateHeader({
    super.key,
    required this.title,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.sectionTitle.copyWith(fontSize: fontSize),
      ),
    );
  }
}
