# 🛠 Workshop

## 🎯 **What We're Building**

Create a **professional adaptive dashboard** that showcases advanced responsive design techniques:
- **Multi-Platform Dashboard** with adaptive navigation and layout
- **Responsive Grid System** that adjusts to any screen size
- **Breakpoint Management** with professional breakpoint handling
- **Adaptive Components** that change behavior based on context
- **Performance Optimization** for smooth responsive transitions
- **Platform-Specific Adaptations** for native feel on each platform

## ✅ **Expected Outcome**

A comprehensive responsive dashboard featuring:
- 📱 **Mobile Layout** - Bottom navigation with single-column content
- 📱 **Tablet Layout** - Navigation rail with two-column grids
- 🖥️ **Desktop Layout** - Side navigation with multi-column dashboards
- 📊 **Responsive Widgets** - Charts, cards, and lists that adapt beautifully
- 🎨 **Smooth Transitions** - Seamless layout changes on window resize
- ♿ **Accessibility Support** - Works perfectly with assistive technologies

## 🏗️ **Project Structure**

We'll build a clean architecture responsive system:

```
lib/
├── core/
│   ├── responsive/               # 📱 Responsive framework
│   │   ├── breakpoints.dart     # Breakpoint system
│   │   ├── responsive_builder.dart  # Layout builder
│   │   ├── screen_size.dart     # Screen size utilities
│   │   └── adaptive_widgets.dart   # Adaptive components
│   ├── theme/
│   │   └── responsive_theme.dart    # Responsive theming
│   └── constants/
│       └── layout_constants.dart   # Layout configuration
├── domain/
│   ├── entities/
│   │   ├── dashboard_item.dart     # Dashboard content entity
│   │   └── navigation_item.dart    # Navigation structure
│   └── repositories/
│       └── dashboard_repository.dart   # Dashboard data interface
├── data/
│   ├── models/
│   │   └── dashboard_item_model.dart   # Data models
│   └── repositories/
│       └── dashboard_repository_impl.dart  # Data implementation
├── presentation/
│   ├── controllers/
│   │   └── dashboard_controller.dart   # Dashboard state
│   ├── screens/
│   │   ├── dashboard_screen.dart       # Main dashboard
│   │   ├── analytics_screen.dart       # Analytics view
│   │   └── settings_screen.dart        # Settings view
│   ├── widgets/
│   │   ├── adaptive_navigation.dart    # Responsive navigation
│   │   ├── responsive_grid.dart        # Adaptive grid system
│   │   ├── dashboard_card.dart         # Responsive cards
│   │   ├── adaptive_chart.dart         # Responsive charts
│   │   └── responsive_list.dart        # Adaptive lists
│   └── layouts/
│       ├── mobile_layout.dart          # Mobile-specific layout
│       ├── tablet_layout.dart          # Tablet-specific layout
│       └── desktop_layout.dart         # Desktop-specific layout
└── main.dart                           # App entry with responsive setup
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Responsive Foundation** ⏱️ *15 minutes*

Create the core responsive system with professional breakpoint management:

```dart
// lib/core/responsive/screen_size.dart
enum ScreenSize {
  mobile,
  tablet,
  desktop,
  ultrawide;

  /// Get minimum width for this screen size
  double get minWidth {
    switch (this) {
      case ScreenSize.mobile: return 0;
      case ScreenSize.tablet: return 768;
      case ScreenSize.desktop: return 1024;
      case ScreenSize.ultrawide: return 1440;
    }
  }

  /// Get maximum width for this screen size
  double get maxWidth {
    switch (this) {
      case ScreenSize.mobile: return 767;
      case ScreenSize.tablet: return 1023;
      case ScreenSize.desktop: return 1439;
      case ScreenSize.ultrawide: return double.infinity;
    }
  }

  /// Check if this screen size matches the given width
  bool matches(double width) {
    return width >= minWidth && width <= maxWidth;
  }

  /// Get display name for this screen size
  String get displayName {
    switch (this) {
      case ScreenSize.mobile: return 'Mobile';
      case ScreenSize.tablet: return 'Tablet';
      case ScreenSize.desktop: return 'Desktop';
      case ScreenSize.ultrawide: return 'Ultra-wide';
    }
  }

