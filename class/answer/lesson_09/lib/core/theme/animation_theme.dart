/// Animation-aware theme configuration
/// 
/// This file provides theme configurations optimized for animation experiences
/// with appropriate colors, typography, and component styling.
library;

import 'package:flutter/material.dart';

/// Animation-optimized theme configurations
/// 
/// Provides carefully crafted themes that enhance the animation experience
/// with appropriate color schemes, typography, and component styling.
class AnimationTheme {
  /// Private constructor
  const AnimationTheme._();

  /// Light theme optimized for animations
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      fontFamily: 'Poppins',
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(width: 2),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Text theme
      textTheme: _textTheme,

      // Page transitions theme
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Dark theme optimized for animations
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      fontFamily: 'Poppins',
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(width: 2),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Text theme
      textTheme: _textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),

      // Page transitions theme
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Light color scheme
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6366F1),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE0E7FF),
    onPrimaryContainer: Color(0xFF1E1B93),
    secondary: Color(0xFF8B5CF6),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFF3E8FF),
    onSecondaryContainer: Color(0xFF5B21B6),
    tertiary: Color(0xFF10B981),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFECFDF5),
    onTertiaryContainer: Color(0xFF064E3B),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEF2F2),
    onErrorContainer: Color(0xFF991B1B),
    background: Color(0xFFFAFAFA),
    onBackground: Color(0xFF1A1A1A),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1A1A1A),
    surfaceVariant: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF737373),
    outline: Color(0xFFD4D4D8),
    outlineVariant: Color(0xFFE4E4E7),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF1A1A1A),
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: Color(0xFF818CF8),
    surfaceTint: Color(0xFF6366F1),
  );

  /// Dark color scheme
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF818CF8),
    onPrimary: Color(0xFF1E1B93),
    primaryContainer: Color(0xFF3730A3),
    onPrimaryContainer: Color(0xFFE0E7FF),
    secondary: Color(0xFFA78BFA),
    onSecondary: Color(0xFF5B21B6),
    secondaryContainer: Color(0xFF7C3AED),
    onSecondaryContainer: Color(0xFFF3E8FF),
    tertiary: Color(0xFF34D399),
    onTertiary: Color(0xFF064E3B),
    tertiaryContainer: Color(0xFF059669),
    onTertiaryContainer: Color(0xFFECFDF5),
    error: Color(0xFFF87171),
    onError: Color(0xFF991B1B),
    errorContainer: Color(0xFFDC2626),
    onErrorContainer: Color(0xFFFEF2F2),
    background: Color(0xFF0A0A0A),
    onBackground: Color(0xFFFAFAFA),
    surface: Color(0xFF1A1A1A),
    onSurface: Color(0xFFFAFAFA),
    surfaceVariant: Color(0xFF2A2A2A),
    onSurfaceVariant: Color(0xFFA3A3A3),
    outline: Color(0xFF525252),
    outlineVariant: Color(0xFF404040),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFFAFAFA),
    onInverseSurface: Color(0xFF1A1A1A),
    inversePrimary: Color(0xFF6366F1),
    surfaceTint: Color(0xFF818CF8),
  );

  /// Typography optimized for animations
  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 57,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 36,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );

  /// Animation-specific color palette
  static const AnimationColors animationColors = AnimationColors();
}

/// Animation-specific color palette
class AnimationColors {
  const AnimationColors();

  // Gradient colors for onboarding pages
  static const Color welcomePrimary = Color(0xFF6366F1);
  static const Color welcomeSecondary = Color(0xFF8B5CF6);
  
  static const Color featuresPrimary = Color(0xFF10B981);
  static const Color featuresSecondary = Color(0xFF34D399);
  
  static const Color benefitsPrimary = Color(0xFFF59E0B);
  static const Color benefitsSecondary = Color(0xFFFBBF24);
  
  static const Color ctaPrimary = Color(0xFFEF4444);
  static const Color ctaSecondary = Color(0xFFF87171);

  // Animation state colors
  static const Color animationPlaying = Color(0xFF10B981);
  static const Color animationPaused = Color(0xFFF59E0B);
  static const Color animationError = Color(0xFFEF4444);
  static const Color animationIdle = Color(0xFF6B7280);

  // Performance indicator colors
  static const Color performanceGood = Color(0xFF10B981);
  static const Color performanceWarning = Color(0xFFF59E0B);
  static const Color performancePoor = Color(0xFFEF4444);

  // Interactive element colors
  static const Color buttonPrimary = Color(0xFF6366F1);
  static const Color buttonSecondary = Color(0xFF8B5CF6);
  static const Color buttonSuccess = Color(0xFF10B981);
  static const Color buttonWarning = Color(0xFFF59E0B);
  static const Color buttonDanger = Color(0xFFEF4444);

  // Overlay and surface colors
  static const Color overlayLight = Color(0x80FFFFFF);
  static const Color overlayDark = Color(0x80000000);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceDepressed = Color(0xFFF5F5F5);
}