import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/language_manager.dart';

class PasswordRequirementsWidget extends StatelessWidget {
  final String password;
  final bool showRequirements;

  const PasswordRequirementsWidget({
    super.key,
    required this.password,
    this.showRequirements = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showRequirements) return const SizedBox.shrink();

    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageManager.isArabic
              ? 'متطلبات كلمة المرور:'
              : 'Password Requirements:',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        _buildRequirement(
          languageManager.isArabic
              ? '8 أحرف على الأقل'
              : 'At least 8 characters',
          password.length >= 8,
        ),
        _buildRequirement(
          languageManager.isArabic
              ? 'رقم واحد على الأقل'
              : 'At least one number',
          RegExp(r'[0-9]').hasMatch(password),
        ),
        _buildRequirement(
          languageManager.isArabic
              ? 'حرف كبير واحد على الأقل'
              : 'At least one uppercase letter',
          RegExp(r'[A-Z]').hasMatch(password),
        ),
        _buildRequirement(
          languageManager.isArabic
              ? 'حرف صغير واحد على الأقل'
              : 'At least one lowercase letter',
          RegExp(r'[a-z]').hasMatch(password),
        ),
        _buildRequirement(
          languageManager.isArabic
              ? 'رمز خاص واحد على الأقل (!@#\$%^&*)'
              : 'At least one special character (!@#\$%^&*)',
          RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password),
        ),
      ],
    );
  }

  Widget _buildRequirement(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isValid ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isValid ? Colors.green : Colors.grey,
                fontWeight: isValid ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
