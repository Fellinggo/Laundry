import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    // Opsional: bersihkan state provider saat keluar halaman jika tidak memakai blok scope provider lokal
    WidgetsBinding.instance.addPostFrameCallback(
      (
        _,
      ) {
        if (mounted) {
          context
              .read<
                AddAddressController
              >()
              .resetState();
        }
      },
    );
    super.dispose();
  }

  void _saveAddress() {
    final provider = context
        .read<
          AddAddressController
        >();

    // Pemicu validasi di controller
    if (!provider.validate(
      addressController.text,
    ))
      return;

    final addressData = provider.createAddress(
      addressController.text,
    );

    Navigator.pop(
      context,
      addressData.toMap(),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // Mendengarkan perubahan state dari AddAddressController
    final addrProvider = context
        .watch<
          AddAddressController
        >();

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
                      addrProvider.titleError !=
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
                      value: addrProvider.selectedTitle,
                      hint: Text(
                        'Pilih Tipe Alamat',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      isExpanded: true,
                      items: addrProvider.titleOptions.map(
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
                            addrProvider.selectTitle(
                              newValue,
                            );
                          },
                    ),
              ),
            ),

            if (addrProvider.titleError !=
                null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 12,
                ),
                child: Text(
                  addrProvider.titleError!,
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
              errorText: addrProvider.addressError,
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
