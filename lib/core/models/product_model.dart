class ProductModel {
  final int id;
  final String imageUrl;
  final String nameEn;
  final String nameAr;
  final String unitEn;
  final String unitAr;
  final String salePrice;
  final bool isFavorite;

  ProductModel({
    required this.id,
    required this.imageUrl,
    required this.nameEn,
    required this.nameAr,
    required this.unitEn,
    required this.unitAr,
    required this.salePrice,
    required this.isFavorite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      nameEn: json['name_en'] ?? '',
      nameAr: json['name_ar'] ?? '',
      unitEn: json['unit_en'] ?? '',
      unitAr: json['unit_ar'] ?? '',
      salePrice: json['sale_price'] ?? '0.00',
      isFavorite: json['is_favorite'] ?? false,
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

  @override
  String toString() {
    return 'ProductModel(id: $id, nameEn: $nameEn, nameAr: $nameAr, price: $salePrice)';
  }
}
