import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../utils/formatter.dart';

class HomeController
    extends
        ChangeNotifier {
  List<
    OrderModel
  >
  _activeOrders = [];
  UserModel? _user;
  bool _isLoading = false;

  List<
    OrderModel
  >
  get activeOrders => _activeOrders;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn =>
      _user?.isLoggedIn ??
      false;
  String? get userFirstName => _user?.firstName;

  HomeController() {
    loadUserData();
    loadActiveOrders();
  }

  Future<
    void
  >
  loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn =
        prefs.getBool(
          'isLoggedIn',
        ) ??
        false;
    final fullName = isLoggedIn
        ? prefs.getString(
            'userName',
          )
        : null;

    _user = UserModel.fromPreferences(
      isLoggedIn,
      fullName,
    );
    notifyListeners();
  }

  // Tambahkan method ini untuk refresh data user dari luar
  Future<
    void
  >
  refreshUserData() async {
    await loadUserData();
  }

  Future<
    void
  >
  loadActiveOrders() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final isLogin =
        prefs.getBool(
          'isLoggedIn',
        ) ??
        false;

    if (!isLogin) {
      _activeOrders = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    final List<
      String
    >
    activeRaw =
        prefs.getStringList(
          'active_orders',
        ) ??
        [];
    final List<
      String
    >
    processRaw =
        prefs.getStringList(
          'process_orders',
        ) ??
        [];
    final List<
      String
    >
    ordersRaw = [
      ...activeRaw,
      ...processRaw,
    ];

    print(
      '========== HOME SCREEN ==========',
    );
    print(
      'Jumlah pesanan di SharedPreferences: ${ordersRaw.length}',
    );
    print(
      'active_orders: ${activeRaw.length}',
    );
    print(
      'process_orders: ${processRaw.length}',
    );

    final List<
      String
    >
    validOrders = ordersRaw.where(
      (
        orderString,
      ) {
        final data = Uri.splitQueryString(
          orderString,
        );
        final String orderId =
            data['orderId'] ??
            '';
        return orderId.isNotEmpty &&
            orderId !=
                '000000';
      },
    ).toList();

    _activeOrders = validOrders.map(
      (
        e,
      ) {
        final data = Uri.splitQueryString(
          e,
        );
        return OrderModel.fromMap(
          data,
        );
      },
    ).toList();

    print(
      'Active orders loaded: ${_activeOrders.length}',
    );
    for (var order in _activeOrders) {
      print(
        '   - Order ID: ${order.orderId}',
      );
    }
    print(
      '==================================',
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<
    void
  >
  refreshData() async {
    await loadUserData();
    await loadActiveOrders();
  }

  String getDisplayTotal(
    OrderModel order,
  ) {
    int finalTotal = Formatter.calculateFinalTotal(
      order.totalPrice,
      order.isDummyOrder,
    );
    return Formatter.formatRupiah(
      finalTotal,
    );
  }

  Future<
    void
  >
  copyPromoCodeToClipboard(
    BuildContext context,
    String code,
  ) async {
    await Clipboard.setData(
      ClipboardData(
        text: code,
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Kode $code berhasil disalin',
          ),
          duration: const Duration(
            milliseconds: 800,
          ),
        ),
      );
    }
  }
}
