import 'package:flutter/material.dart';
import '../models/terms_model.dart';

class TermsController
    extends
        ChangeNotifier {
  TermsModel _termsModel = TermsModel.defaultTerms();
  bool _isLoading = false;
  String? _errorMessage;

  TermsModel get termsModel => _termsModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TermsController() {
    loadTermsData();
  }

  // Untuk loading data (bisa dari API/local storage nanti)
  Future<
    void
  >
  loadTermsData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulasi loading dari local storage atau API
      // Untuk sekarang menggunakan data default
      await Future.delayed(
        const Duration(
          milliseconds: 100,
        ),
      ); // Simulasi loading
      _termsModel = TermsModel.defaultTerms();
      _isLoading = false;
      notifyListeners();
    } catch (
      e
    ) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Untuk refresh data jika diperlukan
  Future<
    void
  >
  refreshTerms() async {
    await loadTermsData();
  }

  // Untuk navigasi kembali
  void goBack(
    BuildContext context,
  ) {
    Navigator.pop(
      context,
    );
  }
}
