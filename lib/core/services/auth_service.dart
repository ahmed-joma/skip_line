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
    required String username,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    print('🚀 ===== REGISTER API CALL STARTED =====');
    print('📝 Preparing registration data...');
    print('   👤 Username: $username');
    print('   📧 Email: $email');
    print('   📱 Phone: $phone');
    print('   🏠 Address: $address');
    print('   🔒 Password: [HIDDEN]');

    try {
      print('🌐 Sending POST request to /register...');
      final response = await NetworkService.post(
        '/register',
        body: {
          'name': username,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'phone': phone,
          'address': address,
        },
      );

      print('📥 Received response from server');
      print('   Status Code: ${response.statusCode}');
      print('   Response Type: ${response.data.runtimeType}');

      final responseData = response.data as Map<String, dynamic>;
      print('🔍 Parsed response data:');
      print('   Raw Data: $responseData');

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
        print('✅ Registration successful!');
        print(
          '🎫 Token received: ${apiResponse.data!.token.substring(0, 10)}...',
        );
        print('👤 User data: ${apiResponse.data!.user.fullName}');
        print('📧 Email: ${apiResponse.data!.user.email}');
        print('📱 Phone: ${apiResponse.data!.user.phone}');
        print('🏠 Address: ${apiResponse.data!.user.address}');

        // Save token and user data
        print('💾 Saving token and user data locally...');
        await saveUserToken(apiResponse.data!.token);
        await saveUserData(apiResponse.data!.user);
        print('✅ Token and user data saved successfully');
      } else {
        print('❌ Registration failed: ${apiResponse.msg}');
      }

      print('🏁 ===== REGISTER API CALL COMPLETED =====');
      return apiResponse;
    } on DioException catch (e) {
      print('❌ DioException occurred during registration');
      final errorMessage = NetworkService.handleDioError(e);
      print('🔧 Error handled: $errorMessage');

      return ApiResponseModel(
        status: false,
        code: e.response?.statusCode ?? 500,
        msg: errorMessage,
      );
    } catch (e) {
      print('❌ Unexpected error during registration: $e');
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Unexpected error: $e',
      );
    }
  }

  // Verify email with code
  Future<ApiResponseModel<void>> verifyEmail(String code) async {
    print('🚀 ===== VERIFY EMAIL API CALL STARTED =====');
    print('📝 Preparing verification data...');
    print('   🔢 Code: $code');

    try {
      final token = await getUserToken();
      if (token == null) {
        print('❌ No authentication token found');
        return ApiResponseModel(
          status: false,
          code: 401,
          msg: 'User not logged in',
        );
      }

      print('🎫 Token found: ${token.substring(0, 10)}...');
      print('🌐 Sending POST request to /verify...');

      final response = await NetworkService.post(
        '/verify',
        body: {'code': code},
        token: token,
      );

      print('📥 Received response from server');
      print('   Status Code: ${response.statusCode}');
      print('   Response Type: ${response.data.runtimeType}');

      final responseData = response.data as Map<String, dynamic>;
      print('🔍 Parsed response data:');
      print('   Raw Data: $responseData');

      final apiResponse = ApiResponseModel.fromJson(responseData, null);

      print('🔍 Parsed API response:');
      print('   Status: ${apiResponse.status}');
      print('   Code: ${apiResponse.code}');
      print('   Message: ${apiResponse.msg}');

      if (apiResponse.isSuccess) {
        print('✅ Email verification successful!');
        print('🎉 User email has been verified successfully');
      } else {
        print('❌ Email verification failed: ${apiResponse.msg}');
      }

      print('🏁 ===== VERIFY EMAIL API CALL COMPLETED =====');
      return apiResponse;
    } on DioException catch (e) {
      print('❌ DioException occurred during email verification');
      final errorMessage = NetworkService.handleDioError(e);
      print('🔧 Error handled: $errorMessage');

      return ApiResponseModel(
        status: false,
        code: e.response?.statusCode ?? 500,
        msg: errorMessage,
      );
    } catch (e) {
      print('❌ Unexpected error during email verification: $e');
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Unexpected error: $e',
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
