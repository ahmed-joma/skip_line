import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isEmailValid = false;
  bool _usernameError = false;
  bool _emailError = false;
  bool _phoneError = false;
  bool _phoneLengthError = false;
  bool _cityError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;
  bool _isPasswordValid = false;

  // Address dropdown
  String? _selectedCity;
  final List<String> _saudiCities = [
    'الرياض',
    'جدة',
    'مكة المكرمة',
    'المدينة المنورة',
    'الدمام',
    'الخبر',
    'الظهران',
    'الطائف',
    'بريدة',
    'تبوك',
    'حائل',
    'الأحساء',
    'نجران',
    'جازان',
    'الباحة',
    'عرعر',
    'سكاكا',
    'القطيف',
    'ينبع',
    'أبها',
  ];

  String _getEnglishCityName(String arabicCity) {
    switch (arabicCity) {
      case 'الرياض':
        return 'Riyadh';
      case 'جدة':
        return 'Jeddah';
      case 'مكة المكرمة':
        return 'Makkah';
      case 'المدينة المنورة':
        return 'Madinah';
      case 'الدمام':
        return 'Dammam';
      case 'الخبر':
        return 'Khobar';
      case 'الظهران':
        return 'Dhahran';
      case 'الطائف':
        return 'Taif';
      case 'بريدة':
        return 'Buraydah';
      case 'تبوك':
        return 'Tabuk';
      case 'حائل':
        return 'Hail';
      case 'الأحساء':
        return 'Al Ahsa';
      case 'نجران':
        return 'Najran';
      case 'جازان':
        return 'Jazan';
      case 'الباحة':
        return 'Al Baha';
      case 'عرعر':
        return 'Arar';
      case 'سكاكا':
        return 'Sakaka';
      case 'القطيف':
        return 'Qatif';
      case 'ينبع':
        return 'Yanbu';
      case 'أبها':
        return 'Abha';
      default:
        return arabicCity;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
      _phoneError = _phoneController.text.trim().isEmpty;
      _phoneLengthError = _phoneController.text.trim().length != 9;
      _cityError = _selectedCity == null;
      _passwordError = _passwordController.text.trim().isEmpty;
      _confirmPasswordError = _confirmPasswordController.text.trim().isEmpty;
    });

    if (_usernameError ||
        _emailError ||
        _phoneError ||
        _phoneLengthError ||
        _cityError ||
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

    // Show loading notification
    _showTopNotification(
      languageManager.isArabic ? 'جاري إنشاء الحساب...' : 'Creating account...',
      isError: false,
    );

    print('🎯 ===== SIGNUP VIEW - STARTING REGISTRATION =====');
    print('📋 Form validation passed successfully!');
    print('📝 Collected form data:');
    print('   👤 Username: ${_usernameController.text.trim()}');
    print('   📧 Email: ${_emailController.text.trim()}');
    print('   📱 Phone: +966${_phoneController.text.trim()}');
    print('   🏠 Address: ${_selectedCity}');
    print('   🔒 Password: [HIDDEN]');
    print('🔄 Calling AuthService.register()...');

    try {
      // Call register API
      final result = await AuthService().register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: '+966${_phoneController.text.trim()}',
        address: _selectedCity!,
      );

      print('📥 Received response from AuthService');
      print('   Success: ${result.isSuccess}');
      print('   Message: ${result.msg}');

      if (result.isSuccess) {
        print('🎉 ===== REGISTRATION SUCCESSFUL! =====');
        print('✅ Register successful! Showing success message...');

        // Show success message
        _showTopNotification(
          languageManager.isArabic
              ? 'تم إنشاء الحساب بنجاح!'
              : 'Account created successfully!',
          isError: false,
        );

        // Navigate to verification screen
        print('🔄 Redirecting to verification screen...');
        print('🏁 ===== SIGNUP VIEW - REGISTRATION COMPLETED =====');
        context.go('/signup-verification');
      } else {
        print('❌ ===== REGISTRATION FAILED! =====');
        print('❌ Register failed! Showing error message...');

        // Check if it's an existing email error
        String errorMessage = result.msg.isNotEmpty ? result.msg : '';
        print('🔍 Error message to check: $errorMessage');
        print('🔍 Error code: ${result.code}');

        bool isExistingEmail = false;

        // Check by error code first
        if (result.code == 422) {
          print('📧 Status code 422 detected - likely validation error');
          isExistingEmail = true;
        }

        // Check by error message content
        if (!isExistingEmail && errorMessage.isNotEmpty) {
          String lowerMessage = errorMessage.toLowerCase();
          isExistingEmail =
              lowerMessage.contains('email') &&
              (lowerMessage.contains('already') ||
                  lowerMessage.contains('exists') ||
                  lowerMessage.contains('taken') ||
                  lowerMessage.contains('duplicate') ||
                  lowerMessage.contains('in use') ||
                  lowerMessage.contains('registered'));
        }

        if (isExistingEmail) {
          print('📧 Detected existing email error');
          _showTopNotification(
            languageManager.isArabic
                ? 'هذا الإيميل مستخدم مسبقاً! يرجى استخدام إيميل آخر أو تسجيل الدخول'
                : 'This email is already in use! Please use a different email or sign in',
            isError: true,
          );
        } else {
          print('❌ Other error type detected');
          _showTopNotification(
            errorMessage.isNotEmpty
                ? errorMessage
                : (languageManager.isArabic
                      ? 'فشل في إنشاء الحساب'
                      : 'Failed to create account'),
            isError: true,
          );
        }
        print('🏁 ===== SIGNUP VIEW - REGISTRATION FAILED =====');
        return; // Stop execution here, don't navigate
      }
    } catch (e) {
      print('❌ ===== REGISTRATION ERROR! =====');
      print('❌ Error during register: $e');
      _showTopNotification(
        languageManager.isArabic
            ? 'حدث خطأ أثناء إنشاء الحساب'
            : 'Error occurred during registration',
        isError: true,
      );
      print('🏁 ===== SIGNUP VIEW - REGISTRATION ERROR =====');
      return; // Stop execution here, don't navigate
    }

    // This code only runs if registration was successful
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

                  // Phone Field
                  Consumer<LanguageManager>(
                    builder: (context, languageManager, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageManager.isArabic
                                ? 'رقم الهاتف'
                                : 'Phone Number',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            maxLength: 9,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (_phoneError && value.trim().isNotEmpty) {
                                  _phoneError = false;
                                }
                                if (_phoneLengthError && value.length == 9) {
                                  _phoneLengthError = false;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 12),
                                  const Text(
                                    '🇸🇦',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '+966',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: (_phoneError || _phoneLengthError)
                                      ? Colors.red
                                      : Color(0xFF123459),
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: (_phoneError || _phoneLengthError)
                                      ? Colors.red
                                      : Color(0xFF123459),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: (_phoneError || _phoneLengthError)
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

                  // Address Field
                  Consumer<LanguageManager>(
                    builder: (context, languageManager, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageManager.isArabic ? 'المدينة' : 'City',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            value: _selectedCity,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCity = newValue;
                                if (_cityError && newValue != null) {
                                  _cityError = false;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              hintText: languageManager.isArabic
                                  ? 'اختر مدينتك'
                                  : 'Select your city',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _cityError
                                      ? Colors.red
                                      : Color(0xFF123459),
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _cityError
                                      ? Colors.red
                                      : Color(0xFF123459),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: _cityError
                                      ? Colors.red
                                      : Color(0xFF123459),
                                ),
                              ),
                            ),
                            items: _saudiCities.map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(
                                  languageManager.isArabic
                                      ? city
                                      : _getEnglishCityName(city),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
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
    );
  }
}
