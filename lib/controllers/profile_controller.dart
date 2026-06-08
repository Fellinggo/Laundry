import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/data/address_dummy.dart';
import '../models/address_model.dart';
import '../models/profile_model.dart';

class ProfileController
    extends
        ChangeNotifier {
  ProfileModel _profile = ProfileModel.guest();
  bool _isLoading = false;

  ProfileModel get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _profile.isLoggedIn;
  String get name => _profile.name;
  String get email => _profile.email;
  List<
    AddressModel
  >
  get addresses => _profile.addresses;

  ProfileController() {
    loadUser();
  }

  String get _addressKey => 'userAddresses_${_profile.email}';
  String get _titlesKey => 'userAddressTitles_${_profile.email}';

  Future<
    void
  >
  loadUser() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn =
        prefs.getBool(
          'isLoggedIn',
        ) ??
        false;

    if (isLoggedIn) {
      final name =
          prefs.getString(
            'userName',
          ) ??
          'User';
      final email =
          prefs.getString(
            'userEmail',
          ) ??
          '-';

      final addressKey = 'userAddresses_$email';
      final titlesKey = 'userAddressTitles_$email';

      final savedAddresses =
          prefs.getStringList(
            addressKey,
          ) ??
          [];
      final savedTitles =
          prefs.getStringList(
            titlesKey,
          ) ??
          [];

      List<
        AddressModel
      >
      addresses = [];

      if (savedAddresses.isNotEmpty) {
        addresses = List.generate(
          savedAddresses.length,
          (
            i,
          ) => AddressModel(
            title:
                i <
                    savedTitles.length
                ? savedTitles[i]
                : 'Alamat',
            address: savedAddresses[i],
          ),
        );
      } else {
        final isSignup =
            prefs.getBool(
              'isSignup',
            ) ??
            false;

        if (isSignup) {
          addresses = [];
        } else {
          addresses = List.from(
            AddressModelDummy.defaultAddresses,
          );
          await _saveAddressesToPrefs(
            addresses,
            email,
          );
        }
      }

      _profile = ProfileModel.loggedIn(
        name: name,
        email: email,
        addresses: addresses,
      );
    } else {
      _profile = ProfileModel.guest();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<
    void
  >
  _saveAddressesToPrefs(
    List<
      AddressModel
    >
    addresses,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final addressKey = 'userAddresses_$email';
    final titlesKey = 'userAddressTitles_$email';

    final addressList = addresses
        .map(
          (
            addr,
          ) => addr.address,
        )
        .toList();
    final titleList = addresses
        .map(
          (
            addr,
          ) => addr.title,
        )
        .toList();

    await prefs.setStringList(
      addressKey,
      addressList,
    );
    await prefs.setStringList(
      titlesKey,
      titleList,
    );
  }

  Future<
    void
  >
  _saveCurrentAddresses() async {
    if (_profile.isLoggedIn) {
      await _saveAddressesToPrefs(
        _profile.addresses,
        _profile.email,
      );
    }
  }

  Future<
    void
  >
  editName(
    BuildContext context,
  ) async {
    final controller = TextEditingController(
      text: _profile.name,
    );

    final newName =
        await showDialog<
          String
        >(
          context: context,
          builder:
              (
                context,
              ) => AlertDialog(
                title: const Text(
                  'Edit Nama',
                ),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    hintText: 'Masukkan nama baru',
                  ),
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(
                      context,
                    ),
                    child: const Text(
                      'Batal',
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(
                      context,
                      controller.text.trim(),
                    ),
                    child: const Text(
                      'Simpan',
                    ),
                  ),
                ],
              ),
        );

    if (newName !=
            null &&
        newName.isNotEmpty &&
        newName !=
            _profile.name) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'userName',
        newName,
      );

      _profile = _profile.copyWith(
        name: newName,
      );
      notifyListeners();
    }
  }

  Future<
    void
  >
  addNewAddress(
    BuildContext context,
  ) async {
    final result = await Navigator.pushNamed(
      context,
      '/add-address',
    );

    if (result !=
            null &&
        result
            is Map) {
      final newAddress = AddressModel(
        title: result['title'],
        address: result['address'],
      );

      final updatedAddresses = [
        ..._profile.addresses,
        newAddress,
      ];
      _profile = _profile.copyWith(
        addresses: updatedAddresses,
      );
      await _saveCurrentAddresses();
      notifyListeners();
    }
  }

  Future<
    void
  >
  editAddress(
    BuildContext context,
    int index,
  ) async {
    final address = _profile.addresses[index];

    final result = await Navigator.pushNamed(
      context,
      '/edit-address',
      arguments: {
        'index': index,
        'title': address.title,
        'address': address.address,
      },
    );

    if (result !=
            null &&
        result
            is Map) {
      final updatedAddresses =
          List<
            AddressModel
          >.from(
            _profile.addresses,
          );
      updatedAddresses[index] = AddressModel(
        title: result['title'],
        address: result['address'],
      );

      _profile = _profile.copyWith(
        addresses: updatedAddresses,
      );
      await _saveCurrentAddresses();
      notifyListeners();
    }
  }

  Future<
    void
  >
  deleteAddress(
    int index,
  ) async {
    final updatedAddresses =
        List<
          AddressModel
        >.from(
          _profile.addresses,
        );
    updatedAddresses.removeAt(
      index,
    );

    _profile = _profile.copyWith(
      addresses: updatedAddresses,
    );
    await _saveCurrentAddresses();
    notifyListeners();
  }

  void handleProtectedAction(
    BuildContext context,
    VoidCallback action,
  ) {
    if (!_profile.isLoggedIn) {
      Navigator.pushNamed(
        context,
        '/login',
      ).then(
        (
          _,
        ) {
          loadUser();
        },
      );
    } else {
      action();
    }
  }

  void navigateToSettings(
    BuildContext context,
  ) {
    Navigator.pushNamed(
      context,
      '/settings',
    ).then(
      (
        _,
      ) {
        loadUser();
      },
    );
  }

  void navigateToLogin(
    BuildContext context,
  ) {
    Navigator.pushNamed(
      context,
      '/login',
    ).then(
      (
        _,
      ) {
        loadUser();
      },
    );
  }

  void refresh() {
    loadUser();
  }
}
