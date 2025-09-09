import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/Product_Detail/product_detail_cubit.dart';
import '../../manager/Product_Detail/product_detail_state.dart';
import '../../../data/models/product_model.dart';

class ReviewSection extends StatelessWidget {
  final ProductModel product;
  final bool isArabic;

  const ReviewSection({
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
            children: [
              // العنوان مع السهم والنجوم
              GestureDetector(
                onTap: () {
                  cubit.navigateToReviews();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        isArabic ? 'المراجعات' : 'Review',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      // النجوم
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < product.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.red,
                            size: 20,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
