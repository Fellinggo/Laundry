import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class OrderDetailBox
    extends
        StatelessWidget {
  final Widget child;

  const OrderDetailBox({
    super.key,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color: AppColors.borderLight,
        ),
      ),
      child: child,
    );
  }
}
