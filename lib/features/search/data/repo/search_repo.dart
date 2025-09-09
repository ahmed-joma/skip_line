import '../models/product_model.dart';

abstract class SearchRepo {
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<ProductModel>> getAllProducts();
}
