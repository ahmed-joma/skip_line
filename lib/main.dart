import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/app_routers.dart';
import 'core/services/api_service.dart';
import 'core/services/network_service.dart';
import 'shared/themes/app_theme.dart';
import 'shared/constants/language_manager.dart';
import 'features/my_cart/presentation/manager/cart/cart_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);

  // Initialize Network Service with Dio
  print('🚀 Initializing Network Service...');
  NetworkService.initialize();

  // Initialize API service
  ApiService().init();

  runApp(const SkipLineApp());
}

class SkipLineApp extends StatelessWidget {
  const SkipLineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LanguageManager()..initializeLanguage(),
        ),
        BlocProvider(create: (context) => CartCubit()),
      ],
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
