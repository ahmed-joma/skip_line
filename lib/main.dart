import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF123459),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SkipLineApp());
}

class SkipLineApp extends StatelessWidget {
  const SkipLineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkipLine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF123459),
        scaffoldBackgroundColor: const Color(0xFF123459),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}
