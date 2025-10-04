import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/constants/language_manager.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/auth_service.dart';

class VerificationCodeView extends StatefulWidget {
  const VerificationCodeView({super.key});

  @override
  State<VerificationCodeView> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends State<VerificationCodeView> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  int _remainingTime = 300; // 5 minutes in seconds
  bool _isTimerActive = true;
  Timer? _timer;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _startTimer();
    // Hide system UI to make screen full
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _loadUserEmail() async {
    try {
      final userData = await AuthService().getUserData();
      if (userData != null) {
        setState(() {
          _userEmail = userData.email;
        });
      }
    } catch (e) {
      print('Error loading user email: $e');
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
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
        _timer?.cancel();
      }
    });
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        // Don't auto-verify, wait for Confirm button
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
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
    print('🔄 Calling AuthService.resendVerificationCode()...');

    try {
      // Call resend API
      final result = await AuthService().resendVerificationCode();

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
        print('🔄 Timer reset to 5 minutes');
        print('🏁 ===== VERIFICATION CODE VIEW - RESEND COMPLETED =====');
      } else {
        print('❌ ===== RESEND FAILED! =====');
        print('❌ Failed to resend verification code! Showing error message...');
        _showTopNotification(
          result.msg.isNotEmpty
              ? result.msg
              : (languageManager.isArabic
                    ? 'فشل في إعادة إرسال رمز التحقق'
                    : 'Failed to resend verification code'),
          isError: true,
        );
        print('🏁 ===== VERIFICATION CODE VIEW - RESEND FAILED =====');
      }
    } catch (e) {
      print('❌ ===== RESEND ERROR! =====');
      print('❌ Error during resend: $e');
      _showTopNotification(
        languageManager.isArabic
            ? 'حدث خطأ أثناء إعادة إرسال الرمز'
            : 'Error occurred during resend',
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

  void _verifyCode(String code) async {
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );

    // Show loading notification
    _showTopNotification(
      languageManager.isArabic
          ? 'جاري التحقق من الرمز...'
          : 'Verifying code...',
      isError: false,
    );

    print('🎯 ===== VERIFICATION CODE VIEW - STARTING VERIFICATION =====');
    print('📝 Verification code entered: $code');
    print('📧 User email: $_userEmail');
    print('🔄 Calling AuthService.verifyEmail()...');

    try {
      // Call verify API
      final result = await AuthService().verifyEmail(code);

      print('📥 Received response from AuthService');
      print('   Success: ${result.isSuccess}');
      print('   Message: ${result.msg}');

      if (result.isSuccess) {
        print('🎉 ===== VERIFICATION SUCCESSFUL! =====');
        print('✅ Email verification successful! Showing success message...');

        // Show success message
        _showTopNotification(
          languageManager.isArabic
              ? 'تم إنشاء حسابك بنجاح! مرحباً بك في SkipLine'
              : 'Your account has been created successfully! Welcome to SkipLine',
          isError: false,
        );

        // Navigate to home screen after successful verification
        print('🔄 Redirecting to home screen...');
        print('🏁 ===== VERIFICATION CODE VIEW - VERIFICATION COMPLETED =====');
        context.go('/home');
      } else {
        print('❌ ===== VERIFICATION FAILED! =====');
        print('❌ Email verification failed! Showing error message...');
        _showTopNotification(
          result.msg.isNotEmpty
              ? result.msg
              : (languageManager.isArabic
                    ? 'رمز التحقق غير صحيح'
                    : 'Invalid verification code'),
          isError: true,
        );
        print('🏁 ===== VERIFICATION CODE VIEW - VERIFICATION FAILED =====');
      }
    } catch (e) {
      print('❌ ===== VERIFICATION ERROR! =====');
      print('❌ Error during verification: $e');
      _showTopNotification(
        languageManager.isArabic
            ? 'حدث خطأ أثناء التحقق'
            : 'Error occurred during verification',
        isError: true,
      );
      print('🏁 ===== VERIFICATION CODE VIEW - VERIFICATION ERROR =====');
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
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 24,
            left: 24,
            right: 24,
            bottom: 24,
          ),
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
                  languageManager.isArabic ? 'رمز التحقق' : 'Verification Code',
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
                        text: _userEmail ?? 'user@example.com',
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

                // Confirm Button
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

                // Back to Sign Up
                TextButton(
                  onPressed: () => context.go('/signup'),
                  child: Text(
                    languageManager.isArabic
                        ? 'العودة إلى التسجيل'
                        : 'Back to Sign Up',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
