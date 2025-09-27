import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/services/product_service.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../shared/constants/language_manager.dart';
import '../../../../../shared/widgets/top_notification.dart';

class BestSellersView extends StatefulWidget {
  const BestSellersView({super.key});

  @override
  State<BestSellersView> createState() => _BestSellersViewState();
}

class _BestSellersViewState extends State<BestSellersView> {
  List<ProductModel> bestSellers = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBestSellers();
  }

  Future<void> _loadBestSellers() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final result = await ProductService.getProducts();

      if (result.isSuccess && result.data != null) {
        setState(() {
          bestSellers = result.data!.bestSellers;
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
        errorMessage = 'Error loading best sellers: $e';
        isLoading = false;
      });
    }
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
          icon: Icon(
            isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          isArabic ? 'الأكثر مبيعاً' : 'Best Sellers',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(isArabic),
    );
  }

  Widget _buildBody(bool isArabic) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF123459)),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBestSellers,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF123459),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isArabic ? 'إعادة المحاولة' : 'Retry',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (bestSellers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'لا توجد منتجات متاحة' : 'No products available',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // عدد المنتجات
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Text(
            '${bestSellers.length} ${isArabic ? 'منتج' : 'products'}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // قائمة المنتجات
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: bestSellers.length,
            itemBuilder: (context, index) {
              final product = bestSellers[index];
              return _buildProductCard(product, isArabic);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(ProductModel product, bool isArabic) {
    return GestureDetector(
      onTap: () {
        print('🔄 Navigating to product detail for ID: ${product.id}');
        print('📦 Product: ${product.nameEn} (${product.nameAr})');
        context.go('/product-detail', extra: product.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
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
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image,
                        color: Colors.grey[400],
                        size: 40,
                      );
                    },
                  ),
                ),
              ),
            ),
            // تفاصيل المنتج
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج
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
                    // الوحدة والسعر
                    Text(
                      '${product.getUnit(isArabic)}, ${isArabic ? 'السعر' : 'Price'}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    // السعر
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${isArabic ? 'ر.س' : 'SR'}${product.salePrice}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF123459),
                          ),
                        ),
                        // زر المفضلة
                        GestureDetector(
                          onTap: () async {
                            // Check if user is logged in
                            final isLoggedIn = await AuthService().isLoggedIn();
                            if (!isLoggedIn) {
                              // Show message and redirect to sign in
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isArabic
                                        ? 'يرجى تسجيل الدخول أولاً لإضافة المنتج للمفضلة'
                                        : 'Please sign in first to add product to favorites',
                                  ),
                                  backgroundColor: Colors.orange,
                                  action: SnackBarAction(
                                    label: isArabic ? 'تسجيل دخول' : 'Sign In',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      context.go('/signin');
                                    },
                                  ),
                                ),
                              );
                              return;
                            }
                            // If logged in, proceed with adding to favorites
                            TopNotification.show(
                              context,
                              isArabic
                                  ? 'تم إضافة المنتج للمفضلة'
                                  : 'Product added to favorites',
                              isError: false,
                            );
                          },
                          child: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: product.isFavorite
                                ? Colors.red
                                : Colors.grey[400],
                            size: 20,
                          ),
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
