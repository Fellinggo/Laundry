import 'package:flutter/material.dart';
import 'package:wushlaundry/views/widgets/primary_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import 'address_option_tile.dart';

class AddressSelector
    extends
        StatelessWidget {
  final Map<
    String,
    String
  >
  addresses;
  final String selectedAddressType;
  final bool showAddressOptions;
  final bool isLoadingAddresses;
  final TextEditingController customAddressController;
  final VoidCallback onAddressTap;
  final Function(
    String,
  )
  onAddressSelected;
  final VoidCallback onUseCustomAddress;
  final VoidCallback onNavigateToProfile;

  const AddressSelector({
    super.key,
    required this.addresses,
    required this.selectedAddressType,
    required this.showAddressOptions,
    required this.isLoadingAddresses,
    required this.customAddressController,
    required this.onAddressTap,
    required this.onAddressSelected,
    required this.onUseCustomAddress,
    required this.onNavigateToProfile,
  });

  String _getSelectedAddress() {
    if (selectedAddressType ==
        'Custom') {
      return customAddressController.text;
    }
    if (selectedAddressType.isNotEmpty &&
        addresses.containsKey(
          selectedAddressType,
        )) {
      return addresses[selectedAddressType]!;
    }
    return '';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (isLoadingAddresses) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(
            14,
          ),
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    if (addresses.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(
          16,
        ),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(
            14,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.location_off_outlined,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Belum ada alamat tersimpan',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              onPressed: onNavigateToProfile,
              child: const Text(
                'Tambah Alamat di Profil',
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: onAddressTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(
                14,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedAddressType,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        _getSelectedAddress(),
                        style: AppTextStyles.bodyMuted,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
        if (showAddressOptions) ...[
          const SizedBox(
            height: 10,
          ),
          ...addresses.keys.map(
            (
              key,
            ) => AddressOptionTile(
              title: key,
              address: addresses[key]!,
              onTap: () => onAddressSelected(
                key,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: customAddressController,
            decoration: InputDecoration(
              hintText: 'Atau masukkan alamat lain...',
              filled: true,
              fillColor: AppColors.inputFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  14,
                ),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged:
                (
                  _,
                ) {},
          ),
          const SizedBox(
            height: 10,
          ),
          PrimaryButton(
            label: 'Gunakan alamat ini',
            onPressed: onUseCustomAddress,
          ),
        ],
      ],
    );
  }
}
