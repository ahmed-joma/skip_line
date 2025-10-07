import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skip_line/shared/constants/language_manager.dart';
import '../../manager/scan_cubit.dart';
import '../../../../my_cart/presentation/manager/cart/cart_cubit.dart';
import '../../../../my_cart/data/models/cart_item.dart';
import 'package:go_router/go_router.dart';

class ScanProductCard extends StatelessWidget {
  final String productName;
  final String productCategory;
  final String productImage;
  final int productId;
  final String productPrice;
  final VoidCallback onAddPressed;

  const ScanProductCard({
    super.key,
    required this.productName,
    required this.productCategory,
    required this.productImage,
    required this.productId,
    required this.productPrice,
    required this.onAddPressed,
  });

  // ترجمة عربية للمنتجات الشائعة
  String _getArabicName(String englishName) {
    String lowerName = englishName.toLowerCase();

    if (lowerName.contains('banana')) return 'موز';
    if (lowerName.contains('apple')) return 'تفاح';
    if (lowerName.contains('milk')) return 'حليب طازج';
    if (lowerName.contains('bread')) return 'خبز';
    if (lowerName.contains('cheese')) return 'جبن';
    if (lowerName.contains('yogurt')) return 'زبادي';
    if (lowerName.contains('orange')) return 'برتقال';
    if (lowerName.contains('tomato')) return 'طماطم';
    if (lowerName.contains('potato')) return 'بطاطس';
    if (lowerName.contains('onion')) return 'بصل';
    if (lowerName.contains('saudi')) return 'حليب السعودية';
    if (lowerName.contains('chicken')) return 'دجاج';
    if (lowerName.contains('beef')) return 'لحم بقري';
    if (lowerName.contains('fish')) return 'سمك';
    if (lowerName.contains('rice')) return 'أرز';
    if (lowerName.contains('pasta')) return 'معكرونة';
    if (lowerName.contains('sugar')) return 'سكر';
    if (lowerName.contains('salt')) return 'ملح';
    if (lowerName.contains('oil')) return 'زيت';
    if (lowerName.contains('water')) return 'ماء';

    return englishName;
  }

  String _getArabicCategory(String englishCategory) {
    String lowerCategory = englishCategory.toLowerCase();

    if (lowerCategory.contains('fruits') || lowerCategory.contains('fruit'))
      return 'فواكه';
    if (lowerCategory.contains('vegetables') ||
        lowerCategory.contains('vegetable'))
      return 'خضروات';
    if (lowerCategory.contains('dairy')) return 'ألبان';
    if (lowerCategory.contains('bakery')) return 'مخبوزات';
    if (lowerCategory.contains('beverages') ||
        lowerCategory.contains('beverage'))
      return 'مشروبات';
    if (lowerCategory.contains('snacks') || lowerCategory.contains('snack'))
      return 'وجبات خفيفة';
    if (lowerCategory.contains('meat')) return 'لحوم';
    if (lowerCategory.contains('seafood')) return 'مأكولات بحرية';
    if (lowerCategory.contains('grains')) return 'حبوب';
    if (lowerCategory.contains('spices')) return 'توابل';
    if (lowerCategory.contains('frozen')) return 'مجمدات';
    if (lowerCategory.contains('canned')) return 'معلبات';
    if (lowerCategory.contains('organic')) return 'عضوي';
    if (lowerCategory.contains('fresh')) return 'طازج';
    if (lowerCategory.contains('milk')) return 'ألبان';

    return englishCategory;
  }

  // دالة إضافة المنتج للسلة
  void _addToCart(BuildContext context) {
    try {
      // تأثير هابتي
      HapticFeedback.lightImpact();

      // إنشاء CartItem
      final cartItem = CartItem(
        id: productId.toString(),
        productId: productId.toString(),
        name: productName,
        nameAr: productName,
        description: productCategory,
        descriptionAr: productCategory,
        price:
            double.tryParse(productPrice.replaceAll('ر.س', '').trim()) ?? 0.0,
        weight: '1kg',
        imagePath: productImage,
        category: productCategory,
        categoryAr: productCategory,
        quantity: 1,
      );

      // إضافة للسلة
      context.read<CartCubit>().addToCart(cartItem);

      // عرض إشعار
      _showCartNotification(context);
    } catch (e) {
      print('❌ خطأ في إضافة المنتج للسلة: $e');
    }
  }

  // دالة عرض إشعار السلة
  void _showCartNotification(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // أيقونة النجاح
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // النص
                Expanded(
                  child: Text(
                    languageManager.isArabic
                        ? 'تم إضافة $productName إلى السلة'
                        : '$productName added to cart',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // زر View Cart
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    overlayEntry.remove();
                    context.go('/cart');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      languageManager.isArabic ? 'عرض السلة' : 'View Cart',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // زر الإغلاق
                GestureDetector(
                  onTap: () => overlayEntry.remove(),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // إزالة الإشعار تلقائياً بعد 4 ثوانٍ
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        final isArabic = languageManager.isArabic;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // صورة المنتج
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: productImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF123459),
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // تفاصيل المنتج
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'فئة المنتج' : 'Product Category',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArabic ? _getArabicName(productName) : productName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArabic
                          ? _getArabicCategory(productCategory)
                          : productCategory,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // زر الإضافة
              GestureDetector(
                onTap: () => _addToCart(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3), // أزرق داكن
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),

              const SizedBox(width: 8),

              // زر إعادة المسح
              GestureDetector(
                onTap: () {
                  context.read<ScanCubit>().clearScannedProduct();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
