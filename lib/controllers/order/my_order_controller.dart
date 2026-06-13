import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/data/dataDummy.dart';
import '../../models/order/user_order_model.dart';
import '../../services/order_api_service.dart';

class MyOrdersController extends ChangeNotifier {
  bool _loggedIn;

  int _currentTab = 0;
  List<UserOrder> _activeOrders = [];
  List<UserOrder> _processOrders = [];
  List<UserOrder> _completedOrders = [];
  bool _isLoading = true;
  
  final OrderApiService _orderApiService;
  
  // 🔥 TAMBAHKAN FLAG UNTUK MENCEGAH MULTIPLE LOAD
  bool _isLoadingOrders = false;
  bool _initialized = false;

  int get currentTab => _currentTab;
  List<UserOrder> get activeOrders => _activeOrders;
  List<UserOrder> get processOrders => _processOrders;
  List<UserOrder> get completedOrders => _completedOrders;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _loggedIn;

  MyOrdersController({
    required bool loggedIn,
    OrderApiService? orderApiService,
  }) : _loggedIn = loggedIn,
       _orderApiService = orderApiService ?? OrderApiService() {
    loadOrders();
  }

  // 🔥 METHOD UPDATE LOGIN STATUS (DIREVISI)
  void updateLoginStatus(bool loggedIn) {
    if (_loggedIn != loggedIn) {
      _loggedIn = loggedIn;
      if (!loggedIn) {
        _activeOrders = [];
        _processOrders = [];
        _completedOrders = [];
        _isLoading = false;
        _initialized = false; // 🔥 Reset flag
        notifyListeners();
      }
      loadOrders();
    }
  }

  // 🔥 METHOD CLEAR ALL DATA
  void clearAllData() {
    _activeOrders = [];
    _processOrders = [];
    _completedOrders = [];
    _isLoading = false;
    _loggedIn = false;
    _initialized = false; // 🔥 Reset flag
    notifyListeners();
  }

  void changeTab(int index) {
    if (_currentTab != index) {
      _currentTab = index;
      notifyListeners();
    }
  }

  int _parseRupiahToInt(String rupiah) {
    if (rupiah.isEmpty) return 0;
    String cleaned = rupiah
        .replaceAll('Rp', '')
        .replaceAll('.', '')
        .replaceAll(' ', '')
        .trim();
    return int.tryParse(cleaned) ?? 0;
  }

  Future<void> _cleanInvalidOrders() async {
    final prefs = await SharedPreferences.getInstance();
    bool cleaned = false;

    List<String> activeRaw = prefs.getStringList('active_orders') ?? [];
    List<String> validActive = activeRaw.where((order) {
      final data = Uri.splitQueryString(order);
      final orderId = data['orderId'] ?? '';
      final totalPrice = data['totalPrice'] ?? 'Rp 0';
      int nominal = _parseRupiahToInt(totalPrice);

      if (orderId.isNotEmpty && orderId != '100001') return true;
      if (orderId == '100001') return true;

      return nominal > 5000;
    }).toList();

    if (validActive.length != activeRaw.length) {
      await prefs.setStringList('active_orders', validActive);
      cleaned = true;
    }

    List<String> processRaw = prefs.getStringList('process_orders') ?? [];
    List<String> validProcess = processRaw.where((order) {
      final data = Uri.splitQueryString(order);
      final orderId = data['orderId'] ?? '';
      final totalPrice = data['totalPrice'] ?? 'Rp 0';
      int nominal = _parseRupiahToInt(totalPrice);

      if (orderId.isNotEmpty && orderId != DummyOrders.dummyOrderId) return true;
      if (orderId == DummyOrders.dummyOrderId) return true;

      return nominal > 5000;
    }).toList();

    if (validProcess.length != processRaw.length) {
      await prefs.setStringList('process_orders', validProcess);
      cleaned = true;
    }

    List<String> completedRaw = prefs.getStringList('completed_orders') ?? [];
    List<String> validCompleted = completedRaw.where((order) {
      final data = Uri.splitQueryString(order);
      final orderId = data['orderId'] ?? '';
      final totalPrice = data['totalPrice'] ?? 'Rp 0';
      int nominal = _parseRupiahToInt(totalPrice);

      if (orderId.isNotEmpty) return true;

      return nominal > 5000;
    }).toList();

    if (validCompleted.length != completedRaw.length) {
      await prefs.setStringList('completed_orders', validCompleted);
      cleaned = true;
    }

    if (cleaned) {
      debugPrint('Data invalid telah dibersihkan');
    }
  }

  List<UserOrder> _parseOrdersList(List<String> ordersRaw) {
    return ordersRaw
        .map((orderString) => UserOrder.fromQueryString(orderString))
        .toList();
  }
  