  /// Get recommended column count for grids
  int get defaultColumns {
    switch (this) {
      case ScreenSize.mobile: return 1;
      case ScreenSize.tablet: return 2;
      case ScreenSize.desktop: return 3;
      case ScreenSize.ultrawide: return 4;
    }
  }

  /// Get recommended content padding
  double get contentPadding {
    switch (this) {
      case ScreenSize.mobile: return 16.0;
      case ScreenSize.tablet: return 24.0;
      case ScreenSize.desktop: return 32.0;
      case ScreenSize.ultrawide: return 40.0;
    }
  }
}

// lib/core/responsive/breakpoints.dart
import 'package:flutter/material.dart';
import 'screen_size.dart';

class Breakpoints {
  // Standard breakpoint values
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double wide = 1440;
  static const double ultrawide = 1920;

  // Responsive breakpoint ranges
  static const double mobileSmall = 320;
  static const double mobileLarge = 480;
  static const double tabletSmall = 768;
  static const double tabletLarge = 1024;
  static const double desktopSmall = 1024;
  static const double desktopLarge = 1440;

  /// Get screen size for the given width
  static ScreenSize getScreenSize(double width) {
    if (width >= ultrawide) return ScreenSize.ultrawide;
    if (width >= desktop) return ScreenSize.desktop;
    if (width >= tablet) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }

  /// Get screen size from context
  static ScreenSize getScreenSizeFromContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return getScreenSize(width);
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return getScreenSizeFromContext(context) == ScreenSize.mobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return getScreenSizeFromContext(context) == ScreenSize.tablet;
  }

  /// Check if current screen is desktop or larger
  static bool isDesktop(BuildContext context) {
    final screenSize = getScreenSizeFromContext(context);
    return screenSize == ScreenSize.desktop || screenSize == ScreenSize.ultrawide;
  }

  /// Check if current screen is ultrawide
  static bool isUltrawide(BuildContext context) {
    return getScreenSizeFromContext(context) == ScreenSize.ultrawide;
  }

  /// Get responsive value based on screen size
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
    T? ultrawide,
  }) {
    final screenSize = getScreenSizeFromContext(context);
    
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSize.ultrawide:
        return ultrawide ?? desktop ?? tablet ?? mobile;
    }
  }

  /// Get grid column count based on screen size
  static int getGridColumns(BuildContext context, {
    int? mobile,
    int? tablet,
    int? desktop,
    int? ultrawide,
  }) {
    return getResponsiveValue(
      context: context,
      mobile: mobile ?? 1,
      tablet: tablet ?? 2,
      desktop: desktop ?? 3,
      ultrawide: ultrawide ?? 4,
    );
  }

  /// Get content padding based on screen size
  static EdgeInsets getContentPadding(BuildContext context) {
    final screenSize = getScreenSizeFromContext(context);
    final padding = screenSize.contentPadding;
    
    return EdgeInsets.all(padding);
  }

  /// Get responsive spacing value
  static double getSpacing(BuildContext context, {
    double mobile = 8.0,
    double? tablet,
    double? desktop,
    double? ultrawide,
  }) {
    return getResponsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.5,
      desktop: desktop ?? mobile * 2.0,
      ultrawide: ultrawide ?? mobile * 2.5,
    );
  }

  /// Get maximum content width for centering
  static double getMaxContentWidth(BuildContext context) {
    return getResponsiveValue(
      context: context,
      mobile: double.infinity,
      tablet: 800,
      desktop: 1200,
      ultrawide: 1400,
    );
  }

  /// Get font size scale factor
  static double getFontScaleFactor(BuildContext context) {
    return getResponsiveValue(
      context: context,
      mobile: 0.9,
      tablet: 1.0,
      desktop: 1.1,
      ultrawide: 1.2,
    );
  }
}
```

### **Step 2: Responsive Builder Framework** ⏱️ *20 minutes*

Create a powerful responsive builder system:

```dart
// lib/core/responsive/responsive_builder.dart
import 'package:flutter/material.dart';
import 'breakpoints.dart';
import 'screen_size.dart';

/// A powerful responsive builder that adapts to screen size changes
class ResponsiveBuilder extends StatelessWidget {
  /// Builder function that receives context and screen size
  final Widget Function(BuildContext context, ScreenSize screenSize)? builder;
  
