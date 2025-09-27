import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/constants/language_manager.dart';
import '../../../../../core/models/product_model.dart';
import '../manager/Product_Detail/product_detail_cubit.dart';
import '../manager/Product_Detail/product_detail_state.dart';
import 'widgets/product_image_section.dart';
import 'widgets/product_info_section.dart';
import 'widgets/product_detail_section.dart';
import 'widgets/nutrition_section.dart';
import 'widgets/review_section.dart';
import 'widgets/add_to_cart_button.dart';

class ProductDetailView extends StatelessWidget {
  final ProductModel? product;
  final int? productId;

  const ProductDetailView({super.key, this.product, this.productId})
    : assert(
        product != null || productId != null,
        'Either product or productId must be provided',
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ProductDetailCubit();
        if (product != null) {
          cubit.loadProduct(product!);
        } else if (productId != null) {
          cubit.loadProductFromApi(productId!);
        }
        return cubit;
      },
      child: Consumer<LanguageManager>(
        builder: (context, languageManager, child) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: _buildAppBar(context, languageManager.isArabic),
            body: BlocConsumer<ProductDetailCubit, ProductDetailState>(
              listener: (context, state) {
                if (state is ProductFavoriteAdded) {
                  _showSnackBar(
                    context,
                    languageManager.isArabic
                        ? 'تم إضافة المنتج للمفضلة'
                        : 'Product added to favorites',
                    Colors.green,
                  );
                } else if (state is ProductFavoriteRemoved) {
                  _showSnackBar(
                    context,
                    languageManager.isArabic
                        ? 'تم إزالة المنتج من المفضلة'
                        : 'Product removed from favorites',
                    Colors.orange,
                  );
                } else if (state is ProductAddedToCart) {
                  _showSnackBar(
                    context,
                    languageManager.isArabic
                        ? 'تم إضافة المنتج للسلة'
                        : 'Product added to cart',
                    Colors.blue,
                  );
                } else if (state is NavigateToNutrition) {
                  // يمكن إضافة صفحة التغذية هنا
                  _showSnackBar(
                    context,
                    languageManager.isArabic
                        ? 'صفحة التغذية قريباً'
                        : 'Nutrition page coming soon',
                    Colors.blue,
                  );
                } else if (state is NavigateToReviews) {
                  // يمكن إضافة صفحة المراجعات هنا
                  _showSnackBar(
                    context,
                    languageManager.isArabic
                        ? 'صفحة المراجعات قريباً'
                        : 'Reviews page coming soon',
                    Colors.blue,
                  );
                } else if (state is ProductQuantityChanged) {
                  // لا نفعل شيء، فقط نحدث الواجهة
                  print('🔄 Quantity changed to: ${state.quantity}');
                }
              },
              builder: (context, state) {
                if (state is ProductDetailLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductDetailError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (productId != null) {
                              context
                                  .read<ProductDetailCubit>()
                                  .loadProductFromApi(productId!);
                            }
                          },
                          child: Text(
                            languageManager.isArabic
                                ? 'إعادة المحاولة'
                                : 'Retry',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProductDetailLoaded ||
                    state is ProductQuantityChanged) {
                  // الحصول على المنتج الحالي من الـ cubit
                  final cubit = context.read<ProductDetailCubit>();
                  final currentProduct = cubit.product;

                  if (currentProduct == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // قسم الصور
                        ProductImageSection(
                          product: currentProduct,
                          isArabic: languageManager.isArabic,
                        ),

                        const SizedBox(height: 16),

                        // قسم معلومات المنتج
                        ProductInfoSection(
                          product: currentProduct,
                          isArabic: languageManager.isArabic,
                        ),

                        const SizedBox(height: 16),

                        // قسم تفاصيل المنتج
                        ProductDetailSection(
                          product: currentProduct,
                          isArabic: languageManager.isArabic,
                        ),

                        const SizedBox(height: 16),

                        // قسم التغذية
                        NutritionSection(
                          product: currentProduct,
                          isArabic: languageManager.isArabic,
                        ),

                        const SizedBox(height: 16),

                        // قسم المراجعات
                        ReviewSection(
                          product: currentProduct,
                          isArabic: languageManager.isArabic,
                        ),

                        const SizedBox(height: 100), // مساحة للزر السفلي
                      ],
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
            bottomNavigationBar:
                BlocBuilder<ProductDetailCubit, ProductDetailState>(
                  builder: (context, state) {
                    if (state is ProductDetailLoaded ||
                        state is ProductQuantityChanged) {
                      final cubit = context.read<ProductDetailCubit>();
                      final currentProduct = cubit.product;

                      if (currentProduct != null) {
                        return AddToCartButton(
                          product: currentProduct,
                          isArabic: languageManager.isArabic,
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isArabic) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () {
          if (Navigator.canPop(context)) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.share, color: Colors.black, size: 24),
          onPressed: () {
            // وظيفة المشاركة
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
