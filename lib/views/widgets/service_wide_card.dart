import 'package:flutter/material.dart';
import 'package:wushlaundry/views/widgets/eta_badge.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/image_helper.dart';

class ServiceWideCard extends StatelessWidget {
  final String title;
  final String price;
  final String eta;
  final String imageKeyword; // Menggunakan keyword, bukan path
  final VoidCallback onTap;

  const ServiceWideCard({
    super.key,
    required this.title,
    required this.price,
    required this.eta,
    required this.imageKeyword,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.36),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Menggunakan ImageHelper dengan keyword
                    ImageHelper.buildServiceImage(
                      imageKeyword: imageKeyword,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: EtaBadge(
                        label: eta,
                        type: EtaType.normal,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}