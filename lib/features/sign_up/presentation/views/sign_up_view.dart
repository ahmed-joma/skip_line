import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/constants/language_manager.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../shared/widgets/password_requirements_widget.dart';
import '../../../../../shared/utils/password_validator.dart';

class SignUpView extends StatefulWidget {
  final Map<String, dynamic>? extraData;

  const SignUpView({super.key, this.extraData});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isEmailValid = false;
  bool _usernameError = false;
  bool _emailError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;
  bool _isPasswordValid = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateAndSignUp() async {
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );

    setState(() {
      _usernameError = _usernameController.text.trim().isEmpty;
      _emailError = _emailController.text.trim().isEmpty;
      _passwordError = _passwordController.text.trim().isEmpty;
      _confirmPasswordError = _confirmPasswordController.text.trim().isEmpty;
    });

    if (_usernameError ||
        _emailError ||
        _passwordError ||
        _confirmPasswordError) {
      _showTopNotification(
        languageManager.isArabic
            ? 'يرجى ملء جميع الحقول المطلوبة'
            : 'Please fill in all required fields',
        isError: true,
      );
      return;
    }

    // Check if passwords match
    if (!_isPasswordValid) {
      _showTopNotification(
        languageManager.isArabic
            ? 'كلمة المرور لا تلبي المتطلبات'
            : 'Password does not meet requirements',
        isError: true,
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showTopNotification(
        languageManager.isArabic
            ? 'كلمة المرور غير متطابقة'
            : 'Passwords do not match',
        isError: true,
      );
      return;
    }

    // Simulate signup and save token
    print('Signup with email: ${_emailController.text}');

    // Save user token (simulate successful signup)
    await AuthService().saveUserToken(
      'user_token_${DateTime.now().millisecondsSinceEpoch}',
    );
    print('User token saved successfully');

    // Check if user came from checkout (has payment data)
    if (widget.extraData != null &&
        widget.extraData!['redirectToPayment'] == true) {
      // For now, navigate directly to payment (in real app, would go to verification first)
      double totalPrice = widget.extraData!['totalPrice'] ?? 0.0;
      print('Redirecting to payment with total: $totalPrice');
      context.go('/payment', extra: totalPrice);
    } else {
      // Navigate to verification code screen
      context.go('/signup-verification');
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

  void _validateEmail(String email) {
    setState(() {
      _isEmailValid = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(email);
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // App Logo
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 50),

              // Sign Up Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Consumer<LanguageManager>(
                    builder: (context, languageManager, child) {
                      return Text(
                        languageManager.isArabic ? 'إنشاء حساب' : 'Sign Up',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Consumer<LanguageManager>(
                    builder: (context, languageManager, child) {
                      return Text(
                        languageManager.isArabic
                            ? 'أدخل بياناتك للمتابعة'
                            : 'Enter your credentials to continue',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Username Field
                  Consumer<LanguageManager>(
                    builder: (context, languageManager, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageManager.isArabic
                                ? 'اسم المستخدم'
                                : 'Username',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _usernameController,
                            onChanged: (value) {
                              if (_usernameError && value.trim().isNotEmpty) {
                                setState(() {
                                  _usernameError = false;
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
                                  color: _usernameError
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _usernameError
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _usernameError
                                      ? Colors.red
                                      : Color(0xFF123459),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Email Field
                  Consumer<LanguageManager>(
                    builder: (context, languageManager, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageManager.isArabic
                                ? 'البريد الإلكتروني'
                                : 'Email',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              _validateEmail(value);
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
                              suffixIcon: _isEmailValid
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF123459),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  Consumer<LanguageManager>(
                    builder: (context, languageManager, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageManager.isArabic
                                ? 'كلمة المرور'
                                : 'Password',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            onChanged: (value) {
                              if (_passwordError && value.trim().isNotEmpty) {
                                setState(() {
                                  _passwordError = false;
                                });
                              }
                              setState(() {
                                _isPasswordValid =
                                    PasswordValidator.isValidPassword(value);
                              });
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
                                    _isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    key: ValueKey(_isPasswordVisible),
                                    color: Colors.grey,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password Field
                  Consumer<LanguageManager>(
                    builder: (context, languageManager, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageManager.isArabic
                                ? 'تأكيد كلمة المرور'
                                : 'Confirm Password',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            onChanged: (value) {
                              if (_confirmPasswordError &&
                                  value.trim().isNotEmpty) {
                                setState(() {
                                  _confirmPasswordError = false;
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
                                  color: _confirmPasswordError
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _confirmPasswordError
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _confirmPasswordError
                                      ? Colors.red
                                      : Color(0xFF123459),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    key: ValueKey(_isConfirmPasswordVisible),
                                    color: Colors.grey,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Terms and Privacy Policy
                  Consumer<LanguageManager>(
                    builder: (context, languageManager, child) {
                      return RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: languageManager.isArabic
                                  ? 'بالمتابعة، أنت توافق على '
                                  : 'By continuing you agree to our ',
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: Navigate to Terms of Service
                                  print('Terms of Service pressed');
                                },
                                child: Text(
                                  languageManager.isArabic
                                      ? 'شروط الخدمة'
                                      : 'Terms of Service',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF123459),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF123459),
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: languageManager.isArabic ? ' و ' : ' and ',
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: Navigate to Privacy Policy
                                  print('Privacy Policy pressed');
                                },
                                child: Text(
                                  languageManager.isArabic
                                      ? 'سياسة الخصوصية'
                                      : 'Privacy Policy',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF123459),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF123459),
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: languageManager.isArabic ? '.' : '.',
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password Requirements
                  PasswordRequirementsWidget(
                    password: _passwordController.text,
                    showRequirements: _passwordController.text.isNotEmpty,
                  ),

                  const SizedBox(height: 30),

                  // Sign Up Button
                  Center(
                    child: SizedBox(
                      width: 320,
                      height: 63,
                      child: ElevatedButton(
                        onPressed: _validateAndSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF123459),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Consumer<LanguageManager>(
                          builder: (context, languageManager, child) {
                            return Text(
                              languageManager.isArabic
                                  ? 'إنشاء حساب'
                                  : 'Sign Up',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Link
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
                                    ? 'لديك حساب بالفعل؟ '
                                    : 'Already have an account? ',
                              ),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    // Pass the same extra data to sign in
                                    context.go(
                                      '/signin',
                                      extra: widget.extraData,
                                    );
                                  },
                                  child: Text(
                                    languageManager.isArabic
                                        ? 'تسجيل الدخول'
                                        : 'Sign In',
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
    );
  }
}