  /// Specific widgets for each screen size
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? ultrawide;
  
  /// Whether to animate transitions between layouts
  final bool animate;
  
  /// Animation duration for layout transitions
  final Duration animationDuration;

  const ResponsiveBuilder({
    super.key,
    this.builder,
    this.mobile,
    this.tablet,
    this.desktop,
    this.ultrawide,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : assert(
         builder != null || mobile != null,
         'Either builder or mobile widget must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = Breakpoints.getScreenSize(constraints.maxWidth);
        final widget = _getWidgetForScreenSize(context, screenSize);
        
        if (animate) {
          return AnimatedSwitcher(
            duration: animationDuration,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(screenSize),
              child: widget,
            ),
          );
        }
        
        return widget;
      },
    );
  }

  Widget _getWidgetForScreenSize(BuildContext context, ScreenSize screenSize) {
    // Try to use specific widget first
    switch (screenSize) {
      case ScreenSize.mobile:
        if (mobile != null) return mobile!;
        break;
      case ScreenSize.tablet:
        if (tablet != null) return tablet!;
        if (mobile != null) return mobile!; // Fallback to mobile
        break;
      case ScreenSize.desktop:
        if (desktop != null) return desktop!;
        if (tablet != null) return tablet!; // Fallback to tablet
        if (mobile != null) return mobile!; // Ultimate fallback
        break;
      case ScreenSize.ultrawide:
        if (ultrawide != null) return ultrawide!;
        if (desktop != null) return desktop!; // Fallback to desktop
        if (tablet != null) return tablet!; // Fallback to tablet
        if (mobile != null) return mobile!; // Ultimate fallback
        break;
    }
    
    // Use builder if no specific widget found
    if (builder != null) {
      return builder!(context, screenSize);
    }
    
    // This should never happen due to assert
    throw StateError('No widget or builder provided for responsive layout');
  }
}

/// Utility extension for responsive values
extension ResponsiveExtension on BuildContext {
  /// Get current screen size
  ScreenSize get screenSize => Breakpoints.getScreenSizeFromContext(this);
  
  /// Check if mobile
  bool get isMobile => Breakpoints.isMobile(this);
  
  /// Check if tablet
  bool get isTablet => Breakpoints.isTablet(this);
  
  /// Check if desktop
  bool get isDesktop => Breakpoints.isDesktop(this);
  
  /// Check if ultrawide
  bool get isUltrawide => Breakpoints.isUltrawide(this);
  
  /// Get responsive value
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? ultrawide,
  }) {
    return Breakpoints.getResponsiveValue(
      context: this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      ultrawide: ultrawide,
    );
  }
  
  /// Get grid columns
  int get gridColumns => screenSize.defaultColumns;
  
  /// Get content padding
  EdgeInsets get contentPadding => Breakpoints.getContentPadding(this);
  
  /// Get spacing value
  double spacing([double base = 16.0]) => Breakpoints.getSpacing(this, mobile: base);
}

/// Responsive widget for conditional rendering
class ResponsiveVisibility extends StatelessWidget {
  final Widget child;
  final bool visibleOnMobile;
  final bool visibleOnTablet;
  final bool visibleOnDesktop;
  final bool visibleOnUltrawide;
  final Widget? replacement;

  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.visibleOnMobile = true,
    this.visibleOnTablet = true,
    this.visibleOnDesktop = true,
    this.visibleOnUltrawide = true,
    this.replacement,
  });

  /// Show only on mobile
  const ResponsiveVisibility.mobile({
    super.key,
    required this.child,
    this.replacement,
  }) : visibleOnMobile = true,
       visibleOnTablet = false,
       visibleOnDesktop = false,
       visibleOnUltrawide = false;

  /// Show only on tablet and above
  const ResponsiveVisibility.tabletAndUp({
    super.key,
    required this.child,
    this.replacement,
  }) : visibleOnMobile = false,
       visibleOnTablet = true,
       visibleOnDesktop = true,
       visibleOnUltrawide = true;

  /// Show only on desktop and above
  const ResponsiveVisibility.desktopAndUp({
    super.key,
    required this.child,
    this.replacement,
  }) : visibleOnMobile = false,
       visibleOnTablet = false,
       visibleOnDesktop = true,
       visibleOnUltrawide = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = context.screenSize;
    
    bool isVisible = switch (screenSize) {
      ScreenSize.mobile => visibleOnMobile,
      ScreenSize.tablet => visibleOnTablet,
      ScreenSize.desktop => visibleOnDesktop,
      ScreenSize.ultrawide => visibleOnUltrawide,
    };
    
    if (isVisible) {
      return child;
    }
    
    return replacement ?? const SizedBox.shrink();
  }
}
```

### **Step 3: Adaptive Widget System** ⏱️ *25 minutes*

Build responsive widgets that adapt to different screen sizes:

```dart
// lib/core/responsive/adaptive_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'responsive_builder.dart';
import 'breakpoints.dart';

