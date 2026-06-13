// lib/models/service_model.dart
import '../../views/widgets/eta_badge.dart';
import '../../core/utils/image_helper.dart';

class ServiceModel {
  final String id;
  final String title;
  final String price;
  final String eta;
  final EtaType etaType;
  final String imageKeyword; // Menyimpan keyword dari API
  final bool isWide;

  ServiceModel({
    required this.id,
    required this.title,
    required this.price,
    required this.eta,
    required this.etaType,
    required this.imageKeyword,
    required this.isWide,
  });

  // Getter untuk kemudahan akses (opsional)
  String get imagePath => ImageHelper.getImagePath(imageKeyword);

  // Factory untuk konversi dari API (JSON)
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'].toString(),
      title: json['name'] ?? json['title'] ?? '',
      price: json['price'] ?? '',
      eta: json['eta'] ?? '',
      etaType: _parseEtaType(json['eta_type'] ?? 'normal'),
      imageKeyword: json['image'] ?? '', // Keyword dari API
      isWide: json['is_wide'] ?? false,
    );
  }

  // Konversi ke JSON untuk API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'price': price,
      'eta': eta,
      'eta_type': etaType.toString().split('.').last,
      'image': imageKeyword,
      'is_wide': isWide,
    };
  }

  // Helper parsing EtaType dari string
  static EtaType _parseEtaType(String type) {
    switch (type.toLowerCase()) {
      case 'fast':
        return EtaType.fast;
      case 'long':
        return EtaType.long;
      case 'express':
        return EtaType.express;
      default:
        return EtaType.normal;
    }
  }

  // Factory untuk konversi dari dummy data ke model (fallback)
  factory ServiceModel.fromDummy(dynamic dummyService) {
    return ServiceModel(
      id: dummyService.title.toLowerCase().replaceAll(' ', '_'),
      title: dummyService.title,
      price: dummyService.price,
      eta: dummyService.eta,
      etaType: dummyService.etaType,
      imageKeyword: dummyService.imagePath, // Sesuaikan dengan dummy data
      isWide: dummyService.isWide,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'eta': eta,
      'etaType': etaType.toString(),
      'imageKeyword': imageKeyword,
      'isWide': isWide,
    };
  }
}