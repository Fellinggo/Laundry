// lib/services/order_api_service.dart
import 'package:dio/dio.dart';

class OrderApiService {
  static const String baseUrl = 'https://6a2bebc63e2b60ab038f092a.mockapi.io';
  static const String ordersEndpoint = '/orders';
  
  final Dio _dio;

  OrderApiService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await _dio.get(ordersEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        
        final processedData = data.map((order) {
          return {
            'orderId': order['orderId'].toString(),
            'service': order['service'],
            'qty': order['qty'].toString(),
            'pickup_time': order['pickup_time'],
            'delivery_time': order['delivery_time'],
            'total_price': order['total_price'],
            'address': order['address'],
            'itemJson': order['itemJson'],
          };
        }).toList();
        
        return processedData;
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}