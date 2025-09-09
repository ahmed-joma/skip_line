class ProductModel {
  final String id;
  final String name;
  final String nameAr;
  final String imagePath;
  final String description;
  final String descriptionAr;
  final String price;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.imagePath,
    required this.description,
    required this.descriptionAr,
    required this.price,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      imagePath: json['imagePath'] ?? '',
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      price: json['price'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'imagePath': imagePath,
      'description': description,
      'descriptionAr': descriptionAr,
      'price': price,
      'category': category,
    };
  }
}
