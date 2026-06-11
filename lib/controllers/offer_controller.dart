import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wushlaundry/views/widgets/login_modal_sheet.dart';
import '../models/offer_model.dart';

class OffersController extends ChangeNotifier {
  bool _loggedIn;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenServices;

  List<OfferModel> _offers = [];
  bool _isLoading = false;

  List<OfferModel> get offers => _offers;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _loggedIn;

  OffersController({
    required bool loggedIn,
    this.onOpenNotifications,
    this.onOpenServices,
  }) : _loggedIn = loggedIn {
    loadOffers();
  }

  /// Memperbarui status login secara dinamis dari parameter widget di luar
  void updateLoginStatus(bool loggedIn) {
    if (_loggedIn != loggedIn) {
      _loggedIn = loggedIn;
      notifyListeners();
    }
  }

  void loadOffers() {
    _offers = OfferModel.getDefaultOffers();
    notifyListeners();
  }

  List<OfferModel> getNewUserOffers() {
    return _offers
        .where((offer) => offer.category == OfferCategory.newUser)
        .toList();
  }

  List<OfferModel> getSpecialOffers() {
    return _offers
        .where((offer) => offer.category == OfferCategory.special)
        .toList();
  }

  void handleNotificationTap(BuildContext context) {
    if (!_loggedIn) {
      showLoginModal(context);
      return;
    }
    onOpenNotifications?.call();
  }

  Future<void> handlePromoCardTap(
    BuildContext context,
    OfferModel offer,
  ) async {
    if (!_loggedIn) {
      showLoginModal(context);
      return;
    }

    // Copy promo code to clipboard
    await Clipboard.setData(ClipboardData(text: offer.promoCode));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kode ${offer.promoCode} berhasil disalin'),
          duration: const Duration(milliseconds: 800),
        ),
      );
    }

    // Wait a bit before navigating
    await Future.delayed(const Duration(milliseconds: 500));

    onOpenServices?.call();
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
