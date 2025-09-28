import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/services/product_service.dart';
import '../../../../../core/services/favorite_service.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../shared/constants/language_manager.dart';
import '../../../../../shared/widgets/top_notification.dart';

class ExclusiveOffersView extends StatefulWidget {
  const ExclusiveOffersView({super.key});

  @override
  State<ExclusiveOffersView> createState() => _ExclusiveOffersViewState();
}

class _ExclusiveOffersViewState extends State<ExclusiveOffersView> {
  List<ProductModel> exclusiveOffers = [];
  bool isLoading = true;
  String? errorMessage;

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
        childAspectRatio: 0.75,
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
        context.go('/product-details/${product.id}');
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

                    // Price and Add Button
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

                        // Favorite Button
                        GestureDetector(
                          onTap: () async {
                            final isLoggedIn = await AuthService().isLoggedIn();
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
                                          isFavorite: !exclusiveOffers[index]
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
