import 'package:flutter/material.dart';
import 'presentation/views/verification_code_view.dart';

class VerificationCodeScreen extends StatelessWidget {
  final String? userEmail;

  const VerificationCodeScreen({super.key, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return VerificationCodeView(userEmail: userEmail);
  }
}
