class ProductModel {
  final int id;
  final String imageUrl;
  final String nameEn;
  final String nameAr;
  final String unitEn;
  final String unitAr;
  final String salePrice;
  final bool isFavorite;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? nutritionEn;
  final String? nutritionAr;
  final int? rate;

  ProductModel({
    required this.id,
    required this.imageUrl,
    required this.nameEn,
    required this.nameAr,
    required this.unitEn,
    required this.unitAr,
    required this.salePrice,
    required this.isFavorite,
    this.descriptionEn,
    this.descriptionAr,
    this.nutritionEn,
    this.nutritionAr,
    this.rate,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is String ? int.parse(json['id']) : (json['id'] ?? 0),
      imageUrl: json['image_url'] ?? '',
      nameEn: json['name_en'] ?? '',
      nameAr: json['name_ar'] ?? '',
      unitEn: json['unit_en'] ?? '',
      unitAr: json['unit_ar'] ?? '',
      salePrice: json['sale_price'] ?? '0.00',
      isFavorite: json['is_favorite'] ?? false,
      descriptionEn: json['description_en'],
      descriptionAr: json['description_ar'],
      nutritionEn: json['nutrition_en'],
      nutritionAr: json['nutrition_ar'],
      rate: json['rate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'name_en': nameEn,
      'name_ar': nameAr,
      'unit_en': unitEn,
      'unit_ar': unitAr,
      'sale_price': salePrice,
      'is_favorite': isFavorite,
      'description_en': descriptionEn,
      'description_ar': descriptionAr,
      'nutrition_en': nutritionEn,
      'nutrition_ar': nutritionAr,
      'rate': rate,
    };
  }

  // Helper method to get name based on language
  String getName(bool isArabic) {
    return isArabic ? nameAr : nameEn;
  }

  // Helper method to get unit based on language
  String getUnit(bool isArabic) {
    return isArabic ? unitAr : unitEn;
  }

  // Helper method to format price
  String getFormattedPrice() {
    return '${salePrice} ر.س';
  }

  // Helper method to get description based on language
  String? getDescription(bool isArabic) {
    return isArabic ? descriptionAr : descriptionEn;
  }

  // Helper method to get nutrition based on language
  String? getNutrition(bool isArabic) {
    return isArabic ? nutritionAr : nutritionEn;
  }

  // Helper method to get rating stars
  String getRatingStars() {
    if (rate == null) return '';
    return '⭐' * (rate!);
  }

  // Copy with method for updating product properties
  ProductModel copyWith({
    int? id,
    String? imageUrl,
    String? nameEn,
    String? nameAr,
    String? unitEn,
    String? unitAr,
    String? salePrice,
    bool? isFavorite,
    String? descriptionEn,
    String? descriptionAr,
    String? nutritionEn,
    String? nutritionAr,
    int? rate,
  }) {
    return ProductModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      unitEn: unitEn ?? this.unitEn,
      unitAr: unitAr ?? this.unitAr,
      salePrice: salePrice ?? this.salePrice,
      isFavorite: isFavorite ?? this.isFavorite,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      nutritionEn: nutritionEn ?? this.nutritionEn,
      nutritionAr: nutritionAr ?? this.nutritionAr,
      rate: rate ?? this.rate,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, nameEn: $nameEn, nameAr: $nameAr, price: $salePrice)';
  }
}
