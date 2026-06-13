// lib/controllers/service_controller.dart
import 'package:flutter/material.dart';
import 'package:wushlaundry/views/widgets/login_modal_sheet.dart';
import '../../models/static/service_model.dart';
import '../../services/api_service.dart';
import '../../../data/service_dummy.dart';

class ServicesController extends ChangeNotifier {
  bool _loggedIn;
  VoidCallback? _onOpenNotifications;
  bool _isLoading = false;
  String? _errorMessage;
  
  final ApiService _apiService;
  
  List<ServiceModel> _allServices = [];
  List<ServiceModel> _gridServices = [];
  List<ServiceModel> _wideServices = [];

  List<ServiceModel> get gridServices => _gridServices;
  List<ServiceModel> get wideServices => _wideServices;
  bool get isLoggedIn => _loggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ServicesController({
    required bool loggedIn,
    VoidCallback? onOpenNotifications,
    ApiService? apiService,
  }) : _loggedIn = loggedIn,
       _onOpenNotifications = onOpenNotifications,
       _apiService = apiService ?? ApiService() {
    _loadServices();
  }

  /// Memperbarui dependensi eksternal dari Screen tanpa membuat ulang instansiasi controller
  void updateDependencies({
    required bool loggedIn,
    VoidCallback? onOpenNotifications,
  }) {
    bool hasChanged = false;
    if (_loggedIn != loggedIn) {
      _loggedIn = loggedIn;
      hasChanged = true;
    }
    if (_onOpenNotifications != onOpenNotifications) {
      _onOpenNotifications = onOpenNotifications;
      hasChanged = true;
    }

    if (hasChanged) {
      notifyListeners();
    }
  }

  /// Load services dari API
  Future<void> _loadServices() async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      // Coba ambil data dari API
      _allServices = await _apiService.getServices();
      
      // Sortir berdasarkan tipe
      _gridServices = _allServices.where((service) => !service.isWide).toList();
      _wideServices = _allServices.where((service) => service.isWide).toList();
      
      // Jika API berhasil, gunakan data dari API
      notifyListeners();
    } catch (e) {
      // Jika API gagal, fallback ke dummy data
      _errorMessage = e.toString();
      _loadDummyServicesAsFallback();
    } finally {
      _setLoading(false);
    }
  }
  
  /// Fallback ke dummy data jika API gagal
  void _loadDummyServicesAsFallback() {
    _allServices = serviceDummy
        .map((service) => ServiceModel.fromDummy(service))
        .toList();
    
    _gridServices = _allServices.where((service) => !service.isWide).toList();
    _wideServices = _allServices.where((service) => service.isWide).toList();
    
    notifyListeners();
  }
  
  /// Refresh services dari API
  Future<void> refreshServices() async {
    await _loadServices();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void handleServiceTap(BuildContext context, String serviceTitle) {
    if (!_loggedIn) {
      showLoginModal(context);
      return;
    }

    // Cari service berdasarkan title untuk mendapatkan ID
    final service = _allServices.firstWhere(
      (s) => s.title == serviceTitle,
      orElse: () => _allServices.first,
    );
    
    Navigator.pushNamed(
      context,
      '/service-detail',
      arguments: {
        'title': serviceTitle,
        'id': service.id, // Kirim ID juga
      },
    );
  }

  void handleNotificationTap(BuildContext context) {
    if (!_loggedIn) {
      showLoginModal(context);
      return;
    }

    _onOpenNotifications?.call();
  }

  void handleProtectedAction(BuildContext context, VoidCallback action) {
    if (!_loggedIn) {
      showLoginModal(context);
      return;
    }
    action();
  }
}