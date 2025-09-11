import 'package:flutter/material.dart';
import '../../manager/product_details2_cubit.dart';
import '../../../data/models/product_details2_model.dart';

class ProductImageSection2 extends StatelessWidget {
  final ProductDetails2Model product;
  final ProductDetails2Cubit cubit;

  const ProductImageSection2({
    super.key,
    required this.product,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // صورة المنتج الرئيسية
          _buildProductImage(),

          const SizedBox(height: 16),

          // نقاط التنقل
          _buildImageDots(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          product.images.first,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(Icons.image, color: Colors.grey, size: 50),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        product.images.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 0 ? Colors.grey[400] : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
