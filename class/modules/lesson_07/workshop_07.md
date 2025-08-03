# 🛠 Lesson 7: Theming Your App - Workshop

## 🎯 **What We're Building**

Create a **professional theming system** for our FlutterShop e-commerce app with:
- **Material 3 Design System** with dynamic color generation
- **Dark/Light Mode** with smooth transitions and persistence
- **Custom Theme Extensions** for brand-specific styling
- **Theme Management** with clean architecture patterns
- **Responsive Theming** that adapts to different contexts
- **Accessibility Features** with WCAG compliant colors

## ✅ **Expected Outcome**

A comprehensive theming system featuring:
- 🎨 **Beautiful Themes** - Material 3 with brand colors
- 🌙 **Dark Mode Support** - Complete dark theme implementation
- ⚙️ **Theme Settings** - User-customizable theme options
- 🎭 **Dynamic Colors** - Generate themes from any seed color
- 📱 **Responsive Design** - Adaptive theming for different screens
- ♿ **Accessibility** - High contrast and readable themes

## 🏗️ **Project Structure**

We'll extend our clean architecture with theming:

```
lib/
├── core/
│   ├── theme/                    # 🎨 Theme system
│   │   ├── app_theme.dart       # Main theme definitions
│   │   ├── theme_extensions.dart # Custom theme extensions
│   │   ├── color_schemes.dart   # Material 3 color schemes
│   │   └── typography.dart      # Typography definitions
│   └── constants/
│       └── design_tokens.dart   # Design system tokens
├── domain/
│   ├── entities/
│   │   └── theme_settings.dart  # Theme preference entity
│   ├── repositories/
│   │   └── theme_repository.dart # Theme repository interface
│   └── usecases/
│       ├── get_theme_settings_usecase.dart
│       └── update_theme_settings_usecase.dart
├── data/
│   ├── models/
│   │   └── theme_settings_model.dart
│   ├── datasources/
│   │   └── theme_datasource.dart
│   └── repositories/
│       └── theme_repository_impl.dart
├── presentation/
│   ├── controllers/
│   │   └── theme_controller.dart
│   ├── screens/
│   │   └── settings/theme_settings_screen.dart
│   └── widgets/
│       ├── theme_mode_selector.dart
│       ├── color_picker_widget.dart
│       └── theme_preview_card.dart
└── main.dart
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Design Tokens Foundation** ⏱️ *10 minutes*

Create centralized design tokens for consistent styling:

```dart
// lib/core/constants/design_tokens.dart
class DesignTokens {
  // Brand Colors - Your app's identity
  static const Color primarySeed = Color(0xFF6750A4); // Purple
  static const Color secondarySeed = Color(0xFF625B71); // Neutral purple
  static const Color tertiarySeed = Color(0xFF7D5260); // Warm purple
  
  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Typography Scale
  static const String primaryFont = 'SF Pro Display';
  static const String secondaryFont = 'SF Pro Text';
  
  // Spacing Scale (8pt grid system)
  static const double space4xs = 2.0;
  static const double space3xs = 4.0;
  static const double space2xs = 6.0;
  static const double spaceXs = 8.0;
  static const double spaceSm = 12.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 20.0;
  static const double spaceXl = 24.0;
  static const double space2xl = 32.0;
  static const double space3xl = 40.0;
  static const double space4xl = 48.0;
  
  // Border Radius Scale
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 20.0;
  static const double radius3xl = 24.0;
  static const double radiusFull = 9999.0;
  
  // Elevation Scale
  static const double elevationNone = 0.0;
  static const double elevationSm = 1.0;
  static const double elevationMd = 3.0;
  static const double elevationLg = 6.0;
  static const double elevationXl = 8.0;
  static const double elevation2xl = 12.0;
  static const double elevation3xl = 16.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Breakpoints for Responsive Design
  static const double breakpointMobile = 480;
  static const double breakpointTablet = 768;
  static const double breakpointDesktop = 1024;
  static const double breakpointLarge = 1440;
}
```

### **Step 2: Material 3 Color Schemes** ⏱️ *15 minutes*

Generate comprehensive color schemes using Material 3:

```dart
// lib/core/theme/color_schemes.dart
import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';

