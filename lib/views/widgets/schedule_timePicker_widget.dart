import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class ScheduleTimePicker
    extends
        StatelessWidget {
  final TimeOfDay? selectedTime;
  final bool hasError;
  final VoidCallback onTap;
  final String label;

  const ScheduleTimePicker({
    super.key,
    required this.selectedTime,
    required this.hasError,
    required this.onTap,
    this.label = 'Pilih jam',
  });

  String _formatTime() {
    if (selectedTime ==
        null)
      return label;
    final h = selectedTime!.hour.toString().padLeft(
      2,
      '0',
    );
    final m = selectedTime!.minute.toString().padLeft(
      2,
      '0',
    );
    return '$h:$m';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(
                14,
              ),
              border: Border.all(
                color: hasError
                    ? Colors.red
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    _formatTime(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            height: 14,
            child: hasError
                ? const Text(
                    'Wajib diisi',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
