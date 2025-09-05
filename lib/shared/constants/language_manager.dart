import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_strings_ar.dart';
import 'app_strings_en.dart';

enum AppLanguage { arabic, english }

class LanguageManager extends ChangeNotifier {
  static const String _languageKey = 'app_language';

  AppLanguage _currentLanguage = AppLanguage.english;

  AppLanguage get currentLanguage => _currentLanguage;

  bool get isArabic => _currentLanguage == AppLanguage.arabic;
  bool get isEnglish => _currentLanguage == AppLanguage.english;

  // Get localized strings based on current language
  dynamic get strings {
    switch (_currentLanguage) {
      case AppLanguage.arabic:
        return AppStringsAr();
      case AppLanguage.english:
        return AppStringsEn();
    }
  }

  // Initialize language from storage
  Future<void> initializeLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);

    if (languageCode != null) {
      _currentLanguage = languageCode == 'ar'
          ? AppLanguage.arabic
          : AppLanguage.english;
    } else {
      // Default to English
      _currentLanguage = AppLanguage.english;
      await saveLanguage(AppLanguage.english);
    }

    notifyListeners();
  }

  // Change language
  Future<void> changeLanguage(AppLanguage language) async {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      await saveLanguage(language);
      notifyListeners();
    }
  }

  // Save language to storage
  Future<void> saveLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _languageKey,
      language == AppLanguage.arabic ? 'ar' : 'en',
    );
  }

  // Get language name
  String getLanguageName(AppLanguage language) {
    switch (language) {
      case AppLanguage.arabic:
        return AppStringsEn.arabic; // Use English name for Arabic
      case AppLanguage.english:
        return AppStringsEn.english;
    }
  }

  // Get current language name
  String get currentLanguageName => getLanguageName(_currentLanguage);

  // Toggle between languages
  Future<void> toggleLanguage() async {
    final newLanguage = _currentLanguage == AppLanguage.arabic
        ? AppLanguage.english
        : AppLanguage.arabic;
    await changeLanguage(newLanguage);
  }
}
