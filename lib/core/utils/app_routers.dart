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
