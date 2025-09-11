class ProductDetails2Model {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final List<String> images;
  final bool isFavorite;
  final int quantity;
  final String weight;
  final String nutritionInfo;
  final double rating;
  final int reviewCount;

  ProductDetails2Model({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    required this.images,
    required this.isFavorite,
    required this.quantity,
    required this.weight,
    required this.nutritionInfo,
    required this.rating,
    required this.reviewCount,
  });

  ProductDetails2Model copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    double? price,
    List<String>? images,
    bool? isFavorite,
    int? quantity,
    String? weight,
    String? nutritionInfo,
    double? rating,
    int? reviewCount,
  }) {
    return ProductDetails2Model(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      price: price ?? this.price,
      images: images ?? this.images,
      isFavorite: isFavorite ?? this.isFavorite,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      nutritionInfo: nutritionInfo ?? this.nutritionInfo,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}
