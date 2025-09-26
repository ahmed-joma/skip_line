import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../shared/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/login_response_model.dart';
import '../models/api_response_model.dart';
import 'network_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Save user token
  Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userTokenKey, token);
  }

  // Get user token
  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userTokenKey);
  }

  // Save user data
  Future<void> saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userDataKey, jsonEncode(user.toJson()));
  }

  // Get user data
  Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(AppConstants.userDataKey);
    if (userDataString != null) {
      try {
        final userData = jsonDecode(userDataString);
        return UserModel.fromJson(userData);
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getUserToken();
    return token != null && token.isNotEmpty;
  }

  // Login with email and password
  Future<ApiResponseModel<LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    print('🔐 Starting login process...');
    print('📧 Email: $email');
    print('🔑 Password: ${'*' * password.length}');

    try {
      print('📤 Sending login request to API...');
      final response = await NetworkService.post(
        '/login',
        body: {'email': email, 'password': password},
      );

      print('📥 Received response from server');
      print('📊 Response status: ${response.statusCode}');
      print('📋 Response data: ${response.data}');

      final responseData = response.data as Map<String, dynamic>;
      final apiResponse = ApiResponseModel.fromJson(
        responseData,
        (data) => LoginResponseModel.fromJson(data),
      );

      print('🔍 Parsed API response:');
      print('   Status: ${apiResponse.status}');
      print('   Code: ${apiResponse.code}');
      print('   Message: ${apiResponse.msg}');
      print('   Has Data: ${apiResponse.data != null}');

      if (apiResponse.isSuccess && apiResponse.data != null) {
        print('✅ Login successful!');
        print(
          '🎫 Token received: ${apiResponse.data!.token.substring(0, 10)}...',
        );
        print('👤 User data: ${apiResponse.data!.user.fullName}');

        // Save token and user data
        print('💾 Saving token and user data locally...');
        await saveUserToken(apiResponse.data!.token);
        await saveUserData(apiResponse.data!.user);
        print('✅ Token and user data saved successfully');
      } else {
        print('❌ Login failed: ${apiResponse.msg}');
      }

      return apiResponse;
    } on DioException catch (e) {
      print('❌ DioException occurred during login');
      final errorMessage = NetworkService.handleDioError(e);
      print('🔧 Error handled: $errorMessage');

      return ApiResponseModel(
        status: false,
        code: e.response?.statusCode ?? 500,
        msg: errorMessage,
      );
    } catch (e) {
      print('❌ Unexpected error during login: $e');
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Unexpected error: $e',
      );
    }
  }

  // Register new user
  Future<ApiResponseModel<LoginResponseModel>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await NetworkService.post(
        '/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone': phone,
          'address': address,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      final apiResponse = ApiResponseModel.fromJson(
        responseData,
        (data) => LoginResponseModel.fromJson(data),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        // Save token and user data
        await saveUserToken(apiResponse.data!.token);
        await saveUserData(apiResponse.data!.user);
        print('Registration successful - Token saved');
      }

      return apiResponse;
    } catch (e) {
      print('Registration error: $e');
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Network error: $e',
      );
    }
  }

  // Verify email with code
  Future<ApiResponseModel<void>> verifyEmail(String code) async {
    try {
      final token = await getUserToken();
      if (token == null) {
        return ApiResponseModel(
          status: false,
          code: 401,
          msg: 'User not logged in',
        );
      }

      final response = await NetworkService.post(
        '/verify',
        body: {'code': code},
        token: token,
      );

      final responseData = response.data as Map<String, dynamic>;
      return ApiResponseModel.fromJson(responseData, null);
    } catch (e) {
      print('Email verification error: $e');
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Network error: $e',
      );
    }
  }

  // Resend verification code
  Future<ApiResponseModel<void>> resendVerificationCode() async {
    try {
      final token = await getUserToken();
      if (token == null) {
        return ApiResponseModel(
          status: false,
          code: 401,
          msg: 'User not logged in',
        );
      }

      final response = await NetworkService.post(
        '/verify/resend',
        token: token,
      );

      final responseData = response.data as Map<String, dynamic>;
      return ApiResponseModel.fromJson(responseData, null);
    } catch (e) {
      print('Resend verification error: $e');
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Network error: $e',
      );
    }
  }

  // Logout - call API and clear local data
  Future<ApiResponseModel<void>> logout() async {
    try {
      final token = await getUserToken();
      if (token != null) {
        // Call logout API
        final response = await NetworkService.post('/logout', token: token);
        final responseData = response.data as Map<String, dynamic>;
        final apiResponse = ApiResponseModel.fromJson(responseData, null);

        // Clear local data regardless of API response
        await _clearLocalData();
        return apiResponse;
      } else {
        // No token, just clear local data
        await _clearLocalData();
        return ApiResponseModel(
          status: true,
          code: 200,
          msg: 'Logged out successfully',
        );
      }
    } catch (e) {
      print('Logout error: $e');
      // Clear local data even if API call fails
      await _clearLocalData();
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Network error: $e',
      );
    }
  }

  // Clear local data
  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userTokenKey);
    await prefs.remove(AppConstants.userDataKey);
    print('Local user data cleared');
  }

  // Clear only token (for payment completion)
  Future<void> clearToken() async {
    await _clearLocalData();
    print('Token cleared after payment completion');
  }
}
