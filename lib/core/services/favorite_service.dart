import 'package:dio/dio.dart';
import 'network_service.dart';
import 'auth_service.dart';

class FavoriteService {
  static const String _endpoint = '/favorite';

  /// إضافة أو إزالة منتج من المفضلة
  static Future<Map<String, dynamic>> updateFavorite(int productId) async {
    try {
      print('🚀 ===== UPDATE FAVORITE API CALL STARTED =====');
      print('📝 Preparing favorite request...');
      print('🆔 Product ID: $productId');

      final token = await AuthService().getUserToken();
      if (token == null) {
        print('❌ No authentication token found');
        return {
          'status': false,
          'code': 401,
          'msg': 'Authentication token not found',
        };
      }
      print('🎫 Token found: ${token.substring(0, 10)}...');

      final response = await NetworkService.post(
        '$_endpoint/update/$productId',
        token: token,
      );

      print('🌐 DIO: *** Response ***');
      print(
        '🌐 DIO: uri: ${NetworkService.baseUrl}$_endpoint/update/$productId',
      );
      print('🌐 DIO: Response Text:');
      print('🌐 DIO: ${response.data}');
      print('🌐 DIO:');

      if (response.statusCode == 200) {
        print('✅ POST Success: ${response.statusCode}');
        print('📥 Response Data: ${response.data}');

        final result = response.data as Map<String, dynamic>;

        if (result['status'] == true) {
          print('✅ Favorite updated successfully!');
          print('📝 Message: ${result['msg']}');
        } else {
          print('❌ Failed to update favorite: ${result['msg']}');
        }

        print('🏁 ===== UPDATE FAVORITE API CALL COMPLETED =====');
        return result;
      } else {
        print('❌ POST Failed: ${response.statusCode}');
        print('📥 Error Response: ${response.data}');
        print('🏁 ===== UPDATE FAVORITE API CALL COMPLETED =====');
        return {
          'status': false,
          'code': response.statusCode ?? 500,
          'msg': response.data?['msg'] ?? 'Failed to update favorite',
        };
      }
    } on DioException catch (e) {
      print('❌ Error updating favorite: $e');
      print('🏁 ===== UPDATE FAVORITE API CALL COMPLETED =====');
      return {
        'status': false,
        'code': e.response?.statusCode ?? 500,
        'msg': e.response?.data?['msg'] ?? 'Error updating favorite: $e',
      };
    } catch (e) {
      print('❌ Error updating favorite: $e');
      print('🏁 ===== UPDATE FAVORITE API CALL COMPLETED =====');
      return {
        'status': false,
        'code': 500,
        'msg': 'Error updating favorite: $e',
      };
    }
  }
}
