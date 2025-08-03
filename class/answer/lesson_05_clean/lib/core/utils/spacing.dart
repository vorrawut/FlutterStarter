import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Utility widgets for consistent spacing throughout the app
class Spacing {
  /// Vertical spacing widgets
  static const Widget verticalXs = SizedBox(height: AppConstants.spaceXs);
  static const Widget verticalSm = SizedBox(height: AppConstants.spaceSm);
  static const Widget verticalMd = SizedBox(height: AppConstants.spaceMd);
  static const Widget verticalLg = SizedBox(height: AppConstants.spaceLg);
  static const Widget verticalXl = SizedBox(height: AppConstants.spaceXl);
  static const Widget vertical2xl = SizedBox(height: AppConstants.space2xl);
  static const Widget vertical3xl = SizedBox(height: AppConstants.space3xl);
  static const Widget vertical4xl = SizedBox(height: AppConstants.space4xl);
  static const Widget vertical5xl = SizedBox(height: AppConstants.space5xl);
  static const Widget vertical6xl = SizedBox(height: AppConstants.space6xl);

  /// Horizontal spacing widgets
  static const Widget horizontalXs = SizedBox(width: AppConstants.spaceXs);
  static const Widget horizontalSm = SizedBox(width: AppConstants.spaceSm);
  static const Widget horizontalMd = SizedBox(width: AppConstants.spaceMd);
  static const Widget horizontalLg = SizedBox(width: AppConstants.spaceLg);
  static const Widget horizontalXl = SizedBox(width: AppConstants.spaceXl);
  static const Widget horizontal2xl = SizedBox(width: AppConstants.space2xl);
  static const Widget horizontal3xl = SizedBox(width: AppConstants.space3xl);
  static const Widget horizontal4xl = SizedBox(width: AppConstants.space4xl);
  static const Widget horizontal5xl = SizedBox(width: AppConstants.space5xl);
  static const Widget horizontal6xl = SizedBox(width: AppConstants.space6xl);

  /// Custom spacing widgets
  static Widget vertical(double height) => SizedBox(height: height);
  static Widget horizontal(double width) => SizedBox(width: width);

  /// Responsive spacing that adapts to screen size
  static Widget responsiveVertical(BuildContext context, {
    double mobile = AppConstants.spaceLg,
    double tablet = AppConstants.spaceXl,
    double desktop = AppConstants.space2xl,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenSize = screenWidth.screenSize;

    switch (screenSize) {
      case ScreenSize.mobile:
        return SizedBox(height: mobile);
      case ScreenSize.tablet:
        return SizedBox(height: tablet);
      case ScreenSize.desktop:
      case ScreenSize.largeDesktop:
        return SizedBox(height: desktop);
    }
  }

  static Widget responsiveHorizontal(BuildContext context, {
    double mobile = AppConstants.spaceLg,
    double tablet = AppConstants.spaceXl,
    double desktop = AppConstants.space2xl,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenSize = screenWidth.screenSize;

    switch (screenSize) {
      case ScreenSize.mobile:
        return SizedBox(width: mobile);
      case ScreenSize.tablet:
        return SizedBox(width: tablet);
      case ScreenSize.desktop:
      case ScreenSize.largeDesktop:
        return SizedBox(width: desktop);
    }
  }
}

/// Extension on EdgeInsets for consistent padding
extension AppPadding on EdgeInsets {
  /// All sides padding
  static const EdgeInsets allXs = EdgeInsets.all(AppConstants.spaceXs);
  static const EdgeInsets allSm = EdgeInsets.all(AppConstants.spaceSm);
  static const EdgeInsets allMd = EdgeInsets.all(AppConstants.spaceMd);
  static const EdgeInsets allLg = EdgeInsets.all(AppConstants.spaceLg);
  static const EdgeInsets allXl = EdgeInsets.all(AppConstants.spaceXl);
  static const EdgeInsets all2xl = EdgeInsets.all(AppConstants.space2xl);
  static const EdgeInsets all3xl = EdgeInsets.all(AppConstants.space3xl);

  /// Symmetric padding
  static const EdgeInsets symmetricHorizontalXs = EdgeInsets.symmetric(horizontal: AppConstants.spaceXs);
  static const EdgeInsets symmetricHorizontalSm = EdgeInsets.symmetric(horizontal: AppConstants.spaceSm);
  static const EdgeInsets symmetricHorizontalMd = EdgeInsets.symmetric(horizontal: AppConstants.spaceMd);
  static const EdgeInsets symmetricHorizontalLg = EdgeInsets.symmetric(horizontal: AppConstants.spaceLg);
  static const EdgeInsets symmetricHorizontalXl = EdgeInsets.symmetric(horizontal: AppConstants.spaceXl);
  static const EdgeInsets symmetricHorizontal2xl = EdgeInsets.symmetric(horizontal: AppConstants.space2xl);

  static const EdgeInsets symmetricVerticalXs = EdgeInsets.symmetric(vertical: AppConstants.spaceXs);
  static const EdgeInsets symmetricVerticalSm = EdgeInsets.symmetric(vertical: AppConstants.spaceSm);
  static const EdgeInsets symmetricVerticalMd = EdgeInsets.symmetric(vertical: AppConstants.spaceMd);
  static const EdgeInsets symmetricVerticalLg = EdgeInsets.symmetric(vertical: AppConstants.spaceLg);
  static const EdgeInsets symmetricVerticalXl = EdgeInsets.symmetric(vertical: AppConstants.spaceXl);
  static const EdgeInsets symmetricVertical2xl = EdgeInsets.symmetric(vertical: AppConstants.space2xl);

  /// Only specific sides
  static const EdgeInsets onlyTop = EdgeInsets.only(top: AppConstants.spaceLg);
  static const EdgeInsets onlyBottom = EdgeInsets.only(bottom: AppConstants.spaceLg);
  static const EdgeInsets onlyLeft = EdgeInsets.only(left: AppConstants.spaceLg);
  static const EdgeInsets onlyRight = EdgeInsets.only(right: AppConstants.spaceLg);

  /// Page-level padding
  static const EdgeInsets page = EdgeInsets.all(AppConstants.spaceXl);
  static const EdgeInsets pageMobile = EdgeInsets.all(AppConstants.spaceLg);
  static const EdgeInsets pageDesktop = EdgeInsets.all(AppConstants.space2xl);

  /// Card content padding
  static const EdgeInsets cardContent = EdgeInsets.all(AppConstants.space2xl);
  static const EdgeInsets cardContentCompact = EdgeInsets.all(AppConstants.spaceLg);

  /// Button padding
  static const EdgeInsets button = EdgeInsets.symmetric(
    vertical: AppConstants.spaceMd,
    horizontal: AppConstants.spaceLg,
  );
  static const EdgeInsets buttonCompact = EdgeInsets.symmetric(
    vertical: AppConstants.spaceSm,
    horizontal: AppConstants.spaceMd,
  );
}