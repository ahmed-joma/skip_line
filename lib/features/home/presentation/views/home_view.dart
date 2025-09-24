import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/constants/language_manager.dart';
import '../../../../core/services/auth_service.dart';
import '../../../search/presentation/views/search_view.dart';
import '../../../Product_Detail/data/models/product_model.dart' as detail;
import '../../../Product_Detail/presentation/utils/navigation_helper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                  Text(
                    languageManager.isArabic ? 'عرض الكل' : 'See all',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF123459),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildProductCard(
                      'assets/images/banana.png',
                      languageManager.isArabic ? 'موز عضوي' : 'Organic Bananas',
                      '1kg, Priceg',
                      'SR8',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildProductCard(
                      'assets/images/apple.png',
                      languageManager.isArabic ? 'تفاح أحمر' : 'Red Apple',
                      '1kg, Priceg',
                      'SR10',
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
                  Text(
                    languageManager.isArabic ? 'عرض الكل' : 'See all',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF123459),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildProductCard(
                      'assets/images/mike.png',
                      languageManager.isArabic ? 'حليب طازج' : 'Fresh Milk',
                      '1L, Fresh',
                      'SR5',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildProductCard(
                      'assets/images/laban.png',
                      languageManager.isArabic ? 'لبن طبيعي' : 'Natural Yogurt',
                      '500g, Natural',
                      'SR9',
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

  Widget _buildSecondExclusiveOffersSection() {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildProductCard(
                      'assets/images/Egge.png',
                      languageManager.isArabic
                          ? 'بيض دجاج أحمر'
                          : 'Egg Chicken Red',
                      '4pcs, Price',
                      'SR1.99',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildProductCard(
                      'assets/images/Egge2.png',
                      languageManager.isArabic
                          ? 'بيض دجاج أبيض'
                          : 'Egg Chicken White',
                      '180g, Price',
                      'SR1.50',
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

  Widget _buildProductCard(
    String imagePath,
    String title,
    String subtitle,
    String price,
  ) {
    return GestureDetector(
      onTap: () {
        // إنشاء منتج تجريبي للتنقل
        final product = detail.ProductModel(
          id: '1',
          name: title,
          nameAr: title,
          description: subtitle,
          descriptionAr: subtitle,
          price: double.parse(price.replaceAll('SR', '').trim()),
          weight: '1kg',
          images: [imagePath], // سيتم تحويله إلى URL في صفحة التفاصيل
          category: 'Fruits',
          categoryAr: 'الفواكه',
          rating: 4.5,
          reviewCount: 128,
          isFavorite: false,
          nutrition: {},
          features: [],
          featuresAr: [],
        );

        NavigationHelper.navigateToProductDetailFromHome(context, product);
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
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
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
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
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
      builder: (context) => Container(
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
                _buildMenuOption(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: isArabic ? 'الطلبات' : 'Orders',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to orders
                  },
                ),
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
                FutureBuilder<bool>(
                  future: AuthService().isLoggedIn(),
                  builder: (context, snapshot) {
                    final isLoggedIn = snapshot.data ?? false;

                    if (isLoggedIn) {
                      return _buildMenuOption(
                        context,
                        icon: Icons.favorite_outline,
                        title: isArabic ? 'المفضلة' : 'Favorites',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Navigate to favorites
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),

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
                          Navigator.pop(context);
                          if (isLoggedIn) {
                            // Logout
                            await AuthService().logout();
                            setState(() {}); // Refresh UI
                          } else {
                            // Sign In
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
                      await AuthService().logout();
                      Navigator.pop(context);
                      // Refresh the page to update UI
                      setState(() {});
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
