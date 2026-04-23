import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({super.key});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final titleController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map?;

    if (args != null) {
      titleController.text = args['title'] ?? '';
      addressController.text = args['address'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileNavy,

      appBar: AppBar(
        backgroundColor: AppColors.profileNavy,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Alamat",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Container(
        margin: const EdgeInsets.only(top: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Judul Alamat",
                style: AppTextStyles.sectionTitle,
              ),

              const SizedBox(height: 8),

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Contoh: Rumah / Kantor",
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                "Alamat Lengkap",
                style: AppTextStyles.sectionTitle,
              ),

              const SizedBox(height: 8),

              TextField(
                controller: addressController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Masukkan alamat lengkap",
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, {
                      'title': titleController.text,
                      'address': addressController.text,
                    });
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
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