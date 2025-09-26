import 'package:dio/dio.dart';

class NetworkService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // Dio instance
  static final Dio _dio = Dio();

  // Initialize Dio
  static void initialize() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);

    // Default headers
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Interceptors for logging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        logPrint: (obj) => print('🌐 DIO: $obj'),
      ),
    );

    print('🚀 NetworkService initialized with Dio');
    print('📍 Base URL: $baseUrl');
  }

  // GET request
  static Future<Response> get(
    String endpoint, {
    String? token,
    Map<String, dynamic>? queryParams,
  }) async {
    print('📤 GET Request: $endpoint');
    if (queryParams != null) {
      print('📋 Query Params: $queryParams');
    }

    try {
      final options = Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      );

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: options,
      );

      print('✅ GET Success: ${response.statusCode}');
      print('📥 Response Data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('❌ GET Error: ${e.message}');
      print('🔍 Error Type: ${e.type}');
      if (e.response != null) {
        print('📥 Error Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  // POST request
  static Future<Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    print('📤 POST Request: $endpoint');
    if (body != null) {
      print('📋 Request Body: $body');
    }

    try {
      final options = Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      );

      final response = await _dio.post(endpoint, data: body, options: options);

      print('✅ POST Success: ${response.statusCode}');
      print('📥 Response Data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('❌ POST Error: ${e.message}');
      print('🔍 Error Type: ${e.type}');
      if (e.response != null) {
        print('📥 Error Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  // PUT request
  static Future<Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    print('📤 PUT Request: $endpoint');
    if (body != null) {
      print('📋 Request Body: $body');
    }

    try {
      final options = Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      );

      final response = await _dio.put(endpoint, data: body, options: options);

      print('✅ PUT Success: ${response.statusCode}');
      print('📥 Response Data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('❌ PUT Error: ${e.message}');
      print('🔍 Error Type: ${e.type}');
      if (e.response != null) {
        print('📥 Error Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  // DELETE request
  static Future<Response> delete(String endpoint, {String? token}) async {
    print('📤 DELETE Request: $endpoint');

    try {
      final options = Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      );

      final response = await _dio.delete(endpoint, options: options);

      print('✅ DELETE Success: ${response.statusCode}');
      print('📥 Response Data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('❌ DELETE Error: ${e.message}');
      print('🔍 Error Type: ${e.type}');
      if (e.response != null) {
        print('📥 Error Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  // Handle Dio errors
  static String handleDioError(DioException e) {
    print('🔧 Handling Dio Error...');

    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['msg'] ?? data['errors'] ?? data['message'];
        if (message != null) {
          print('📝 Error Message: $message');
          return message.toString();
        }
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        print('⏰ Connection Timeout');
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        print('⏰ Send Timeout');
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        print('⏰ Receive Timeout');
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        print('❌ Bad Response: ${e.response?.statusCode}');
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        print('❌ Request Cancelled');
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        print('❌ Connection Error');
        return 'Connection error. Please check your internet connection.';
      default:
        print('❌ Unknown Error: ${e.message}');
        return 'Unknown error occurred: ${e.message}';
    }
  }
}
