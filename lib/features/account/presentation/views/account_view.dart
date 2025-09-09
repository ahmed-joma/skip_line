import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/constants/language_manager.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final LanguageManager languageManager = LanguageManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // User Profile Section
              _buildUserProfileSection(),

              const SizedBox(height: 20),

              // Account Options List
              _buildAccountOptionsList(),

              const SizedBox(height: 30),

              // Log Out Button
              _buildLogOutButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildUserProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
          ),

          const SizedBox(width: 15),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reema',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '053324****',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Edit Icon
          GestureDetector(
            onTap: () {
              // TODO: Navigate to edit profile
            },
            child: Icon(Icons.edit, color: Colors.grey[600], size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOptionsList() {
    final List<AccountOption> options = [
      AccountOption(
        icon: Icons.shopping_bag_outlined,
        title: languageManager.isArabic ? 'الطلبات' : 'Orders',
        onTap: () {
          // TODO: Navigate to orders
        },
      ),
      AccountOption(
        icon: Icons.person_outline,
        title: languageManager.isArabic ? 'تفاصيلي' : 'My Details',
        onTap: () {
          // TODO: Navigate to my details
        },
      ),
      AccountOption(
        icon: Icons.qr_code_scanner_outlined,
        title: languageManager.isArabic ? 'مسح' : 'Scan',
        onTap: () {
          // TODO: Navigate to scan
        },
      ),
      AccountOption(
        icon: Icons.credit_card_outlined,
        title: languageManager.isArabic ? 'طرق الدفع' : 'Payment Methods',
        onTap: () {
          // TODO: Navigate to payment methods
        },
      ),
      AccountOption(
        icon: Icons.smart_toy_outlined,
        title: languageManager.isArabic ? 'المساعد الذكي' : 'Chatbot',
        onTap: () {
          // TODO: Navigate to chatbot
        },
      ),
      AccountOption(
        icon: Icons.notifications_outlined,
        title: languageManager.isArabic ? 'الإشعارات' : 'Notifications',
        onTap: () {
          // TODO: Navigate to notifications
        },
      ),
      AccountOption(
        icon: Icons.help_outline,
        title: languageManager.isArabic ? 'المساعدة' : 'Help',
        onTap: () {
          // TODO: Navigate to help
        },
      ),
      AccountOption(
        icon: Icons.info_outline,
        title: languageManager.isArabic ? 'حول' : 'About',
        onTap: () {
          // TODO: Navigate to about
        },
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: options.asMap().entries.map((entry) {
          int index = entry.key;
          AccountOption option = entry.value;

          return Column(
            children: [
              ListTile(
                leading: Icon(option.icon, color: Colors.grey[700], size: 24),
                title: Text(
                  option.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 16,
                ),
                onTap: option.onTap,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
              ),
              if (index < options.length - 1)
                Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 20,
                  endIndent: 20,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogOutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: 350,
      child: ElevatedButton(
        onPressed: () {
          context.go('/signin');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(Icons.logout, color: const Color(0xFF123459), size: 20),
            Expanded(
              child: Center(
                child: Text(
                  languageManager.isArabic ? 'تسجيل الخروج' : 'Log Out',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF123459),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40), // To balance the left icon
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(
            Icons.storefront_outlined,
            languageManager.isArabic ? 'المتجر' : 'Shop',
            false,
          ),
          _buildBottomNavItem(
            Icons.qr_code_scanner_outlined,
            languageManager.isArabic ? 'مسح' : 'Scan',
            false,
          ),
          _buildBottomNavItem(
            Icons.shopping_cart_outlined,
            languageManager.isArabic ? 'السلة' : 'Cart',
            false,
          ),
          _buildBottomNavItem(
            Icons.smart_toy_outlined,
            languageManager.isArabic ? 'المساعد' : 'Chatbot',
            false,
          ),
          _buildBottomNavItem(
            Icons.person,
            languageManager.isArabic ? 'الحساب' : 'Account',
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (label == (languageManager.isArabic ? 'المتجر' : 'Shop')) {
          context.go('/home');
        }
        // TODO: Add navigation for other items
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF123459) : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF123459) : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class AccountOption {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  AccountOption({required this.icon, required this.title, required this.onTap});
}
