import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/sign_in/sign_in_screen.dart';
import '../../features/sign_up/sign_up_screen.dart';
import '../../features/reset_password/reset_password_screen.dart';

class AppRouters {
  // Route Constants
  static const String kSplashView = '/splash';
  static const String kOnboardingView = '/onboarding';
  static const String kLoginView = '/signin';
  static const String kRegisterView = '/signup';
  static const String kResetPasswordView = '/reset-password';
  static const String kHomeView = '/home';
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

      // Home Screen
      GoRoute(
        path: kHomeView,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Home Screen'))),
      ),

      // Scan Screen
      GoRoute(
        path: kScanView,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Scan Screen'))),
      ),

      // Cart Screen
      GoRoute(
        path: kCartView,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Cart Screen'))),
      ),

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
