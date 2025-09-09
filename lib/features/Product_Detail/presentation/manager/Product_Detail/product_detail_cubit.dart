import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/product_model.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(ProductDetailInitial());

  ProductModel? _product;
  int _quantity = 1;
  int _currentImageIndex = 0;
  bool _isProductDetailExpanded = false;
  bool _isNutritionExpanded = false;

  ProductModel? get product => _product;
  int get quantity => _quantity;
  int get currentImageIndex => _currentImageIndex;
  bool get isProductDetailExpanded => _isProductDetailExpanded;
  bool get isNutritionExpanded => _isNutritionExpanded;

  void loadProduct(ProductModel product) {
    _product = product;
    emit(ProductDetailLoaded(product));
  }

  void toggleFavorite() {
    if (_product != null) {
      _product = _product!.copyWith(isFavorite: !_product!.isFavorite);
      emit(ProductDetailLoaded(_product!));

      // إرسال إشعار
      if (_product!.isFavorite) {
        emit(ProductFavoriteAdded());
      } else {
        emit(ProductFavoriteRemoved());
      }
    }
  }

  void incrementQuantity() {
    _quantity++;
    emit(ProductQuantityChanged(_quantity));
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      emit(ProductQuantityChanged(_quantity));
    }
  }

  void changeImageIndex(int index) {
    _currentImageIndex = index;
    emit(ProductImageChanged(index));
  }

  void toggleProductDetailExpansion() {
    _isProductDetailExpanded = !_isProductDetailExpanded;
    emit(ProductDetailExpansionChanged(_isProductDetailExpanded));
  }

  void toggleNutritionExpansion() {
    _isNutritionExpanded = !_isNutritionExpanded;
    emit(NutritionExpansionChanged(_isNutritionExpanded));
  }

  void addToCart() {
    if (_product != null) {
      emit(ProductAddedToCart());
    }
  }

  void navigateToNutrition() {
    emit(NavigateToNutrition());
  }

  void navigateToReviews() {
    emit(NavigateToReviews());
  }
}
