import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class PinKeypad extends StatelessWidget {
  const PinKeypad({super.key, required this.onDigit, required this.onBackspace});

  final ValueChanged<int> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.keypadBg,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      child: Column(
        children: [
          _row([1, 2, 3]),
          _row([4, 5, 6]),
          _row([7, 8, 9]),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(child: _key(Text('0', style: _numStyle), () => onDigit(0))),
              Expanded(
                child: _key(const Icon(Icons.backspace_outlined, color: AppColors.textDark, size: 22), onBackspace),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static final TextStyle _numStyle = AppTextStyles.sectionTitle.copyWith(fontSize: 26, color: AppColors.textDark);

  Widget _row(List<int> nums) {
    return Row(
      children: nums
          .map(
            (n) => Expanded(
              child: _key(Text('$n', style: _numStyle), () => onDigit(n)),
            ),
          )
          .toList(),
    );
  }

  Widget _key(Widget child, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(height: 52, child: Center(child: child)),
      ),
    );
  }
}
