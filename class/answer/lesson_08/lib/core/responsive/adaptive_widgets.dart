/// Adaptive widgets library for responsive design
/// 
/// This file contains a collection of adaptive widgets that automatically
/// adjust their behavior, appearance, and layout based on screen size.
library;

import 'package:flutter/material.dart';
import 'breakpoints.dart';
import 'responsive_builder.dart';
import 'screen_size.dart';

/// Adaptive card that adjusts its appearance based on screen size
/// 
/// This card automatically adjusts its elevation, border radius,
/// and internal padding based on the current device type.
class AdaptiveCard extends StatelessWidget {
  /// Creates an adaptive card
  const AdaptiveCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.margin,
    this.padding,
    this.onTap,
  });

  /// The child widget inside the card
  final Widget child;

  /// Background color (uses theme default if null)
  final Color? backgroundColor;

  /// Card elevation (auto-calculated if null)
  final double? elevation;

  /// Border radius (auto-calculated if null)
  final BorderRadius? borderRadius;

  /// Card margin (auto-calculated if null)
  final EdgeInsets? margin;

  /// Card padding (auto-calculated if null)
  final EdgeInsets? padding;

  /// Optional tap handler
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        // Calculate responsive properties
        final responsiveElevation = elevation ?? _getElevation(deviceType);
        final responsiveBorderRadius = borderRadius ?? _getBorderRadius(deviceType);
        final responsiveMargin = margin ?? _getMargin(deviceType);
        final responsivePadding = padding ?? _getPadding(deviceType);

        Widget cardChild = Container(
          margin: responsiveMargin,
          child: Card(
            backgroundColor: backgroundColor,
            elevation: responsiveElevation,
            shape: RoundedRectangleBorder(
              borderRadius: responsiveBorderRadius,
            ),
            child: Padding(
              padding: responsivePadding,
              child: child,
            ),
          ),
        );

        if (onTap != null) {
          cardChild = InkWell(
            onTap: onTap,
            borderRadius: responsiveBorderRadius,
            child: cardChild,
          );
        }

        return cardChild;
      },
    );
  }

  double _getElevation(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 2.0;
      case DeviceType.tablet:
        return 4.0;
      case DeviceType.desktop:
        return 6.0;
    }
  }

  BorderRadius _getBorderRadius(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return BorderRadius.circular(8.0);
      case DeviceType.tablet:
        return BorderRadius.circular(12.0);
      case DeviceType.desktop:
        return BorderRadius.circular(16.0);
    }
  }

  EdgeInsets _getMargin(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.all(8.0);
      case DeviceType.tablet:
        return const EdgeInsets.all(12.0);
      case DeviceType.desktop:
        return const EdgeInsets.all(16.0);
    }
  }

  EdgeInsets _getPadding(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.all(16.0);
      case DeviceType.tablet:
        return const EdgeInsets.all(20.0);
      case DeviceType.desktop:
        return const EdgeInsets.all(24.0);
    }
  }
}

/// Adaptive button that changes size based on screen size
/// 
/// This button automatically adjusts its height, padding, and font size
/// to provide optimal touch targets across different device types.
class AdaptiveButton extends StatelessWidget {
  /// Creates an adaptive button
  const AdaptiveButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.padding,
    this.borderRadius,
    this.minimumSize,
  });

  /// Button press handler
  final VoidCallback? onPressed;

  /// Button child (usually Text or Row with icon)
  final Widget child;

  /// Button background color
  final Color? backgroundColor;

  /// Button foreground color
  final Color? foregroundColor;

  /// Button elevation
  final double? elevation;

  /// Button padding
  final EdgeInsets? padding;

  /// Button border radius
  final BorderRadius? borderRadius;

  /// Minimum button size
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        final screenSize = ScreenSize.of(context);
        
        // Calculate responsive properties
        final responsiveMinimumSize = minimumSize ?? Size(
          _getMinWidth(deviceType),
          screenSize.getButtonHeight(),
        );
        
        final responsivePadding = padding ?? _getPadding(deviceType);
        final responsiveBorderRadius = borderRadius ?? _getBorderRadius(deviceType);

        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: elevation,
            padding: responsivePadding,
            minimumSize: responsiveMinimumSize,
            shape: RoundedRectangleBorder(
              borderRadius: responsiveBorderRadius,
            ),
          ),
          child: child,
        );
      },
    );
  }

  double _getMinWidth(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 88.0;
      case DeviceType.tablet:
        return 96.0;
      case DeviceType.desktop:
        return 104.0;
    }
  }

  EdgeInsets _getPadding(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
      case DeviceType.tablet:
        return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
      case DeviceType.desktop:
        return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
    }
  }

  BorderRadius _getBorderRadius(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return BorderRadius.circular(8.0);
      case DeviceType.tablet:
        return BorderRadius.circular(10.0);
      case DeviceType.desktop:
        return BorderRadius.circular(12.0);
    }
  }
}

