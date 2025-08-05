/// Screen size utilities and helper functions
/// 
/// This file provides utility functions and classes for working with
/// screen sizes, orientations, and device characteristics.
library;

import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Screen size information and utilities
/// 
/// This class provides comprehensive information about the current screen
/// and device characteristics, including size, orientation, and density.
class ScreenSize {
  /// Creates a ScreenSize instance from the current context
  const ScreenSize._({
    required this.size,
    required this.devicePixelRatio,
    required this.textScaleFactor,
    required this.padding,
    required this.viewInsets,
    required this.deviceType,
  });

  /// Factory constructor to create ScreenSize from BuildContext
  factory ScreenSize.of(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final deviceType = Breakpoints.getDeviceType(size.width);

    return ScreenSize._(
      size: size,
      devicePixelRatio: mediaQuery.devicePixelRatio,
      textScaleFactor: mediaQuery.textScaleFactor,
      padding: mediaQuery.padding,
      viewInsets: mediaQuery.viewInsets,
      deviceType: deviceType,
    );
  }

  /// The logical screen size
  final Size size;

  /// The device pixel ratio
  final double devicePixelRatio;

  /// The text scale factor
  final double textScaleFactor;

  /// The screen padding (safe areas)
  final EdgeInsets padding;

  /// The view insets (keyboard, etc.)
  final EdgeInsets viewInsets;

  /// The device type based on screen width
  final DeviceType deviceType;

  /// Screen width in logical pixels
  double get width => size.width;

  /// Screen height in logical pixels
  double get height => size.height;

  /// Screen diagonal in logical pixels
  double get diagonal => (width * width + height * height) / 2;

  /// Available width (excluding safe areas)
  double get availableWidth => width - padding.horizontal;

  /// Available height (excluding safe areas and view insets)
  double get availableHeight => height - padding.vertical - viewInsets.vertical;

  /// Screen aspect ratio (width / height)
  double get aspectRatio => width / height;

  /// Whether the screen is in landscape orientation
  bool get isLandscape => width > height;

  /// Whether the screen is in portrait orientation
  bool get isPortrait => !isLandscape;

  /// Whether this is a mobile device
  bool get isMobile => deviceType == DeviceType.mobile;

  /// Whether this is a tablet device
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Whether this is a desktop device
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Whether this is a compact device (narrow screens)
  bool get isCompact => width < 400;

  /// Whether this is a medium-sized device
  bool get isMedium => width >= 400 && width < 840;

  /// Whether this is an expanded device (wide screens)
  bool get isExpanded => width >= 840;

  /// Whether the device has a high pixel density
  bool get isHighDensity => devicePixelRatio > 2.0;

  /// Whether the device has a large text scale
  bool get hasLargeText => textScaleFactor > 1.3;

  /// Whether there is a keyboard visible
  bool get isKeyboardVisible => viewInsets.bottom > 100;

  /// Physical screen width in pixels
  double get physicalWidth => width * devicePixelRatio;

  /// Physical screen height in pixels
  double get physicalHeight => height * devicePixelRatio;

  /// Get responsive value based on screen size categories
  T responsiveValue<T>({
    required T compact,
    T? medium,
    T? expanded,
  }) {
    if (isCompact) return compact;
    if (isMedium) return medium ?? compact;
    return expanded ?? medium ?? compact;
  }

  /// Get column count based on available width and item size
  int getColumnCount({
    required double itemWidth,
    double spacing = 16.0,
    int minColumns = 1,
    int maxColumns = 4,
  }) {
    final availableSpace = availableWidth - (spacing * 2); // Account for side padding
    final itemsPerRow = (availableSpace / (itemWidth + spacing)).floor();
    return itemsPerRow.clamp(minColumns, maxColumns);
  }

  /// Get appropriate font size for current screen
  double getFontSize(double baseSize) {
    return Breakpoints.getFontSize(width, baseSize) * textScaleFactor;
  }

  /// Get appropriate padding for current screen
  double getPadding(double basePadding) {
    return Breakpoints.getPadding(width, basePadding);
  }

  /// Get appropriate icon size for current screen
  double getIconSize(double baseSize) {
    if (isMobile) return baseSize;
    if (isTablet) return baseSize * 1.2;
    return baseSize * 1.4;
  }

  /// Get appropriate button height for current screen
  double getButtonHeight() {
    if (isMobile) return 48.0;
    if (isTablet) return 52.0;
    return 56.0;
  }

