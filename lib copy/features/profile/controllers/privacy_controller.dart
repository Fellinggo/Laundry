import 'package:flutter/material.dart';
import '../../../Data1/models/privacy_policy_model.dart';

class PrivacyPolicyController extends ChangeNotifier {
  PrivacyPolicyModel _policyModel = PrivacyPolicyModel.defaultPolicy();
  bool _isLoading = false;
  String? _errorMessage;

  PrivacyPolicyModel get policyModel => _policyModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PrivacyPolicyController() {
    loadPrivacyPolicy();
  }

  // Load data (bisa dari API/local storage nanti)
  Future<void> loadPrivacyPolicy() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulasi loading data
      await Future.delayed(const Duration(milliseconds: 100));
      _policyModel = PrivacyPolicyModel.defaultPolicy();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh data
  Future<void> refreshPolicy() async {
    await loadPrivacyPolicy();
  }

  // Navigasi kembali
  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  // Handle learn more button
  void onLearnMorePressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur akan segera tersedia'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
