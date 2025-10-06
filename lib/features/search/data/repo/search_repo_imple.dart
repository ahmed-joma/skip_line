import '../models/product_model.dart';
import 'search_repo.dart';
import '../../../../core/services/product_service.dart';

class SearchRepoImpl implements SearchRepo {
  // قائمة المنتجات المحملة من API
  static List<ProductModel> _allProducts = [];

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    if (query.isEmpty) return _allProducts;

    // البحث في المنتجات المحملة محلياً
    return _allProducts.where((product) {
      final searchQuery = query.toLowerCase();
      return product.name.toLowerCase().contains(searchQuery) ||
          product.nameAr.contains(query) ||
          product.description.toLowerCase().contains(searchQuery) ||
          product.descriptionAr.contains(query) ||
          product.category.toLowerCase().contains(searchQuery);
    }).toList();
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      print('🔍 SearchRepoImpl - جلب جميع المنتجات من API...');

      // جلب المنتجات من API
      final result = await ProductService.getProducts();

      if (result.isSuccess && result.data != null) {
        print('✅ تم جلب المنتجات بنجاح من API');

        // دمج Best Sellers و Exclusive Offers في قائمة واحدة
        final allProducts = <ProductModel>[];

        // إضافة Best Sellers
        for (final product in result.data!.bestSellers) {
          allProducts.add(
            ProductModel(
              id: product.id.toString(),
              name: product.nameEn,
              nameAr: product.nameAr,
              imagePath: product.imageUrl,
              description: product.descriptionEn ?? '',
              descriptionAr: product.descriptionAr ?? '',
              price: product.salePrice,
              category: 'best_seller',
            ),
          );
        }

        // إضافة Exclusive Offers
        for (final product in result.data!.exclusiveOffers) {
          allProducts.add(
            ProductModel(
              id: product.id.toString(),
              name: product.nameEn,
              nameAr: product.nameAr,
              imagePath: product.imageUrl,
              description: product.descriptionEn ?? '',
              descriptionAr: product.descriptionAr ?? '',
              price: product.salePrice,
              category: 'exclusive_offer',
            ),
          );
        }

        // حفظ المنتجات في الذاكرة للبحث السريع
        _allProducts = allProducts;

        print('📦 تم تحميل ${allProducts.length} منتج');
        print('   - Best Sellers: ${result.data!.bestSellers.length}');
        print('   - Exclusive Offers: ${result.data!.exclusiveOffers.length}');

        return allProducts;
      } else {
        print('❌ فشل في جلب المنتجات: ${result.msg}');
        return [];
      }
    } catch (e) {
      print('❌ خطأ في جلب المنتجات: $e');
      return [];
    }
  }
}
