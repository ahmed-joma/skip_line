import 'package:dio/dio.dart';
import '../models/products_response_model.dart';
import '../models/product_model.dart';
import '../models/api_response_model.dart';
import 'network_service.dart';

class ProductService {
  static const String _endpoint = '/product';

  /// جلب المنتجات (Best Sellers و Exclusive Offers)
  static Future<ApiResponseModel<ProductsData>> getProducts() async {
    print('🚀 ===== GET PRODUCTS API CALL STARTED =====');
    print('📝 Preparing products request...');

    try {
      print('🌐 Sending GET request to $_endpoint...');
      print('📋 Request Headers: {Content-Type: application/json}');

      final response = await NetworkService.get(_endpoint);

      print('📥 Received response from server');
      print('   Status Code: ${response.statusCode}');
      print('   Response Type: ${response.data.runtimeType}');

      final responseData = response.data as Map<String, dynamic>;
      print('🔍 Parsed response data:');
      print('   Raw Data: $responseData');

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
        print('✅ Products fetched successfully!');

        final productsData = ProductsData.fromJson(responseData['data']);
        print('📦 Products Data:');
        print('   Best Sellers: ${productsData.bestSellers.length} items');
        print(
          '   Exclusive Offers: ${productsData.exclusiveOffers.length} items',
        );

        // طباعة تفاصيل المنتجات
        if (productsData.bestSellers.isNotEmpty) {
          print('🏆 Best Sellers:');
          for (int i = 0; i < productsData.bestSellers.length && i < 3; i++) {
            final product = productsData.bestSellers[i];
            print(
              '   ${i + 1}. ${product.nameEn} (${product.nameAr}) - ${product.salePrice} ر.س',
            );
          }
        }

        if (productsData.exclusiveOffers.isNotEmpty) {
          print('🎯 Exclusive Offers:');
          for (
            int i = 0;
            i < productsData.exclusiveOffers.length && i < 3;
            i++
          ) {
            final product = productsData.exclusiveOffers[i];
            print(
              '   ${i + 1}. ${product.nameEn} (${product.nameAr}) - ${product.salePrice} ر.س',
            );
          }
        }
      } else {
        print('❌ Failed to fetch products: ${responseData['msg']}');
      }

      print('🏁 ===== GET PRODUCTS API CALL COMPLETED =====');
      return ApiResponseModel(
        status: isSuccess,
        code: responseData['code'] ?? response.statusCode ?? 500,
        msg:
            responseData['msg'] ??
            (isSuccess
                ? 'Products fetched successfully'
                : 'Failed to fetch products'),
        data: isSuccess ? ProductsData.fromJson(responseData['data']) : null,
      );
    } on DioException catch (e) {
      print('❌ DioException occurred during get products');
      print('🔍 Error Type: ${e.type}');
      print('🔍 Status Code: ${e.response?.statusCode}');
      print('🔍 Response Data: ${e.response?.data}');

      final errorMessage = NetworkService.handleDioError(e);
      print('🔧 Error handled: $errorMessage');

      print('🏁 ===== GET PRODUCTS API CALL COMPLETED (ERROR) =====');
      return ApiResponseModel(
        status: false,
        code: e.response?.statusCode ?? 500,
        msg: errorMessage,
      );
    } catch (e) {
      print('❌ Unexpected error during get products: $e');

      print(
        '🏁 ===== GET PRODUCTS API CALL COMPLETED (UNEXPECTED ERROR) =====',
      );
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Unexpected error: $e',
      );
    }
  }

  /// جلب منتج واحد بالمعرف
  static Future<ApiResponseModel<ProductModel>> getProductById(
    int productId,
  ) async {
    print('🚀 ===== GET PRODUCT BY ID API CALL STARTED =====');
    print('📝 Preparing product request for ID: $productId...');

    try {
      final endpoint = '$_endpoint/$productId';
      print('🌐 Sending GET request to $endpoint...');
      print('📋 Request Headers: {Content-Type: application/json}');

      final response = await NetworkService.get(endpoint);

      print('📥 Received response from server');
      print('   Status Code: ${response.statusCode}');
      print('   Response Type: ${response.data.runtimeType}');

      final responseData = response.data as Map<String, dynamic>;
      print('🔍 Parsed response data:');
      print('   Raw Data: $responseData');

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
        print('✅ Product fetched successfully!');

        final product = ProductModel.fromJson(responseData['data']);
        print('📦 Product Data:');
        print('   ID: ${product.id}');
        print('   Name EN: ${product.nameEn}');
        print('   Name AR: ${product.nameAr}');
        print('   Price: ${product.salePrice} ر.س');
        print('   Unit: ${product.unitEn} (${product.unitAr})');
        print('   Is Favorite: ${product.isFavorite}');
      } else {
        print('❌ Failed to fetch product: ${responseData['msg']}');
      }

      print('🏁 ===== GET PRODUCT BY ID API CALL COMPLETED =====');
      return ApiResponseModel(
        status: isSuccess,
        code: responseData['code'] ?? response.statusCode ?? 500,
        msg:
            responseData['msg'] ??
            (isSuccess
                ? 'Product fetched successfully'
                : 'Failed to fetch product'),
        data: isSuccess ? ProductModel.fromJson(responseData['data']) : null,
      );
    } on DioException catch (e) {
      print('❌ DioException occurred during get product by ID');
      print('🔍 Error Type: ${e.type}');
      print('🔍 Status Code: ${e.response?.statusCode}');
      print('🔍 Response Data: ${e.response?.data}');

      final errorMessage = NetworkService.handleDioError(e);
      print('🔧 Error handled: $errorMessage');

      print('🏁 ===== GET PRODUCT BY ID API CALL COMPLETED (ERROR) =====');
      return ApiResponseModel(
        status: false,
        code: e.response?.statusCode ?? 500,
        msg: errorMessage,
      );
    } catch (e) {
      print('❌ Unexpected error during get product by ID: $e');

      print(
        '🏁 ===== GET PRODUCT BY ID API CALL COMPLETED (UNEXPECTED ERROR) =====',
      );
      return ApiResponseModel(
        status: false,
        code: 500,
        msg: 'Unexpected error: $e',
      );
    }
  }
}
