import '../models/address_model.dart';

class EditAddressController {
  AddressModel loadAddress(
    Map? args,
  ) {
    return AddressModel(
      title:
          args?['title'] ??
          '',
      address:
          args?['address'] ??
          '',
    );
  }

  AddressModel saveAddress({
    required String title,
    required String address,
  }) {
    return AddressModel(
      title: title.trim(),
      address: address.trim(),
    );
  }
}
