import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class NavyCenterTitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NavyCenterTitleAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor = AppColors.headerNavy,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Material(
      color: backgroundColor,
      child: SizedBox(
        height: 56 + top,
        child: Padding(
          padding: EdgeInsets.only(top: top),
          child: Row(
            children: [
              leading ?? const SizedBox(width: 48),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.screenTitleWhite,
                ),
              ),
              SizedBox(
                width: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions ?? const [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavyBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NavyBackAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.backgroundColor = AppColors.headerNavy,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Material(
      color: backgroundColor,
      child: SizedBox(
        height: 56 + top,
        child: Padding(
          padding: EdgeInsets.only(top: top),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack ?? () => Navigator.maybePop(context),
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.iconCircle,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_left, color: AppColors.headerNavy, size: 28),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.screenTitleWhite,
                ),
              ),
              if (actions != null && actions!.isNotEmpty)
                Row(children: actions!)
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}
