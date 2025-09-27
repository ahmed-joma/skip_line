import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/Product_Detail/product_detail_cubit.dart';
import '../../manager/Product_Detail/product_detail_state.dart';
import '../../../../../core/models/product_model.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;
  final bool isArabic;

  const ProductInfoSection({
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
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اسم المنتج والوزن
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? product.nameAr : product.nameEn,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product.getUnit(isArabic)}, ${isArabic ? 'السعر' : 'Price'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // عداد الكمية والسعر
              Row(
                children: [
                  // عداد الكمية
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // زر النقص
                        GestureDetector(
                          onTap: () {
                            cubit.decrementQuantity();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.remove,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        // العدد
                        Container(
                          width: 60,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.symmetric(
                              vertical: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${cubit.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        // زر الزيادة
                        GestureDetector(
                          onTap: () {
                            cubit.incrementQuantity();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // السعر
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Builder(
                        builder: (context) {
                          final totalPrice =
                              double.parse(product.salePrice) * cubit.quantity;
                          print(
                            '💰 Displaying price: ${product.salePrice} × ${cubit.quantity} = $totalPrice',
                          );
                          return Text(
                            '${isArabic ? 'السعر' : 'Price'}: ${isArabic ? 'ر.س' : 'SR'}${totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20, // تقليل حجم الخط
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
