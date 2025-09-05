import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/constants/language_manager.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF0F5), // Light pink
              Color(0xFFF0F8FF), // Light blue
              Color(0xFFF0FFF0), // Light green
              Color(0xFFFFF8DC), // Light yellow
              Color(0xFFF5F0FF), // Light purple
              Colors.white, // White at bottom
              Colors.white, // White at bottom
            ],
            stops: [0.0, 0.05, 0.1, 0.15, 0.2, 0.25, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // App Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 60),

                // Login Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Consumer<LanguageManager>(
                      builder: (context, languageManager, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              languageManager.isArabic
                                  ? 'تسجيل الدخول'
                                  : 'Login',
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              languageManager.isArabic
                                  ? 'أدخل بريدك الإلكتروني وكلمة المرور'
                                  : 'Enter your emails and password',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // Email Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF123459)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Password Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF123459)),
                            ),
                            suffixIcon: IconButton(
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  key: ValueKey(_obscurePassword),
                                  color: Colors.grey,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Navigate to forgot password
                              print('Forgot Password pressed');
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Log In Button
                    Center(
                      child: SizedBox(
                        width: 350,
                        height: 63,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Handle login
                            print('Login pressed');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF123459),
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
                                    ? 'تسجيل الدخول'
                                    : 'Log In',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Signup Link
                    Center(
                      child: Consumer<LanguageManager>(
                        builder: (context, languageManager, child) {
                          return RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: languageManager.isArabic
                                      ? 'ليس لديك حساب؟ '
                                      : 'Don\'t have an account? ',
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      // TODO: Navigate to signup
                                      print('Signup pressed');
                                    },
                                    child: Text(
                                      languageManager.isArabic
                                          ? 'سجل الآن'
                                          : 'Signup',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF123459),
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xFF123459),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50), // Extra space for keyboard
              ],
            ),
          ),
        ),
      ),
    );
  }
}
