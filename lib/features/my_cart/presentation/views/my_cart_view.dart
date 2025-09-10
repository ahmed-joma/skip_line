import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/constants/language_manager.dart';
import '../manager/cart/cart_cubit.dart';
import '../manager/cart/cart_state.dart';
import 'widgets/cart_item_widget.dart';
import 'widgets/checkout_button.dart';

class MyCartView extends StatelessWidget {
  const MyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyCartScreen();
  }
}

class MyCartScreen extends StatelessWidget {
  const MyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageManager = Provider.of<LanguageManager>(context);
    final isArabic = languageManager.isArabic;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, isArabic),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            return _buildEmptyCart(context, isArabic);
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return _buildEmptyCart(context, isArabic);
            }
            return _buildCartContent(context, state, isArabic);
          } else if (state is CartError) {
            return _buildErrorState(context, state.message, isArabic);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isArabic) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () {
          if (Navigator.canPop(context)) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
      ),
      title: Text(
        isArabic ? 'سلة التسوق' : 'My Cart',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildEmptyCart(BuildContext context, bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            isArabic ? 'سلة التسوق فارغة' : 'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isArabic
                ? 'أضف بعض المنتجات لتبدأ التسوق'
                : 'Add some products to start shopping',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF123459),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              isArabic ? 'تسوق الآن' : 'Shop Now',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 100, color: Colors.red[400]),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.red[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
    BuildContext context,
    CartLoaded state,
    bool isArabic,
  ) {
    return Column(
      children: [
        // قائمة المنتجات
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.only(bottom: 16),
                child: CartItemWidget(
                  key: ValueKey(item.productId),
                  item: item,
                  isArabic: isArabic,
                ),
              );
            },
          ),
        ),
        // زر الدفع
        CheckoutButton(isArabic: isArabic),
      ],
    );
  }
}
