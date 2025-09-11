import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../manager/product_details2_cubit.dart';
import '../manager/product_details2_state.dart';
import 'widgets/product_image_section2.dart';
import 'widgets/product_info_section2.dart';
import 'widgets/product_details_section2.dart';
import 'widgets/nutrition_section2.dart';
import 'widgets/review_section2.dart';
import 'widgets/rescan_button.dart';
import 'widgets/add_to_cart_button2.dart';

class ProductDetails2View extends StatefulWidget {
  final String productName;
  final String productCategory;
  final String productImage;

  const ProductDetails2View({
    super.key,
    required this.productName,
    required this.productCategory,
    required this.productImage,
  });

  @override
  State<ProductDetails2View> createState() => _ProductDetails2ViewState();
}

class _ProductDetails2ViewState extends State<ProductDetails2View>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetails2Cubit()
        ..loadProduct(
          widget.productName,
          widget.productCategory,
          widget.productImage,
        ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: BlocBuilder<ProductDetails2Cubit, ProductDetails2State>(
            builder: (context, state) {
              if (state is ProductDetails2Loaded) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // صورة المنتج
                      ProductImageSection2(
                        product: state.product,
                        cubit: context.read<ProductDetails2Cubit>(),
                      ),

                      const SizedBox(height: 20),

                      // معلومات المنتج
                      ProductInfoSection2(
                        product: state.product,
                        cubit: context.read<ProductDetails2Cubit>(),
                      ),

                      const SizedBox(height: 20),

                      // تفاصيل المنتج
                      ProductDetailsSection2(
                        product: state.product,
                        cubit: context.read<ProductDetails2Cubit>(),
                      ),

                      const SizedBox(height: 16),

                      // المعلومات الغذائية
                      NutritionSection2(
                        product: state.product,
                        cubit: context.read<ProductDetails2Cubit>(),
                      ),

                      const SizedBox(height: 16),

                      // التقييمات
                      ReviewSection2(
                        product: state.product,
                        cubit: context.read<ProductDetails2Cubit>(),
                      ),

                      const SizedBox(height: 30),

                      // زر Re-scan
                      RescanButton(
                        onPressed: () {
                          context.go('/scan');
                        },
                      ),

                      const SizedBox(height: 16),

                      // زر Add to Cart
                      AddToCartButton2(
                        product: state.product,
                        cubit: context.read<ProductDetails2Cubit>(),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () {
          if (Navigator.canPop(context)) {
            context.pop();
          } else {
            context.go('/scan');
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.black),
          onPressed: () {
            // وظيفة المشاركة
          },
        ),
      ],
    );
  }
}
