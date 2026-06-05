import 'package:flutter/material.dart';

class AddressEmptyWidget
    extends
        StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback? onLoginTap;
  final VoidCallback? onAddAddressTap;

  const AddressEmptyWidget({
    super.key,
    required this.isLoggedIn,
    this.onLoginTap,
    this.onAddAddressTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    if (isLoggedIn) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ),
          child: Column(
            children: [
              const Icon(
                Icons.location_off_outlined,
                color: Colors.grey,
                size: 48,
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Belum ada alamat tersimpan\nTap + untuk menambahkan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          20.0,
        ),
        child: Column(
          children: [
            const Icon(
              Icons.location_off_outlined,
              color: Colors.grey,
              size: 48,
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Silakan login untuk melihat alamat',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: onLoginTap,
              child: const Text(
                'Login Sekarang',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
