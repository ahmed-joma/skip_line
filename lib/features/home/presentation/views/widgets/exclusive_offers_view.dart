import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/services/product_service.dart';
import '../../../../../core/services/favorite_service.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../shared/constants/language_manager.dart';
import '../../../../../shared/widgets/top_notification.dart';
import '../../../../my_cart/presentation/manager/cart/cart_cubit.dart';
import '../../../../my_cart/data/models/cart_item.dart';

class ExclusiveOffersView extends StatefulWidget {
  const ExclusiveOffersView({super.key});

  @override
  State<ExclusiveOffersView> createState() => _ExclusiveOffersViewState();
}

class _ExclusiveOffersViewState extends State<ExclusiveOffersView> {
  List<ProductModel> exclusiveOffers = [];
  bool isLoading = true;
  String? errorMessage;

  // Animation state for add to cart buttons
  final Map<String, bool> _buttonPressedStates = {};

  @override
  void initState() {
    super.initState();
    _loadExclusiveOffers();
  }

  Future<void> _loadExclusiveOffers() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final result = await ProductService.getProducts();

      if (result.isSuccess && result.data != null) {
        setState(() {
          exclusiveOffers = result.data!.exclusiveOffers;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = result.msg;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading exclusive offers: $e';
        isLoading = false;
      });
    }
  }

  /// إضافة منتج للسلة مع إظهار إشعار
  void _addToCart(ProductModel product) {
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );

    // تأثير بصري عند الضغط
    setState(() {
      _buttonPressedStates[product.id.toString()] = true;
    });

    // تأثير اهتزازي
    HapticFeedback.lightImpact();

    // إعادة تعيين التأثير بعد 200ms
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _buttonPressedStates[product.id.toString()] = false;
        });
      }
    });

    // تحويل السعر من String إلى double
    final price = double.tryParse(product.salePrice) ?? 0.0;

    // إنشاء CartItem من ProductModel
    final cartItem = CartItem(
      id: product.id.toString(),
      productId: product.id.toString(),
      name: product.nameEn,
      nameAr: product.nameAr,
      description: product.descriptionEn ?? '',
      descriptionAr: product.descriptionAr ?? '',
      price: price,
      weight: product.unitEn,
      imagePath: product.imageUrl,
      category: 'General',
      categoryAr: 'عام',
      quantity: 1,
    );

    // إضافة المنتج للسلة باستخدام CartCubit
    context.read<CartCubit>().addToCart(cartItem);

    // إظهار إشعار السلة الجديد مع زر View Cart
    _showCartNotification(context, languageManager, product);

    print('✅ Product ${product.id} added to cart successfully');
  }

  /// إظهار إشعار السلة مع زر View Cart
  void _showCartNotification(
    BuildContext context,
    LanguageManager languageManager,
    ProductModel product,
  ) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50), // أخضر جميل
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
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
                        ? 'تم إضافة ${product.getName(languageManager.isArabic)} إلى السلة'
                        : '${product.getName(languageManager.isArabic)} added to cart',
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
    final languageManager = Provider.of<LanguageManager>(context);
    final isArabic = languageManager.isArabic;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          isArabic ? 'العروض الحصرية' : 'Exclusive Offers',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context, isArabic),
    );
  }

  Widget _buildBody(BuildContext context, bool isArabic) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadExclusiveOffers,
              child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
            ),
          ],
        ),
      );
    }

    if (exclusiveOffers.isEmpty) {
      return Center(
        child: Text(
          isArabic ? 'لا توجد منتجات' : 'No products available',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.69, // زيادة الارتفاع قليلاً لإصلاح الـ overflow
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: exclusiveOffers.length,
      itemBuilder: (context, index) {
        final product = exclusiveOffers[index];
        return _buildProductCard(context, product, isArabic);
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductModel product,
    bool isArabic,
  ) {
    return GestureDetector(
      onTap: () {
        print('🔄 Navigating to product detail for ID: ${product.id}');
        print('📦 Product: ${product.nameEn} (${product.nameAr})');

        // التنقل باستخدام productId بدلاً من تمرير المنتج كاملاً
        context.push('/product-detail', extra: {'productId': product.id});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF123459),
                          ),
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      isArabic ? product.nameAr : product.nameEn,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Product Unit
                    Text(
                      '1 ${isArabic ? product.unitAr : product.unitEn}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),

                    // Price and Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          '${product.salePrice} ر.س',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF123459),
                          ),
                        ),

                        // Buttons Column (Add to Cart + Favorite)
                        Column(
                          children: [
                            // Add to Cart Button
                            GestureDetector(
                              onTap: () {
                                _addToCart(product);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: EdgeInsets.all(
                                  _buttonPressedStates[product.id.toString()] ==
                                          true
                                      ? 8
                                      : 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _buttonPressedStates[product.id
                                              .toString()] ==
                                          true
                                      ? const Color(
                                          0xFF0F2A4A,
                                        ) // لون أغمق عند الضغط
                                      : const Color(0xFF123459),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF123459)
                                          .withOpacity(
                                            _buttonPressedStates[product.id
                                                        .toString()] ==
                                                    true
                                                ? 0.5
                                                : 0.3,
                                          ),
                                      spreadRadius:
                                          _buttonPressedStates[product.id
                                                  .toString()] ==
                                              true
                                          ? 2
                                          : 1,
                                      blurRadius:
                                          _buttonPressedStates[product.id
                                                  .toString()] ==
                                              true
                                          ? 6
                                          : 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size:
                                      _buttonPressedStates[product.id
                                              .toString()] ==
                                          true
                                      ? 18
                                      : 16,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Favorite Button
                            GestureDetector(
                              onTap: () async {
                                final isLoggedIn = await AuthService()
                                    .isLoggedIn();
                                if (!isLoggedIn) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isArabic
                                            ? 'يرجى تسجيل الدخول أولاً لإضافة المنتج للمفضلة'
                                            : 'Please sign in first to add product to favorites',
                                      ),
                                      backgroundColor: Colors.orange,
                                      action: SnackBarAction(
                                        label: isArabic
                                            ? 'تسجيل دخول'
                                            : 'Sign In',
                                        textColor: Colors.white,
                                        onPressed: () {
                                          context.go('/signin');
                                        },
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  print(
                                    '🚀 Toggling favorite for product: ${product.id}',
                                  );

                                  final result =
                                      await FavoriteService.updateFavorite(
                                        product.id,
                                      );

                                  if (result['status'] == true) {
                                    // تحديث الحالة المحلية
                                    setState(() {
                                      final index = exclusiveOffers.indexWhere(
                                        (p) => p.id == product.id,
                                      );
                                      if (index != -1) {
                                        exclusiveOffers[index] =
                                            exclusiveOffers[index].copyWith(
                                              isFavorite:
                                                  !exclusiveOffers[index]
                                                      .isFavorite,
                                            );
                                      }
                                    });

                                    // إظهار الإشعار المناسب
                                    if (result['msg'].contains('added')) {
                                      TopNotification.show(
                                        context,
                                        isArabic
                                            ? 'تم إضافة المنتج للمفضلة'
                                            : 'Product added to favorites',
                                        isError: false,
                                      );
                                    } else {
                                      TopNotification.show(
                                        context,
                                        isArabic
                                            ? 'تم إزالة المنتج من المفضلة'
                                            : 'Product removed from favorites',
                                        isError: false,
                                      );
                                    }

                                    print(
                                      '✅ Favorite updated successfully: ${result['msg']}',
                                    );
                                  } else {
                                    print(
                                      '❌ Failed to update favorite: ${result['msg']}',
                                    );

                                    TopNotification.show(
                                      context,
                                      isArabic
                                          ? 'فشل في تحديث المفضلة'
                                          : 'Failed to update favorite',
                                      isError: true,
                                    );
                                  }
                                } catch (e) {
                                  print('❌ Error updating favorite: $e');

                                  TopNotification.show(
                                    context,
                                    isArabic
                                        ? 'حدث خطأ في تحديث المفضلة'
                                        : 'Error updating favorite',
                                    isError: true,
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  product.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: product.isFavorite
                                      ? Colors.red
                                      : Colors.grey[400],
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
