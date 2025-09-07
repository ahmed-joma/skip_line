import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/utils/app_routers.dart';
import 'core/services/api_service.dart';
import 'shared/themes/app_theme.dart';
import 'shared/constants/language_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);

  // Initialize API service
  ApiService().init();

  runApp(const SkipLineApp());
}

class SkipLineApp extends StatelessWidget {
  const SkipLineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageManager()..initializeLanguage(),
      child: Consumer<LanguageManager>(
        builder: (context, languageManager, child) {
          return MaterialApp.router(
            title: 'SkipLine',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: languageManager.isArabic
                ? const Locale('ar', 'SA')
                : const Locale('en', 'US'),
            routerConfig: AppRouters.router,
          );
        },
      ),
    );
  }
}
