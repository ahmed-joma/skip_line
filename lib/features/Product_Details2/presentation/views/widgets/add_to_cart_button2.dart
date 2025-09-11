import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../manager/product_details2_cubit.dart';
import '../../manager/product_details2_state.dart';
import '../../../data/models/product_details2_model.dart';
import '../../../../my_cart/presentation/manager/cart/cart_cubit.dart';
import '../../../../my_cart/data/models/cart_item.dart';
import '../../../../../shared/widgets/top_notification.dart';

class AddToCartButton2 extends StatelessWidget {
  final ProductDetails2Model product;
  final bool isArabic;

  const AddToCartButton2({
    super.key,
    required this.product,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetails2Cubit, ProductDetails2State>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // زر Re-scan
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/scan');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isArabic ? 'إعادة المسح' : 'Re-scan',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // زر Add to Cart
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        _addToCart(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isArabic ? 'أضف للسلة' : 'Add To Basket',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addToCart(BuildContext context) {
    // الحصول على الكمية من ProductDetails2Cubit
    final productDetailsCubit = context.read<ProductDetails2Cubit>();
    final quantity = productDetailsCubit.quantity;

    // إنشاء CartItem من ProductDetails2Model مع الكمية الصحيحة
    final cartItem = CartItem(
      id: product.id,
      productId: product.id,
      name: product.name,
      nameAr: product.nameAr,
      description: product.description,
      descriptionAr: product.descriptionAr,
      price: product.price,
      weight: product.weight,
      imagePath: product.images.isNotEmpty ? product.images.first : '',
      category: product.category,
      categoryAr: product.categoryAr,
      quantity: quantity, // استخدام الكمية المختارة
    );

    // إضافة المنتج للسلة
    context.read<CartCubit>().addToCart(cartItem);

    // إظهار إشعار قابل للنقر مع الكمية
    TopNotification.showWithAction(
      context,
      isArabic
          ? 'تم إضافة $quantity من المنتج للسلة'
          : '$quantity items added to cart',
      isArabic ? 'عرض السلة' : 'View Cart',
      () => context.go('/cart'),
      isError: false,
    );
  }
}
