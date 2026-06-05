import 'package:flutter/material.dart';
import 'package:wushlaundry/constants/app_text_styles.dart';
import 'package:wushlaundry/views/widgets/labeled_text_field.dart';
import 'package:wushlaundry/views/widgets/primary_button.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../controllers/add_address_controller.dart';

class AddAddressScreen
    extends
        StatefulWidget {
  const AddAddressScreen({
    super.key,
  });

  @override
  State<
    AddAddressScreen
  >
  createState() => _AddAddressScreenState();
}

class _AddAddressScreenState
    extends
        State<
          AddAddressScreen
        > {
  final controller = AddAddressController();

  final TextEditingController addressController = TextEditingController();

  String? selectedTitle;
  String? addressError;
  String? titleError;

  bool _validate() {
    setState(
      () {
        titleError = controller.validateTitle(
          selectedTitle,
        );

        addressError = controller.validateAddress(
          addressController.text,
        );
      },
    );

    return titleError ==
            null &&
        addressError ==
            null;
  }

  void _saveAddress() {
    if (!_validate()) return;

    final addressData = controller.createAddress(
      title: selectedTitle!,
      address: addressController.text,
    );

    Navigator.pop(
      context,
      addressData.toMap(),
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
        title: Text(
          'Tambah Alamat',
          style: AppTextStyles.screenTitleWhite.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipe Alamat',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(
                  AppSpacing.inputRadius,
                ),
                border: Border.all(
                  color:
                      titleError !=
                          null
                      ? Colors.red
                      : AppColors.borderLight,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child:
                    DropdownButton<
                      String
                    >(
                      value: selectedTitle,
                      hint: Text(
                        'Pilih Tipe Alamat',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      isExpanded: true,
                      items: controller.titleOptions.map(
                        (
                          title,
                        ) {
                          return DropdownMenuItem<
                            String
                          >(
                            value: title,
                            child: Text(
                              title,
                              style: AppTextStyles.body,
                            ),
                          );
                        },
                      ).toList(),
                      onChanged:
                          (
                            String? newValue,
                          ) {
                            setState(
                              () {
                                selectedTitle = newValue;
                                titleError = null;
                              },
                            );
                          },
                    ),
              ),
            ),

            if (titleError !=
                null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 12,
                ),
                child: Text(
                  titleError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),

            const SizedBox(
              height: 24,
            ),

            LabeledTextField(
              label: 'Alamat Lengkap',
              hint: 'Masukkan alamat lengkap',
              prefixIcon: Icons.location_on_outlined,
              controller: addressController,
              maxLines: 3,
              errorText: addressError,
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Contoh: Jl. Melati No. 12, Kel. Cilandak, Kec. Cilandak, Jakarta Selatan, DKI Jakarta 12430',
              style: AppTextStyles.bodyMuted.copyWith(
                fontSize: 11,
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            PrimaryButton(
              label: 'Simpan Alamat',
              onPressed: _saveAddress,
            ),
          ],
        ),
      ),
    );
  }
}
