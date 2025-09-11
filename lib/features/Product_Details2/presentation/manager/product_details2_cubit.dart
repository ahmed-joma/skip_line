import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_details2_state.dart';
import '../../data/models/product_details2_model.dart';

class ProductDetails2Cubit extends Cubit<ProductDetails2State> {
  ProductDetails2Cubit() : super(ProductDetails2Initial());

  ProductDetails2Model? _product;
  int _quantity = 1;
  int _currentImageIndex = 0;
  bool _isProductDetailExpanded = false;
  bool _isNutritionExpanded = false;

  ProductDetails2Model? get product => _product;
  int get quantity => _quantity;
  int get currentImageIndex => _currentImageIndex;
  bool get isProductDetailExpanded => _isProductDetailExpanded;
  bool get isNutritionExpanded => _isNutritionExpanded;

  void loadProduct(ProductDetails2Model product) {
    _product = product;
    _quantity = product.quantity;
    emit(ProductDetails2Loaded(product: product));
  }

  void toggleFavorite() {
    if (_product != null) {
      _product = _product!.copyWith(isFavorite: !_product!.isFavorite);
      emit(ProductDetails2Loaded(product: _product!));

      if (_product!.isFavorite) {
        emit(ProductDetails2FavoriteAdded());
      } else {
        emit(ProductDetails2FavoriteRemoved());
      }
    }
  }

  void incrementQuantity() {
    _quantity++;
    emit(ProductDetails2QuantityChanged());
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      emit(ProductDetails2QuantityChanged());
    }
  }

  void changeImageIndex(int index) {
    if (_product != null && index >= 0 && index < _product!.images.length) {
      _currentImageIndex = index;
      emit(ProductDetails2ImageChanged());
    }
  }

  void toggleProductDetailsExpansion() {
    _isProductDetailExpanded = !_isProductDetailExpanded;
    emit(ProductDetails2ExpansionChanged());
  }

  void toggleNutritionExpansion() {
    _isNutritionExpanded = !_isNutritionExpanded;
    emit(ProductDetails2NutritionExpansionChanged());
  }

  void addToCart() {
    emit(ProductDetails2AddedToCart());
  }

  void navigateToNutrition() {
    emit(ProductDetails2NavigateToNutrition());
  }

  void navigateToReviews() {
    emit(ProductDetails2NavigateToReviews());
  }
}
