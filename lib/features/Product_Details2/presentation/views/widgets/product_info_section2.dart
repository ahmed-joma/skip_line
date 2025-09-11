import 'package:flutter/material.dart';
import '../../manager/product_details2_cubit.dart';
import '../../../data/models/product_details2_model.dart';

class ProductInfoSection2 extends StatelessWidget {
  final ProductDetails2Model product;
  final ProductDetails2Cubit cubit;

  const ProductInfoSection2({
    super.key,
    required this.product,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اسم المنتج والمفضلة
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => cubit.toggleFavorite(),
                child: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: product.isFavorite ? Colors.red : Colors.grey,
                  size: 28,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // الوزن والسعر
          Text(
            '${product.weight}, Priceg',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),

          const SizedBox(height: 20),

          // الكمية والسعر
          Row(
            children: [
              // أزرار الكمية
              _buildQuantityControls(),

              const Spacer(),

              // السعر
              Text(
                'SR${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Row(
      children: [
        // زر النقص
        GestureDetector(
          onTap: () => cubit.decrementQuantity(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Icon(Icons.remove, color: Colors.grey, size: 20),
          ),
        ),

        const SizedBox(width: 16),

        // الكمية
        Container(
          width: 50,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              product.quantity.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // زر الزيادة
        GestureDetector(
          onTap: () => cubit.incrementQuantity(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Icon(Icons.add, color: Colors.grey, size: 20),
          ),
        ),
      ],
    );
  }
}
