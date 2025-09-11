import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../manager/Product_Detail/product_detail_cubit.dart';
import '../../manager/Product_Detail/product_detail_state.dart';
import '../../../data/models/product_model.dart';
import '../../../../my_cart/presentation/manager/cart/cart_cubit.dart';
import '../../../../my_cart/data/models/cart_item.dart';
import '../../../../../shared/widgets/top_notification.dart';

class AddToCartButton extends StatelessWidget {
  final ProductModel product;
  final bool isArabic;

  const AddToCartButton({
    super.key,
    required this.product,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
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
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  _addToCart(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: const Color(0xFF1E3A8A).withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart, size: 20),
                label: Text(
                  isArabic ? 'أضف للسلة' : 'Add To Basket',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _addToCart(BuildContext context) {
    // الحصول على الكمية من ProductDetailCubit
    final productDetailCubit = context.read<ProductDetailCubit>();
    final quantity = productDetailCubit.quantity;

    // إنشاء CartItem من ProductModel مع الكمية الصحيحة
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
