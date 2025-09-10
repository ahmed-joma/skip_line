import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart_item.dart';
import '../../manager/cart/cart_cubit.dart';
import '../../manager/cart/cart_state.dart';
import '../../../../../shared/widgets/top_notification.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final bool isArabic;

  const CartItemWidget({super.key, required this.item, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        // التحقق من وجود العنصر في القائمة
        if (state is CartLoaded) {
          final itemExists = state.items.any(
            (cartItem) => cartItem.productId == item.productId,
          );

          // إذا لم يعد العنصر موجود، إرجاع Container فارغ مع انيميشن
          if (!itemExists) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 0,
              child: const SizedBox.shrink(),
            );
          }

          // البحث عن العنصر المحدث في القائمة
          final updatedItem = state.items.firstWhere(
            (cartItem) => cartItem.productId == item.productId,
          );

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: _buildCartItem(context, updatedItem),
          );
        }

        return _buildCartItem(context, item);
      },
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem currentItem) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة المنتج
          _buildProductImage(currentItem),
          const SizedBox(width: 16),
          // تفاصيل المنتج والكمية
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductDetails(currentItem),
                const SizedBox(height: 12),
                _buildQuantityControls(context, currentItem),
              ],
            ),
          ),
          // السعر وزر الحذف
          _buildPriceAndDelete(context, currentItem),
        ],
      ),
    );
  }

  Widget _buildProductImage(CartItem currentItem) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildImage(currentItem),
      ),
    );
  }

  Widget _buildImage(CartItem currentItem) {
    if (currentItem.imagePath.startsWith('http')) {
      return Image.network(
        currentItem.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.image, color: Colors.grey[400]);
        },
      );
    } else {
      return Image.asset(
        currentItem.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.image, color: Colors.grey[400]);
        },
      );
    }
  }

  Widget _buildProductDetails(CartItem currentItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? currentItem.nameAr : currentItem.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${currentItem.weight}, ${isArabic ? 'السعر' : 'Price'}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildQuantityControls(BuildContext context, CartItem currentItem) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildQuantityButton(
          context,
          icon: Icons.remove,
          onPressed: () => _decrementQuantity(context, currentItem),
        ),
        const SizedBox(width: 8),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              '${currentItem.quantity}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildQuantityButton(
          context,
          icon: Icons.add,
          onPressed: () => _incrementQuantity(context, currentItem),
        ),
      ],
    );
  }

  Widget _buildPriceAndDelete(BuildContext context, CartItem currentItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // زر الحذف
        GestureDetector(
          onTap: () => _removeItem(context, currentItem),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.close, size: 16, color: Colors.blue[600]),
          ),
        ),
        const SizedBox(height: 8),
        // السعر
        Text(
          'SR${currentItem.totalPrice.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey[300]!, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          size: 16,
          color: icon == Icons.add ? Colors.blue[600] : Colors.grey[600],
        ),
      ),
    );
  }

  void _incrementQuantity(BuildContext context, CartItem currentItem) {
    context.read<CartCubit>().incrementQuantity(currentItem.productId);
  }

  void _decrementQuantity(BuildContext context, CartItem currentItem) {
    context.read<CartCubit>().decrementQuantity(currentItem.productId);
  }

  void _removeItem(BuildContext context, CartItem currentItem) {
    // حذف فوري من السلة
    context.read<CartCubit>().removeFromCart(currentItem.productId);

    // إظهار إشعار تأكيد فوري
    TopNotification.show(
      context,
      isArabic ? 'تم حذف المنتج من السلة' : 'Item removed from cart',
      isError: false,
    );
  }
}