/// Adaptive container that changes padding and constraints based on screen size
class AdaptiveContainer extends StatelessWidget {
  final Widget child;
  final Map<ScreenSize, EdgeInsets>? padding;
  final Map<ScreenSize, BoxConstraints>? constraints;
  final Map<ScreenSize, AlignmentGeometry>? alignment;
  final Color? color;
  final Decoration? decoration;

  const AdaptiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.constraints,
    this.alignment,
    this.color,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        return Container(
          padding: padding?[screenSize] ?? EdgeInsets.all(screenSize.contentPadding),
          constraints: constraints?[screenSize],
          alignment: alignment?[screenSize],
          color: color,
          decoration: decoration,
          child: child,
        );
      },
    );
  }
}

/// Responsive grid that adapts column count and spacing
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final Map<ScreenSize, int>? crossAxisCounts;
  final Map<ScreenSize, double>? aspectRatios;
  final Map<ScreenSize, double>? spacing;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisCounts,
    this.aspectRatios,
    this.spacing,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final crossAxisCount = crossAxisCounts?[screenSize] ?? screenSize.defaultColumns;
        final aspectRatio = aspectRatios?[screenSize] ?? 1.0;
        final gridSpacing = spacing?[screenSize] ?? context.spacing();
        
        return GridView.builder(
          physics: physics,
          shrinkWrap: shrinkWrap,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: gridSpacing,
            mainAxisSpacing: gridSpacing,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

/// Adaptive navigation that changes between bottom nav, rail, and drawer
class AdaptiveNavigation extends StatelessWidget {
  final List<AdaptiveNavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;

  const AdaptiveNavigation({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
      ultrawide: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: onDestinationSelected,
        items: items.take(5).map((item) => BottomNavigationBarItem(
          icon: Icon(item.icon),
          activeIcon: Icon(item.activeIcon ?? item.icon),
          label: item.label,
          tooltip: item.tooltip,
        )).toList(),
      ),
      floatingActionButton: floatingActionButton,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            extended: false,
            destinations: items.map((item) => NavigationRailDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.activeIcon ?? item.icon),
              label: Text(item.label),
            )).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            children: [
              if (appBar != null)
                SizedBox(
                  height: kToolbarHeight,
                  child: DrawerHeader(
                    margin: EdgeInsets.zero,
                    child: appBar!.preferredSize.height > 0 
                        ? (appBar as dynamic).title ?? const SizedBox.shrink()
                        : const SizedBox.shrink(),
                  ),
                ),
              ...items.map((item) => NavigationDrawerDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.activeIcon ?? item.icon),
                label: Text(item.label),
              )),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                if (appBar != null && extendBodyBehindAppBar == false) appBar!,
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Navigation item for adaptive navigation
class AdaptiveNavigationItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String? tooltip;

  const AdaptiveNavigationItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.tooltip,
  });
}

/// Responsive text that scales with screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Map<ScreenSize, double>? fontSizeOverrides;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.fontSizeOverrides,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
        final scaleFactor = Breakpoints.getFontScaleFactor(context);
        final customFontSize = fontSizeOverrides?[screenSize];
        
        final responsiveStyle = baseStyle.copyWith(
          fontSize: customFontSize ?? (baseStyle.fontSize! * scaleFactor),
        );
        
        return Text(
          text,
          style: responsiveStyle,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}

