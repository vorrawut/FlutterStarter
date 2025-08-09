import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Utility class for responsive design functionality
class ResponsiveUtils {
  /// Get screen size category from context
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width.screenSize;
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return getScreenSize(context) == ScreenSize.mobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return getScreenSize(context) == ScreenSize.tablet;
  }

  /// Check if current screen is desktop or larger
  static bool isDesktop(BuildContext context) {
    final screenSize = getScreenSize(context);
    return screenSize == ScreenSize.desktop || screenSize == ScreenSize.largeDesktop;
  }

  /// Get number of columns for grid based on screen size
  static int getGridColumns(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
    int largeDesktop = 4,
  }) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet;
      case ScreenSize.desktop:
        return desktop;
      case ScreenSize.largeDesktop:
        return largeDesktop;
    }
  }

  /// Get responsive value based on screen size
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSize.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return EdgeInsets.all(getResponsiveValue(
      context,
      mobile: AppConstants.spaceLg,
      tablet: AppConstants.spaceXl,
      desktop: AppConstants.space2xl,
    ));
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    final scaleFactor = getResponsiveValue(
      context,
      mobile: 0.9,
      tablet: 1.0,
      desktop: 1.1,
    );
    return baseFontSize * scaleFactor;
  }

  /// Get responsive card aspect ratio
  static double getCardAspectRatio(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 1.6,
      tablet: 1.8,
      desktop: 2.0,
    );
  }

  /// Calculate responsive width with max constraint
  static double getResponsiveWidth(
    BuildContext context, {
    double percentage = 1.0,
    double? maxWidth,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final calculatedWidth = screenWidth * percentage;
    
    if (maxWidth != null && calculatedWidth > maxWidth) {
      return maxWidth;
    }
    
    return calculatedWidth;
  }
}

/// Widget that builds different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveBuilder({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = constraints.maxWidth.screenSize;

        switch (screenSize) {
          case ScreenSize.mobile:
            return mobile ?? const SizedBox.shrink();
          case ScreenSize.tablet:
            return tablet ?? mobile ?? const SizedBox.shrink();
          case ScreenSize.desktop:
            return desktop ?? tablet ?? mobile ?? const SizedBox.shrink();
          case ScreenSize.largeDesktop:
            return largeDesktop ?? 
                   desktop ?? 
                   tablet ?? 
                   mobile ?? 
                   const SizedBox.shrink();
        }
      },
    );
  }
}

/// Widget that provides responsive grid layout
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? childAspectRatio;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final int largeDesktopColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.childAspectRatio,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.largeDesktopColumns = 4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ResponsiveUtils.getGridColumns(
          context,
          mobile: mobileColumns,
          tablet: tabletColumns,
          desktop: desktopColumns,
          largeDesktop: largeDesktopColumns,
        );

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: childAspectRatio ?? 
                ResponsiveUtils.getCardAspectRatio(context),
            mainAxisSpacing: mainAxisSpacing ?? AppConstants.spaceXl,
            crossAxisSpacing: crossAxisSpacing ?? AppConstants.spaceLg,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

/// Mixin to add responsive capabilities to any widget
mixin ResponsiveMixin<T extends StatefulWidget> on State<T> {
  ScreenSize get currentScreenSize => ResponsiveUtils.getScreenSize(context);
  
  bool get isMobile => ResponsiveUtils.isMobile(context);
  bool get isTablet => ResponsiveUtils.isTablet(context);
  bool get isDesktop => ResponsiveUtils.isDesktop(context);

  /// Get responsive value with type safety
  R responsive<R>({
    required R mobile,
    R? tablet,
    R? desktop,
    R? largeDesktop,
  }) {
    return ResponsiveUtils.getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }
}