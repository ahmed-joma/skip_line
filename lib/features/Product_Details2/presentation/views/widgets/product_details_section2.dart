import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/product_details2_cubit.dart';
import '../../manager/product_details2_state.dart';
import '../../../data/models/product_details2_model.dart';

class ProductDetailSection2 extends StatelessWidget {
  final ProductDetails2Model product;
  final bool isArabic;

  const ProductDetailSection2({
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
              // العنوان مع السهم
              GestureDetector(
                onTap: () {
                  cubit.toggleProductDetailsExpansion();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        isArabic ? 'تفاصيل المنتج' : 'Product Detail',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      AnimatedRotation(
                        turns: cubit.isProductDetailExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // المحتوى القابل للطي
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: cubit.isProductDetailExpanded ? null : 0,
                child: cubit.isProductDetailExpanded
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Text(
                          isArabic
                              ? product.descriptionAr
                              : product.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
