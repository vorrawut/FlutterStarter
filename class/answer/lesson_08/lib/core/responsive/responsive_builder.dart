/// Responsive builder for adaptive layout construction
/// 
/// This file contains the core responsive building blocks that enable
/// widgets to adapt their layout based on screen size and constraints.
library;

import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Type definition for responsive widget builders
/// 
/// These builders receive the current context, device type, and constraints
/// to build appropriate widgets for the current screen size.
typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  DeviceType deviceType,
  BoxConstraints constraints,
);

/// Core responsive builder widget
/// 
/// This widget rebuilds its child whenever the screen size changes,
/// allowing for real-time responsive adaptations. It uses LayoutBuilder
/// to get accurate constraint information and MediaQuery to detect changes.
class ResponsiveBuilder extends StatelessWidget {
  /// Creates a responsive builder
  /// 
  /// The [builder] function is called whenever the layout constraints change,
  /// providing the context, device type, and current constraints.
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  /// Builder function that creates the appropriate widget for current screen size
  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get device type based on available width
        final deviceType = Breakpoints.getDeviceType(constraints.maxWidth);
        
        // Call the builder with current context and constraints
        return builder(context, deviceType, constraints);
      },
    );
  }
}

/// Responsive widget that adapts between different layouts
/// 
/// This widget allows you to specify different widgets for different
/// device types, providing a clean API for responsive design.
class ResponsiveWidget extends StatelessWidget {
  /// Creates a responsive widget with device-specific builders
  /// 
  /// At minimum, you must provide a [mobile] widget. If [tablet] or [desktop]
  /// are not provided, they will fall back to the [mobile] widget.
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  /// Widget to display on mobile devices
  final Widget mobile;

  /// Widget to display on tablet devices (falls back to mobile if null)
  final Widget? tablet;

  /// Widget to display on desktop devices (falls back to tablet or mobile if null)
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        switch (deviceType) {
          case DeviceType.mobile:
            return mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.desktop:
            return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}

/// Responsive container that adapts its properties based on screen size
/// 
/// This container automatically adjusts padding, margin, and other properties
/// based on the current device type, following responsive design principles.
class ResponsiveContainer extends StatelessWidget {
  /// Creates a responsive container
  const ResponsiveContainer({
    super.key,
    this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
    this.mobileMargin,
    this.tabletMargin,
    this.desktopMargin,
    this.decoration,
    this.constraints,
    this.alignment,
    this.width,
    this.height,
  });

  /// The child widget
  final Widget? child;

  /// Padding for mobile devices
  final EdgeInsets? mobilePadding;

  /// Padding for tablet devices
  final EdgeInsets? tabletPadding;

  /// Padding for desktop devices
  final EdgeInsets? desktopPadding;

  /// Margin for mobile devices
  final EdgeInsets? mobileMargin;

  /// Margin for tablet devices
  final EdgeInsets? tabletMargin;

  /// Margin for desktop devices
  final EdgeInsets? desktopMargin;

  /// Container decoration
  final Decoration? decoration;

  /// Container constraints
  final BoxConstraints? constraints;

  /// Child alignment
  final Alignment? alignment;

  /// Container width
  final double? width;

  /// Container height
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, layoutConstraints) {
        // Determine padding based on device type
        EdgeInsets? padding;
        EdgeInsets? margin;

        switch (deviceType) {
          case DeviceType.mobile:
            padding = mobilePadding;
            margin = mobileMargin;
            break;
          case DeviceType.tablet:
            padding = tabletPadding ?? mobilePadding;
            margin = tabletMargin ?? mobileMargin;
            break;
          case DeviceType.desktop:
            padding = desktopPadding ?? tabletPadding ?? mobilePadding;
            margin = desktopMargin ?? tabletMargin ?? mobileMargin;
            break;
        }

        return Container(
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          decoration: decoration,
          constraints: constraints,
          alignment: alignment,
          child: child,
        );
      },
    );
  }
}

/// Responsive grid that adapts column count based on screen size
/// 
/// This grid automatically adjusts its column count based on available
/// space and device type, providing an intelligent grid layout system.
class ResponsiveGrid extends StatelessWidget {
  /// Creates a responsive grid
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.childAspectRatio = 1.0,
  });

  /// Grid children
  final List<Widget> children;

  /// Number of columns on mobile (defaults to auto-calculated)
  final int? mobileColumns;

  /// Number of columns on tablet (defaults to auto-calculated)
  final int? tabletColumns;

  /// Number of columns on desktop (defaults to auto-calculated)
  final int? desktopColumns;

  /// Horizontal spacing between grid items
  final double spacing;

  /// Vertical spacing between grid items
  final double runSpacing;

  /// Aspect ratio of grid children
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        // Determine column count based on device type
        int columnCount;

        switch (deviceType) {
          case DeviceType.mobile:
            columnCount = mobileColumns ?? Breakpoints.getGridColumns(constraints.maxWidth);
            break;
          case DeviceType.tablet:
            columnCount = tabletColumns ?? Breakpoints.getGridColumns(constraints.maxWidth);
            break;
          case DeviceType.desktop:
            columnCount = desktopColumns ?? Breakpoints.getGridColumns(constraints.maxWidth);
            break;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

/// Responsive text that scales appropriately for different screen sizes
/// 
/// This text widget automatically adjusts its font size based on device type
/// while maintaining readability across all screen sizes.
class ResponsiveText extends StatelessWidget {
  /// Creates responsive text
  const ResponsiveText(
    this.text, {
    super.key,
    required this.baseFontSize,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSizeMultiplier = 1.0,
  });

  /// The text to display
  final String text;

  /// Base font size (will be scaled for different devices)
  final double baseFontSize;

  /// Additional text style
  final TextStyle? style;

  /// Text alignment
  final TextAlign? textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow? overflow;

  /// Additional font size multiplier
  final double fontSizeMultiplier;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        // Calculate responsive font size
        final responsiveFontSize = Breakpoints.getFontSize(
          constraints.maxWidth,
          baseFontSize * fontSizeMultiplier,
        );

        // Merge styles
        final effectiveStyle = (style ?? const TextStyle()).copyWith(
          fontSize: responsiveFontSize,
        );

        return Text(
          text,
          style: effectiveStyle,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}

/// Responsive spacing that adapts based on screen size
/// 
/// Provides consistent spacing that scales appropriately across devices.
class ResponsiveSpacing extends StatelessWidget {
  /// Creates responsive spacing
  const ResponsiveSpacing({
    super.key,
    required this.baseSpacing,
    this.axis = Axis.vertical,
  });

  /// Base spacing value (will be scaled for different devices)
  final double baseSpacing;

  /// Spacing axis (vertical or horizontal)
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        // Calculate responsive spacing
        final responsiveSpacing = Breakpoints.getPadding(
          constraints.maxWidth,
          baseSpacing,
        );

        return SizedBox(
          width: axis == Axis.horizontal ? responsiveSpacing : null,
          height: axis == Axis.vertical ? responsiveSpacing : null,
        );
      },
    );
  }
}