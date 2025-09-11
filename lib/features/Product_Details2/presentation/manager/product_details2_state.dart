import 'package:equatable/equatable.dart';
import '../../data/models/product_details2_model.dart';

abstract class ProductDetails2State extends Equatable {
  const ProductDetails2State();

  @override
  List<Object?> get props => [];
}

class ProductDetails2Initial extends ProductDetails2State {}

class ProductDetails2Loaded extends ProductDetails2State {
  final ProductDetails2Model product;

  const ProductDetails2Loaded({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductDetails2QuantityChanged extends ProductDetails2State {
  final int quantity;

  const ProductDetails2QuantityChanged(this.quantity);

  @override
  List<Object?> get props => [quantity];
}

class ProductDetails2ImageChanged extends ProductDetails2State {}

class ProductDetails2ExpansionChanged extends ProductDetails2State {}

class ProductDetails2NutritionExpansionChanged extends ProductDetails2State {}

class ProductDetails2FavoriteAdded extends ProductDetails2State {}

class ProductDetails2FavoriteRemoved extends ProductDetails2State {}

class ProductDetails2AddedToCart extends ProductDetails2State {}

class ProductDetails2NavigateToNutrition extends ProductDetails2State {}

class ProductDetails2NavigateToReviews extends ProductDetails2State {}
