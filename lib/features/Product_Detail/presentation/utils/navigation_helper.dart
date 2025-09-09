import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_routers.dart';
import '../../data/models/product_model.dart';

class NavigationHelper {
  static void navigateToProductDetail(
    BuildContext context,
    ProductModel product,
  ) {
    context.go(AppRouters.kProductDetailView, extra: product.toJson());
  }

  static void navigateToProductDetailFromHome(
    BuildContext context,
    ProductModel product,
  ) {
    context.push(AppRouters.kProductDetailView, extra: product.toJson());
  }
}