/// Adaptive card that changes padding and elevation based on screen size
class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final Map<ScreenSize, EdgeInsets>? padding;
  final Map<ScreenSize, double>? elevation;
  final Color? color;
  final ShapeBorder? shape;
  final bool semanticContainer;

  const AdaptiveCard({
    super.key,
    required this.child,
    this.padding,
    this.elevation,
    this.color,
    this.shape,
    this.semanticContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final cardPadding = padding?[screenSize] ?? 
            EdgeInsets.all(screenSize.contentPadding * 0.75);
        final cardElevation = elevation?[screenSize] ?? 
            (screenSize == ScreenSize.mobile ? 2.0 : 4.0);
        
        return Card(
          elevation: cardElevation,
          color: color,
          shape: shape,
          semanticContainer: semanticContainer,
          child: Padding(
            padding: cardPadding,
            child: child,
          ),
        );
      },
    );
  }
}

/// Responsive image that loads different assets based on screen density
class ResponsiveImage extends StatelessWidget {
  final String imagePath;
  final Map<ScreenSize, String>? imageVariants;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ImageFrameBuilder? frameBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;

  const ResponsiveImage({
    super.key,
    required this.imagePath,
    this.imageVariants,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.frameBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final selectedImagePath = imageVariants?[screenSize] ?? imagePath;
        final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
        
        return Image.asset(
          selectedImagePath,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          frameBuilder: frameBuilder,
          errorBuilder: errorBuilder,
          cacheWidth: width != null ? (width! * devicePixelRatio).round() : null,
          cacheHeight: height != null ? (height! * devicePixelRatio).round() : null,
        );
      },
    );
  }
}
```

### **Step 4: Dashboard Data Layer** ⏱️ *15 minutes*

Create the data structures for our adaptive dashboard:

```dart
// lib/domain/entities/dashboard_item.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Dashboard item entity representing a widget in the dashboard
class DashboardItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? color;
  final DashboardItemType type;
  final Map<String, dynamic> data;
  final int priority;
  final bool isVisible;
  final Map<String, dynamic>? responsiveConfig;

  const DashboardItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.color,
    required this.type,
    this.data = const {},
    this.priority = 0,
    this.isVisible = true,
    this.responsiveConfig,
  });

  /// Create a copy with updated properties
  DashboardItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    Color? color,
    DashboardItemType? type,
    Map<String, dynamic>? data,
    int? priority,
    bool? isVisible,
    Map<String, dynamic>? responsiveConfig,
  }) {
    return DashboardItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      data: data ?? this.data,
      priority: priority ?? this.priority,
      isVisible: isVisible ?? this.isVisible,
      responsiveConfig: responsiveConfig ?? this.responsiveConfig,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        icon,
        color,
        type,
        data,
        priority,
        isVisible,
        responsiveConfig,
      ];
}

/// Types of dashboard items
enum DashboardItemType {
  metric,
  chart,
  list,
  table,
  widget,
  action;

  String get displayName {
    switch (this) {
      case DashboardItemType.metric: return 'Metric';
      case DashboardItemType.chart: return 'Chart';
      case DashboardItemType.list: return 'List';
      case DashboardItemType.table: return 'Table';
      case DashboardItemType.widget: return 'Widget';
      case DashboardItemType.action: return 'Action';
    }
  }

  IconData get defaultIcon {
    switch (this) {
      case DashboardItemType.metric: return Icons.analytics;
      case DashboardItemType.chart: return Icons.pie_chart;
      case DashboardItemType.list: return Icons.list;
      case DashboardItemType.table: return Icons.table_chart;
      case DashboardItemType.widget: return Icons.widgets;
      case DashboardItemType.action: return Icons.touch_app;
    }
  }
}

// lib/domain/entities/navigation_item.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Navigation item for adaptive navigation
class NavigationItem extends Equatable {
  final String id;
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;
  final bool isVisible;
  final int order;
  final List<NavigationItem>? children;

  const NavigationItem({
    required this.id,
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.route,
    this.isVisible = true,
    this.order = 0,
    this.children,
  });

  /// Check if this item has children
  bool get hasChildren => children != null && children!.isNotEmpty;

  /// Check if this item is a parent
  bool get isParent => hasChildren;

  @override
  List<Object?> get props => [
        id,
        label,
        icon,
        activeIcon,
        route,
        isVisible,
        order,
        children,
      ];
}