class AppColorSchemes {
  // Generate light color scheme from seed color
  static ColorScheme lightColorScheme({Color? seedColor}) {
    return ColorScheme.fromSeed(
      seedColor: seedColor ?? DesignTokens.primarySeed,
      brightness: Brightness.light,
    );
  }

  // Generate dark color scheme from seed color
  static ColorScheme darkColorScheme({Color? seedColor}) {
    return ColorScheme.fromSeed(
      seedColor: seedColor ?? DesignTokens.primarySeed,
      brightness: Brightness.dark,
    );
  }

  // High contrast light scheme for accessibility
  static ColorScheme highContrastLightColorScheme({Color? seedColor}) {
    final baseScheme = lightColorScheme(seedColor: seedColor);
    return baseScheme.copyWith(
      // Increase contrast for better accessibility
      onSurface: Colors.black,
      onBackground: Colors.black,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      outline: Colors.black54,
    );
  }

  // High contrast dark scheme for accessibility
  static ColorScheme highContrastDarkColorScheme({Color? seedColor}) {
    final baseScheme = darkColorScheme(seedColor: seedColor);
    return baseScheme.copyWith(
      // Increase contrast for better accessibility
      onSurface: Colors.white,
      onBackground: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      outline: Colors.white70,
    );
  }

  // Custom semantic colors for specific app needs
  static const Map<String, Color> semanticColors = {
    'success': DesignTokens.success,
    'warning': DesignTokens.warning,
    'info': DesignTokens.info,
    'discount': Color(0xFFE53E3E), // Red for discounts
    'free': Color(0xFF38A169), // Green for free items
    'premium': Color(0xFFD69E2E), // Gold for premium features
  };

