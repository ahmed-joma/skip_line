import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/sign_in/sign_in_screen.dart';
import '../../features/sign_up/sign_up_screen.dart';
import '../../features/reset_password/reset_password_screen.dart';
import '../../features/reset_password/verification_code_screen.dart';
import '../../features/sign_up/verification_code_screen.dart' as signup;
import '../../features/home/presentation/views/home_view.dart';
import '../../features/account/account_screen.dart';
import '../../features/chat_bot/presentation/views/chat_bot_view.dart';
import '../../features/Product_Detail/presentation/views/Product_Detail_view.dart';
import '../../features/Product_Detail/data/models/product_model.dart';
import '../../features/my_cart/presentation/views/my_cart_view.dart';
import '../../features/scan/presentation/views/scan_view.dart';
import '../../features/Product_Details2/presentation/views/product_details2_view.dart';
import '../../features/Product_Details2/data/models/product_details2_model.dart';

class AppRouters {
  // Route Constants
  static const String kSplashView = '/splash';
  static const String kOnboardingView = '/onboarding';
  static const String kLoginView = '/signin';
  static const String kRegisterView = '/signup';
  static const String kResetPasswordView = '/reset-password';
  static const String kVerificationCodeView = '/verification-code';
  static const String kSignUpVerificationView = '/signup-verification';
  static const String kHomeView = '/home';
  static const String kAccountView = '/account';
  static const String kChatBotView = '/chatbot';
  static const String kProductDetailView = '/product-detail';
  static const String kScanView = '/scan';
  static const String kProductDetails2View = '/product-details2';
  static const String kCartView = '/cart';
  static const String kPaymentView = '/payment';
  static const String kProfileView = '/profile';