  Future<void> _fetchAndSaveOrdersFromApi() async {
    // 🔥 Cegah multiple fetch
    if (_initialized) {
      debugPrint('Already initialized, skipping API fetch');
      return;
    }
    
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
        
        debugPrint('MyOrders - Order $orderId: items=$fixedItems, totalPrice=$formattedTotalPrice');
      }
      
      if (ordersQuery.isNotEmpty) {
        await prefs.setStringList('process_orders', ordersQuery);
        debugPrint('Data dari API berhasil disimpan ke SharedPreferences, jumlah: ${ordersQuery.length}');
      }
      
      _initialized = true; // 🔥 Tandai sudah di-fetch
    } catch (e) {
      debugPrint('Gagal mengambil data dari API: $e');
    }
  }

  Future<void> loadOrders() async {
    // 🔥 Cegah multiple load bersamaan
    if (_isLoadingOrders) {
      debugPrint('Already loading orders, skipping...');
      return;
    }
    
    _isLoadingOrders = true;
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = _loggedIn;

    debugPrint('========== MY ORDERS SCREEN ==========');
    debugPrint('isLoggedIn: $isLoggedIn');

    if (!isLoggedIn) {
      _activeOrders = [];
      _processOrders = [];
      _completedOrders = [];
      _isLoading = false;
      _isLoadingOrders = false;
      notifyListeners();
      return;
    }
    
    // 🔥 Fetch API hanya sekali
    if (!_initialized) {
      await _fetchAndSaveOrdersFromApi();
    }
    
    await _cleanInvalidOrders();

    final loginMethod = prefs.getString('login_method') ?? '';
    final isSignIn = loginMethod == 'signin';

    if (isSignIn) {
      final existingProcess = prefs.getStringList('process_orders') ?? [];
      final hasDummy = existingProcess.any(
        (order) => order.contains(DummyOrders.dummyOrderId),
      );

      if (!hasDummy) {
        await prefs.setStringList('process_orders', DummyOrders.processOrders);
        debugPrint('Dummy data injected for Sign In user');
      }
    }

    List<String> activeRaw = prefs.getStringList('active_orders') ?? [];
    List<String> processRaw = prefs.getStringList('process_orders') ?? [];
    List<String> completedRaw = prefs.getStringList('completed_orders') ?? [];

    if (!isSignIn) {
      processRaw = processRaw
          .where((order) => !order.contains(DummyOrders.dummyOrderId))
          .toList();
    }

    // 🔥 Update data tanpa notify berulang
    final newActiveOrders = _parseOrdersList(activeRaw);
    final newProcessOrders = _parseOrdersList(processRaw);
    final newCompletedOrders = _parseOrdersList(completedRaw);
    
    bool hasChanges = false;
    
    if (!_isOrderListSame(_activeOrders, newActiveOrders)) {
      _activeOrders = newActiveOrders;
      hasChanges = true;
    }
    if (!_isOrderListSame(_processOrders, newProcessOrders)) {
      _processOrders = newProcessOrders;
      hasChanges = true;
    }
    if (!_isOrderListSame(_completedOrders, newCompletedOrders)) {
      _completedOrders = newCompletedOrders;
      hasChanges = true;
    }
    
    _isLoading = false;
    _isLoadingOrders = false;
    
    if (hasChanges) {
      notifyListeners();
    } else {
      notifyListeners(); // Tetap notify untuk matikan loading
    }
  }
  
  // 🔥 Helper untuk membandingkan list
  bool _isOrderListSame(List<UserOrder> oldList, List<UserOrder> newList) {
    if (oldList.length != newList.length) return false;
    for (int i = 0; i < oldList.length; i++) {
      if (oldList[i].orderId != newList[i].orderId) return false;
    }
    return true;
  }

  void refreshOrders() {
    // Reset flag agar bisa refresh
    _initialized = false;
    _isLoadingOrders = false;
    loadOrders();
  }

  String formatRupiah(int number) {
    final s = number.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  void navigateToOrderDetail(BuildContext context, UserOrder order, String status) {
    Navigator.pushNamed(
      context,
      '/order-detail',
      arguments: {
        ...order.toMap(),
        'fromActiveOrder': status == 'active',
        'fromProcessOrder': status == 'process',
        'deliveryFee': order.deliveryFeeValue,
      },
    );
  }

  List<UserOrder> getCurrentTabOrders() {
    switch (_currentTab) {
      case 0:
        return _activeOrders;
      case 1:
        return _processOrders;
      case 2:
        return _completedOrders;
      default:
        return [];
    }
  }
}