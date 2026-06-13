import 'package:wushlaundry/models/profile/address_model.dart';

class AddressModelDummy {
  static List<
    AddressModel
  >
  get defaultAddresses => [
    AddressModel(
      title: 'Rumah',
      address: 'Jl. Contoh No. 123, RT 01/RW 02, Kelurahan Contoh, Kecamatan Contoh, Kota Contoh, 12345',
    ),
    AddressModel(
      title: 'Kantor',
      address: 'Jl. Perkantoran No. 45, RT 03/RW 04, Kelurahan Bisnis, Kecamatan Pusat, Kota Contoh, 67890',
    ),
    AddressModel(
      title: 'Kost',
      address: 'Jl. Pendidikan No. 67, RT 02/RW 01, Kelurahan Mahasiswa, Kecamatan Belajar, Kota Contoh, 54321',
    ),
  ];

  // Alternatif jika ingin dari JSON
  static List<
    AddressModel
  >
  fromJson(
    List<
      dynamic
    >
    jsonList,
  ) {
    return jsonList
        .map(
          (
            json,
          ) => AddressModel.fromMap(
            json,
          ),
        )
        .toList();
  }

  // Untuk keperluan dummy data injection
  static List<
    Map<
      String,
      String
    >
  >
  get dummyMaps => [
    {
      'title': 'Rumah',
      'address': 'Jl. Contoh No. 123, RT 01/RW 02, Kelurahan Contoh, Kecamatan Contoh, Kota Contoh, 12345',
    },
    {
      'title': 'Kantor',
      'address': 'Jl. Perkantoran No. 45, RT 03/RW 04, Kelurahan Bisnis, Kecamatan Pusat, Kota Contoh, 67890',
    },
    {
      'title': 'Kost',
      'address': 'Jl. Pendidikan No. 67, RT 02/RW 01, Kelurahan Mahasiswa, Kecamatan Belajar, Kota Contoh, 54321',
    },
  ];
}