  static final router = GoRouter(
    initialLocation: kSplashView,
    routes: [
      // Splash Screen
      GoRoute(
        path: kSplashView,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Screen
      GoRoute(
        path: kOnboardingView,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Login Screen
      GoRoute(
        path: kLoginView,
        builder: (context, state) => const SignInScreen(),
      ),

      // Sign Up Screen
      GoRoute(
        path: kRegisterView,
        builder: (context, state) => const SignUpScreen(),
      ),

      // Reset Password Screen
      GoRoute(
        path: kResetPasswordView,
        builder: (context, state) => const ResetPasswordScreen(),
      ),

      // Verification Code Screen (Reset Password)
      GoRoute(
        path: kVerificationCodeView,
        builder: (context, state) => const VerificationCodeScreen(),
      ),

      // Sign Up Verification Code Screen
      GoRoute(
        path: kSignUpVerificationView,
        builder: (context, state) => const signup.VerificationCodeScreen(),
      ),

      // Home Screen
      GoRoute(path: kHomeView, builder: (context, state) => const HomeView()),

      // Account Screen
      GoRoute(
        path: kAccountView,
        builder: (context, state) => const AccountScreen(),
      ),

      // Chat Bot Screen
      GoRoute(
        path: kChatBotView,
        builder: (context, state) => const ChatBotView(),
      ),

      // Product Detail Screen
      GoRoute(
        path: kProductDetailView,
        builder: (context, state) {
          final productData = state.extra as Map<String, dynamic>?;
          if (productData != null) {
            final product = ProductModel.fromJson(productData);
            return ProductDetailView(product: product);
          }
          return const Scaffold(body: Center(child: Text('Product not found')));
        },
      ),

      // Scan Screen
      GoRoute(path: kScanView, builder: (context, state) => const ScanView()),

      // Product Details 2 Screen
      GoRoute(
        path: kProductDetails2View,
        builder: (context, state) {
          final productData = state.extra as Map<String, dynamic>?;
          if (productData != null) {
            // إنشاء ProductDetails2Model من البيانات المرسلة
            final productName = productData['productName'] ?? '';
            final productCategory = productData['productCategory'] ?? '';

            // ترجمة عربية افتراضية للمنتجات الشائعة
            String getArabicName(String englishName) {
              String lowerName = englishName.toLowerCase();

              // ترجمة المنتجات الشائعة
              if (lowerName.contains('banana')) return 'موز';
              if (lowerName.contains('apple')) return 'تفاح';
              if (lowerName.contains('milk')) return 'حليب طازج';
              if (lowerName.contains('bread')) return 'خبز';
              if (lowerName.contains('cheese')) return 'جبن';
              if (lowerName.contains('yogurt')) return 'زبادي';
              if (lowerName.contains('orange')) return 'برتقال';
              if (lowerName.contains('tomato')) return 'طماطم';
              if (lowerName.contains('potato')) return 'بطاطس';
              if (lowerName.contains('onion')) return 'بصل';
              if (lowerName.contains('saudi')) return 'حليب السعودية';
              if (lowerName.contains('chicken')) return 'دجاج';
              if (lowerName.contains('beef')) return 'لحم بقري';
              if (lowerName.contains('fish')) return 'سمك';
              if (lowerName.contains('rice')) return 'أرز';
              if (lowerName.contains('pasta')) return 'معكرونة';
              if (lowerName.contains('sugar')) return 'سكر';
              if (lowerName.contains('salt')) return 'ملح';
              if (lowerName.contains('oil')) return 'زيت';
              if (lowerName.contains('water')) return 'ماء';

              return englishName; // إذا لم توجد ترجمة، استخدم الاسم الإنجليزي
            }

            String getArabicCategory(String englishCategory) {
              String lowerCategory = englishCategory.toLowerCase();

              // ترجمة الفئات الشائعة
              if (lowerCategory.contains('fruits') ||
                  lowerCategory.contains('fruit'))
                return 'فواكه';
              if (lowerCategory.contains('vegetables') ||
                  lowerCategory.contains('vegetable'))
                return 'خضروات';
              if (lowerCategory.contains('dairy')) return 'ألبان';
              if (lowerCategory.contains('bakery')) return 'مخبوزات';
              if (lowerCategory.contains('beverages') ||
                  lowerCategory.contains('beverage'))
                return 'مشروبات';
              if (lowerCategory.contains('snacks') ||
                  lowerCategory.contains('snack'))
                return 'وجبات خفيفة';
              if (lowerCategory.contains('meat')) return 'لحوم';
              if (lowerCategory.contains('seafood')) return 'مأكولات بحرية';
              if (lowerCategory.contains('grains')) return 'حبوب';
              if (lowerCategory.contains('spices')) return 'توابل';
              if (lowerCategory.contains('frozen')) return 'مجمدات';
              if (lowerCategory.contains('canned')) return 'معلبات';
              if (lowerCategory.contains('organic')) return 'عضوي';
              if (lowerCategory.contains('fresh')) return 'طازج';

              return englishCategory; // إذا لم توجد ترجمة، استخدم الفئة الإنجليزية
            }

            final product = ProductDetails2Model(
              id: '1',
              name: productName,
              nameAr: getArabicName(productName),
              description:
                  'Saudi Milk Is One Of The Finest Types Of Long-Life Milk That Can Be Kept At Room Temperature.',
              descriptionAr:
                  'حليب السعودية من أجود أنواع الحليب طويل الأمد الذي يمكن الاحتفاظ به في درجة حرارة الغرفة.',
              price: 5.0,
              images: [
                productData['productImage'] ?? 'assets/images/banana.png',
              ],
              isFavorite: false,
              quantity: 1,
              weight: '1L',
              nutritionInfo: '100gr',
              rating: 5.0,
              reviewCount: 128,
              category: productCategory,
              categoryAr: getArabicCategory(productCategory),
            );
            return ProductDetails2View(product: product);
          }
          return const Scaffold(body: Center(child: Text('Product not found')));
        },
      ),

      // Cart Screen
      GoRoute(path: kCartView, builder: (context, state) => const MyCartView()),

      // Payment Screen
      GoRoute(
        path: kPaymentView,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Payment Screen'))),
      ),

      // Profile Screen
      GoRoute(
        path: kProfileView,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Profile Screen'))),
      ),
    ],
  );
}
