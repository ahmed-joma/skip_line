import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../manager/Product_Detail/product_detail_cubit.dart';
import '../../manager/Product_Detail/product_detail_state.dart';
import '../../../../../../core/services/auth_service.dart';
import '../../../../../core/models/product_model.dart';

class ProductImageSection extends StatelessWidget {
  final ProductModel product;
  final bool isArabic;

  const ProductImageSection({
    super.key,
    required this.product,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        final cubit = context.read<ProductDetailCubit>();

        return Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // الصورة الرئيسية
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _buildProductImage(
                    product.imageUrl.isNotEmpty
                        ? product.imageUrl
                        : 'assets/images/banana.png',
                  ),
                ),
              ),

              // نقاط التنقل السفلية
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    1, // صورة واحدة فقط
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: index == cubit.currentImageIndex ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == cubit.currentImageIndex
                            ? Colors.black
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),

              // زر المفضلة
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
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
                    cubit.toggleFavorite();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      cubit.product?.isFavorite == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: cubit.product?.isFavorite == true
                          ? Colors.red
                          : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductImage(String imagePath) {
    // التحقق من نوع الصورة
    if (imagePath.startsWith('http')) {
      // صورة من الإنترنت
      return Center(
        child: Image.network(
          imagePath,
          width: 150,
          height: 150,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: Icon(Icons.image, size: 100, color: Colors.grey[400]),
            );
          },
        ),
      );
    } else {
      // صورة محلية
      return Center(
        child: Image.asset(
          imagePath,
          width: 150,
          height: 150,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: Icon(Icons.image, size: 100, color: Colors.grey[400]),
            );
          },
        ),
      );
    }
  }
}
