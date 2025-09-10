import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String productId;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final String weight;
  final String imagePath;
  final String category;
  final String categoryAr;
  final int quantity;

  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    required this.weight,
    required this.imagePath,
    required this.category,
    required this.categoryAr,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    double? price,
    String? weight,
    String? imagePath,
    String? category,
    String? categoryAr,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      categoryAr: categoryAr ?? this.categoryAr,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [
    id,
    productId,
    name,
    nameAr,
    description,
    descriptionAr,
    price,
    weight,
    imagePath,
    category,
    categoryAr,
    quantity,
  ];
}
