import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/constants/language_manager.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with TickerProviderStateMixin {
  AnimationController? _fadeController;
  Animation<double>? _fadeAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Initialize fade animation after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAnimation();
    });

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // TODO: Navigate to onboarding or home screen
        print('Navigate to next screen');
      }
    });
  }

  void _initializeAnimation() {
    if (!_isInitialized) {
      _fadeController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );

      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController!, curve: Curves.easeIn),
      );

      _isInitialized = true;
      _fadeController!.forward();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF123459), // Custom blue background
      body: SafeArea(
        child: _isInitialized && _fadeAnimation != null
            ? FadeTransition(opacity: _fadeAnimation!, child: _buildContent())
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo Section - Simple and Direct
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SK Logo PNG - Big and Clear
              Image.asset('assets/images/splash.png', width: 150, height: 150),
              const SizedBox(height: 8),
            ],
          ),

          const SizedBox(width: 20),

          // Text Section - Simple and Direct with Flexible
          Expanded(
            child: Consumer<LanguageManager>(
              builder: (context, languageManager, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      languageManager.isArabic
                          ? 'تطبيق الدفع الذاتي الذكي'
                          : 'Smart Self-Checkout App',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      languageManager.isArabic
                          ? 'مصمم لتسريع خدمتك\nفي المتاجر المحلية'
                          : 'Designed to speed up your\nservice at local stores',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
