import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/constants/language_manager.dart';
import '../manager/Product_Detail/product_detail_cubit.dart';
import '../manager/Product_Detail/product_detail_state.dart';
import '../../data/models/product_model.dart';
import 'widgets/product_image_section.dart';
import 'widgets/product_info_section.dart';
import 'widgets/product_detail_section.dart';
import 'widgets/nutrition_section.dart';
import 'widgets/review_section.dart';
import 'widgets/add_to_cart_button.dart';
import '../../../my_cart/presentation/manager/cart/cart_cubit.dart';

class ProductDetailView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailCubit()..loadProduct(product),
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
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // قسم الصور
                      ProductImageSection(
                        product: product,
                        isArabic: languageManager.isArabic,
                      ),

                      const SizedBox(height: 16),

                      // قسم معلومات المنتج
                      ProductInfoSection(
                        product: product,
                        isArabic: languageManager.isArabic,
                      ),

                      const SizedBox(height: 16),

                      // قسم تفاصيل المنتج
                      ProductDetailSection(
                        product: product,
                        isArabic: languageManager.isArabic,
                      ),

                      const SizedBox(height: 16),

                      // قسم التغذية
                      NutritionSection(
                        product: product,
                        isArabic: languageManager.isArabic,
                      ),

                      const SizedBox(height: 16),

                      // قسم المراجعات
                      ReviewSection(
                        product: product,
                        isArabic: languageManager.isArabic,
                      ),

                      const SizedBox(height: 100), // مساحة للزر السفلي
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar: AddToCartButton(
              product: product,
              isArabic: languageManager.isArabic,
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
