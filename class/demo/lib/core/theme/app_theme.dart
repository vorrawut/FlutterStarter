import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';

/// Application Theme Configuration
/// 
/// Demonstrates:
/// - Material 3 Design System (Lesson 7: Theming Your App)
/// - Custom color schemes and typography
/// - Accessibility considerations
/// - Theme extensions for custom components
/// - Dark/Light mode support
/// - Professional theme architecture
class AppTheme {
  AppTheme._(); // Private constructor
  
  // Color Seeds for Material 3
  static const Color _primarySeed = Color(0xFF6750A4);
  // Additional seeds for future customization
  // static const Color _secondarySeed = Color(0xFF625B71);
  // static const Color _tertiarySeed = Color(0xFF7D5260);
  // static const Color _errorSeed = Color(0xFFBA1A1A);
  
  /// Light Theme Configuration
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: _primarySeed,
      brightness: Brightness.light,
    );
    
    return _buildTheme(colorScheme, Brightness.light);
  }
  
  /// Dark Theme Configuration
  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: _primarySeed,
      brightness: Brightness.dark,
    );
    
    return _buildTheme(colorScheme, Brightness.dark);
  }
  
  /// Build Theme with Shared Configuration
  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    
    return ThemeData(
      // Core Theme Properties
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      
      // Typography (Custom font: Inter)
      textTheme: _buildTextTheme(colorScheme),
      primaryTextTheme: _buildTextTheme(colorScheme),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        systemOverlayStyle: isDark 
            ? SystemUiOverlayStyle.light 
            : SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        color: colorScheme.surfaceContainer,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: const TextStyle(

            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          side: BorderSide(color: colorScheme.outline),
          textStyle: const TextStyle(

            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          textStyle: const TextStyle(

            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 6,
        highlightElevation: 12,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surfaceContainer,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
  
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
  
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // Navigation Rail Theme
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedLabelTextStyle: TextStyle(
  
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(
  
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        labelStyle: TextStyle(
  
          color: colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        backgroundColor: colorScheme.surfaceContainerHigh,
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 16,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.borderRadius),
          ),
        ),
        backgroundColor: colorScheme.surfaceContainerHigh,
      ),
      
      // Extensions for custom components
      extensions: [
        SocialThemeExtension(
          postBackgroundColor: colorScheme.surfaceContainer,
          chatBubbleColor: colorScheme.primaryContainer,
          quizCardColor: colorScheme.secondaryContainer,
          achievementColor: colorScheme.tertiaryContainer,
          onlineIndicatorColor: const Color(0xFF4CAF50),
          offlineIndicatorColor: colorScheme.outline,
        ),
      ],
    );
  }
  
  /// Build Custom Text Theme
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: TextStyle(

        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      displayMedium: TextStyle(

        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      displaySmall: TextStyle(

        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      headlineLarge: TextStyle(

        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineMedium: TextStyle(

        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineSmall: TextStyle(

        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleLarge: TextStyle(

        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleMedium: TextStyle(

        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleSmall: TextStyle(

        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      bodyLarge: TextStyle(

        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodyMedium: TextStyle(

        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      bodySmall: TextStyle(

        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
      labelLarge: TextStyle(

        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      labelMedium: TextStyle(

        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      labelSmall: TextStyle(

        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Custom Theme Extension for Social Features
/// 
/// Demonstrates:
/// - Theme extensions for custom component colors
/// - Type-safe color management
/// - Component-specific theming
@immutable
class SocialThemeExtension extends ThemeExtension<SocialThemeExtension> {
  const SocialThemeExtension({
    required this.postBackgroundColor,
    required this.chatBubbleColor,
    required this.quizCardColor,
    required this.achievementColor,
    required this.onlineIndicatorColor,
    required this.offlineIndicatorColor,
  });
  
  final Color postBackgroundColor;
  final Color chatBubbleColor;
  final Color quizCardColor;
  final Color achievementColor;
  final Color onlineIndicatorColor;
  final Color offlineIndicatorColor;
  
  @override
  SocialThemeExtension copyWith({
    Color? postBackgroundColor,
    Color? chatBubbleColor,
    Color? quizCardColor,
    Color? achievementColor,
    Color? onlineIndicatorColor,
    Color? offlineIndicatorColor,
  }) {
    return SocialThemeExtension(
      postBackgroundColor: postBackgroundColor ?? this.postBackgroundColor,
      chatBubbleColor: chatBubbleColor ?? this.chatBubbleColor,
      quizCardColor: quizCardColor ?? this.quizCardColor,
      achievementColor: achievementColor ?? this.achievementColor,
      onlineIndicatorColor: onlineIndicatorColor ?? this.onlineIndicatorColor,
      offlineIndicatorColor: offlineIndicatorColor ?? this.offlineIndicatorColor,
    );
  }
  
  @override
  SocialThemeExtension lerp(ThemeExtension<SocialThemeExtension>? other, double t) {
    if (other is! SocialThemeExtension) {
      return this;
    }
    
    return SocialThemeExtension(
      postBackgroundColor: Color.lerp(postBackgroundColor, other.postBackgroundColor, t)!,
      chatBubbleColor: Color.lerp(chatBubbleColor, other.chatBubbleColor, t)!,
      quizCardColor: Color.lerp(quizCardColor, other.quizCardColor, t)!,
      achievementColor: Color.lerp(achievementColor, other.achievementColor, t)!,
      onlineIndicatorColor: Color.lerp(onlineIndicatorColor, other.onlineIndicatorColor, t)!,
      offlineIndicatorColor: Color.lerp(offlineIndicatorColor, other.offlineIndicatorColor, t)!,
    );
  }
}

/// Theme Helper Extension
/// 
/// Demonstrates:
/// - Extension methods for easy theme access
/// - Type-safe theme property access
extension ThemeExtensions on BuildContext {
  SocialThemeExtension get socialTheme => 
      Theme.of(this).extension<SocialThemeExtension>()!;
}
