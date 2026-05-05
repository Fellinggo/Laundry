import '../widgets/eta_badge.dart';

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
    this.isWide = false,
  });
}

final List<ServiceModel> serviceDummy = [
  ServiceModel(
    title: 'Cuci Regular',
    price: 'Rp 20.000 / Plastik',
    eta: 'ETA 10 jam',
    etaType: EtaType.normal,
    imagePath: 'assets/images/Cucireg.png',
  ),
  ServiceModel(
    title: 'Cuci Setrika',
    price: 'Rp 28.000 / Plastik',
    eta: 'ETA 11 jam',
    etaType: EtaType.fast,
    imagePath: 'assets/images/Cucisetrika.png',
  ),
  ServiceModel(
    title: 'Cuci Kering',
    price: 'Rp 23.000 / Plastik',
    eta: 'ETA 12 jam',
    etaType: EtaType.long,
    imagePath: 'assets/images/kering.png',
  ),
  ServiceModel(
    title: 'Paket Service',
    price: 'Rp 48.000 / Plastik',
    eta: 'Express',
    etaType: EtaType.express,
    imagePath: 'assets/images/paket.png',
  ),
  ServiceModel(
    title: 'Cuci Jas / Gaun',
    price: 'Rp 23.000 / item',
    eta: 'Express',
    etaType: EtaType.express,
    imagePath: 'assets/images/jasgaun.png',
  ),
  ServiceModel(
    title: 'Setrika Saja',
    price: 'Rp 21.000 / Plastik',
    eta: 'ETA 11 jam',
    etaType: EtaType.fast,
    imagePath: 'assets/images/setrikasaja.png',
  ),

  ServiceModel(
    title: 'Cuci Bedcover / Selimut / Sprei',
    price: 'Rp 25.000 / Item',
    eta: 'ETA 12 jam',
    etaType: EtaType.normal,
    imagePath: 'assets/images/sprei.png',
    isWide: true,
  ),
  ServiceModel(
    title: 'Cuci Sepatu',
    price: 'Rp 20.000 / Item',
    eta: 'ETA 12 jam',
    etaType: EtaType.normal,
    imagePath: 'assets/images/sepatu.png',
    isWide: true,
  ),
];