class AddressModel {
  final String title;
  final String address;

  AddressModel({
    required this.title,
    required this.address,
  });

  factory AddressModel.fromMap(
    Map<
      String,
      dynamic
    >
    map,
  ) {
    return AddressModel(
      title:
          map['title'] ??
          'Alamat',
      address:
          map['address'] ??
          '',
    );
  }

  Map<
    String,
    dynamic
  >
  toMap() {
    return {
      'title': title,
      'address': address,
    };
  }

  AddressModel copyWith({
    String? title,
    String? address,
  }) {
    return AddressModel(
      title:
          title ??
          this.title,
      address:
          address ??
          this.address,
    );
  }
}
