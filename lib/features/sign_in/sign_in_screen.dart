import 'package:flutter/material.dart';
import 'presentation/views/sign_in_view.dart';

class SignInScreen extends StatelessWidget {
  final Map<String, dynamic>? extraData;

  const SignInScreen({super.key, this.extraData});

  @override
  Widget build(BuildContext context) {
    return SignInView(extraData: extraData);
  }
}
