import 'package:wushlaundry/views/widgets/eta_badge.dart';

// Ini adalah MODEL untuk data service
class ServiceModel {
  final String title;
  final String price;
  final String eta;
  final EtaType etaType;
  final String imagePath;
  final bool isWide;

  ServiceModel({
    required this.title,
    required this.price,
    required this.eta,
    required this.etaType,
    required this.imagePath,
    required this.isWide,
  });

  // Factory untuk konversi dari dummy data ke model
  factory ServiceModel.fromDummy(
    dynamic dummyService,
  ) {
    return ServiceModel(
      title: dummyService.title,
      price: dummyService.price,
      eta: dummyService.eta,
      etaType: dummyService.etaType,
      imagePath: dummyService.imagePath,
      isWide: dummyService.isWide,
    );
  }

  Map<
    String,
    dynamic
  >
  toMap() {
    return {
      'title': title,
      'price': price,
      'eta': eta,
      'etaType': etaType.toString(),
      'imagePath': imagePath,
      'isWide': isWide,
    };
  }
}