/// Adaptive icon that scales based on screen size
/// 
/// This icon automatically adjusts its size to provide appropriate
/// visual weight across different device types.
class AdaptiveIcon extends StatelessWidget {
  /// Creates an adaptive icon
  const AdaptiveIcon(
    this.icon, {
    super.key,
    this.baseSize = 24.0,
    this.color,
    this.semanticLabel,
  });

  /// The icon to display
  final IconData icon;

  /// Base icon size (will be scaled)
  final double baseSize;

  /// Icon color
  final Color? color;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        final screenSize = ScreenSize.of(context);
        final responsiveSize = screenSize.getIconSize(baseSize);

        return Icon(
          icon,
          size: responsiveSize,
          color: color,
          semanticLabel: semanticLabel,
        );
      },
    );
  }
}

/// Adaptive list tile that adjusts its appearance based on screen size
/// 
/// This list tile automatically adjusts its padding, icon sizes,
/// and content density based on the current device type.
class AdaptiveListTile extends StatelessWidget {
  /// Creates an adaptive list tile
  const AdaptiveListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.visualDensity,
  });

  /// Leading widget (usually an icon or avatar)
  final Widget? leading;

  /// Title widget (usually text)
  final Widget? title;

  /// Subtitle widget (usually text)
  final Widget? subtitle;

  /// Trailing widget (usually an icon or text)
  final Widget? trailing;

  /// Tap handler
  final VoidCallback? onTap;

  /// Content padding (auto-calculated if null)
  final EdgeInsets? contentPadding;

  /// Visual density (auto-calculated if null)
  final VisualDensity? visualDensity;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        final responsiveContentPadding = contentPadding ?? _getContentPadding(deviceType);
        final responsiveVisualDensity = visualDensity ?? _getVisualDensity(deviceType);

        return ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          onTap: onTap,
          contentPadding: responsiveContentPadding,
          visualDensity: responsiveVisualDensity,
        );
      },
    );
  }

  EdgeInsets _getContentPadding(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0);
      case DeviceType.tablet:
        return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0);
      case DeviceType.desktop:
        return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0);
    }
  }

  VisualDensity _getVisualDensity(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return VisualDensity.standard;
      case DeviceType.tablet:
        return const VisualDensity(horizontal: 0, vertical: 1);
      case DeviceType.desktop:
        return const VisualDensity(horizontal: 0, vertical: 2);
    }
  }
}

/// Adaptive scaffold that provides responsive layout structure
/// 
/// This scaffold automatically handles responsive app bar heights,
/// drawer behavior, and safe area management.
class AdaptiveScaffold extends StatelessWidget {
  /// Creates an adaptive scaffold
  const AdaptiveScaffold({
    super.key,
    this.appBar,
    this.body,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
  });

  /// App bar widget
  final PreferredSizeWidget? appBar;

  /// Body widget
  final Widget? body;

  /// Drawer widget
  final Widget? drawer;

  /// End drawer widget
  final Widget? endDrawer;

  /// Bottom navigation bar
  final Widget? bottomNavigationBar;

  /// Floating action button
  final Widget? floatingActionButton;

  /// Background color
  final Color? backgroundColor;

  /// Whether to resize when keyboard appears
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        return Scaffold(
          appBar: appBar,
          body: body,
          drawer: drawer,
          endDrawer: endDrawer,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        );
      },
    );
  }
}

/// Adaptive app bar that adjusts height based on screen size
/// 
/// This app bar automatically adjusts its height and spacing
/// to provide appropriate visual hierarchy across devices.
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an adaptive app bar
  const AdaptiveAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
  });

  /// App bar title
  final Widget? title;

  /// Leading widget
  final Widget? leading;

  /// Action widgets
  final List<Widget>? actions;

  /// Background color
  final Color? backgroundColor;

  /// Elevation
  final double? elevation;

  /// Whether to center the title
  final bool? centerTitle;

  /// Whether to automatically add back button
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        final screenSize = ScreenSize.of(context);
        
        return AppBar(
          title: title,
          leading: leading,
          actions: actions,
          backgroundColor: backgroundColor,
          elevation: elevation,
          centerTitle: centerTitle,
          automaticallyImplyLeading: automaticallyImplyLeading,
          toolbarHeight: screenSize.getAppBarHeight(),
        );
      },
    );
  }

  @override
  Size get preferredSize {
    // This will be overridden by toolbarHeight in build method
    return const Size.fromHeight(kToolbarHeight);
  }
}

/// Adaptive divider that adjusts thickness based on screen size
/// 
/// This divider provides appropriate visual separation across devices.
class AdaptiveDivider extends StatelessWidget {
  /// Creates an adaptive divider
  const AdaptiveDivider({
    super.key,
    this.color,
    this.indent,
    this.endIndent,
  });

  /// Divider color
  final Color? color;

  /// Indent from start
  final double? indent;

  /// Indent from end
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        final thickness = _getThickness(deviceType);
        
        return Divider(
          color: color,
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
        );
      },
    );
  }

  double _getThickness(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 1.0;
      case DeviceType.tablet:
        return 1.5;
      case DeviceType.desktop:
        return 2.0;
    }
  }
}