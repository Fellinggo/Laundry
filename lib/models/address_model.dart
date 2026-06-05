class AddressModel {
  final String title;
  final String address;

  const AddressModel({
    required this.title,
    required this.address,
  });

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
}
