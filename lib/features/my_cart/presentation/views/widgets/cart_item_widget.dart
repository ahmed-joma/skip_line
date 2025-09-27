import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart_item.dart';
import '../../manager/cart/cart_cubit.dart';
import '../../../../../shared/widgets/top_notification.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final bool isArabic;

  const CartItemWidget({super.key, required this.item, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return _buildCartItem(context, item);
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
          onPressed: () => _decrementQuantity(context),
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
          onPressed: () => _incrementQuantity(context),
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
          onTap: () => _removeItem(context),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.close, size: 16, color: Colors.blueGrey),
          ),
        ),
        const SizedBox(height: 8),
        // السعر
        Text(
          '${isArabic ? 'ر.س' : 'SR'}${currentItem.totalPrice.toStringAsFixed(2)}',
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

  void _incrementQuantity(BuildContext context) {
    context.read<CartCubit>().incrementQuantity(item.productId);
  }

  void _decrementQuantity(BuildContext context) {
    context.read<CartCubit>().decrementQuantity(item.productId);
  }

  void _removeItem(BuildContext context) {
    // حذف فوري من السلة
    context.read<CartCubit>().removeFromCart(item.productId);

    // إظهار إشعار تأكيد فوري
    TopNotification.show(
      context,
      isArabic ? 'تم حذف المنتج من السلة' : 'Item removed from cart',
      isError: false,
    );
  }
}
