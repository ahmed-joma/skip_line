import 'package:flutter/material.dart';
import 'presentation/views/sign_up_view.dart';

class SignUpScreen extends StatelessWidget {
  final Map<String, dynamic>? extraData;

  const SignUpScreen({super.key, this.extraData});

  @override
  Widget build(BuildContext context) {
    return SignUpView(extraData: extraData);
  }
}
