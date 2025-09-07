import 'package:dio/dio.dart';
import '../../shared/constants/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-API-Key': AppConstants.apiKey,
        },
      ),
    );

    // Add interceptors for logging
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  // Password Reset - Send Code
  Future<ApiResponse> sendPasswordResetCode(String email) async {
    try {
      final response = await _dio.post(
        '/api/v1/password/send/code',
        data: {'email': email},
      );

      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Password Reset - Reset Password
  Future<ApiResponse> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/password/reset',
        data: {
          'email': email,
          'code': code,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Handle Dio errors
  ApiResponse _handleDioError(DioException e) {
    if (e.response != null) {
      // Server responded with error status
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return ApiResponse.fromJson(data);
      }
    }

    // Network or other error
    return ApiResponse(
      status: false,
      code: 500,
      msg: 'Network error. Please check your connection.',
    );
  }
}

class ApiResponse {
  final bool status;
  final int code;
  final String msg;
  final String? errors;

  ApiResponse({
    required this.status,
    required this.code,
    required this.msg,
    this.errors,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 500,
      msg: json['msg'] ?? 'Unknown error',
      errors: json['errors'],
    );
  }

  bool get isSuccess => status && code >= 200 && code < 300;
  bool get isValidationError => code == 422;
  bool get isNotFound => code == 404;
  bool get isUnauthorized => code == 401;
}
