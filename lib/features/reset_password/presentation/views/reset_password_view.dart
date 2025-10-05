import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/constants/language_manager.dart';
import '../../../../core/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _emailError = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );

    setState(() {
      _emailError = _emailController.text.trim().isEmpty;
    });

    if (_emailError) {
      _showTopNotification(
        languageManager.isArabic
            ? 'يرجى إدخال البريد الإلكتروني'
            : 'Please enter your email',
        isError: true,
      );
      return;
    }

    // Show loading
    _showTopNotification(
      languageManager.isArabic
          ? 'جاري إرسال رمز التحقق...'
          : 'Sending verification code...',
      isError: false,
    );

    try {
      print('🎯 ===== RESET PASSWORD VIEW - STARTING SEND CODE =====');
      print('📧 User email: ${_emailController.text.trim()}');
      print('🔄 Calling AuthService.passwordSendCode()...');

      final result = await AuthService().passwordSendCode(
        _emailController.text.trim(),
      );

      print('📥 Received response from AuthService');
      print('   Success: ${result.isSuccess}');
      print('   Message: ${result.msg}');

      if (result.isSuccess) {
        print('🎉 ===== SEND CODE SUCCESSFUL! =====');
        print(
          '✅ Password reset code sent successfully! Showing success message...',
        );

        _showTopNotification(
          languageManager.isArabic
              ? 'تم إرسال رمز التحقق إلى بريدك الإلكتروني'
              : 'Verification code has been sent to your email',
          isError: false,
        );

        print('🔄 Redirecting to verification code screen...');
        print('🏁 ===== RESET PASSWORD VIEW - SEND CODE COMPLETED =====');
        context.go('/verification-code', extra: _emailController.text.trim());
      } else {
        print('❌ ===== SEND CODE FAILED! =====');
        print('❌ Failed to send password reset code! Showing error message...');

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
        print('🏁 ===== RESET PASSWORD VIEW - SEND CODE FAILED =====');
      }
    } catch (e) {
      print('❌ ===== SEND CODE ERROR! =====');
      print('❌ Error during send code: $e');

      String errorMessage;
      if (e.toString().contains('timeout') ||
          e.toString().contains('Timeout')) {
        errorMessage = languageManager.isArabic
            ? 'اتصال بطيء - يرجى المحاولة مرة أخرى أو التحقق من الإنترنت'
            : 'Slow connection - Please try again or check your internet';
      } else if (e.toString().contains('connection') ||
          e.toString().contains('Connection')) {
        errorMessage = languageManager.isArabic
            ? 'خطأ في الاتصال - يرجى التحقق من الإنترنت'
            : 'Connection error - Please check your internet';
      } else {
        errorMessage = languageManager.isArabic
            ? 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى'
            : 'Unexpected error occurred. Please try again';
      }

      _showTopNotification(errorMessage, isError: true);
      print('🏁 ===== RESET PASSWORD VIEW - SEND CODE ERROR =====');
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
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return Scaffold(
          backgroundColor: Colors.white,
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
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

                        const SizedBox(height: 50),

                        // Reset Password Title
                        Text(
                          languageManager.isArabic
                              ? 'إعادة تعيين كلمة المرور'
                              : 'Reset Password',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Description
                        Text(
                          languageManager.isArabic
                              ? 'أدخل بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور'
                              : 'Enter your email address and we\'ll send you a link to reset your password',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Email Field
                        Column(
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
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textDirection: languageManager.isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
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
                                    color: _emailError
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: _emailError
                                        ? Colors.red
                                        : Colors.grey,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return languageManager.isArabic
                                      ? 'يرجى إدخال البريد الإلكتروني'
                                      : 'Please enter your email';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return languageManager.isArabic
                                      ? 'يرجى إدخال بريد إلكتروني صحيح'
                                      : 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Confirm Button
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _handleResetPassword,
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

                        // Back to Sign In
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              languageManager.isArabic
                                  ? 'تذكرت كلمة المرور؟'
                                  : 'Remember your password?',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => context.go('/signin'),
                              child: Text(
                                languageManager.isArabic
                                    ? 'تسجيل الدخول'
                                    : 'Sign In',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF123459),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
