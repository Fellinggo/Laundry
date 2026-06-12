// lib/services/api_service.dart
import 'package:dio/dio.dart';
import '../models/order/order_model.dart';
import '../models/service/service_model.dart';

class ApiService {
  // BaseOptions untuk konfigurasi dasar Dio
  static final Dio _dio = Dio(BaseOptions(
    // GANTI DENGAN URL MOCKAPI-MU!
    baseUrl: 'https://6a2a5fa4b687a7d5cbc3991f.mockapi.io',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  // --- Fungsi untuk Order ---
  static Future<List<OrderModel>> fetchAllOrders() async {
    try {
      final Response response = await _dio.get('/orders');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        // Mengubah setiap item JSON di list menjadi object OrderModel
        return data.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data pesanan');
      }
    } on DioException catch (e) {
      throw Exception('Error koneksi: ${e.message}');
    }
  }

  static Future<OrderModel> createOrder(OrderModel newOrder) async {
    try {
      final Response response = await _dio.post(
        '/orders',
        data: newOrder.toJson(),
      );
      if (response.statusCode == 201) {
        return OrderModel.fromJson(response.data);
      } else {
        throw Exception('Gagal membuat pesanan baru');
      }
    } on DioException catch (e) {
      throw Exception('Error koneksi: ${e.message}');
    }
  }

  // --- Fungsi untuk Service ---
  static Future<List<ServiceModel>> fetchAllServices() async {
    try {
      final Response response = await _dio.get('/services');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data layanan');
      }
    } on DioException catch (e) {
      throw Exception('Error koneksi: ${e.message}');
    }
  }
}