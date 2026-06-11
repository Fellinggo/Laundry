import 'package:flutter/material.dart';

class WalletLogoBox extends StatelessWidget {
  final String label;
  final Color color;

  const WalletLogoBox({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        border: Border.all(color: color),
      ),
      child: FittedBox(
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
