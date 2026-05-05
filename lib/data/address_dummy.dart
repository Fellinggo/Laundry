class AddressModel {
  final String title;
  final String address;

  AddressModel({
    required this.title,
    required this.address,
  });
}

final List<AddressModel> addressDummy = [
  AddressModel(
    title: 'Rumah',
    address: 'Jl. Melati No. 12, Jakarta Selatan',
  ),
  AddressModel(
    title: 'Kantor',
    address: 'Gedung Aurora Lt. 5, Jl. Sudirman',
  ),
];