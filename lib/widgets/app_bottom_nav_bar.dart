import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = BottomNavVariant.white,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final BottomNavVariant variant;

  @override
  Widget build(BuildContext context) {
    final bg = variant == BottomNavVariant.navy
        ? AppColors.headerNavyAlt
        : AppColors.white;
    final active = variant == BottomNavVariant.navy
        ? AppColors.skyTab
        : AppColors.actionBlue;
    final inactive = variant == BottomNavVariant.navy
        ? Colors.white54
        : AppColors.textMuted;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [
          if (variant == BottomNavVariant.white)
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      selected: currentIndex == 0,
                      activeColor: active,
                      inactiveColor: inactive,
                      onTap: () => onTap(0),
                    ),
                    _NavItem(
                      icon: Icons.receipt_long_outlined,
                      label: 'Order',
                      selected: currentIndex == 1,
                      activeColor: active,
                      inactiveColor: inactive,
                      onTap: () => onTap(1),
                    ),
                    const SizedBox(width: 45),
                    _NavItem(
                      icon: Icons.percent_rounded,
                      label: 'Diskon',
                      selected: currentIndex == 3,
                      activeColor: active,
                      inactiveColor: inactive,
                      onTap: () => onTap(3),
                    ),
                    _NavItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Profile',
                      selected: currentIndex == 4,
                      activeColor: active,
                      inactiveColor: inactive,
                      onTap: () => onTap(4),
                    ),
                  ],
                ),
              ),

              /// CENTER ACTION BUTTON
              Positioned(
                top: -10,
                child: GestureDetector(
                  onTap: () => onTap(2),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.headerNavy,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo_white.png',
                        width: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum BottomNavVariant { white, navy }

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}