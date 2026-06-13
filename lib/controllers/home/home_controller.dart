import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/core/utils/formatter.dart';
import 'package:wushlaundry/models/auth/user_model.dart';
import 'package:wushlaundry/models/order/order_model.dart';
import 'package:wushlaundry/services/order_api_service.dart';

class HomeController extends ChangeNotifier {
  List<OrderModel> _activeOrders = [];
  UserModel? _user;
  bool _isLoading = false;
  final OrderApiService _orderApiService;

  List<OrderModel> get activeOrders => _activeOrders;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user?.isLoggedIn ?? false;
  String? get userFirstName => _user?.firstName;

  HomeController({OrderApiService? orderApiService}) 
      : _orderApiService = orderApiService ?? OrderApiService() {
    refreshData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final fullName = isLoggedIn ? prefs.getString('userName') : null;
    
    _user = UserModel.fromPreferences(isLoggedIn, fullName);
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    await loadUserData();
  }

  Future<void> _fetchAndSaveOrdersFromApi() async {
    try {
      final apiOrders = await _orderApiService.getOrders();
      final prefs = await SharedPreferences.getInstance();
      
      List<String> ordersQuery = [];
      
      for (var order in apiOrders) {
        final orderId = order['orderId'].toString();
        final service = order['service'];
        final qty = order['qty'].toString();
        final pickupTime = order['pickup_time'];
        final deliveryTime = order['delivery_time'];
        final totalPrice = order['total_price'].toString();
        final address = order['address'];
        final items = order['itemJson'];
        
        final List<dynamic> fixedItems = [];
        for (var item in items) {
          final itemQty = item['qty'] as int;
          final itemPrice = item['price'] as int;
          fixedItems.add({
            'title': item['title'],
            'qty': itemQty,
            'price': itemPrice,
            'subtotal': itemQty * itemPrice,
            'image': item['image'] ?? '',
          });
        }
        
        final itemsJson = Uri.encodeComponent(json.encode(fixedItems));
        final formattedTotalPrice = 'Rp ${int.parse(totalPrice).toString()}';
        
        final queryString = 'orderId=$orderId&service=$service&qty=$qty&pickupTime=$pickupTime&deliveryTime=$deliveryTime&totalPrice=$formattedTotalPrice&address=$address&itemsJson=$itemsJson&deliveryFee=5000';
        ordersQuery.add(queryString);
      }
      
      if (ordersQuery.isNotEmpty) {
        await prefs.setStringList('process_orders', ordersQuery);
        debugPrint('Data dari API berhasil disimpan ke SharedPreferences (Home), jumlah: ${ordersQuery.length}');
      }
    } catch (e) {
      debugPrint('Gagal mengambil data dari API (Home): $e');
    }
  }

  Future<void> loadActiveOrders() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('isLoggedIn') ?? false;

    if (!isLogin) {
      _activeOrders = [];
      _isLoading = false;
      notifyListeners();
      return;
    }
    
    await _fetchAndSaveOrdersFromApi();

    final List<String> activeRaw = prefs.getStringList('active_orders') ?? [];
    final List<String> processRaw = prefs.getStringList('process_orders') ?? [];
    final List<String> ordersRaw = [
      ...activeRaw,
      ...processRaw,
    ];

    final List<String> validOrders = ordersRaw.where((orderString) {
      final data = Uri.splitQueryString(orderString);
      final String orderId = data['orderId'] ?? '';
      return orderId.isNotEmpty && orderId != '000000';
    }).toList();

    _activeOrders = validOrders.map((e) {
      final data = Uri.splitQueryString(e);
      return OrderModel.fromMap(data);
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshData() async {
    await loadUserData();
    await loadActiveOrders();
  }

  // 🔥 METHOD LOGOUT - LANGSUNG RESET STATE TANPA PERLU REFRESH MANUAL
  Future<void> logout() async {
    // Reset state langsung
    _activeOrders = [];
    _user = UserModel.fromPreferences(false, null);
    _isLoading = false;
    
    // Notify listeners agar UI langsung berubah
    notifyListeners();
    
    // Optional: bersihkan SharedPreferences jika perlu
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    
    debugPrint('Logout berhasil, state HomeController sudah direset');
  }

  Future<void> updateLoginStatus(bool isLoggedIn) async {
    if (!isLoggedIn) {
      _activeOrders = [];
      _user = UserModel.fromPreferences(false, null);
      notifyListeners();
    }
    await refreshData();
  }

  String getDisplayTotal(OrderModel order) {
    int finalTotal = Formatter.calculateFinalTotal(order.totalPrice, order.isDummyOrder);
    return Formatter.formatRupiah(finalTotal);
  }

  Future<void> copyPromoCodeToClipboard(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kode $code berhasil disalin'),
          duration: const Duration(milliseconds: 800),
        ),
      );
    }
  }
  
  // Method baru untuk refresh dari luar (opsional, untuk keperluan debugging)
  Future<void> forceRefresh() async {
    await refreshData();
  }
}