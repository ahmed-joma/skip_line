import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/constants/language_manager.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.go('/home'),
        ),
        title: Consumer<LanguageManager>(
          builder: (context, languageManager, child) {
            return Text(
              languageManager.isArabic ? 'المساعدة' : 'Help',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        centerTitle: true,
      ),
      body: Consumer<LanguageManager>(
        builder: (context, languageManager, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeSection(languageManager.isArabic),

                const SizedBox(height: 30),

                // Quick Help Section
                _buildQuickHelpSection(languageManager.isArabic),

                const SizedBox(height: 30),

                // FAQ Section
                _buildFAQSection(languageManager.isArabic),

                const SizedBox(height: 30),

                // Contact Section
                _buildContactSection(languageManager.isArabic),

                const SizedBox(height: 30),

                // App Info Section
                _buildAppInfoSection(languageManager.isArabic),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(bool isArabic) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF123459), Color(0xFF0F2A47)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF123459).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.help_outline, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'مرحباً بك في مركز المساعدة' : 'Welcome to Help Center',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'نحن هنا لمساعدتك في استخدام تطبيق SkipLine بسهولة وأمان'
                : 'We are here to help you use SkipLine app easily and safely',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickHelpSection(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'المساعدة السريعة' : 'Quick Help',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF123459),
          ),
        ),
        const SizedBox(height: 16),
        _buildHelpCard(
          icon: Icons.qr_code_scanner,
          title: isArabic ? 'كيفية المسح' : 'How to Scan',
          description: isArabic
              ? 'اضغط على زر المسح ووجه الكاميرا نحو الباركود أو QR Code'
              : 'Tap the scan button and point camera towards barcode or QR Code',
          isArabic: isArabic,
        ),
        const SizedBox(height: 12),
        _buildHelpCard(
          icon: Icons.shopping_cart,
          title: isArabic ? 'إدارة السلة' : 'Cart Management',
          description: isArabic
              ? 'أضف المنتجات للسلة وعدل الكميات حسب حاجتك'
              : 'Add products to cart and adjust quantities as needed',
          isArabic: isArabic,
        ),
        const SizedBox(height: 12),
        _buildHelpCard(
          icon: Icons.payment,
          title: isArabic ? 'الدفع الآمن' : 'Secure Payment',
          description: isArabic
              ? 'استخدم طرق الدفع الآمنة المتاحة في التطبيق'
              : 'Use secure payment methods available in the app',
          isArabic: isArabic,
        ),
      ],
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isArabic,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF123459).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF123459), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF123459),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'الأسئلة الشائعة' : 'Frequently Asked Questions',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF123459),
          ),
        ),
        const SizedBox(height: 16),
        _buildFAQItem(
          question: isArabic
              ? 'كيف يمكنني إضافة منتج للسلة؟'
              : 'How can I add a product to cart?',
          answer: isArabic
              ? 'امسح الباركود أو QR Code للمنتج، ثم اضغط على "إضافة للسلة"'
              : 'Scan the product barcode or QR Code, then tap "Add to Cart"',
          isArabic: isArabic,
        ),
        _buildFAQItem(
          question: isArabic
              ? 'هل الدفع آمن في التطبيق؟'
              : 'Is payment secure in the app?',
          answer: isArabic
              ? 'نعم، نستخدم أحدث تقنيات التشفير لحماية بياناتك المالية'
              : 'Yes, we use latest encryption technologies to protect your financial data',
          isArabic: isArabic,
        ),
        _buildFAQItem(
          question: isArabic
              ? 'كيف يمكنني تغيير اللغة؟'
              : 'How can I change the language?',
          answer: isArabic
              ? 'اضغط على زر اللغة في أعلى الشاشة الرئيسية'
              : 'Tap the language button at the top of the home screen',
          isArabic: isArabic,
        ),
        _buildFAQItem(
          question: isArabic
              ? 'ماذا أفعل إذا لم يعمل المسح؟'
              : 'What should I do if scanning doesn\'t work?',
          answer: isArabic
              ? 'تأكد من إعطاء إذن الكاميرا وتأكد من وضوح الباركود'
              : 'Make sure camera permission is granted and barcode is clear',
          isArabic: isArabic,
        ),
      ],
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required bool isArabic,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF123459),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'تواصل معنا' : 'Contact Us',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF123459),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildContactItem(
                icon: Icons.email,
                title: isArabic ? 'البريد الإلكتروني' : 'Email',
                subtitle: 'support@skipline.com',
                isArabic: isArabic,
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                icon: Icons.phone,
                title: isArabic ? 'الهاتف' : 'Phone',
                subtitle: '+966 50 123 4567',
                isArabic: isArabic,
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                icon: Icons.access_time,
                title: isArabic ? 'ساعات العمل' : 'Working Hours',
                subtitle: isArabic ? '24/7' : '24/7',
                isArabic: isArabic,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isArabic,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF123459).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF123459), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF123459),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection(bool isArabic) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/logo.png', width: 60, height: 60),
          const SizedBox(height: 12),
          Text(
            'SkipLine',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF123459),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'الإصدار 1.0.0' : 'Version 1.0.0',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'تطبيق تسوق ذكي وسريع' : 'Smart and Fast Shopping App',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
