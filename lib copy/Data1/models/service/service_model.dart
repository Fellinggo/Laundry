enum EtaType { hours, days, minutes }

class ServiceModel {
  final String id;               // tambahan dari MockAPI (Object ID)
  final String title;
  final int price;               // ubah dari String ke int (karena Number di API)
  final String eta;
  final EtaType etaType;
  final String imagePath;
  final bool isWide;

  ServiceModel({
    required this.id,
    required this.title,
    required this.price,
    required this.eta,
    required this.etaType,
    required this.imagePath,
    required this.isWide,
  });

  // Factory untuk konversi dari JSON MockAPI
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    // Konversi etaType dari string ke enum
    EtaType type;
    switch (json['etaType']) {
      case 'days':
        type = EtaType.days;
        break;
      case 'minutes':
        type = EtaType.minutes;
        break;
      default:
        type = EtaType.hours;
    }

    return ServiceModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] is int ? json['price'] : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      eta: json['eta'] ?? '',
      etaType: type,
      imagePath: json['imagePath'] ?? '',
      isWide: json['isWide'] ?? false,
    );
  }

  // Factory untuk konversi dari dummy data (tetap dipertahankan jika diperlukan)
  factory ServiceModel.fromDummy(dynamic dummyService) {
    return ServiceModel(
      id: dummyService.id ?? '',
      title: dummyService.title,
      price: dummyService.price is int ? dummyService.price : int.tryParse(dummyService.price?.toString() ?? '0') ?? 0,
      eta: dummyService.eta,
      etaType: dummyService.etaType,
      imagePath: dummyService.imagePath,
      isWide: dummyService.isWide,
    );
  }

  // Konversi ke JSON untuk dikirim ke API (POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'eta': eta,
      'etaType': etaType.toString().split('.').last, // 'hours', 'days', 'minutes'
      'imagePath': imagePath,
      'isWide': isWide,
    };
  }

  // Jika masih perlu toMap untuk keperluan lain
  Map<String, dynamic> toMap() {
    return toJson();
  }
}