// lib/data/repositories/dashboard_repository_impl.dart
import '../../domain/entities/dashboard_item.dart';
import '../../domain/entities/navigation_item.dart';

/// Mock implementation of dashboard repository
class DashboardRepositoryImpl {
  /// Get dashboard items for the home screen
  Future<List<DashboardItem>> getDashboardItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      const DashboardItem(
        id: 'revenue',
        title: 'Total Revenue',
        subtitle: '\$125,430',
        icon: Icons.attach_money,
        color: Colors.green,
        type: DashboardItemType.metric,
        data: {
          'value': 125430,
          'change': 12.5,
          'period': 'This month',
        },
      ),
      const DashboardItem(
        id: 'users',
        title: 'Active Users',
        subtitle: '2,847',
        icon: Icons.people,
        color: Colors.blue,
        type: DashboardItemType.metric,
        data: {
          'value': 2847,
          'change': 8.2,
          'period': 'Last 30 days',
        },
      ),
      const DashboardItem(
        id: 'orders',
        title: 'New Orders',
        subtitle: '156',
        icon: Icons.shopping_cart,
        color: Colors.orange,
        type: DashboardItemType.metric,
        data: {
          'value': 156,
          'change': -3.1,
          'period': 'Today',
        },
      ),
      const DashboardItem(
        id: 'satisfaction',
        title: 'Customer Satisfaction',
        subtitle: '94.2%',
        icon: Icons.sentiment_very_satisfied,
        color: Colors.purple,
        type: DashboardItemType.metric,
        data: {
          'value': 94.2,
          'change': 2.1,
          'period': 'This quarter',
        },
      ),
      const DashboardItem(
        id: 'sales_chart',
        title: 'Sales Overview',
        subtitle: 'Last 7 days',
        icon: Icons.show_chart,
        color: Colors.indigo,
        type: DashboardItemType.chart,
        data: {
          'chartType': 'line',
          'dataPoints': [120, 132, 101, 134, 90, 230, 210],
          'labels': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        },
      ),
      const DashboardItem(
        id: 'recent_activities',
        title: 'Recent Activities',
        subtitle: 'Latest updates',
        icon: Icons.timeline,
        color: Colors.teal,
        type: DashboardItemType.list,
        data: {
          'items': [
            'New user registered: John Doe',
            'Order #1234 completed',
            'Payment received: \$1,250',
            'Product review added',
            'Support ticket resolved',
          ],
        },
      ),
    ];
  }

  /// Get navigation items
  List<NavigationItem> getNavigationItems() {
    return const [
      NavigationItem(
        id: 'dashboard',
        label: 'Dashboard',
        icon: Icons.dashboard,
        activeIcon: Icons.dashboard,
        route: '/dashboard',
        order: 0,
      ),
      NavigationItem(
        id: 'analytics',
        label: 'Analytics',
        icon: Icons.analytics_outlined,
        activeIcon: Icons.analytics,
        route: '/analytics',
        order: 1,
      ),
      NavigationItem(
        id: 'products',
        label: 'Products',
        icon: Icons.inventory_2_outlined,
        activeIcon: Icons.inventory_2,
        route: '/products',
        order: 2,
      ),
      NavigationItem(
        id: 'orders',
        label: 'Orders',
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag,
        route: '/orders',
        order: 3,
      ),
      NavigationItem(
        id: 'customers',
        label: 'Customers',
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        route: '/customers',
        order: 4,
      ),
      NavigationItem(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        route: '/settings',
        order: 5,
      ),
    ];
  }
}
```

*This is the foundation of our responsive dashboard. Continue with the remaining steps to build the complete adaptive interface...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_08

# Install dependencies
flutter pub get

# Run the app
flutter run

# Test responsiveness
# 1. Resize the window (on desktop/web)
# 2. Rotate device (on mobile)
# 3. Try different device simulators
# 4. Test accessibility features
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **Responsive Design Principles** - Mobile-first, progressive enhancement
- **MediaQuery & LayoutBuilder** - Dynamic layout adaptation
- **Breakpoint Systems** - Professional responsive frameworks
- **Adaptive Components** - Context-aware widget behavior
- **Platform Integration** - Native-feeling experiences
- **Performance Optimization** - Efficient responsive rendering

**Ready to create universally excellent user experiences? 📱💻🖥️✨**