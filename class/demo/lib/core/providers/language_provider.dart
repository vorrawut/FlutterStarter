import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/storage_service.dart';

/// Language Provider using Riverpod
/// 
/// Demonstrates:
/// - State management with Riverpod (Lesson 13)
/// - Persistent storage (Lesson 17)
/// - Internationalization (Lesson 2)
/// - Provider lifecycle management

const String _kLanguageKey = 'selected_language';

/// Language state notifier for managing app language
class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('en')) {
    _loadSavedLanguage();
  }

  /// Load saved language from storage
  Future<void> _loadSavedLanguage() async {
    try {
      final savedLanguage = await StorageService.read(_kLanguageKey);
      if (savedLanguage != null) {
        final locale = Locale(savedLanguage);
        if (_supportedLocales.contains(locale)) {
          state = locale;
        }
      }
    } catch (e) {
      // If error loading, keep default English
      debugPrint('Error loading saved language: $e');
    }
  }

  /// Change language and persist to storage
  Future<void> changeLanguage(Locale locale) async {
    if (_supportedLocales.contains(locale) && state != locale) {
      state = locale;
      try {
        await StorageService.write(_kLanguageKey, locale.languageCode);
        debugPrint('Language changed to: ${locale.languageCode}');
      } catch (e) {
        debugPrint('Error saving language: $e');
      }
    }
  }

  /// Toggle between English and Thai
  Future<void> toggleLanguage() async {
    final newLocale = state.languageCode == 'en' 
        ? const Locale('th') 
        : const Locale('en');
    await changeLanguage(newLocale);
  }

  /// Check if current language is Thai
  bool get isThaiSelected => state.languageCode == 'th';

  /// Check if current language is English
  bool get isEnglishSelected => state.languageCode == 'en';

  /// Get current language display name
  String get currentLanguageDisplayName {
    switch (state.languageCode) {
      case 'th':
        return 'ไทย';
      case 'en':
      default:
        return 'English';
    }
  }

  /// Get supported locales
  static const List<Locale> _supportedLocales = [
    Locale('en'),
    Locale('th'),
  ];

  static List<Locale> get supportedLocales => _supportedLocales;
}

/// Language provider - exposes the language state
final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>(
  (ref) => LanguageNotifier(),
);

/// Convenience provider for checking if Thai is selected
final isThaiProvider = Provider<bool>((ref) {
  final locale = ref.watch(languageProvider);
  return locale.languageCode == 'th';
});

/// Convenience provider for checking if English is selected
final isEnglishProvider = Provider<bool>((ref) {
  final locale = ref.watch(languageProvider);
  return locale.languageCode == 'en';
});

/// Provider for getting current language display name
final currentLanguageDisplayNameProvider = Provider<String>((ref) {
  final locale = ref.watch(languageProvider);
  switch (locale.languageCode) {
    case 'th':
      return 'ไทย';
    case 'en':
    default:
      return 'English';
  }
});
