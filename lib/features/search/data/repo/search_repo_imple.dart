import '../models/product_model.dart';
import 'search_repo.dart';

class SearchRepoImpl implements SearchRepo {
  // قائمة المنتجات الثابتة - يمكن استبدالها بقاعدة بيانات حقيقية
  static final List<ProductModel> _products = [
    ProductModel(
      id: '1',
      name: 'Organic Bananas',
      nameAr: 'موز عضوي',
      imagePath: 'assets/images/banana.png',
      description: '1kg, Priceg',
      descriptionAr: '1كيلو، سعر',
      price: 'SR8',
      category: 'fruits',
    ),
    ProductModel(
      id: '2',
      name: 'Red Apple',
      nameAr: 'تفاح أحمر',
      imagePath: 'assets/images/apple.png',
      description: '1kg, Priceg',
      descriptionAr: '1كيلو، سعر',
      price: 'SR10',
      category: 'fruits',
    ),
    ProductModel(
      id: '3',
      name: 'Fresh Milk',
      nameAr: 'حليب طازج',
      imagePath: 'assets/images/mike.png',
      description: '1L, Fresh',
      descriptionAr: '1لتر، طازج',
      price: 'SR5',
      category: 'dairy',
    ),
    ProductModel(
      id: '4',
      name: 'Natural Yogurt',
      nameAr: 'لبن طبيعي',
      imagePath: 'assets/images/laban.png',
      description: '500g, Natural',
      descriptionAr: '500جرام، طبيعي',
      price: 'SR9',
      category: 'dairy',
    ),
    ProductModel(
      id: '5',
      name: 'Egg Chicken Red',
      nameAr: 'بيض دجاج أحمر',
      imagePath: 'assets/images/Egge.png',
      description: '4pcs, Price',
      descriptionAr: '4قطع، سعر',
      price: 'SR1.99',
      category: 'eggs',
    ),
    ProductModel(
      id: '6',
      name: 'Egg Chicken White',
      nameAr: 'بيض دجاج أبيض',
      imagePath: 'assets/images/Egge2.png',
      description: '180g, Price',
      descriptionAr: '180جرام، سعر',
      price: 'SR1.50',
      category: 'eggs',
    ),
  ];

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    if (query.isEmpty) return [];

    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 500));

    return _products.where((product) {
      final searchQuery = query.toLowerCase();
      return product.name.toLowerCase().contains(searchQuery) ||
          product.nameAr.contains(query) ||
          product.description.toLowerCase().contains(searchQuery) ||
          product.descriptionAr.contains(query) ||
          product.category.toLowerCase().contains(searchQuery);
    }).toList();
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_products);
  }
}
