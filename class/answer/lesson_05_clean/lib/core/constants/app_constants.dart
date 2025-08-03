import 'package:flutter/material.dart';

/// Application-wide constants following design system principles
class AppConstants {
  // App Information
  static const String appName = 'Advanced Layout Masterclass';
  static const String fontFamily = 'Inter';

  // Spacing Scale (4pt grid system)
  static const double spaceXs = 4.0;   // 4px
  static const double spaceSm = 8.0;   // 8px
  static const double spaceMd = 12.0;  // 12px
  static const double spaceLg = 16.0;  // 16px
  static const double spaceXl = 20.0;  // 20px
  static const double space2xl = 24.0; // 24px
  static const double space3xl = 32.0; // 32px
  static const double space4xl = 40.0; // 40px
  static const double space5xl = 48.0; // 48px
  static const double space6xl = 64.0; // 64px

  // Border Radius Scale
  static const double radiusXs = 2.0;  // 2px
  static const double radiusSm = 4.0;  // 4px
  static const double radiusMd = 8.0;  // 8px
  static const double radiusLg = 12.0; // 12px
  static const double radiusXl = 16.0; // 16px
  static const double radius2xl = 24.0; // 24px
  static const double radius3xl = 32.0; // 32px

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Breakpoints for responsive design
  static const double breakpointMobile = 480.0;
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 1024.0;
  static const double breakpointLargeDesktop = 1440.0;

  // Layout Constants
  static const double maxContentWidth = 1200.0;
  static const double cardAspectRatio = 1.8;
  static const int maxGridColumns = 4;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Shadow Definitions
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 15,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get shadowXl => [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 25,
          offset: const Offset(0, 15),
        ),
      ];

  // Z-Index Constants
  static const int zIndexBase = 0;
  static const int zIndexDropdown = 1000;
  static const int zIndexModal = 2000;
  static const int zIndexTooltip = 3000;
  static const int zIndexToast = 4000;
}

/// Screen size categories for responsive design
enum ScreenSize {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Extension to get screen size from width
extension ScreenSizeExtension on double {
  ScreenSize get screenSize {
    if (this < AppConstants.breakpointMobile) return ScreenSize.mobile;
    if (this < AppConstants.breakpointTablet) return ScreenSize.tablet;
    if (this < AppConstants.breakpointDesktop) return ScreenSize.desktop;
    return ScreenSize.largeDesktop;
  }
}

/// Common string constants
class AppStrings {
  // Tab Names
  static const String businessCardsTab = 'Business Cards';
  static const String socialProfilesTab = 'Social Profiles';
  static const String teamGridTab = 'Team Grid';
  static const String contactCardsTab = 'Contact Cards';

  // Button Labels
  static const String follow = 'Follow';
  static const String following = 'Following';
  static const String message = 'Message';
  static const String layoutAnalysis = 'Layout Analysis';
  static const String clearOutput = 'Clear Output';

  // Section Headers
  static const String businessCardsHeader = 'Professional Business Cards';
  static const String businessCardsSubheader = 'Advanced layouts with complex positioning and styling';
  static const String socialProfilesHeader = 'Social Profiles';
  static const String socialProfilesSubheader = 'Dynamic layouts with staggered positioning';

  // Dialog Content
  static const String layoutInfoTitle = '🎨 Advanced Layouts';
  static const String layoutInfoContent = 
      'This app demonstrates professional Flutter layout techniques:\n\n'
      '• Complex constraint systems\n'
      '• Responsive design patterns\n'
      '• Advanced widget composition\n'
      '• Professional spacing systems\n'
      '• Performance optimization';
  static const String gotIt = 'Got it!';

  // Analysis Types
  static const String constraintsAnalysis = 'Constraints';
  static const String responsiveAnalysis = 'Responsive';
  static const String performanceAnalysis = 'Performance';

  // Placeholder Text
  static const String teamGridPlaceholder = 'Team Grid Layout';
  static const String teamGridDescription = 'Advanced grid layouts with\ndynamic content sizing';
  static const String contactCardsPlaceholder = 'Contact Cards';
  static const String contactCardsDescription = 'Interactive contact layouts with\nanimated interactions';
}