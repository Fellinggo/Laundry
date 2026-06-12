class OfferModel {
  final String id;
  final String title;
  final String imagePath;
  final String promoCode;
  final OfferCategory category;

  OfferModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.promoCode,
    required this.category,
  });

  factory OfferModel.newUserOffer() {
    return OfferModel(
      id: 'new_user_offer',
      title: 'Tawaran Pengguna Baru',
      imagePath: 'assets/images/promos.png',
      promoCode: 'SSSd789',
      category: OfferCategory.newUser,
    );
  }

  factory OfferModel.specialOffer({
    required String id,
    required String title,
    required String imagePath,
    required String promoCode,
  }) {
    return OfferModel(
      id: id,
      title: title,
      imagePath: imagePath,
      promoCode: promoCode,
      category: OfferCategory.special,
    );
  }

  static List<OfferModel> getDefaultOffers() {
    return [
      OfferModel.newUserOffer(),
      OfferModel.specialOffer(
        id: 'payday_offer',
        title: 'Penawaran Khusus',
        imagePath: 'assets/images/pays.png',
        promoCode: 'PAYDAYWUSH',
      ),
      OfferModel.specialOffer(
        id: 'bedcover_offer',
        title: 'Penawaran Khusus',
        imagePath: 'assets/images/bedcovers.png',
        promoCode: 'BERSIHSPREI',
      ),
    ];
  }
}

enum OfferCategory { newUser, special }

extension OfferCategoryExtension on OfferCategory {
  String get displayTitle {
    switch (this) {
      case OfferCategory.newUser:
        return 'Tawaran Pengguna Baru';
      case OfferCategory.special:
        return 'Penawaran Khusus';
    }
  }
}
