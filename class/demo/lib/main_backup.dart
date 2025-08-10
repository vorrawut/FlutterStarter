import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_core/firebase_core.dart'; // Temporarily disabled for demo
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/providers/language_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/storage/storage_service.dart';
// import 'firebase_options.dart'; // Temporarily disabled for demo
import 'l10n/app_localizations.dart';

/// FlutterSocial Pro - Complete Demo Application
/// 
/// This app demonstrates all concepts from the Flutter Curriculum:
/// - Phase 1: Foundation (Dart, Widgets, Layouts)
/// - Phase 2: UI Mastery (Navigation, Theming, Animations, Responsive)
/// - Phase 3: State Management (Riverpod, Bloc, Provider, setState)
/// - Phase 4: Data Integration (Dio/Retrofit, Hive/SQLite, Offline-first)
/// - Phase 5: Firebase & Cloud (Auth, Firestore, Functions, FCM)
/// - Phase 6: Production Ready (Testing, CI/CD, Error Handling, Monitoring)
///
/// Architecture: Clean Architecture with feature-based organization
/// State Management: Hybrid approach (Riverpod + Bloc + Provider + setState)
/// Real-world use case: Social learning platform for students and educators
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize local storage
  try {
    await Hive.initFlutter();
    await StorageService.initialize();
  } catch (e) {
    debugPrint('Storage initialization error: $e');
    // Continue without storage for now
  }
  
  // Initialize Firebase - Temporarily disabled for demo
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  // Run the app with Riverpod provider scope
  runApp(
    const ProviderScope(
      child: FlutterSocialProApp(),
    ),
  );
}

/// Main Application Widget
/// 
/// Demonstrates:
/// - MaterialApp.router configuration (Lesson 6: Navigation)
/// - Theme management with Material 3 (Lesson 7: Theming)
/// - Responsive design principles (Lesson 8: Responsive UI)
/// - Provider integration for global state (Lesson 11: Provider)
class FlutterSocialProApp extends ConsumerWidget {
  const FlutterSocialProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme and language providers for reactive changes
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(languageProvider);
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      // App Configuration
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme Configuration (Lesson 7: Theming Your App)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      // Navigation Configuration (Lesson 6: Navigation & Routing)
      routerConfig: router,
      
      // Localization Support (Lesson 2: Environment Setup)
      locale: locale,
      supportedLocales: LanguageNotifier.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Builder for responsive design and global scaffolds
      builder: (context, child) {
        return _ResponsiveWrapper(child: child);
      },
    );
  }
}

/// Responsive Wrapper Widget
/// 
/// Demonstrates:
/// - Responsive design patterns (Lesson 8: Responsive UI)
/// - MediaQuery best practices
/// - Adaptive layouts for different screen sizes
class _ResponsiveWrapper extends StatelessWidget {
  final Widget? child;
  
  const _ResponsiveWrapper({this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // Ensure text scaling doesn't break layouts
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }
}

/// Theme Mode Provider
/// 
/// Demonstrates:
/// - Riverpod StateNotifier (Lesson 13: Riverpod)
/// - Theme persistence
/// - Reactive UI updates
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

/// Theme Mode State Management
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }
  
  Future<void> _loadThemeMode() async {
    final savedTheme = await StorageService.getThemeMode();
    state = savedTheme;
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await StorageService.setThemeMode(mode);
  }
  
  void toggleTheme() {
    final newMode = state == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    setThemeMode(newMode);
  }
}