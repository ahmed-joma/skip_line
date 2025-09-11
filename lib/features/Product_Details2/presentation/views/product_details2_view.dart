import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/constants/language_manager.dart';
import '../manager/product_details2_cubit.dart';
import '../manager/product_details2_state.dart';
import '../../data/models/product_details2_model.dart';
import 'widgets/product_image_section2.dart';
import 'widgets/product_info_section2.dart';
import 'widgets/product_details_section2.dart';
import 'widgets/nutrition_section2.dart';
import 'widgets/review_section2.dart';
import 'widgets/add_to_cart_button2.dart';

class ProductDetails2View extends StatelessWidget {
  final ProductDetails2Model product;

  const ProductDetails2View({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetails2Cubit()..loadProduct(product),
      child: Consumer<LanguageManager>(
        builder: (context, languageManager, child) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: _buildAppBar(context, languageManager.isArabic),
            body: BlocConsumer<ProductDetails2Cubit, ProductDetails2State>(
              listener: (context, state) {
                if (state is ProductDetails2FavoriteAdded) {
                  _showSnackBar(
                    context,
                    languageManager.isArabic
                        ? 'تم إضافة المنتج للمفضلة'
                        : 'Product added to favorites',
                    Colors.green,
                  );
                } else if (state is ProductDetails2FavoriteRemoved) {
                  _showSnackBar(
                    context,
                    languageManager.isArabic
                        ? 'تم إزالة المنتج من المفضلة'
                        : 'Product removed from favorites',
                    Colors.orange,
                  );
                } else if (state is ProductDetails2AddedToCart) {
                  _showSnackBar(
                    context,
                    languageManager.isArabic
                        ? 'تم إضافة المنتج للسلة'
                        : 'Product added to cart',
                    Colors.blue,
                  );
                } else if (state is ProductDetails2NavigateToNutrition) {
                  _showSnackBar(
                    context,
                    languageManager.isArabic
                        ? 'صفحة التغذية قريباً'
                        : 'Nutrition page coming soon',
                    Colors.blue,
                  );
                } else if (state is ProductDetails2NavigateToReviews) {
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
                      ProductImageSection2(
                        product: product,
                        isArabic: languageManager.isArabic,
                      ),

                      const SizedBox(height: 16),

                      // قسم معلومات المنتج
                      ProductInfoSection2(
                        product: product,
                        isArabic: languageManager.isArabic,
                      ),

                      const SizedBox(height: 16),

                      // قسم تفاصيل المنتج
                      ProductDetailSection2(
                        product: product,
                        isArabic: languageManager.isArabic,
                      ),

                      const SizedBox(height: 16),

                      // قسم التغذية
                      NutritionSection2(
                        product: product,
                        isArabic: languageManager.isArabic,
                      ),

                      const SizedBox(height: 16),

                      // قسم المراجعات
                      ReviewSection2(
                        product: product,
                        isArabic: languageManager.isArabic,
                      ),

                      const SizedBox(height: 100), // مساحة للزر السفلي
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar: AddToCartButton2(
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
