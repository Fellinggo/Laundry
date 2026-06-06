import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wushlaundry/models/user_order_model.dart';
import '../../data/dataDummy.dart';

class MyOrdersController
    extends
        ChangeNotifier {
  final bool loggedIn;

  int _currentTab = 0;
  List<
    UserOrder
  >
  _activeOrders = [];
  List<
    UserOrder
  >
  _processOrders = [];
  List<
    UserOrder
  >
  _completedOrders = [];
  bool _isLoading = true;

  int get currentTab => _currentTab;
  List<
    UserOrder
  >
  get activeOrders => _activeOrders;
  List<
    UserOrder
  >
  get processOrders => _processOrders;
  List<
    UserOrder
  >
  get completedOrders => _completedOrders;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => loggedIn;

  MyOrdersController({
    required this.loggedIn,
  }) {
    loadOrders();
  }

  void changeTab(
    int index,
  ) {
    _currentTab = index;
    notifyListeners();
  }

  int _parseRupiahToInt(
    String rupiah,
  ) {
    if (rupiah.isEmpty) return 0;
    String cleaned = rupiah
        .replaceAll(
          'Rp ',
          '',
        )
        .replaceAll(
          '.',
          '',
        );
    return int.tryParse(
          cleaned,
        ) ??
        0;
  }

  Future<
    void
  >
  _cleanInvalidOrders() async {
    final prefs = await SharedPreferences.getInstance();
    bool cleaned = false;

    List<
      String
    >
    activeRaw =
        prefs.getStringList(
          'active_orders',
        ) ??
        [];
    List<
      String
    >
    validActive = activeRaw.where(
      (
        order,
      ) {
        final data = Uri.splitQueryString(
          order,
        );
        final orderId =
            data['orderId'] ??
            '';
        final totalPrice =
            data['totalPrice'] ??
            'Rp 0';
        int nominal = _parseRupiahToInt(
          totalPrice,
        );
        if (orderId ==
            '100001')
          return true;
        return nominal >
            5000;
      },
    ).toList();

    if (validActive.length !=
        activeRaw.length) {
      await prefs.setStringList(
        'active_orders',
        validActive,
      );
      cleaned = true;
    }

    List<
      String
    >
    processRaw =
        prefs.getStringList(
          'process_orders',
        ) ??
        [];
    List<
      String
    >
    validProcess = processRaw.where(
      (
        order,
      ) {
        final data = Uri.splitQueryString(
          order,
        );
        final orderId =
            data['orderId'] ??
            '';
        final totalPrice =
            data['totalPrice'] ??
            'Rp 0';
        int nominal = _parseRupiahToInt(
          totalPrice,
        );
        if (orderId ==
            DummyOrders.dummyOrderId)
          return true;
        return nominal >
            5000;
      },
    ).toList();

    if (validProcess.length !=
        processRaw.length) {
      await prefs.setStringList(
        'process_orders',
        validProcess,
      );
      cleaned = true;
    }

    List<
      String
    >
    completedRaw =
        prefs.getStringList(
          'completed_orders',
        ) ??
        [];
    List<
      String
    >
    validCompleted = completedRaw.where(
      (
        order,
      ) {
        final totalPrice =
            Uri.splitQueryString(
              order,
            )['totalPrice'] ??
            'Rp 0';
        int nominal = _parseRupiahToInt(
          totalPrice,
        );
        return nominal >
            5000;
      },
    ).toList();

    if (validCompleted.length !=
        completedRaw.length) {
      await prefs.setStringList(
        'completed_orders',
        validCompleted,
      );
      cleaned = true;
    }

    if (cleaned) {
      debugPrint(
        'Data invalid telah dibersihkan',
      );
    }
  }

  List<
    UserOrder
  >
  _parseOrdersList(
    List<
      String
    >
    ordersRaw,
  ) {
    return ordersRaw
        .map(
          (
            orderString,
          ) => UserOrder.fromQueryString(
            orderString,
          ),
        )
        .toList();
  }

  Future<
    void
  >
  loadOrders() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = loggedIn;

    debugPrint(
      '========== MY ORDERS SCREEN ==========',
    );
    debugPrint(
      'isLoggedIn: $isLoggedIn',
    );

    if (!isLoggedIn) {
      _activeOrders = [];
      _processOrders = [];
      _completedOrders = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    await _cleanInvalidOrders();

    final loginMethod =
        prefs.getString(
          'login_method',
        ) ??
        '';
    final isSignIn =
        loginMethod ==
        'signin';

    if (isSignIn) {
      final existingProcess =
          prefs.getStringList(
            'process_orders',
          ) ??
          [];
      final hasDummy = existingProcess.any(
        (
          order,
        ) => order.contains(
          DummyOrders.dummyOrderId,
        ),
      );

      if (!hasDummy) {
        await prefs.setStringList(
          'process_orders',
          DummyOrders.processOrders,
        );
        debugPrint(
          'Dummy data injected for Sign In user',
        );
      }
    }

    List<
      String
    >
    activeRaw =
        prefs.getStringList(
          'active_orders',
        ) ??
        [];
    List<
      String
    >
    processRaw =
        prefs.getStringList(
          'process_orders',
        ) ??
        [];
    List<
      String
    >
    completedRaw =
        prefs.getStringList(
          'completed_orders',
        ) ??
        [];

    if (!isSignIn) {
      processRaw = processRaw
          .where(
            (
              order,
            ) => !order.contains(
              DummyOrders.dummyOrderId,
            ),
          )
          .toList();
    }

    _activeOrders = _parseOrdersList(
      activeRaw,
    );
    _processOrders = _parseOrdersList(
      processRaw,
    );
    _completedOrders = _parseOrdersList(
      completedRaw,
    );
    _isLoading = false;
    notifyListeners();
  }

  void refreshOrders() {
    loadOrders();
  }

  String formatRupiah(
    int number,
  ) {
    final s = number.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (
      int i =
          s.length -
          1;
      i >=
          0;
      i--
    ) {
      buffer.write(
        s[i],
      );
      count++;
      if (count %
                  3 ==
              0 &&
          i !=
              0) {
        buffer.write(
          '.',
        );
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  void navigateToOrderDetail(
    BuildContext context,
    UserOrder order,
    String status,
  ) {
    Navigator.pushNamed(
      context,
      '/order-detail',
      arguments: {
        ...order.toMap(),
        'fromActiveOrder':
            status ==
            'active',
        'fromProcessOrder':
            status ==
            'process',
        'deliveryFee': order.deliveryFeeValue,
      },
    );
  }

  List<
    UserOrder
  >
  getCurrentTabOrders() {
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
