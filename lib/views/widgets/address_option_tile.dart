import 'package:flutter/material.dart';

class AddressOptionTile
    extends
        StatelessWidget {
  final String title;
  final String address;
  final VoidCallback onTap;

  const AddressOptionTile({
    super.key,
    required this.title,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ListTile(
      leading: const Icon(
        Icons.home_outlined,
      ),
      title: Text(
        title,
      ),
      subtitle: Text(
        address,
      ),
      onTap: onTap,
    );
  }
}
