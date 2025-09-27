import '../models/order_response_model.dart';
import 'network_service.dart';
import 'auth_service.dart';

class OrderService {
  static const String _endpoint = '/order';

  /// إنشاء طلب جديد
  static Future<OrderResponseModel> createOrder(List<dynamic> cartItems) async {
    try {
      print('🚀 ===== CREATE ORDER API CALL STARTED =====');
      print('📝 Preparing order request...');

      // تحويل CartItem إلى تنسيق API
      final products = cartItems
          .map(
            (item) => {
              'product_id': int.parse(item.id.toString()),
              'quantity': item.quantity,
            },
          )
          .toList();

      print('📦 Order products:');
      for (int i = 0; i < products.length; i++) {
        print(
          '   ${i + 1}. Product ID: ${products[i]['product_id']}, Quantity: ${products[i]['quantity']}',
        );
      }

      final requestData = {'products': products};

      print('🌐 Sending POST request to $_endpoint/store...');
      print('📋 Request Data: $requestData');

      // الحصول على التوكن
      final token = await AuthService().getUserToken();
      if (token == null) {
        print('❌ No authentication token found');
        return OrderResponseModel(
          status: false,
          code: 401,
          msg: 'Authentication token not found',
        );
      }
      print('🎫 Token found: ${token.substring(0, 10)}...');

      final response = await NetworkService.post(
        '$_endpoint/store',
        body: requestData,
        token: token,
      );

      print('🌐 DIO: *** Response ***');
      print('🌐 DIO: uri: ${NetworkService.baseUrl}$_endpoint/store');
      print('🌐 DIO: Response Text:');
      print('🌐 DIO: ${response.data}');
      print('🌐 DIO:');

      if (response.statusCode == 201) {
        print('✅ POST Success: ${response.statusCode}');
        print('📥 Response Data: ${response.data}');
        print('📥 Received response from server');
        print('   Status Code: ${response.statusCode}');
        print('   Response Type: ${response.data.runtimeType}');

        print('🔍 Parsed response data:');
        print('   Raw Data: ${response.data}');

        final result = OrderResponseModel.fromJson(response.data);

        print('🔍 Response analysis:');
        print('   Status Code: ${response.statusCode}');
        print('   API Status: ${result.status}');
        print('   API Code: ${result.code}');
        print('   Is Success: ${result.isSuccess}');

        if (result.isSuccess && result.data != null) {
          print('✅ Order created successfully!');
          print('📦 Order Data:');
          print('   ID: ${result.orderId}');
          print('   User ID: ${result.data!['order']?['user_id']}');
          print('   Status: ${result.orderStatus}');
          print('   Total: ${result.orderTotal} ر.س');
          print(
            '   Products Count: ${result.data!['order']?['products']?.length ?? 0}',
          );
          print('   Created At: ${result.data!['order']?['created_at']}');
        }

        print('🏁 ===== CREATE ORDER API CALL COMPLETED =====');
        return result;
      } else {
        print('❌ POST Failed: ${response.statusCode}');
        print('📥 Error Response: ${response.data}');
        print('🏁 ===== CREATE ORDER API CALL COMPLETED =====');
        return OrderResponseModel(
          status: false,
          code: response.statusCode ?? 500,
          msg: response.data?['msg'] ?? 'Failed to create order',
        );
      }
    } catch (e) {
      print('❌ Error creating order: $e');
      print('🏁 ===== CREATE ORDER API CALL COMPLETED =====');
      return OrderResponseModel(
        status: false,
        code: 500,
        msg: 'Error creating order: $e',
      );
    }
  }
}
