import 'package:flutter/material.dart';
import 'package:wushlaundry/views/widgets/quantity_stepper.dart';
import '../../../constants/app_text_styles.dart';

class SelectedServiceItem
    extends
        StatelessWidget {
  final String title;
  final String displayTitle;
  final String price;
  final String image;
  final int quantity;
  final int priceValue;
  final Function(
    int,
  )
  onQuantityChanged;

  const SelectedServiceItem({
    super.key,
    required this.title,
    required this.displayTitle,
    required this.price,
    required this.image,
    required this.quantity,
    required this.priceValue,
    required this.onQuantityChanged,
  });

  String _formatPrice(
    int value,
  ) {
    return 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          14,
        ),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              10,
            ),
            child: Image.asset(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 14,
                  ),
                ),
                Text(
                  _formatPrice(
                    priceValue,
                  ),
                  style: AppTextStyles.bodyMuted,
                ),
              ],
            ),
          ),
          QuantityStepper(
            value: quantity,
            onChanged: onQuantityChanged,
          ),
        ],
      ),
    );
  }
}
