import 'package:flutter/material.dart';

class ServiceFilterChip
    extends
        StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final String title;
  final Function(
    bool,
  )
  onSelected;

  const ServiceFilterChip({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.title,
    required this.onSelected,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: FilterChip(
        selected: isSelected,
        onSelected: onSelected,
        label: Row(
          children: [
            Icon(
              icon,
              size: 18,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              title,
            ),
          ],
        ),
      ),
    );
  }
}
