import 'package:flutter/material.dart';
import '../../core/constants/app_text_styles.dart';

class ServiceSectionHeader
    extends
        StatelessWidget {
  final String title;

  const ServiceSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Text(
      title,
      style: AppTextStyles.sectionTitle.copyWith(
        fontSize: 16,
      ),
    );
  }
}
