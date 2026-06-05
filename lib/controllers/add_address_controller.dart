import '../models/address_model.dart';

class AddAddressController {
  final List<
    String
  >
  titleOptions = [
    'Rumah',
    'Kantor',
    'Kos',
    'Apartemen',
    'Lainnya',
  ];

  String? validateTitle(
    String? title,
  ) {
    if (title ==
            null ||
        title.isEmpty) {
      return 'Pilih tipe alamat';
    }
    return null;
  }

  String? validateAddress(
    String address,
  ) {
    final value = address.trim();

    if (value.isEmpty) {
      return 'Alamat tidak boleh kosong';
    }

    if (value.length <
        10) {
      return 'Alamat terlalu pendek (minimal 10 karakter)';
    }

    return null;
  }

  AddressModel createAddress({
    required String title,
    required String address,
  }) {
    return AddressModel(
      title: title,
      address: address.trim(),
    );
  }
}
