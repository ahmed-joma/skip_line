import 'package:equatable/equatable.dart';
import '../../../../../core/models/product_model.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductDetailLoaded extends ProductDetailState {
  final ProductModel product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductFavoriteAdded extends ProductDetailState {}

class ProductFavoriteRemoved extends ProductDetailState {}

class ProductQuantityChanged extends ProductDetailState {
  final int quantity;

  const ProductQuantityChanged(this.quantity);

  @override
  List<Object?> get props => [quantity];
}

class ProductImageChanged extends ProductDetailState {
  final int imageIndex;

  const ProductImageChanged(this.imageIndex);

  @override
  List<Object?> get props => [imageIndex];
}

class ProductDetailExpansionChanged extends ProductDetailState {
  final bool isExpanded;

  const ProductDetailExpansionChanged(this.isExpanded);

  @override
  List<Object?> get props => [isExpanded];
}

class NutritionExpansionChanged extends ProductDetailState {
  final bool isExpanded;

  const NutritionExpansionChanged(this.isExpanded);

  @override
  List<Object?> get props => [isExpanded];
}

class ProductAddedToCart extends ProductDetailState {}

class NavigateToNutrition extends ProductDetailState {}

class NavigateToReviews extends ProductDetailState {}
