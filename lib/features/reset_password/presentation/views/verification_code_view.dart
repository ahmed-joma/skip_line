import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../shared/constants/language_manager.dart';
import '../../../../shared/widgets/password_requirements_widget.dart';
import '../../../../shared/utils/password_validator.dart';
import '../../../../core/services/auth_service.dart';

class VerificationCodeView extends StatefulWidget {
  final String? userEmail;

  const VerificationCodeView({super.key, this.userEmail});

  @override
  State<VerificationCodeView> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends State<VerificationCodeView> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _userEmail = ''; // Store email from previous screen

  int _remainingTime = 300; // 5 minutes in seconds
  bool _isTimerActive = true;
  bool _isCodeVerified = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _newPasswordError = false;
  bool _confirmPasswordError = false;
  bool _isNewPasswordValid = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _loadEmail();
  }

  void _loadEmail() {
    // استخدام البريد الإلكتروني المرسل من الصفحة السابقة
    if (widget.userEmail != null && widget.userEmail!.isNotEmpty) {
      _userEmail = widget.userEmail!;
    } else {
      // إذا لم يتم تمرير البريد الإلكتروني، استخدم placeholder
      _userEmail = 'user@example.com';
    }
    print('📧 Loaded email for password reset: $_userEmail');
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel(); // أوقف أي تايمر شغال قبل ما تبدأ جديد
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _isTimerActive = false;
        });
        timer.cancel();
      }
    });
  }

  void _resendCode() async {
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );

    // Show loading notification
    _showTopNotification(
      languageManager.isArabic
          ? 'جاري إعادة إرسال الرمز...'
          : 'Resending verification code...',
      isError: false,
    );

    print('🎯 ===== VERIFICATION CODE VIEW - STARTING RESEND =====');
    print('📧 User email: $_userEmail');
    print('🔄 Calling AuthService.passwordSendCode()...');

    try {
      // Call resend API
      final result = await AuthService().passwordSendCode(_userEmail);

      print('📥 Received response from AuthService');
      print('   Success: ${result.isSuccess}');
      print('   Message: ${result.msg}');

      if (result.isSuccess) {
        print('🎉 ===== RESEND SUCCESSFUL! =====');
        print(
          '✅ Verification code resent successfully! Showing success message...',
        );

        // Show success message
        _showTopNotification(
          languageManager.isArabic
              ? 'تم إعادة إرسال رمز التحقق بنجاح!'
              : 'Verification code resent successfully!',
          isError: false,
        );

        // Reset timer
        setState(() {
          _remainingTime = 300;
          _isTimerActive = true;
        });
        _startTimer();

        print('🏁 ===== VERIFICATION CODE VIEW - RESEND COMPLETED =====');
      } else {
        print('❌ ===== RESEND FAILED! =====');
        print('❌ Failed to resend verification code! Showing error message...');

        String errorMessage = result.msg;

        // Handle specific error cases
        if (result.code == 404) {
          errorMessage = languageManager.isArabic
              ? 'لا يوجد مستخدم بهذا البريد الإلكتروني'
              : 'No user found with this email address';
        } else if (result.code == 422) {
          errorMessage = languageManager.isArabic
              ? 'البريد الإلكتروني غير صحيح'
              : 'Invalid email address';
        }

        _showTopNotification(errorMessage, isError: true);
        print('🏁 ===== VERIFICATION CODE VIEW - RESEND FAILED =====');
      }
    } catch (e) {
      print('❌ ===== RESEND ERROR! =====');
      print('❌ Error during resend: $e');
      _showTopNotification(
        languageManager.isArabic
            ? 'حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى'
            : 'Connection error. Please try again',
        isError: true,
      );
      print('🏁 ===== VERIFICATION CODE VIEW - RESEND ERROR =====');
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        // Don't auto-verify, wait for Confirm button
      }
    } else if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyCode(String code) {
    setState(() {
      _isCodeVerified = true;
      _isTimerActive = false; // Stop the timer
    });

    // Cancel the timer
    _timer?.cancel();

    _showTopNotification(
      Provider.of<LanguageManager>(context, listen: false).isArabic
          ? 'تم التحقق من الرمز بنجاح'
          : 'Code verified successfully',
      isError: false,
    );
  }

  void _changePassword() async {
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );

    setState(() {
      _newPasswordError = _newPasswordController.text.trim().isEmpty;
      _confirmPasswordError = _confirmPasswordController.text.trim().isEmpty;
    });

    if (_newPasswordError || _confirmPasswordError) {
      _showTopNotification(
        languageManager.isArabic
            ? 'يرجى ملء جميع الحقول المطلوبة'
            : 'Please fill in all required fields',
        isError: true,
      );
      return;
    }

    if (!_isNewPasswordValid) {
      _showTopNotification(
        languageManager.isArabic
            ? 'كلمة المرور لا تلبي المتطلبات'
            : 'Password does not meet requirements',
        isError: true,
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showTopNotification(
        languageManager.isArabic
            ? 'كلمة المرور غير متطابقة'
            : 'Passwords do not match',
        isError: true,
      );
      return;
    }

    // Show loading
    _showTopNotification(
      languageManager.isArabic
          ? 'جاري تغيير كلمة المرور...'
          : 'Changing password...',
      isError: false,
    );

    try {
      print('🎯 ===== VERIFICATION CODE VIEW - STARTING PASSWORD RESET =====');
      print('📧 User email: $_userEmail');
      String code = _controllers.map((controller) => controller.text).join();
      print('🔢 Verification code: $code');
      print('🔄 Calling AuthService.passwordReset()...');

      final result = await AuthService().passwordReset(
        email: _userEmail,
        code: code,
        password: _newPasswordController.text.trim(),
        passwordConfirmation: _confirmPasswordController.text.trim(),
      );

      print('📥 Received response from AuthService');
      print('   Success: ${result.isSuccess}');
      print('   Message: ${result.msg}');

      if (result.isSuccess) {
        print('🎉 ===== PASSWORD RESET SUCCESSFUL! =====');
        print('✅ Password reset successfully! Showing success message...');

        _showTopNotification(
          languageManager.isArabic
              ? 'تم تغيير كلمة المرور بنجاح'
              : 'Password changed successfully',
          isError: false,
        );

        print('🔄 Redirecting to sign in screen...');
        print(
          '🏁 ===== VERIFICATION CODE VIEW - PASSWORD RESET COMPLETED =====',
        );
        // Navigate to sign in screen after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          context.go('/signin');
        });
      } else {
        print('❌ ===== PASSWORD RESET FAILED! =====');
        print('❌ Failed to reset password! Showing error message...');

        String errorMessage = result.msg;

        // Handle specific error cases
        if (result.code == 422) {
          // Check for specific validation errors
          String lowerMessage = result.msg.toLowerCase();
          if (lowerMessage.contains('code') ||
              lowerMessage.contains('verification')) {
            if (lowerMessage.contains('invalid') ||
                lowerMessage.contains('incorrect')) {
              errorMessage = languageManager.isArabic
                  ? 'رمز التحقق غير صحيح'
                  : 'Invalid verification code';
            } else if (lowerMessage.contains('expired') ||
                lowerMessage.contains('expire')) {
              errorMessage = languageManager.isArabic
                  ? 'رمز التحقق منتهي الصلاحية'
                  : 'Verification code has expired';
            } else {
              errorMessage = languageManager.isArabic
                  ? 'رمز التحقق غير صحيح أو منتهي الصلاحية'
                  : 'Verification code is invalid or expired';
            }
          } else if (lowerMessage.contains('password')) {
            errorMessage = languageManager.isArabic
                ? 'كلمة المرور لا تلبي المتطلبات'
                : 'Password does not meet requirements';
          } else if (lowerMessage.contains('email')) {
            errorMessage = languageManager.isArabic
                ? 'البريد الإلكتروني غير صحيح'
                : 'Invalid email address';
          } else {
            errorMessage = languageManager.isArabic
                ? 'رمز التحقق غير صحيح أو منتهي الصلاحية'
                : 'Verification code is invalid or expired';
          }
        } else if (result.code == 400) {
          errorMessage = languageManager.isArabic
              ? 'رمز التحقق غير صحيح'
              : 'Invalid verification code';
        } else if (result.code == 404) {
          errorMessage = languageManager.isArabic
              ? 'لم يتم العثور على رمز التحقق'
              : 'Verification code not found';
        } else if (result.code == 429) {
          errorMessage = languageManager.isArabic
              ? 'تم تجاوز عدد المحاولات المسموح. يرجى المحاولة لاحقاً'
              : 'Too many attempts. Please try again later';
        } else {
          // Generic error - use server message if available
          if (result.msg.isNotEmpty) {
            errorMessage = result.msg;
          } else {
            errorMessage = languageManager.isArabic
                ? 'فشل في تغيير كلمة المرور'
                : 'Failed to change password';
          }
        }

        _showTopNotification(errorMessage, isError: true);
        print('🏁 ===== VERIFICATION CODE VIEW - PASSWORD RESET FAILED =====');
      }
    } catch (e) {
      print('❌ ===== PASSWORD RESET ERROR! =====');
      print('❌ Error during password reset: $e');
      _showTopNotification(
        languageManager.isArabic
            ? 'حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى'
            : 'Connection error. Please try again',
        isError: true,
      );
      print('🏁 ===== VERIFICATION CODE VIEW - PASSWORD RESET ERROR =====');
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
    final languageManager = Provider.of<LanguageManager>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF0F5),
              Color(0xFFF0F8FF),
              Color(0xFFF0FFF0),
              Color(0xFFFFF8DC),
              Color(0xFFF5F0FF),
              Colors.white,
              Colors.white,
            ],
            stops: [0.0, 0.05, 0.1, 0.15, 0.2, 0.25, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    48,
              ),
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
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF123459),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    languageManager.isArabic
                        ? 'رمز التحقق'
                        : 'Verification Code',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      children: [
                        TextSpan(
                          text: languageManager.isArabic
                              ? 'أرسلنا لك رمز التحقق على '
                              : "We've sent you the verification code on ",
                        ),
                        TextSpan(
                          text: _userEmail,
                          style: const TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF123459),
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFF123459),
                          ),
                        ),
                        TextSpan(
                          text: languageManager.isArabic
                              ? '\n\nإذا لم تستلم الرمز، تحقق من مجلد الرسائل المزعجة أو اضغط على "إعادة الإرسال"'
                              : '\n\nIf you didn\'t receive the code, check your spam folder or tap "Resend"',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Code Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 60,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            counterText: '',
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
                          onChanged: (value) => _onDigitChanged(value, index),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),

                  // Timer
                  if (_isTimerActive)
                    Text(
                      languageManager.isArabic
                          ? 'إعادة الإرسال متاحة خلال: ${_formatTime(_remainingTime)}'
                          : 'Resend available in: ${_formatTime(_remainingTime)}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  else
                    TextButton(
                      onPressed: _resendCode,
                      child: Text(
                        languageManager.isArabic
                            ? 'إعادة إرسال الرمز'
                            : 'Resend Code',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF123459),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),

                  // Confirm Button (only show when code is not verified)
                  if (!_isCodeVerified)
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          String code = _controllers
                              .map((controller) => controller.text)
                              .join();
                          if (code.length == 4) {
                            _verifyCode(code);
                          } else {
                            _showTopNotification(
                              languageManager.isArabic
                                  ? 'يرجى إدخال الرمز كاملاً'
                                  : 'Please enter the complete code',
                              isError: true,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF123459),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          languageManager.isArabic ? 'تأكيد' : 'Confirm',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // New Password Fields (shown after code verification)
                  if (_isCodeVerified) ...[
                    // New Password Field
                    Consumer<LanguageManager>(
                      builder: (context, languageManager, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              languageManager.isArabic
                                  ? 'كلمة المرور الجديدة'
                                  : 'New Password',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _newPasswordController,
                              obscureText: !_isNewPasswordVisible,
                              onChanged: (value) {
                                if (_newPasswordError &&
                                    value.trim().isNotEmpty) {
                                  setState(() {
                                    _newPasswordError = false;
                                  });
                                }
                                setState(() {
                                  _isNewPasswordValid =
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
                                    color: _newPasswordError
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: _newPasswordError
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: _newPasswordError
                                        ? Colors.red
                                        : Color(0xFF123459),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      _isNewPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      key: ValueKey(_isNewPasswordVisible),
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isNewPasswordVisible =
                                          !_isNewPasswordVisible;
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

                    // Password Requirements
                    PasswordRequirementsWidget(
                      password: _newPasswordController.text,
                      showRequirements: _newPasswordController.text.isNotEmpty,
                    ),

                    const SizedBox(height: 30),

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

                    const SizedBox(height: 30),

                    // Change Password Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF123459),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          languageManager.isArabic
                              ? 'تغيير كلمة المرور'
                              : 'Change Password',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],

                  // Back to Sign In
                  TextButton(
                    onPressed: () => context.go('/signin'),
                    child: Text(
                      languageManager.isArabic
                          ? 'تذكرت كلمة المرور؟ تسجيل الدخول'
                          : 'Remember your password? Sign In',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
