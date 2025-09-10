import 'scan_repo.dart';

class ScanRepositoryImpl implements ScanRepository {
  @override
  Future<String> processScanResult(String scanResult) async {
    // محاكاة معالجة نتيجة المسح
    await Future.delayed(const Duration(milliseconds: 300));

    // تنظيف النتيجة
    final cleanedResult = scanResult.trim();

    // التحقق من صحة النتيجة
    if (cleanedResult.isEmpty) {
      throw Exception('Invalid scan result');
    }

    return cleanedResult;
  }

  @override
  Future<bool> validateProductCode(String code) async {
    // محاكاة التحقق من صحة كود المنتج
    await Future.delayed(const Duration(milliseconds: 200));

    // التحقق من أن الكود يحتوي على أرقام أو حروف
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(code);
  }

  @override
  Future<Map<String, dynamic>> getProductByCode(String code) async {
    // محاكاة البحث عن المنتج
    await Future.delayed(const Duration(milliseconds: 500));

    // إرجاع بيانات وهمية للمنتج
    return {
      'id': code,
      'name': 'Product from scan: $code',
      'nameAr': 'منتج من المسح: $code',
      'price': 25.0,
      'imagePath': 'assets/images/default_product.png',
      'description': 'Product found by scanning code: $code',
      'descriptionAr': 'منتج تم العثور عليه بمسح الكود: $code',
      'category': 'Scanned Products',
      'categoryAr': 'منتجات ممسوحة',
      'weight': '500g',
      'available': true,
    };
  }
}
