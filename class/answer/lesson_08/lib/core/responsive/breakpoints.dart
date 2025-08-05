/// Professional breakpoint system for responsive design
/// 
/// This file defines the breakpoint system used throughout the application
/// to determine device types and layout strategies.
library;

import 'package:flutter/material.dart';

/// Screen size breakpoints following industry standards
/// 
/// These breakpoints are designed to work well across all devices:
/// - Mobile: 0-767px (phones in portrait/landscape)
/// - Tablet: 768-1023px (tablets, small laptops)
/// - Desktop: 1024px+ (laptops, desktops, large displays)
class Breakpoints {
  /// Private constructor to prevent instantiation
  const Breakpoints._();

  /// Mobile breakpoint - phones and small devices
  /// 
  /// Covers most phones in both portrait and landscape orientations
  static const double mobile = 768;

  /// Tablet breakpoint - tablets and small laptops
  /// 
  /// Covers tablets, small laptops, and devices in landscape
  static const double tablet = 1024;

  /// Desktop breakpoint - large screens
  /// 
  /// Covers laptops, desktops, and large displays
  static const double desktop = 1024;

  /// Get the current device type based on screen width
  /// 
  /// Returns [DeviceType] enum based on the current screen width
  static DeviceType getDeviceType(double width) {
    if (width < mobile) {
      return DeviceType.mobile;
    } else if (width < tablet) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check if current screen is mobile
  static bool isMobile(double width) => width < mobile;

  /// Check if current screen is tablet
  static bool isTablet(double width) => width >= mobile && width < desktop;

  /// Check if current screen is desktop
  static bool isDesktop(double width) => width >= desktop;

  /// Get responsive value based on device type
  /// 
  /// Allows you to specify different values for different screen sizes
  /// If a specific device type value is not provided, it will fall back
  /// to the mobile value.
  /// 
  /// Example:
  /// ```dart
  /// final padding = Breakpoints.getValue(
  ///   context,
  ///   mobile: 16.0,
  ///   tablet: 24.0,
  ///   desktop: 32.0,
  /// );
  /// ```
  static T getValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(width);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Get grid column count based on screen size
  /// 
  /// Provides sensible defaults for grid layouts:
  /// - Mobile: 1-2 columns
  /// - Tablet: 2-3 columns  
  /// - Desktop: 3-4 columns
  static int getGridColumns(double width) {
    if (isMobile(width)) {
      return width < 400 ? 1 : 2; // Very small phones get 1 column
    } else if (isTablet(width)) {
      return width < 900 ? 2 : 3; // Smaller tablets get 2 columns
    } else {
      return width < 1400 ? 3 : 4; // Very large desktops get 4 columns
    }
  }

  /// Get appropriate font size based on screen size
  /// 
  /// Provides readable text scaling across devices
  static double getFontSize(double width, double baseSize) {
    if (isMobile(width)) {
      return baseSize * 0.9; // Slightly smaller on mobile
    } else if (isTablet(width)) {
      return baseSize; // Base size on tablet
    } else {
      return baseSize * 1.1; // Slightly larger on desktop
    }
  }

  /// Get appropriate padding based on screen size
  /// 
  /// Provides comfortable spacing across devices
  static double getPadding(double width, double basePadding) {
    if (isMobile(width)) {
      return basePadding;
    } else if (isTablet(width)) {
      return basePadding * 1.5;
    } else {
      return basePadding * 2;
    }
  }
}

/// Device type enumeration
/// 
/// Represents the three main device categories we design for
enum DeviceType {
  /// Mobile phones and small devices (< 768px)
  mobile,

  /// Tablets and small laptops (768px - 1023px)
  tablet,

  /// Desktop and large displays (>= 1024px)
  desktop,
}

/// Extension methods for BuildContext to easily access breakpoint utilities
/// 
/// These extensions make it convenient to use breakpoints directly from
/// any widget's build context.
extension BreakpointExtensions on BuildContext {
  /// Get the current screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get the current screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get the current device type
  DeviceType get deviceType => Breakpoints.getDeviceType(screenWidth);

  /// Check if current screen is mobile
  bool get isMobile => Breakpoints.isMobile(screenWidth);

  /// Check if current screen is tablet
  bool get isTablet => Breakpoints.isTablet(screenWidth);

  /// Check if current screen is desktop
  bool get isDesktop => Breakpoints.isDesktop(screenWidth);

  /// Get responsive value based on current device type
  /// 
  /// Convenient shorthand for Breakpoints.getValue
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) =>
      Breakpoints.getValue(
        this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );

  /// Get grid column count for current screen size
  int get gridColumns => Breakpoints.getGridColumns(screenWidth);

  /// Get font size scaled for current screen size
  double fontSizeFor(double baseSize) =>
      Breakpoints.getFontSize(screenWidth, baseSize);

  /// Get padding scaled for current screen size
  double paddingFor(double basePadding) =>
      Breakpoints.getPadding(screenWidth, basePadding);
}