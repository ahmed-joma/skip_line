import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../shared/constants/language_manager.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/product_service.dart';
import '../../../../core/models/product_model.dart';
import '../../../search/presentation/views/search_view.dart';
import '../../../my_cart/presentation/manager/cart/cart_cubit.dart';
import '../../../my_cart/data/models/cart_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // Product data
  List<ProductModel> _bestSellers = [];
  List<ProductModel> _exclusiveOffers = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Animation state for add to cart buttons
  final Map<String, bool> _buttonPressedStates = {};

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// إضافة منتج للسلة مع إظهار إشعار
  void _addToCart(ProductModel product) {
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );

    // تأثير بصري عند الضغط
    setState(() {
      _buttonPressedStates[product.id.toString()] = true;
    });

    // تأثير اهتزازي
    HapticFeedback.lightImpact();

    // إعادة تعيين التأثير بعد 200ms
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _buttonPressedStates[product.id.toString()] = false;
        });
      }
    });

    // تحويل السعر من String إلى double
    final price = double.tryParse(product.salePrice) ?? 0.0;

    // إنشاء CartItem من ProductModel
    final cartItem = CartItem(
      id: product.id.toString(),
      productId: product.id.toString(),
      name: product.nameEn,
      nameAr: product.nameAr,
      description: product.descriptionEn ?? '',
      descriptionAr: product.descriptionAr ?? '',
      price: price,
      weight: product.unitEn,
      imagePath: product.imageUrl,
      category: 'General', // ProductModel لا يحتوي على category
      categoryAr: 'عام', // ProductModel لا يحتوي على categoryAr
      quantity: 1,
    );

    // إضافة المنتج للسلة باستخدام CartCubit
    context.read<CartCubit>().addToCart(cartItem);

    // إظهار إشعار السلة الجديد مع زر View Cart
    _showCartNotification(context, languageManager, product);

    print('✅ Product ${product.id} added to cart successfully');
  }

  /// إظهار إشعار السلة مع زر View Cart
  void _showCartNotification(
    BuildContext context,
    LanguageManager languageManager,
    ProductModel product,
  ) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50), // أخضر جميل
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // أيقونة النجاح
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // النص
                Expanded(
                  child: Text(
                    languageManager.isArabic
                        ? 'تم إضافة ${product.getName(languageManager.isArabic)} إلى السلة'
                        : '${product.getName(languageManager.isArabic)} added to cart',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // زر View Cart
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    overlayEntry.remove();
                    context.go('/cart');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      languageManager.isArabic ? 'عرض السلة' : 'View Cart',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // زر الإغلاق
                GestureDetector(
                  onTap: () => overlayEntry.remove(),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // إزالة الإشعار تلقائياً بعد 4 ثوانٍ
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  Future<void> _loadProducts() async {
    print('🔄 ===== LOADING PRODUCTS =====');
    print('📱 Current loading state: $_isLoading');
    print('📱 Current error message: $_errorMessage');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    print('📱 Updated loading state to: $_isLoading');

    try {
      print('📞 Calling ProductService.getProducts()...');
      final result = await ProductService.getProducts();

      print('📥 Received result from ProductService:');
      print('   Success: ${result.isSuccess}');
      print('   Message: ${result.msg}');
      print('   Data: ${result.data}');

      if (result.isSuccess && result.data != null) {
        print('✅ Products loaded successfully!');
        print('📦 Best Sellers count: ${result.data!.bestSellers.length}');
        print(
          '📦 Exclusive Offers count: ${result.data!.exclusiveOffers.length}',
        );

        setState(() {
          _bestSellers = result.data!.bestSellers;
          _exclusiveOffers = result.data!.exclusiveOffers;
          _isLoading = false;
        });

        print('📱 Updated state - Loading: $_isLoading');
        print('📱 Best Sellers in state: ${_bestSellers.length}');
        print('📱 Exclusive Offers in state: ${_exclusiveOffers.length}');
        print(
          '📦 Loaded ${_bestSellers.length} best sellers and ${_exclusiveOffers.length} exclusive offers',
        );
      } else {
        print('❌ Failed to load products: ${result.msg}');
        setState(() {
          _errorMessage = result.msg;
          _isLoading = false;
        });
        print('📱 Updated state - Loading: $_isLoading, Error: $_errorMessage');
      }
    } catch (e) {
      print('❌ Error loading products: $e');
      print('🔍 Error type: ${e.runtimeType}');
      setState(() {
        _errorMessage = 'Error loading products: $e';
        _isLoading = false;
      });
      print('📱 Updated state - Loading: $_isLoading, Error: $_errorMessage');
    }

    print('🏁 ===== PRODUCTS LOADING COMPLETED =====');
    print('📱 Final state - Loading: $_isLoading, Error: $_errorMessage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Search Bar
            _buildSearchBar(),

            // Advertisement Banner
            _buildAdvertisementBanner(),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Best Seller Section
                    _buildBestSellerSection(),

                    const SizedBox(height: 20),

                    // Exclusive Offers Section
                    _buildExclusiveOffersSection(),

                    const SizedBox(height: 20),

                    // Second Exclusive Offers Section
                    _buildSecondExclusiveOffersSection(),

                    const SizedBox(height: 100), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              // Language Toggle and Menu
              Row(
                children: [
                  // Language Toggle
                  GestureDetector(
                    onTap: () {
                      languageManager.toggleLanguage();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: languageManager.isArabic
                            ? const Color(0xFF123459)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        languageManager.isArabic ? 'Ar' : 'En',
                        style: TextStyle(
                          color: languageManager.isArabic
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Sign In Button or User Avatar
                  FutureBuilder<bool>(
                    future: AuthService().isLoggedIn(),
                    builder: (context, snapshot) {
                      final isLoggedIn = snapshot.data ?? false;

                      if (isLoggedIn) {
                        // Show user avatar
                        return GestureDetector(
                          onTap: () {
                            _showUserMenu(context, languageManager.isArabic);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF123459),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      } else {
                        // Show Sign In button
                        return GestureDetector(
                          onTap: () {
                            context.go('/signin');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF123459),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              languageManager.isArabic
                                  ? 'تسجيل دخول'
                                  : 'SIGN IN',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(width: 12),

                  // Menu Button
                  GestureDetector(
                    onTap: () {
                      _showAccountMenu(context, languageManager.isArabic);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.menu, color: Colors.black, size: 24),
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

  Widget _buildSearchBar() {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchView()),
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.search, color: Colors.black, size: 30),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    languageManager.isArabic
                        ? 'البحث في المتجر'
                        : 'Search Store',
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdvertisementBanner() {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Column(
          children: [
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  // محتوى مختلف لكل صفحة
                  String title;
                  String subtitle;
                  Color backgroundColor;

                  switch (index) {
                    case 0:
                      title = languageManager.isArabic
                          ? 'تسوق بمسح المنتجات'
                          : 'Shop by\nscanning\nproducts';
                      subtitle = languageManager.isArabic
                          ? 'مسح سريع وآمن'
                          : 'Quick & Safe\nScanning';
                      backgroundColor = const Color(0xFFF8F9FA);
                      break;
                    case 1:
                      title = languageManager.isArabic
                          ? 'عروض حصرية'
                          : 'Exclusive\nOffers';
                      subtitle = languageManager.isArabic
                          ? 'خصومات كبيرة'
                          : 'Big\nDiscounts';
                      backgroundColor = const Color(0xFFF8F9FA);
                      break;
                    case 2:
                      title = languageManager.isArabic
                          ? 'توصيل سريع'
                          : 'Fast\nDelivery';
                      subtitle = languageManager.isArabic
                          ? 'خلال 30 دقيقة'
                          : 'Within 30\nMinutes';
                      backgroundColor = const Color(0xFFF8F9FA);
                      break;
                    default:
                      title = languageManager.isArabic
                          ? 'تسوق بمسح المنتجات'
                          : 'Shop by\nscanning\nproducts';
                      subtitle = languageManager.isArabic
                          ? 'مسح سريع وآمن'
                          : 'Quick & Safe\nScanning';
                      backgroundColor = const Color(0xFFF8F9FA);
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // QR Code Icon - Left side
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            'assets/images/qr.png',
                            width: 150,
                            height: 180,
                          ),
                        ),

                        // Spacer between QR and text
                        const SizedBox(width: 30),

                        // Text Section - Right side
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 0.5,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFF123459)
                        : Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildBestSellerSection() {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    languageManager.isArabic ? 'الأكثر مبيعاً' : 'Best Seller',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go('/best-sellers');
                    },
                    child: Text(
                      languageManager.isArabic ? 'عرض الكل' : 'See all',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF123459),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Loading state
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF123459),
                      ),
                    ),
                  ),
                )
              // Error state
              else if (_errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _loadProducts,
                          child: Text(
                            languageManager.isArabic
                                ? 'إعادة المحاولة'
                                : 'Retry',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              // Empty state
              else if (_bestSellers.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.grey,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          languageManager.isArabic
                              ? 'لا توجد منتجات متاحة'
                              : 'No products available',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              // Products display
              else
                Row(
                  children: [
                    if (_bestSellers.isNotEmpty)
                      Expanded(
                        child: _buildProductCardFromModel(
                          _bestSellers[0],
                          languageManager.isArabic,
                        ),
                      ),
                    if (_bestSellers.length > 1) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildProductCardFromModel(
                          _bestSellers[1],
                          languageManager.isArabic,
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExclusiveOffersSection() {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    languageManager.isArabic
                        ? 'عروض حصرية'
                        : 'Exclusive offers',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go('/exclusive-offers');
                    },
                    child: Text(
                      languageManager.isArabic ? 'عرض الكل' : 'See all',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF123459),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Loading state
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF123459),
                      ),
                    ),
                  ),
                )
              // Error state
              else if (_errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _loadProducts,
                          child: Text(
                            languageManager.isArabic
                                ? 'إعادة المحاولة'
                                : 'Retry',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              // Empty state
              else if (_exclusiveOffers.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          color: Colors.grey,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          languageManager.isArabic
                              ? 'لا توجد عروض متاحة'
                              : 'No offers available',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              // Products display
              else
                Row(
                  children: [
                    if (_exclusiveOffers.isNotEmpty)
                      Expanded(
                        child: _buildProductCardFromModel(
                          _exclusiveOffers[0],
                          languageManager.isArabic,
                        ),
                      ),
                    if (_exclusiveOffers.length > 1) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildProductCardFromModel(
                          _exclusiveOffers[1],
                          languageManager.isArabic,
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSecondExclusiveOffersSection() {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Loading state
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF123459),
                      ),
                    ),
                  ),
                )
              // Error state
              else if (_errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _loadProducts,
                          child: Text(
                            languageManager.isArabic
                                ? 'إعادة المحاولة'
                                : 'Retry',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              // Empty state
              else if (_exclusiveOffers.length < 3)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          color: Colors.grey,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          languageManager.isArabic
                              ? 'لا توجد عروض إضافية'
                              : 'No additional offers',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              // Products display (show items 2 and 3 from exclusive offers)
              else
                Row(
                  children: [
                    if (_exclusiveOffers.length > 2)
                      Expanded(
                        child: _buildProductCardFromModel(
                          _exclusiveOffers[2],
                          languageManager.isArabic,
                        ),
                      ),
                    if (_exclusiveOffers.length > 3) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildProductCardFromModel(
                          _exclusiveOffers[3],
                          languageManager.isArabic,
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  /// بناء بطاقة منتج من نموذج البيانات
  Widget _buildProductCardFromModel(ProductModel product, bool isArabic) {
    return GestureDetector(
      onTap: () {
        print('🔄 Navigating to product detail for ID: ${product.id}');
        print('📦 Product: ${product.nameEn} (${product.nameAr})');

        // التنقل باستخدام productId بدلاً من تمرير المنتج كاملاً
        context.push('/product-detail', extra: {'productId': product.id});
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
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF123459),
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.getName(isArabic),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Product Unit
                  Text(
                    '1${product.getUnit(isArabic)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),

                  // Price and Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.getFormattedPrice(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF123459),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // إضافة المنتج للسلة
                          _addToCart(product);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: EdgeInsets.all(
                            _buttonPressedStates[product.id.toString()] == true
                                ? 8
                                : 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _buttonPressedStates[product.id.toString()] ==
                                    true
                                ? const Color(0xFF0F2A4A) // لون أغمق عند الضغط
                                : const Color(0xFF123459),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF123459).withOpacity(
                                  _buttonPressedStates[product.id.toString()] ==
                                          true
                                      ? 0.5
                                      : 0.3,
                                ),
                                spreadRadius:
                                    _buttonPressedStates[product.id
                                            .toString()] ==
                                        true
                                    ? 2
                                    : 1,
                                blurRadius:
                                    _buttonPressedStates[product.id
                                            .toString()] ==
                                        true
                                    ? 6
                                    : 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size:
                                _buttonPressedStates[product.id.toString()] ==
                                    true
                                ? 18
                                : 16,
                          ),
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

  Widget _buildBottomNavigationBar() {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    0,
                    Icons.store,
                    languageManager.isArabic ? 'متجر' : 'Shop',
                  ),
                  _buildNavItem(
                    1,
                    Icons.qr_code_scanner,
                    languageManager.isArabic ? 'مسح' : 'Scan',
                  ),
                  _buildNavItem(
                    2,
                    Icons.shopping_cart,
                    languageManager.isArabic ? 'سلة' : 'Cart',
                  ),
                  _buildNavItem(
                    3,
                    Icons.smart_toy,
                    languageManager.isArabic ? 'روبوت' : 'Chatbot',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });

        // Navigate to different pages based on selection
        if (index == 1) {
          context.go('/scan');
        } else if (index == 2) {
          context.go('/cart');
        } else if (index == 3) {
          context.go('/chatbot');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF123459) : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF123459) : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showAccountMenu(BuildContext context, bool isArabic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // Menu title
                Text(
                  isArabic ? 'القائمة' : 'Menu',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // Menu options
                // Orders (only show if logged in)
                const SizedBox.shrink(),
                _buildMenuOption(
                  context,
                  icon: Icons.person_outline,
                  title: isArabic ? 'تفاصيلي' : 'My Details',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to my details
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.qr_code_scanner_outlined,
                  title: isArabic ? 'مسح' : 'Scan',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/scan');
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.credit_card_outlined,
                  title: isArabic ? 'طرق الدفع' : 'Payment Methods',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to payment methods
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.smart_toy_outlined,
                  title: isArabic ? 'المساعد الذكي' : 'Chatbot',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/chatbot');
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.notifications_outlined,
                  title: isArabic ? 'الإشعارات' : 'Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to notifications
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.help_outline,
                  title: isArabic ? 'المساعدة' : 'Help',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/help');
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.info_outline,
                  title: isArabic ? 'حول' : 'About',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to about
                  },
                ),

                // Favorites (only show if logged in)
                const SizedBox.shrink(),

                const SizedBox(height: 16),

                // Sign In/Logout button
                FutureBuilder<bool>(
                  future: AuthService().isLoggedIn(),
                  builder: (context, snapshot) {
                    final isLoggedIn = snapshot.data ?? false;

                    return Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (isLoggedIn) {
                            // Logout
                            print(
                              '🎯 ===== HOME VIEW - STARTING LOGOUT (DRAWER) =====',
                            );
                            print('🔄 Calling AuthService.logout()...');

                            final result = await AuthService().logout();

                            print('📥 Received response from AuthService');
                            print('   Success: ${result.isSuccess}');
                            print('   Message: ${result.msg}');

                            final languageManager =
                                Provider.of<LanguageManager>(
                                  context,
                                  listen: false,
                                );

                            // إغلاق الـ Drawer أولاً
                            Navigator.pop(context);

                            if (result.isSuccess) {
                              print('🎉 ===== LOGOUT SUCCESSFUL! =====');
                              print('✅ User logged out successfully!');

                              // Show success notification
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    languageManager.isArabic
                                        ? 'تم تسجيل الخروج بنجاح'
                                        : 'Logged out successfully',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } else {
                              print('❌ ===== LOGOUT FAILED! =====');
                              print('❌ Logout failed: ${result.msg}');

                              // Show error notification
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    languageManager.isArabic
                                        ? 'فشل في تسجيل الخروج'
                                        : 'Failed to logout',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }

                            print('🔄 Refreshing UI...');
                            setState(() {}); // Refresh UI
                            print(
                              '🏁 ===== HOME VIEW - LOGOUT COMPLETED (DRAWER) =====',
                            );
                          } else {
                            // Sign In
                            Navigator.pop(context);
                            context.go('/signin');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLoggedIn
                              ? Colors.red[600]
                              : const Color(0xFF123459),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isLoggedIn
                              ? (isArabic ? 'تسجيل الخروج' : 'Logout')
                              : (isArabic ? 'تسجيل الدخول' : 'Sign In'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUserMenu(BuildContext context, bool isArabic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // User info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF123459).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF123459),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'مرحباً!' : 'Welcome!',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF123459),
                            ),
                          ),
                          Text(
                            isArabic
                                ? 'تم تسجيل دخولك بنجاح'
                                : 'You are logged in successfully',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Logout button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Logout
                      print(
                        '🎯 ===== HOME VIEW - STARTING LOGOUT (USER MENU) =====',
                      );
                      print('🔄 Calling AuthService.logout()...');

                      final result = await AuthService().logout();

                      print('📥 Received response from AuthService');
                      print('   Success: ${result.isSuccess}');
                      print('   Message: ${result.msg}');

                      final languageManager = Provider.of<LanguageManager>(
                        context,
                        listen: false,
                      );

                      if (result.isSuccess) {
                        print('🎉 ===== LOGOUT SUCCESSFUL! =====');
                        print('✅ User logged out successfully!');

                        // Show success notification
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              languageManager.isArabic
                                  ? 'تم تسجيل الخروج بنجاح'
                                  : 'Logged out successfully',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else {
                        print('❌ ===== LOGOUT FAILED! =====');
                        print('❌ Logout failed: ${result.msg}');

                        // Show error notification
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              languageManager.isArabic
                                  ? 'فشل في تسجيل الخروج'
                                  : 'Failed to logout',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }

                      Navigator.pop(context);
                      print('🔄 Refreshing UI...');
                      setState(() {}); // Refresh the page to update UI
                      print(
                        '🏁 ===== HOME VIEW - LOGOUT COMPLETED (USER MENU) =====',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isArabic ? 'تسجيل الخروج' : 'Logout',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF123459), size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );
  }
}