  /// Get appropriate app bar height for current screen
  double getAppBarHeight() {
    if (isMobile) return kToolbarHeight;
    if (isTablet) return kToolbarHeight + 8;
    return kToolbarHeight + 16;
  }

  /// Get appropriate bottom navigation height
  double getBottomNavHeight() {
    if (isMobile) return 72.0;
    if (isTablet) return 80.0;
    return 88.0;
  }

  /// Get appropriate drawer width
  double getDrawerWidth() {
    final maxWidth = width * 0.85; // Never more than 85% of screen
    if (isMobile) return maxWidth.clamp(280.0, 320.0);
    if (isTablet) return maxWidth.clamp(320.0, 400.0);
    return maxWidth.clamp(320.0, 480.0);
  }

  /// Get appropriate dialog width
  double getDialogWidth() {
    if (isMobile) return width * 0.9;
    if (isTablet) return 560.0;
    return 640.0;
  }

  /// Get maximum content width for readability
  double getMaxContentWidth() {
    if (isMobile) return width;
    if (isTablet) return 768.0;
    return 1200.0;
  }

  @override
  String toString() {
    return 'ScreenSize('
        'size: $size, '
        'deviceType: $deviceType, '
        'orientation: ${isLandscape ? 'landscape' : 'portrait'}, '
        'devicePixelRatio: $devicePixelRatio'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScreenSize &&
        other.size == size &&
        other.devicePixelRatio == devicePixelRatio &&
        other.textScaleFactor == textScaleFactor &&
        other.deviceType == deviceType;
  }

  @override
  int get hashCode {
    return Object.hash(size, devicePixelRatio, textScaleFactor, deviceType);
  }
}

/// Mixin for widgets that need screen size information
/// 
/// This mixin provides easy access to screen size utilities
/// from any StatefulWidget.
mixin ScreenSizeMixin<T extends StatefulWidget> on State<T> {
  /// Get the current screen size information
  ScreenSize get screenSize => ScreenSize.of(context);

  /// Whether the current screen is mobile
  bool get isMobile => screenSize.isMobile;

  /// Whether the current screen is tablet
  bool get isTablet => screenSize.isTablet;

  /// Whether the current screen is desktop
  bool get isDesktop => screenSize.isDesktop;

  /// Whether the current screen is in landscape
  bool get isLandscape => screenSize.isLandscape;

  /// Whether the current screen is in portrait
  bool get isPortrait => screenSize.isPortrait;

  /// Get responsive value based on device type
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return context.responsive(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}

/// Widget that rebuilds when screen size category changes
/// 
/// This widget is useful when you need to rebuild parts of your UI
/// only when the screen size category changes, not on every resize.
class ScreenSizeListener extends StatefulWidget {
  /// Creates a screen size listener
  const ScreenSizeListener({
    super.key,
    required this.builder,
    this.child,
  });

  /// Builder function called when screen size changes
  final Widget Function(BuildContext context, ScreenSize screenSize, Widget? child) builder;

  /// Optional child widget (performance optimization)
  final Widget? child;

  @override
  State<ScreenSizeListener> createState() => _ScreenSizeListenerState();
}

class _ScreenSizeListenerState extends State<ScreenSizeListener> {
  DeviceType? _lastDeviceType;

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize.of(context);
    
    // Only rebuild if device type actually changed
    if (_lastDeviceType != screenSize.deviceType) {
      _lastDeviceType = screenSize.deviceType;
    }

    return widget.builder(context, screenSize, widget.child);
  }
}

/// Orientation listener widget
/// 
/// Rebuilds only when orientation changes, not on every size change.
class OrientationListener extends StatefulWidget {
  /// Creates an orientation listener
  const OrientationListener({
    super.key,
    required this.builder,
    this.child,
  });

  /// Builder function called when orientation changes
  final Widget Function(BuildContext context, Orientation orientation, Widget? child) builder;

  /// Optional child widget (performance optimization)
  final Widget? child;

  @override
  State<OrientationListener> createState() => _OrientationListenerState();
}

class _OrientationListenerState extends State<OrientationListener> {
  Orientation? _lastOrientation;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    
    // Only rebuild if orientation actually changed
    if (_lastOrientation != orientation) {
      _lastOrientation = orientation;
    }

    return widget.builder(context, orientation, widget.child);
  }
}