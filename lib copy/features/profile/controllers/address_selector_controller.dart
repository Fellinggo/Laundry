import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressSelectorController extends ChangeNotifier {
  final TextEditingController customAddressController = TextEditingController();

  Map<String, String> _addresses = {};
  String _selectedAddressType = '';
  bool _showAddressOptions = false;
  bool _isLoadingAddresses = false;
  bool _saveToProfile = false;

  Map<String, String> get addresses => _addresses;
  String get selectedAddressType => _selectedAddressType;
  bool get showAddressOptions => _showAddressOptions;
  bool get isLoadingAddresses => _isLoadingAddresses;
  bool get saveToProfile => _saveToProfile;

  Future<void> loadAddresses() async {
    _isLoadingAddresses = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail') ?? '';
      final addressKey = 'userAddresses_$email';
      final titlesKey = 'userAddressTitles_$email';

      final savedAddresses = prefs.getStringList(addressKey) ?? [];
      final savedTitles = prefs.getStringList(titlesKey) ?? [];

      _addresses = {};
      if (savedAddresses.isNotEmpty) {
        for (int i = 0; i < savedAddresses.length; i++) {
          final title = i < savedTitles.length
              ? savedTitles[i]
              : 'Alamat ${i + 1}';
          _addresses[title] = savedAddresses[i];
        }
      }
    } catch (e) {
      debugPrint('Error loading addresses: $e');
      _addresses = {};
    } finally {
      _isLoadingAddresses = false;
      notifyListeners();
    }
  }

  void toggleSaveToProfile() {
    _saveToProfile = !_saveToProfile;
    notifyListeners();
  }

  void toggleAddressOptions() {
    _showAddressOptions = !_showAddressOptions;
    notifyListeners();
  }

  void selectAddressType(String type) {
    _selectedAddressType = type;
    _showAddressOptions = false;
    customAddressController.clear();
    _saveToProfile = false;
    notifyListeners();
  }

  void useCustomAddress() {
    if (customAddressController.text.trim().isEmpty) return;

    _selectedAddressType = 'Custom';
    _showAddressOptions = false;
    notifyListeners();
  }

  Future<void> saveAddressIfNeeded() async {
    if (_saveToProfile && customAddressController.text.trim().isNotEmpty) {
      final address = customAddressController.text.trim();

      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail') ?? '';
      final addressKey = 'userAddresses_$email';
      final titlesKey = 'userAddressTitles_$email';

      final savedAddresses = prefs.getStringList(addressKey) ?? [];
      final savedTitles = prefs.getStringList(titlesKey) ?? [];

      final newTitle = 'Alamat ${savedAddresses.length + 1}';

      savedAddresses.add(address);
      savedTitles.add(newTitle);

      await prefs.setStringList(addressKey, savedAddresses);
      await prefs.setStringList(titlesKey, savedTitles);

      _addresses[newTitle] = address;
      _saveToProfile = false;

      notifyListeners();
    }
  }

  String getSelectedAddress() {
    if (_selectedAddressType == 'Custom') {
      return customAddressController.text;
    }
    if (_selectedAddressType.isNotEmpty &&
        _addresses.containsKey(_selectedAddressType)) {
      return _addresses[_selectedAddressType]!;
    }
    return '';
  }

  bool isAddressValid() {
    if (_selectedAddressType.isEmpty &&
        customAddressController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    customAddressController.dispose();
    super.dispose();
  }
}
