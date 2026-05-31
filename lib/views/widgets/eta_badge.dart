import 'package:flutter/material.dart';

enum EtaType {
  normal,
  fast,
  long,
  express,
}

class EtaBadge
    extends
        StatelessWidget {
  const EtaBadge({
    super.key,
    required this.label,
    this.type = EtaType.normal,
  });

  final String label;
  final EtaType type;

  @override
  Widget build(
    BuildContext context,
  ) {
    final color = _resolveColor(
      type,
    );
    final textColor = _darken(
      color,
      0.35,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(
          0.65,
        ),
        borderRadius: BorderRadius.circular(
          14,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(
            0.25,
          ),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _resolveColor(
    EtaType type,
  ) {
    switch (type) {
      case EtaType.fast:
        return const Color.fromARGB(
          255,
          151,
          192,
          235,
        );
      case EtaType.long:
        return const Color.fromARGB(
          255,
          193,
          158,
          222,
        );
      case EtaType.express:
        return const Color.fromARGB(
          255,
          245,
          138,
          141,
        );
      case EtaType.normal:
        return const Color.fromARGB(
          255,
          150,
          219,
          152,
        );
    }
  }

  Color _darken(
    Color color,
    double amount,
  ) {
    final hsl = HSLColor.fromColor(
      color,
    );
    final hslDark = hsl.withLightness(
      (hsl.lightness -
              amount)
          .clamp(
            0.0,
            2.0,
          ),
    );
    return hslDark.toColor();
  }
}
