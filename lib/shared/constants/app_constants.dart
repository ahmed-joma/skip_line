class AppConstants {
  // App Info
  static const String appName = 'SkipLine';
  static const String appVersion = '1.0.0';

  // Colors
  static const int primaryColorValue = 0xFF123459;

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // API
  static const String baseUrl = 'https://api.skipline.com';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String isFirstTimeKey = 'is_first_time';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'app_language';

  // Supported Languages
  static const List<String> supportedLanguages = ['en', 'ar'];
  static const String defaultLanguage = 'en';
}
