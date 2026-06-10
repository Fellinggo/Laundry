import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wushlaundry/controllers/address_selector_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'address_option_tile.dart';

class AddressSelector extends StatelessWidget {
  const AddressSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressSelectorController>(
      builder: (context, controller, child) {
        if (controller.isLoadingAddresses) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.inputFill,
                ),
              ),
            ),
          );
        }

        if (controller.addresses.isEmpty && !controller.showAddressOptions) {
          return _buildEmptyState(controller);
        }

        return _buildNormalState(controller);
      },
    );
  }

  Widget _buildEmptyState(AddressSelectorController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Column(
              children: [
                Icon(
                  Icons.location_off_outlined,
                  color: Colors.grey,
                  size: 40,
                ),
                SizedBox(height: 8),
                Text(
                  'Belum ada alamat tersimpan',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.customAddressController,
            maxLines: 3,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Masukkan alamat lengkap...',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.inputFill,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: controller.saveToProfile,
                  onChanged: (_) => controller.toggleSaveToProfile(),
                  checkColor: Colors.white,
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.primaryNavy;
                      }
                      return Colors.white;
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Simpan alamat ke profil',
                style: AppTextStyles.body.copyWith(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNormalState(AddressSelectorController controller) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => controller.toggleAddressOptions(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.selectedAddressType.isNotEmpty
                            ? controller.selectedAddressType
                            : 'Pilih Alamat',
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      if (controller.getSelectedAddress().isNotEmpty)
                        Text(
                          controller.getSelectedAddress(),
                          style: AppTextStyles.bodyMuted,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        if (controller.showAddressOptions) ...[
          const SizedBox(height: 10),
          ...controller.addresses.keys.map(
            (key) => AddressOptionTile(
              title: key,
              address: controller.addresses[key]!,
              isSelected: controller.selectedAddressType == key,
              onTap: () => controller.selectAddressType(key),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller.customAddressController,
            maxLines: 2,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Atau masukkan alamat lain...',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 13,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.inputFill,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: (_) {},
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: controller.saveToProfile,
                  onChanged: (_) => controller.toggleSaveToProfile(),
                  checkColor: Colors.white,
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.primaryNavy;
                      }
                      return Colors.white;
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Simpan alamat ke profil',
                style: AppTextStyles.body.copyWith(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}