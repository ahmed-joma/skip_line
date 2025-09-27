import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/models/product_model.dart';
import '../../../../../core/services/product_service.dart';
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

  /// تحميل تفاصيل المنتج من الـ API
  Future<void> loadProductFromApi(int productId) async {
    print('🔄 ===== LOADING PRODUCT DETAILS FROM API =====');
    print('📝 Product ID: $productId');

    emit(ProductDetailLoading());

    try {
      print('📞 Calling ProductService.getProductById($productId)...');
      final result = await ProductService.getProductById(productId);

      print('📥 Received result from ProductService:');
      print('   Success: ${result.isSuccess}');
      print('   Message: ${result.msg}');
      print('   Data: ${result.data}');

      if (result.isSuccess && result.data != null) {
        print('✅ Product details loaded successfully!');
        print('📦 Product: ${result.data!.nameEn} (${result.data!.nameAr})');

        _product = result.data!;
        emit(ProductDetailLoaded(result.data!));

        print('📱 Product details state updated');
        print('💰 Product price: ${result.data!.salePrice}');
        print('🔢 Quantity: $_quantity');
        print(
          '💵 Total price: ${double.parse(result.data!.salePrice) * _quantity}',
        );
      } else {
        print('❌ Failed to load product details: ${result.msg}');
        emit(ProductDetailError(result.msg));
        print('📱 Product details error state updated');
      }
    } catch (e) {
      print('❌ Unexpected error loading product details: $e');
      emit(ProductDetailError('Unexpected error: $e'));
      print('📱 Product details error state updated');
    }

    print('🏁 ===== PRODUCT DETAILS LOADING COMPLETED =====');
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
