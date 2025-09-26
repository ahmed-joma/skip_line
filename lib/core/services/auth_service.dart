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
      print('🔍 Error Type: ${e.type}');
      print('🔍 Status Code: ${e.response?.statusCode}');
      print('🔍 Response Data: ${e.response?.data}');

      // Check for specific error types
      if (e.response?.statusCode == 422) {
        print('📧 Validation error detected (likely existing email)');
        // Try to extract more specific error message from response
        try {
          final responseData = e.response?.data as Map<String, dynamic>?;
          print('🔍 Full response data: $responseData');

          if (responseData != null) {
            // Check for errors field
            if (responseData.containsKey('errors')) {
              final errors = responseData['errors'];
              print('🔍 Errors field: $errors');

              if (errors is Map && errors.containsKey('email')) {
                print('📧 Email validation error found in errors.email');
                return ApiResponseModel(
                  status: false,
                  code: 422,
                  msg:
                      'This email is already in use. Please use a different email or sign in.',
                );
              }
            }

            // Check for message field
            if (responseData.containsKey('message')) {
              final message = responseData['message'].toString().toLowerCase();
              print('🔍 Message field: $message');

              if (message.contains('email') &&
                  (message.contains('already') ||
                      message.contains('exists') ||
                      message.contains('taken') ||
                      message.contains('duplicate'))) {
                print('📧 Email validation error found in message');
                return ApiResponseModel(
                  status: false,
                  code: 422,
                  msg:
                      'This email is already in use. Please use a different email or sign in.',
                );
              }
            }

            // Check for msg field
            if (responseData.containsKey('msg')) {
              final msg = responseData['msg'].toString().toLowerCase();
              print('🔍 Msg field: $msg');

              if (msg.contains('email') &&
                  (msg.contains('already') ||
                      msg.contains('exists') ||
                      msg.contains('taken') ||
                      msg.contains('duplicate'))) {
                print('📧 Email validation error found in msg');
                return ApiResponseModel(
                  status: false,
                  code: 422,
                  msg:
                      'This email is already in use. Please use a different email or sign in.',
                );
              }
            }
          }
        } catch (parseError) {
          print('⚠️ Could not parse validation errors: $parseError');
        }
      }

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
    print('🚀 ===== RESEND VERIFICATION API CALL STARTED =====');
    print('📝 Preparing resend verification request...');

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
      print('🌐 Sending POST request to /verify/resend...');

      final response = await NetworkService.post(
        '/verify/resend',
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
        print('✅ Verification code resent successfully!');
        print('📧 New verification code sent to user email');
      } else {
        print('❌ Failed to resend verification code: ${apiResponse.msg}');
      }

      print('🏁 ===== RESEND VERIFICATION API CALL COMPLETED =====');
      return apiResponse;
    } on DioException catch (e) {
      print('❌ DioException occurred during resend verification');
      final errorMessage = NetworkService.handleDioError(e);
      print('🔧 Error handled: $errorMessage');

      return ApiResponseModel(
        status: false,
        code: e.response?.statusCode ?? 500,
        msg: errorMessage,
      );
    } catch (e) {
      print('❌ Unexpected error during resend verification: $e');
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Unexpected error: $e',
      );
    }
  }

  // Send password reset code
  Future<ApiResponseModel<void>> passwordSendCode(String email) async {
    print('🚀 ===== PASSWORD SEND CODE API CALL STARTED =====');
    print('📝 Preparing password send code request...');
    print('   📧 Email: $email');

    try {
      print('🌐 Sending POST request to /password/send/code...');
      print('📋 Request Body: {email: $email}');

      final response = await NetworkService.post(
        '/password/send/code',
        body: {'email': email},
      );

      print('📥 Received response from server');
      print('   Status Code: ${response.statusCode}');
      print('   Response Type: ${response.data.runtimeType}');

      final responseData = response.data as Map<String, dynamic>;
      print('🔍 Parsed response data:');
      print('   Raw Data: $responseData');

      // Check if response is successful based on status code and data
      bool isSuccess =
          response.statusCode == 200 &&
          responseData['status'] == true &&
          responseData['code'] == 200;

      print('🔍 Response analysis:');
      print('   Status Code: ${response.statusCode}');
      print('   API Status: ${responseData['status']}');
      print('   API Code: ${responseData['code']}');
      print('   Is Success: $isSuccess');

      if (isSuccess) {
        print('✅ Password reset code sent successfully!');
        print('📧 Reset code sent to user email: $email');
        return ApiResponseModel(
          status: true,
          code: 200,
          msg:
              responseData['msg'] ??
              'A reset password code has been sent to your email.',
        );
      } else {
        print('❌ Failed to send password reset code');
        return ApiResponseModel(
          status: false,
          code: responseData['code'] ?? response.statusCode ?? 500,
          msg: responseData['msg'] ?? 'Failed to send password reset code',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException occurred during password send code');
      print('🔍 Error Type: ${e.type}');
      print('🔍 Status Code: ${e.response?.statusCode}');
      print('🔍 Response Data: ${e.response?.data}');

      // Check for specific error types
      if (e.response?.statusCode == 404) {
        print('📧 Email not found error detected');
        return ApiResponseModel(
          status: false,
          code: 404,
          msg: 'There is no user with this email. try with correct account',
        );
      }

      if (e.response?.statusCode == 422) {
        print('📧 Validation error detected');
        try {
          final responseData = e.response?.data as Map<String, dynamic>?;
          if (responseData != null && responseData.containsKey('errors')) {
            final errors = responseData['errors'];
            if (errors is Map && errors.containsKey('email')) {
              print('📧 Email validation error found');
              return ApiResponseModel(
                status: false,
                code: 422,
                msg: 'The email field must be a valid email address.',
              );
            }
          }
        } catch (parseError) {
          print('⚠️ Could not parse validation errors: $parseError');
        }
      }

      final errorMessage = NetworkService.handleDioError(e);
      print('🔧 Error handled: $errorMessage');

      return ApiResponseModel(
        status: false,
        code: e.response?.statusCode ?? 500,
        msg: errorMessage,
      );
    } catch (e) {
      print('❌ Unexpected error during password send code: $e');
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Unexpected error: $e',
      );
    }
  }

  // Reset password with code
  Future<ApiResponseModel<void>> passwordReset({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    print('🚀 ===== PASSWORD RESET API CALL STARTED =====');
    print('📝 Preparing password reset request...');
    print('   📧 Email: $email');
    print('   🔢 Code: $code');
    print('   🔒 Password: [HIDDEN]');
    print('   🔒 Password Confirmation: [HIDDEN]');

    try {
      print('🌐 Sending POST request to /password/reset...');
      print(
        '📋 Request Body: {email: $email, code: $code, password: [HIDDEN], password_confirmation: [HIDDEN]}',
      );

      final response = await NetworkService.post(
        '/password/reset',
        body: {
          'email': email,
          'code': code,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      print('📥 Received response from server');
      print('   Status Code: ${response.statusCode}');
      print('   Response Type: ${response.data.runtimeType}');

      final responseData = response.data as Map<String, dynamic>;
      print('🔍 Parsed response data:');
      print('   Raw Data: $responseData');

      // Check if response is successful based on status code and data
      bool isSuccess =
          response.statusCode == 200 &&
          responseData['status'] == true &&
          responseData['code'] == 200;

      print('🔍 Response analysis:');
      print('   Status Code: ${response.statusCode}');
      print('   API Status: ${responseData['status']}');
      print('   API Code: ${responseData['code']}');
      print('   Is Success: $isSuccess');

      if (isSuccess) {
        print('✅ Password reset successfully!');
        print('🔒 User password has been updated successfully');
        return ApiResponseModel(
          status: true,
          code: 200,
          msg:
              responseData['msg'] ??
              'Your password has been reset successfully.',
        );
      } else {
        print('❌ Failed to reset password');
        return ApiResponseModel(
          status: false,
          code: responseData['code'] ?? response.statusCode ?? 500,
          msg: responseData['msg'] ?? 'Failed to reset password',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException occurred during password reset');
      print('🔍 Error Type: ${e.type}');
      print('🔍 Status Code: ${e.response?.statusCode}');
      print('🔍 Response Data: ${e.response?.data}');

      // Check for specific error types
      if (e.response?.statusCode == 422) {
        print('📧 Validation error detected');
        try {
          final responseData = e.response?.data as Map<String, dynamic>?;
          if (responseData != null && responseData.containsKey('errors')) {
            final errors = responseData['errors'];
            print('🔍 Validation errors: $errors');

            // Check for specific field errors
            if (errors is Map) {
              if (errors.containsKey('email')) {
                print('📧 Email validation error found');
                return ApiResponseModel(
                  status: false,
                  code: 422,
                  msg: 'The email field must be a valid email address.',
                );
              } else if (errors.containsKey('code')) {
                print('🔢 Code validation error found');
                return ApiResponseModel(
                  status: false,
                  code: 422,
                  msg: 'Invalid or expired verification code.',
                );
              } else if (errors.containsKey('password')) {
                print('🔒 Password validation error found');
                return ApiResponseModel(
                  status: false,
                  code: 422,
                  msg: 'Password does not meet requirements.',
                );
              }
            }
          }
        } catch (parseError) {
          print('⚠️ Could not parse validation errors: $parseError');
        }
      }

      final errorMessage = NetworkService.handleDioError(e);
      print('🔧 Error handled: $errorMessage');

      return ApiResponseModel(
        status: false,
        code: e.response?.statusCode ?? 500,
        msg: errorMessage,
      );
    } catch (e) {
      print('❌ Unexpected error during password reset: $e');
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Unexpected error: $e',
      );
    }
  }

  // Logout - call API and clear local data
  Future<ApiResponseModel<void>> logout() async {
    print('🚀 ===== LOGOUT API CALL STARTED =====');
    print('📝 Preparing logout request...');

    try {
      final token = await getUserToken();
      if (token != null) {
        print('🎫 Token found: ${token.substring(0, 10)}...');
        print('🌐 Sending POST request to /logout...');
        print('📋 Request Headers: {Authorization: Bearer [HIDDEN]}');

        // Call logout API
        final response = await NetworkService.post('/logout', token: token);

        print('📥 Received response from server');
        print('   Status Code: ${response.statusCode}');
        print('   Response Type: ${response.data.runtimeType}');

        final responseData = response.data as Map<String, dynamic>;
        print('🔍 Parsed response data:');
        print('   Raw Data: $responseData');

        // Check if response is successful based on status code and data
        bool isSuccess =
            response.statusCode == 200 &&
            responseData['status'] == true &&
            responseData['code'] == 200;

        print('🔍 Response analysis:');
        print('   Status Code: ${response.statusCode}');
        print('   API Status: ${responseData['status']}');
        print('   API Code: ${responseData['code']}');
        print('   Is Success: $isSuccess');

        if (isSuccess) {
          print('✅ Logout successful!');
          print('🔒 User token has been invalidated successfully');
        } else {
          print('❌ Logout failed: ${responseData['msg']}');
        }

        // Clear local data regardless of API response
        print('🧹 Clearing local data...');
        await _clearLocalData();
        print('✅ Local data cleared successfully');

        print('🏁 ===== LOGOUT API CALL COMPLETED =====');
        return ApiResponseModel(
          status: isSuccess,
          code: responseData['code'] ?? response.statusCode ?? 500,
          msg:
              responseData['msg'] ??
              (isSuccess ? 'User logged out successfully' : 'Logout failed'),
        );
      } else {
        print('❌ No authentication token found');
        print('🧹 Clearing local data...');
        await _clearLocalData();
        print('✅ Local data cleared successfully');

        print('🏁 ===== LOGOUT API CALL COMPLETED (NO TOKEN) =====');
        return ApiResponseModel(
          status: true,
          code: 200,
          msg: 'Logged out successfully (no token found)',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException occurred during logout');
      print('🔍 Error Type: ${e.type}');
      print('🔍 Status Code: ${e.response?.statusCode}');
      print('🔍 Response Data: ${e.response?.data}');

      // Check for specific error types
      if (e.response?.statusCode == 401) {
        print('🔒 Unauthorized error detected');
        print('🧹 Clearing local data...');
        await _clearLocalData();
        print('✅ Local data cleared successfully');

        print('🏁 ===== LOGOUT API CALL COMPLETED (UNAUTHORIZED) =====');
        return ApiResponseModel(
          status: true,
          code: 200,
          msg: 'Logged out successfully (token was invalid)',
        );
      }

      final errorMessage = NetworkService.handleDioError(e);
      print('🔧 Error handled: $errorMessage');

      // Clear local data even if API call fails
      print('🧹 Clearing local data...');
      await _clearLocalData();
      print('✅ Local data cleared successfully');

      print('🏁 ===== LOGOUT API CALL COMPLETED (ERROR) =====');
      return ApiResponseModel(
        status: false,
        code: e.response?.statusCode ?? 500,
        msg: errorMessage,
      );
    } catch (e) {
      print('❌ Unexpected error during logout: $e');

      // Clear local data even if API call fails
      print('🧹 Clearing local data...');
      await _clearLocalData();
      print('✅ Local data cleared successfully');

      print('🏁 ===== LOGOUT API CALL COMPLETED (UNEXPECTED ERROR) =====');
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Unexpected error: $e',
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
