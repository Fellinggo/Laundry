import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class ProfileHeaderWidget
    extends
        StatelessWidget {
  final String name;
  final String email;
  final bool isLoggedIn;
  final VoidCallback onEditName;
  final VoidCallback onSettingsTap;

  const ProfileHeaderWidget({
    super.key,
    required this.name,
    required this.email,
    required this.isLoggedIn,
    required this.onEditName,
    required this.onSettingsTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Profil Saya',
                  style: AppTextStyles.screenTitleWhite.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: onSettingsTap,
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: isLoggedIn
              ? onEditName
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.iconCircle,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: AppTextStyles.sectionTitle.copyWith(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isLoggedIn) ...[
                            const SizedBox(
                              width: 6,
                            ),
                            const Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: Colors.white70,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        email,
                        style: AppTextStyles.bodyMuted.copyWith(
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
