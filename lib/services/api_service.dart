import 'package:dio/dio.dart';
import '../models/static/service_model.dart';

class ApiService {
  static const String baseUrl = 'https://6a2bebc63e2b60ab038f092a.mockapi.io';
  static const String servicesEndpoint = '/services';
  
  final Dio _dio;
  
  ApiService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));
  
  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await _dio.get(servicesEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load services: ${response.statusCode}');
      }
    } on DioException catch (e) { 
      throw Exception('Network error: ${e.message}');
    }
  }
}