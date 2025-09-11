import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/product_details2_cubit.dart';
import '../../manager/product_details2_state.dart';
import '../../../data/models/product_details2_model.dart';

class ProductImageSection2 extends StatelessWidget {
  final ProductDetails2Model product;
  final bool isArabic;

  const ProductImageSection2({
    super.key,
    required this.product,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetails2Cubit, ProductDetails2State>(
      builder: (context, state) {
        final cubit = context.read<ProductDetails2Cubit>();

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
                    product.images.isNotEmpty
                        ? product.images[cubit.currentImageIndex]
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
                    product.images.length,
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
                  onTap: () {
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
