import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/constants/language_manager.dart';
import '../../../../../core/services/auth_service.dart';

class SignInView extends StatefulWidget {
  final Map<String, dynamic>? extraData;

  const SignInView({super.key, this.extraData});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _emailError = false;
  bool _passwordError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndLogin() async {
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );

    setState(() {
      _emailError = _emailController.text.trim().isEmpty;
      _passwordError = _passwordController.text.trim().isEmpty;
    });

    // Check for specific validation errors
    if (_emailError) {
      _showTopNotification(
        languageManager.isArabic
            ? 'يرجى إدخال البريد الإلكتروني'
            : 'Please enter your email address',
        isError: true,
      );
      return;
    }

    if (_passwordError) {
      _showTopNotification(
        languageManager.isArabic
            ? 'يرجى إدخال كلمة المرور'
            : 'Please enter your password',
        isError: true,
      );
      return;
    }

    // Show loading
    print('🔄 Showing loading notification...');
    _showTopNotification(
      languageManager.isArabic ? 'جاري تسجيل الدخول...' : 'Signing in...',
      isError: false,
    );

    try {
      print('📞 Calling AuthService.login()...');
      // Call login API
      final response = await AuthService().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      print('📥 Received response from AuthService');
      print('   Success: ${response.isSuccess}');
      print('   Message: ${response.msg}');

      if (response.isSuccess) {
        // Login successful
        print('✅ Login successful! Showing success message...');
        _showTopNotification(
          languageManager.isArabic
              ? 'تم تسجيل الدخول بنجاح!'
              : 'Login successful!',
          isError: false,
        );

        // Check if user came from checkout (has payment data)
        if (widget.extraData != null &&
            widget.extraData!['redirectToPayment'] == true) {
          // Navigate to payment screen with the total price
          double totalPrice = widget.extraData!['totalPrice'] ?? 0.0;
          print('💳 Redirecting to payment with total: $totalPrice');
          context.go('/payment', extra: totalPrice);
        } else {
          // Navigate to home screen after successful login
          print('🏠 Redirecting to home screen...');
          context.go('/home');
        }
      } else {
        // Login failed
        print('❌ Login failed! Showing error message...');
        print('🔍 Error code: ${response.code}');
        print('🔍 Error message: ${response.msg}');

        String errorMessage = response.msg;

        // Handle specific error cases based on status code and message
        if (response.code == 404) {
          // Email not found
          errorMessage = languageManager.isArabic
              ? 'لا يوجد حساب بهذا البريد الإلكتروني'
              : 'No account found with this email address';
        } else if (response.code == 401) {
          // Wrong password
          errorMessage = languageManager.isArabic
              ? 'كلمة المرور غير صحيحة'
              : 'Incorrect password';
        } else if (response.code == 422) {
          // Validation error - check message content
          String lowerMessage = response.msg.toLowerCase();
          if (lowerMessage.contains('email') &&
              (lowerMessage.contains('not found') ||
                  lowerMessage.contains('invalid'))) {
            errorMessage = languageManager.isArabic
                ? 'البريد الإلكتروني غير صحيح'
                : 'Invalid email address';
          } else if (lowerMessage.contains('password') ||
              lowerMessage.contains('incorrect')) {
            errorMessage = languageManager.isArabic
                ? 'كلمة المرور غير صحيحة'
                : 'Incorrect password';
          } else {
            errorMessage = languageManager.isArabic
                ? 'البيانات المدخلة غير صحيحة'
                : 'Invalid credentials';
          }
        } else if (response.code == 403) {
          // Account not verified
          errorMessage = languageManager.isArabic
              ? 'يرجى تأكيد حسابك أولاً'
              : 'Please verify your account first';
        } else if (response.code == 429) {
          // Too many attempts
          errorMessage = languageManager.isArabic
              ? 'تم تجاوز عدد المحاولات المسموح. يرجى المحاولة لاحقاً'
              : 'Too many login attempts. Please try again later';
        } else {
          // Generic error - use server message if available
          if (response.msg.isNotEmpty) {
            errorMessage = response.msg;
          } else {
            errorMessage = languageManager.isArabic
                ? 'فشل في تسجيل الدخول'
                : 'Login failed';
          }
        }

        _showTopNotification(errorMessage, isError: true);
      }
    } catch (e) {
      // Network or other error
      print('❌ Exception occurred during login: $e');
      _showTopNotification(
        languageManager.isArabic
            ? 'خطأ في الشبكة. يرجى المحاولة مرة أخرى'
            : 'Network error. Please try again',
        isError: true,
      );
    }
  }

  void _showTopNotification(String message, {bool isError = false}) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isError ? Colors.red.shade600 : const Color(0xFF123459),
              borderRadius: BorderRadius.circular(16),
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
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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

    // Auto remove after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
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
                          onChanged: (value) {
                            if (_emailError && value.trim().isNotEmpty) {
                              setState(() {
                                _emailError = false;
                              });
                            }
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _emailError ? Colors.red : Colors.grey,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _emailError ? Colors.red : Colors.grey,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _emailError
                                    ? Colors.red
                                    : Color(0xFF123459),
                              ),
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
                          onChanged: (value) {
                            if (_passwordError && value.trim().isNotEmpty) {
                              setState(() {
                                _passwordError = false;
                              });
                            }
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _passwordError
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _passwordError
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _passwordError
                                    ? Colors.red
                                    : Color(0xFF123459),
                              ),
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
                              context.go('/reset-password');
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
                          onPressed: _validateAndLogin,
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
                                      // Pass the same extra data to sign up
                                      context.go(
                                        '/signup',
                                        extra: widget.extraData,
                                      );
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

                const SizedBox(height: 30),

                // Skip Button - Simple and Modern
                Consumer<LanguageManager>(
                  builder: (context, languageManager, child) {
                    return Center(
                      child: TextButton(
                        onPressed: () => context.go('/home'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          languageManager.isArabic ? 'تخطي' : 'Skip',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20), // Extra space for keyboard
              ],
            ),
          ),
        ),
      ),
    );
  }
}
