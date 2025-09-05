import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/constants/language_manager.dart';

class OnboardingScreenView extends StatelessWidget {
  const OnboardingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      body: Column(
        children: [
          // Onboarding Image
          Image.asset(
            'assets/images/onbording.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          // Bottom Content
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Welcome Text
                  Consumer<LanguageManager>(
                    builder: (context, languageManager, child) {
                      return Column(
                        children: [
                          Text(
                            languageManager.isArabic
                                ? 'مرحباً بك في'
                                : 'Welcome to',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            languageManager.isArabic ? 'سكيب لاين' : 'SkipLine',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            languageManager.isArabic
                                ? 'طريقك السريع للتسوق بدون متاعب'
                                : 'your fast lane to hassle-free shopping.',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Get Started Button
                  SizedBox(
                    width: 350,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to login screen
                        context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF123459), // Custom blue
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Consumer<LanguageManager>(
                        builder: (context, languageManager, child) {
                          return Text(
                            languageManager.isArabic
                                ? 'ابدأ الآن'
                                : 'Get Started',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
