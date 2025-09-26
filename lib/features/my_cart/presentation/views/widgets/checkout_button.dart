import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../manager/cart/cart_cubit.dart';
import '../../manager/cart/cart_state.dart';
import '../../../../../core/services/auth_service.dart';

class CheckoutButton extends StatelessWidget {
  final bool isArabic;

  const CheckoutButton({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        double totalPrice = 0.0;
        if (state is CartLoaded) {
          totalPrice = state.totalPrice;
        }

        return _buildCheckoutButton(context, totalPrice);
      },
    );
  }

  Widget _buildCheckoutButton(BuildContext context, double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // زر الدفع
            SizedBox(
              width: double.infinity,
              height: 66,
              child: ElevatedButton(
                onPressed: () => _handleCheckout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF123459),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // النص بالنص
                    Text(
                      isArabic ? 'الذهاب للدفع' : 'Go to Checkout',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // المربع الأخضر في أقصى اليمين
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'SR${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // شريط التنقل السفلي
            _buildBottomNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(
          context,
          icon: Icons.store,
          label: isArabic ? 'المتجر' : 'Shop',
          isActive: false,
          onTap: () => context.go('/home'),
        ),
        _buildNavItem(
          context,
          icon: Icons.qr_code_scanner,
          label: isArabic ? 'مسح' : 'Scan',
          isActive: false,
          onTap: () {},
        ),
        _buildNavItem(
          context,
          icon: Icons.shopping_cart,
          label: isArabic ? 'السلة' : 'Cart',
          isActive: true,
          onTap: () {},
        ),
        _buildNavItem(
          context,
          icon: Icons.chat,
          label: isArabic ? 'المساعد' : 'Chatbot',
          isActive: false,
          onTap: () => context.go('/chatbot'),
        ),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF123459) : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF123459) : Colors.grey[600],
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _handleCheckout(BuildContext context) async {
    // الحصول على السعر الإجمالي من الحالة الحالية
    final cartState = context.read<CartCubit>().state;
    double totalPrice = 0.0;
    if (cartState is CartLoaded) {
      totalPrice = cartState.totalPrice;
    }

    // طباعة السعر للتأكد من انتقاله
    print('Total Price from Cart: $totalPrice');

    // التحقق من حالة تسجيل الدخول
    final isLoggedIn = await AuthService().isLoggedIn();
    print('User login status: $isLoggedIn');

    if (isLoggedIn) {
      // المستخدم مسجل دخول - الانتقال مباشرة لصفحة الدفع
      print('User is logged in - Redirecting to payment...');
      context.go('/payment', extra: totalPrice);
    } else {
      // المستخدم غير مسجل دخول - الانتقال لصفحة تسجيل الدخول
      print('User is not logged in - Redirecting to sign in...');
      context.go(
        '/signin',
        extra: {'totalPrice': totalPrice, 'redirectToPayment': true},
      );
    }
  }
}
