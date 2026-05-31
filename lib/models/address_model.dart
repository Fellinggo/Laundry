class Address {
  final String id;
  final String label;
  final String fullAddress;
  final String phone;

  Address({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.phone,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      label: json['label'],
      fullAddress: json['full_address'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'full_address': fullAddress,
      'phone': phone,
    };
  }
}