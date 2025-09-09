import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../shared/constants/language_manager.dart';
import '../manager/search/search_cubit.dart';
import '../manager/search/search_state.dart';
import '../../data/repo/search_repo_imple.dart';
import '../../data/models/product_model.dart';
import '../../../Product_Detail/data/models/product_model.dart' as detail;
import '../../../Product_Detail/presentation/utils/navigation_helper.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  late SearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _searchCubit = SearchCubit(SearchRepoImpl());
    // تحميل جميع المنتجات عند فتح الصفحة
    _searchCubit.getAllProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _searchCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header with Search Bar
              _buildSearchHeader(),

              // Search Results
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchInitial) {
                      return _buildInitialState();
                    } else if (state is SearchLoading) {
                      return _buildLoadingState();
                    } else if (state is SearchLoaded) {
                      return _buildSearchResults(state.products);
                    } else if (state is SearchError) {
                      return _buildErrorState(state.message);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Back Button and Search Bar
              Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Search Bar
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                          _searchCubit.searchProducts(value);
                        },
                        decoration: InputDecoration(
                          hintText: languageManager.isArabic
                              ? 'البحث في المتجر'
                              : 'Search Store',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 24,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    _searchCubit.clearSearch();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Filter Button
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement filter functionality
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.tune, color: Colors.black, size: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInitialState() {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                languageManager.isArabic
                    ? 'ابدأ البحث عن المنتجات'
                    : 'Start searching for products',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF123459)),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                languageManager.isArabic
                    ? 'حدث خطأ أثناء البحث'
                    : 'Error occurred while searching',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(List<ProductModel> products) {
    if (products.isEmpty) {
      return Consumer<LanguageManager>(
        builder: (context, languageManager, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  languageManager.isArabic
                      ? 'لم يتم العثور على نتائج'
                      : 'No results found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  languageManager.isArabic
                      ? 'جرب البحث بكلمات مختلفة'
                      : 'Try searching with different words',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        },
      );
    }

    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(product, languageManager.isArabic);
            },
          ),
        );
      },
    );
  }

  Widget _buildProductCard(ProductModel product, bool isArabic) {
    return GestureDetector(
      onTap: () {
        // تحويل ProductModel إلى detail.ProductModel
        final detailProduct = detail.ProductModel(
          id: product.id,
          name: product.name,
          nameAr: product.nameAr,
          description: product.description,
          descriptionAr: product.descriptionAr,
          price: double.parse(product.price.replaceAll('SR', '').trim()),
          weight: '1kg',
          images: [product.imagePath], // سيتم تحويله إلى URL في صفحة التفاصيل
          category: product.category,
          categoryAr: product.category,
          rating: 4.5,
          reviewCount: 128,
          isFavorite: false,
          nutrition: {},
          features: [],
          featuresAr: [],
        );

        NavigationHelper.navigateToProductDetailFromHome(
          context,
          detailProduct,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.grey[50],
              ),
              child: Center(
                child: Image.asset(
                  product.imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? product.nameAr : product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isArabic ? product.descriptionAr : product.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF123459),
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF123459),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
