import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_details2_state.dart';
import '../../data/models/product_details2_model.dart';

class ProductDetails2Cubit extends Cubit<ProductDetails2State> {
  ProductDetails2Cubit() : super(ProductDetails2Initial());

  void loadProduct(
    String productName,
    String productCategory,
    String productImage,
  ) {
    emit(
      ProductDetails2Loaded(
        product: ProductDetails2Model(
          id: '1',
          name: productName,
          nameAr: productName,
          description:
              'Saudi Milk Is One Of The Finest Types Of Long-Life Milk That Can Be Kept At Room Temperature.',
          descriptionAr:
              'حليب السعودية من أجود أنواع الحليب طويل الأمد الذي يمكن الاحتفاظ به في درجة حرارة الغرفة.',
          price: 5.0,
          images: [productImage],
          isFavorite: false,
          quantity: 1,
          weight: '1L',
          nutritionInfo: '100gr',
          rating: 5.0,
          reviewCount: 128,
        ),
      ),
    );
  }

  void toggleFavorite() {
    if (state is ProductDetails2Loaded) {
      final currentState = state as ProductDetails2Loaded;
      final updatedProduct = currentState.product.copyWith(
        isFavorite: !currentState.product.isFavorite,
      );
      emit(ProductDetails2Loaded(product: updatedProduct));

      if (updatedProduct.isFavorite) {
        emit(ProductDetails2FavoriteAdded());
      } else {
        emit(ProductDetails2FavoriteRemoved());
      }
    }
  }

  void incrementQuantity() {
    if (state is ProductDetails2Loaded) {
      final currentState = state as ProductDetails2Loaded;
      final updatedProduct = currentState.product.copyWith(
        quantity: currentState.product.quantity + 1,
      );
      emit(ProductDetails2Loaded(product: updatedProduct));
      emit(ProductDetails2QuantityChanged());
    }
  }

  void decrementQuantity() {
    if (state is ProductDetails2Loaded) {
      final currentState = state as ProductDetails2Loaded;
      if (currentState.product.quantity > 1) {
        final updatedProduct = currentState.product.copyWith(
          quantity: currentState.product.quantity - 1,
        );
        emit(ProductDetails2Loaded(product: updatedProduct));
        emit(ProductDetails2QuantityChanged());
      }
    }
  }

  void changeImageIndex(int index) {
    if (state is ProductDetails2Loaded) {
      emit(ProductDetails2ImageChanged());
    }
  }

  void toggleProductDetailsExpansion() {
    if (state is ProductDetails2Loaded) {
      emit(ProductDetails2ExpansionChanged());
    }
  }

  void toggleNutritionExpansion() {
    if (state is ProductDetails2Loaded) {
      emit(ProductDetails2NutritionExpansionChanged());
    }
  }

  void addToCart() {
    if (state is ProductDetails2Loaded) {
      emit(ProductDetails2AddedToCart());
    }
  }
}