  // Brand gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF6750A4),
      Color(0xFF8B5FBF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [
      Color(0xFF625B71),
      Color(0xFF7D7485),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
```

### **Step 3: Typography System** ⏱️ *10 minutes*

Define comprehensive typography following Material 3:

```dart
// lib/core/theme/typography.dart
import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';

class AppTypography {
  // Base font family
  static const String _primaryFont = DesignTokens.primaryFont;
  static const String _fallbackFont = 'Roboto';

  // Custom text theme with Material 3 scale
  static TextTheme textTheme = const TextTheme(
    // Display styles - Hero content
    displayLarge: TextStyle(
      fontFamily: _primaryFont,
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontFamily: _primaryFont,
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontFamily: _primaryFont,
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),

    // Headline styles - Page and section titles
    headlineLarge: TextStyle(
      fontFamily: _primaryFont,
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontFamily: _primaryFont,
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontFamily: _primaryFont,
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
    ),

    // Title styles - Card and dialog titles
    titleLarge: TextStyle(
      fontFamily: _primaryFont,
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontFamily: _primaryFont,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    titleSmall: TextStyle(
      fontFamily: _primaryFont,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10,
      height: 1.43,
    ),

    // Body styles - Main content
    bodyLarge: TextStyle(
      fontFamily: _fallbackFont,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.50,
      height: 1.50,
    ),
    bodyMedium: TextStyle(
      fontFamily: _fallbackFont,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontFamily: _fallbackFont,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.40,
      height: 1.33,
    ),

    // Label styles - Buttons and UI elements
    labelLarge: TextStyle(
      fontFamily: _fallbackFont,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontFamily: _fallbackFont,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontFamily: _fallbackFont,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50,
      height: 1.45,
    ),
  );

  // Semantic text styles for specific purposes
  static TextStyle get priceText => textTheme.titleLarge!.copyWith(
    fontWeight: FontWeight.w700,
    color: AppColorSchemes.semanticColors['success'],
  );

  static TextStyle get originalPriceText => textTheme.bodyMedium!.copyWith(
    decoration: TextDecoration.lineThrough,
    color: Colors.grey,
  );

  static TextStyle get discountText => textTheme.labelMedium!.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColorSchemes.semanticColors['discount'],
  );

  static TextStyle get buttonText => textTheme.labelLarge!.copyWith(
    fontWeight: FontWeight.w600,
  );

  static TextStyle get captionText => textTheme.bodySmall!.copyWith(
    color: Colors.grey.shade600,
  );
}
```

### **Step 4: Custom Theme Extensions** ⏱️ *15 minutes*

Create custom theme extensions for brand-specific styling:

```dart
// lib/core/theme/theme_extensions.dart
import 'package:flutter/material.dart';
import '../constants/design_tokens.dart';

// Custom spacing extension
@immutable
class SpacingThemeExtension extends ThemeExtension<SpacingThemeExtension> {
  final double space4xs;
  final double space3xs;
  final double space2xs;
  final double spaceXs;
  final double spaceSm;
  final double spaceMd;
  final double spaceLg;
  final double spaceXl;
  final double space2xl;
  final double space3xl;
  final double space4xl;

  const SpacingThemeExtension({
    required this.space4xs,
    required this.space3xs,
    required this.space2xs,
    required this.spaceXs,
    required this.spaceSm,
    required this.spaceMd,
    required this.spaceLg,
    required this.spaceXl,
    required this.space2xl,
    required this.space3xl,
    required this.space4xl,
  });

  static const SpacingThemeExtension defaultSpacing = SpacingThemeExtension(
    space4xs: DesignTokens.space4xs,
    space3xs: DesignTokens.space3xs,
    space2xs: DesignTokens.space2xs,
    spaceXs: DesignTokens.spaceXs,
    spaceSm: DesignTokens.spaceSm,
    spaceMd: DesignTokens.spaceMd,
    spaceLg: DesignTokens.spaceLg,
    spaceXl: DesignTokens.spaceXl,
    space2xl: DesignTokens.space2xl,
    space3xl: DesignTokens.space3xl,
    space4xl: DesignTokens.space4xl,
  );

  @override
  SpacingThemeExtension copyWith({
    double? space4xs,
    double? space3xs,
    double? space2xs,
    double? spaceXs,
    double? spaceSm,
    double? spaceMd,
    double? spaceLg,
    double? spaceXl,
    double? space2xl,
    double? space3xl,
    double? space4xl,
  }) {
    return SpacingThemeExtension(
      space4xs: space4xs ?? this.space4xs,
      space3xs: space3xs ?? this.space3xs,
      space2xs: space2xs ?? this.space2xs,
      spaceXs: spaceXs ?? this.spaceXs,
      spaceSm: spaceSm ?? this.spaceSm,
      spaceMd: spaceMd ?? this.spaceMd,
      spaceLg: spaceLg ?? this.spaceLg,
      spaceXl: spaceXl ?? this.spaceXl,
      space2xl: space2xl ?? this.space2xl,
      space3xl: space3xl ?? this.space3xl,
      space4xl: space4xl ?? this.space4xl,
    );
  }

  @override
  SpacingThemeExtension lerp(
    ThemeExtension<SpacingThemeExtension>? other,
    double t,
  ) {
    if (other is! SpacingThemeExtension) return this;
    return SpacingThemeExtension(
      space4xs: lerpDouble(space4xs, other.space4xs, t) ?? space4xs,
      space3xs: lerpDouble(space3xs, other.space3xs, t) ?? space3xs,
      space2xs: lerpDouble(space2xs, other.space2xs, t) ?? space2xs,
      spaceXs: lerpDouble(spaceXs, other.spaceXs, t) ?? spaceXs,
      spaceSm: lerpDouble(spaceSm, other.spaceSm, t) ?? spaceSm,
      spaceMd: lerpDouble(spaceMd, other.spaceMd, t) ?? spaceMd,
      spaceLg: lerpDouble(spaceLg, other.spaceLg, t) ?? spaceLg,
      spaceXl: lerpDouble(spaceXl, other.spaceXl, t) ?? spaceXl,
      space2xl: lerpDouble(space2xl, other.space2xl, t) ?? space2xl,
      space3xl: lerpDouble(space3xl, other.space3xl, t) ?? space3xl,
      space4xl: lerpDouble(space4xl, other.space4xl, t) ?? space4xl,
    );
  }
}

// Custom radius extension
@immutable
class RadiusThemeExtension extends ThemeExtension<RadiusThemeExtension> {
  final double radiusXs;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  final double radius2xl;
  final double radius3xl;
  final double radiusFull;

  const RadiusThemeExtension({
    required this.radiusXs,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.radius2xl,
    required this.radius3xl,
    required this.radiusFull,
  });

  static const RadiusThemeExtension defaultRadius = RadiusThemeExtension(
    radiusXs: DesignTokens.radiusXs,
    radiusSm: DesignTokens.radiusSm,
    radiusMd: DesignTokens.radiusMd,
    radiusLg: DesignTokens.radiusLg,
    radiusXl: DesignTokens.radiusXl,
    radius2xl: DesignTokens.radius2xl,
    radius3xl: DesignTokens.radius3xl,
    radiusFull: DesignTokens.radiusFull,
  );

  @override
  RadiusThemeExtension copyWith({
    double? radiusXs,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusXl,
    double? radius2xl,
    double? radius3xl,
    double? radiusFull,
  }) {
    return RadiusThemeExtension(
      radiusXs: radiusXs ?? this.radiusXs,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusXl: radiusXl ?? this.radiusXl,
      radius2xl: radius2xl ?? this.radius2xl,
      radius3xl: radius3xl ?? this.radius3xl,
      radiusFull: radiusFull ?? this.radiusFull,
    );
  }

  @override
  RadiusThemeExtension lerp(
    ThemeExtension<RadiusThemeExtension>? other,
    double t,
  ) {
    if (other is! RadiusThemeExtension) return this;
    return RadiusThemeExtension(
      radiusXs: lerpDouble(radiusXs, other.radiusXs, t) ?? radiusXs,
      radiusSm: lerpDouble(radiusSm, other.radiusSm, t) ?? radiusSm,
      radiusMd: lerpDouble(radiusMd, other.radiusMd, t) ?? radiusMd,
      radiusLg: lerpDouble(radiusLg, other.radiusLg, t) ?? radiusLg,
      radiusXl: lerpDouble(radiusXl, other.radiusXl, t) ?? radiusXl,
      radius2xl: lerpDouble(radius2xl, other.radius2xl, t) ?? radius2xl,
      radius3xl: lerpDouble(radius3xl, other.radius3xl, t) ?? radius3xl,
      radiusFull: lerpDouble(radiusFull, other.radiusFull, t) ?? radiusFull,
    );
  }
}

// E-commerce specific theme extension
@immutable
class EcommerceThemeExtension extends ThemeExtension<EcommerceThemeExtension> {
  final Color successColor;
  final Color warningColor;
  final Color errorColor;
  final Color infoColor;
  final Color discountColor;
  final Color freeColor;
  final Color premiumColor;
  final LinearGradient primaryGradient;
  final LinearGradient secondaryGradient;

  const EcommerceThemeExtension({
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
    required this.infoColor,
    required this.discountColor,
    required this.freeColor,
    required this.premiumColor,
    required this.primaryGradient,
    required this.secondaryGradient,
  });

  static const EcommerceThemeExtension defaultEcommerce = EcommerceThemeExtension(
    successColor: DesignTokens.success,
    warningColor: DesignTokens.warning,
    errorColor: Color(0xFFD32F2F),
    infoColor: DesignTokens.info,
    discountColor: Color(0xFFE53E3E),
    freeColor: Color(0xFF38A169),
    premiumColor: Color(0xFFD69E2E),
    primaryGradient: AppColorSchemes.primaryGradient,
    secondaryGradient: AppColorSchemes.secondaryGradient,
  );

  @override
  EcommerceThemeExtension copyWith({
    Color? successColor,
    Color? warningColor,
    Color? errorColor,
    Color? infoColor,
    Color? discountColor,
    Color? freeColor,
    Color? premiumColor,
    LinearGradient? primaryGradient,
    LinearGradient? secondaryGradient,
  }) {
    return EcommerceThemeExtension(
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      errorColor: errorColor ?? this.errorColor,
      infoColor: infoColor ?? this.infoColor,
      discountColor: discountColor ?? this.discountColor,
      freeColor: freeColor ?? this.freeColor,
      premiumColor: premiumColor ?? this.premiumColor,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
    );
  }

  @override
  EcommerceThemeExtension lerp(
    ThemeExtension<EcommerceThemeExtension>? other,
    double t,
  ) {
    if (other is! EcommerceThemeExtension) return this;
    return EcommerceThemeExtension(
      successColor: Color.lerp(successColor, other.successColor, t) ?? successColor,
      warningColor: Color.lerp(warningColor, other.warningColor, t) ?? warningColor,
      errorColor: Color.lerp(errorColor, other.errorColor, t) ?? errorColor,
      infoColor: Color.lerp(infoColor, other.infoColor, t) ?? infoColor,
      discountColor: Color.lerp(discountColor, other.discountColor, t) ?? discountColor,
      freeColor: Color.lerp(freeColor, other.freeColor, t) ?? freeColor,
      premiumColor: Color.lerp(premiumColor, other.premiumColor, t) ?? premiumColor,
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t) ?? primaryGradient,
      secondaryGradient: LinearGradient.lerp(secondaryGradient, other.secondaryGradient, t) ?? secondaryGradient,
    );
  }
}

// Extension helper to easily access custom themes
extension ThemeExtensions on ThemeData {
  SpacingThemeExtension get spacing => 
      extension<SpacingThemeExtension>() ?? SpacingThemeExtension.defaultSpacing;
  
  RadiusThemeExtension get radius => 
      extension<RadiusThemeExtension>() ?? RadiusThemeExtension.defaultRadius;
  
  EcommerceThemeExtension get ecommerce => 
      extension<EcommerceThemeExtension>() ?? EcommerceThemeExtension.defaultEcommerce;
}
```

### **Step 5: Main Theme Configuration** ⏱️ *20 minutes*

Create the main theme builder with comprehensive styling:

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_schemes.dart';
import 'typography.dart';
import 'theme_extensions.dart';
import '../constants/design_tokens.dart';

class AppTheme {
  // Generate light theme from seed color
  static ThemeData light({Color? seedColor}) {
    final colorScheme = AppColorSchemes.lightColorScheme(seedColor: seedColor);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      fontFamily: DesignTokens.primaryFont,
      
      // System UI styling
      appBarTheme: _buildAppBarTheme(colorScheme),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(colorScheme),
      navigationDrawerTheme: _buildNavigationDrawerTheme(colorScheme),
      
      // Button themes
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      filledButtonTheme: _buildFilledButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      
      // Input themes
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      
      // Container themes
      cardTheme: _buildCardTheme(colorScheme),
      dialogTheme: _buildDialogTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      
      // Feedback themes
      snackBarTheme: _buildSnackBarTheme(colorScheme),
      
      // List themes
      listTileTheme: _buildListTileTheme(colorScheme),
      
      // Icon theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: DesignTokens.elevationMd,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        ),
      ),
      
      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceVariant;
        }),
      ),
      
      // Custom extensions
      extensions: const [
        SpacingThemeExtension.defaultSpacing,
        RadiusThemeExtension.defaultRadius,
        EcommerceThemeExtension.defaultEcommerce,
      ],
    );
  }

  // Generate dark theme from seed color
  static ThemeData dark({Color? seedColor}) {
    final colorScheme = AppColorSchemes.darkColorScheme(seedColor: seedColor);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      fontFamily: DesignTokens.primaryFont,
      
      // System UI styling - Dark adaptations
      appBarTheme: _buildAppBarTheme(colorScheme),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(colorScheme),
      navigationDrawerTheme: _buildNavigationDrawerTheme(colorScheme),
      
      // Button themes
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      filledButtonTheme: _buildFilledButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      
      // Input themes
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      
      // Container themes
      cardTheme: _buildCardTheme(colorScheme),
      dialogTheme: _buildDialogTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      
      // Feedback themes
      snackBarTheme: _buildSnackBarTheme(colorScheme),
      
      // List themes
      listTileTheme: _buildListTileTheme(colorScheme),
      
      // Icon theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: DesignTokens.elevationMd,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        ),
      ),
      
      // Switch theme for dark mode
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceVariant;
        }),
      ),
      
      // Custom extensions
      extensions: const [
        SpacingThemeExtension.defaultSpacing,
        RadiusThemeExtension.defaultRadius,
        EcommerceThemeExtension.defaultEcommerce,
      ],
    );
  }

  // High contrast themes for accessibility
  static ThemeData highContrastLight({Color? seedColor}) {
    final colorScheme = AppColorSchemes.highContrastLightColorScheme(
      seedColor: seedColor,
    );
    
    return light(seedColor: seedColor).copyWith(
      colorScheme: colorScheme,
      // Enhanced contrast for accessibility
      dividerColor: Colors.black,
      cardTheme: _buildCardTheme(colorScheme).copyWith(
        shadowColor: Colors.black54,
        elevation: DesignTokens.elevationLg,
      ),
    );
  }

  static ThemeData highContrastDark({Color? seedColor}) {
    final colorScheme = AppColorSchemes.highContrastDarkColorScheme(
      seedColor: seedColor,
    );
    
    return dark(seedColor: seedColor).copyWith(
      colorScheme: colorScheme,
      // Enhanced contrast for accessibility
      dividerColor: Colors.white,
      cardTheme: _buildCardTheme(colorScheme).copyWith(
        shadowColor: Colors.white24,
        elevation: DesignTokens.elevationLg,
      ),
    );
  }

  // Helper methods for building component themes

  static AppBarTheme _buildAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: DesignTokens.elevationSm,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: colorScheme.brightness == Brightness.light 
            ? Brightness.dark 
            : Brightness.light,
        systemNavigationBarColor: colorScheme.surface,
        systemNavigationBarIconBrightness: colorScheme.brightness == Brightness.light 
            ? Brightness.dark 
            : Brightness.light,
      ),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme(
    ColorScheme colorScheme,
  ) {
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: DesignTokens.elevationMd,
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      selectedLabelStyle: AppTypography.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.textTheme.labelMedium,
    );
  }

  static NavigationDrawerThemeData _buildNavigationDrawerTheme(
    ColorScheme colorScheme,
  ) {
    return NavigationDrawerThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      elevation: DesignTokens.elevationLg,
      labelTextStyle: MaterialStateProperty.all(
        AppTypography.textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: DesignTokens.elevationSm,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: AppTypography.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space2xl,
          vertical: DesignTokens.spaceLg,
        ),
      ),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme(
    ColorScheme colorScheme,
  ) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: AppTypography.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space2xl,
          vertical: DesignTokens.spaceLg,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outline),
        textStyle: AppTypography.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.space2xl,
          vertical: DesignTokens.spaceLg,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: AppTypography.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceLg,
          vertical: DesignTokens.spaceMd,
        ),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme colorScheme,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceLg,
        vertical: DesignTokens.spaceLg,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      labelStyle: AppTypography.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      hintStyle: AppTypography.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static CardTheme _buildCardTheme(ColorScheme colorScheme) {
    return CardTheme(
      elevation: DesignTokens.elevationSm,
      color: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(DesignTokens.spaceXs),
    );
  }

  static DialogTheme _buildDialogTheme(ColorScheme colorScheme) {
    return DialogTheme(
      elevation: DesignTokens.elevationXl,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
      ),
      titleTextStyle: AppTypography.textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
      ),
      contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      elevation: DesignTokens.elevationXl,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(DesignTokens.radius2xl),
          topRight: Radius.circular(DesignTokens.radius2xl),
        ),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  static SnackBarThemeData _buildSnackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      elevation: DesignTokens.elevationMd,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onInverseSurface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(DesignTokens.spaceLg),
    );
  }

  static ListTileThemeData _buildListTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceLg,
        vertical: DesignTokens.spaceXs,
      ),
      titleTextStyle: AppTypography.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      subtitleTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      leadingAndTrailingTextStyle: AppTypography.textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      iconColor: colorScheme.onSurfaceVariant,
    );
  }
}
```

*This comprehensive implementation provides a complete Material 3 theming system. Continue with the remaining steps to build the theme management architecture...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_07

# Install dependencies
flutter pub get

# Run the app
flutter run

# Test theme switching
# 1. Open app settings
# 2. Navigate to theme options
# 3. Switch between light/dark modes
# 4. Try different seed colors
# 5. Test accessibility features
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **Material 3 Implementation** - Complete design system integration
- **Theme Architecture** - Clean, maintainable theme structure
- **Dynamic Theming** - Color generation and customization
- **Accessibility** - WCAG compliant color schemes
- **State Management** - Theme state with clean architecture
- **Performance** - Optimized theme switching

**Ready to create beautiful, accessible themes? 🎨✨**