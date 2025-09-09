class ProductModel {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final String weight;
  final List<String> images;
  final String category;
  final String categoryAr;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final Map<String, dynamic> nutrition;
  final List<String> features;
  final List<String> featuresAr;

  ProductModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    required this.weight,
    required this.images,
    required this.category,
    required this.categoryAr,
    required this.rating,
    required this.reviewCount,
    this.isFavorite = false,
    required this.nutrition,
    required this.features,
    required this.featuresAr,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      weight: json['weight'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      categoryAr: json['categoryAr'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      nutrition: json['nutrition'] ?? {},
      features: List<String>.from(json['features'] ?? []),
      featuresAr: List<String>.from(json['featuresAr'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'price': price,
      'weight': weight,
      'images': images,
      'category': category,
      'categoryAr': categoryAr,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFavorite': isFavorite,
      'nutrition': nutrition,
      'features': features,
      'featuresAr': featuresAr,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    double? price,
    String? weight,
    List<String>? images,
    String? category,
    String? categoryAr,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    Map<String, dynamic>? nutrition,
    List<String>? features,
    List<String>? featuresAr,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      images: images ?? this.images,
      category: category ?? this.category,
      categoryAr: categoryAr ?? this.categoryAr,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      nutrition: nutrition ?? this.nutrition,
      features: features ?? this.features,
      featuresAr: featuresAr ?? this.featuresAr,
    );
  }
}
