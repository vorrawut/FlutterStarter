/// Adaptive navigation system for responsive layouts
/// 
/// This file contains the navigation components that automatically adapt
/// based on screen size: bottom navigation for mobile, navigation rail
/// for tablet, and navigation drawer for desktop.
library;

import 'package:flutter/material.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/responsive_builder.dart';

/// Navigation destination data
/// 
/// Represents a single navigation destination with all necessary
/// information for display across different navigation patterns.
class NavigationDestination {
  /// Creates a navigation destination
  const NavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badge,
  });

  /// Icon to display when not selected
  final IconData icon;

  /// Icon to display when selected
  final IconData selectedIcon;

  /// Text label for the destination
  final String label;

  /// Optional badge text or number
  final String? badge;
}

/// Adaptive navigation widget that changes pattern based on screen size
/// 
/// - Mobile: Bottom navigation bar
/// - Tablet: Navigation rail
/// - Desktop: Navigation drawer (persistent)
class AdaptiveNavigation extends StatelessWidget {
  /// Creates an adaptive navigation widget
  const AdaptiveNavigation({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.floatingActionButton,
    this.appBar,
    this.backgroundColor,
  });

  /// List of navigation destinations
  final List<NavigationDestination> destinations;

  /// Currently selected destination index
  final int selectedIndex;

  /// Callback when destination is selected
  final void Function(int index) onDestinationSelected;

  /// Main body content
  final Widget body;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Optional app bar
  final PreferredSizeWidget? appBar;

  /// Background color
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileLayout(context);
          case DeviceType.tablet:
            return _buildTabletLayout(context);
          case DeviceType.desktop:
            return _buildDesktopLayout(context);
        }
      },
    );
  }

  /// Build mobile layout with bottom navigation
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations.map((dest) {
          return NavigationDestination(
            icon: Icon(dest.icon),
            selectedIcon: Icon(dest.selectedIcon),
            label: dest.label,
          );
        }).toList(),
      ),
    );
  }

  /// Build tablet layout with navigation rail
  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: destinations.map((dest) {
              return NavigationRailDestination(
                icon: Icon(dest.icon),
                selectedIcon: Icon(dest.selectedIcon),
                label: Text(dest.label),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }

  /// Build desktop layout with persistent navigation drawer
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          SizedBox(
            width: 280,
            child: Drawer(
              child: Column(
                children: [
                  if (appBar != null)
                    SizedBox(
                      height: appBar!.preferredSize.height + 
                               MediaQuery.of(context).padding.top,
                      child: DrawerHeader(
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.dashboard, size: 32),
                            const SizedBox(width: 16),
                            Text(
                              'Dashboard',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: destinations.length,
                      itemBuilder: (context, index) {
                        final dest = destinations[index];
                        final isSelected = index == selectedIndex;
                        
                        return ListTile(
                          leading: Icon(
                            isSelected ? dest.selectedIcon : dest.icon,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          title: Text(
                            dest.label,
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onTap: () => onDestinationSelected(index),
                          trailing: dest.badge != null
                              ? Badge(
                                  label: Text(dest.badge!),
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Scaffold(
              appBar: appBar,
              body: body,
              floatingActionButton: floatingActionButton,
              backgroundColor: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Adaptive app drawer for mobile overlay
/// 
/// This drawer is used for mobile devices when accessed via drawer icon.
/// It provides a full-screen navigation experience.
class AdaptiveDrawer extends StatelessWidget {
  /// Creates an adaptive drawer
  const AdaptiveDrawer({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.header,
    this.footer,
  });

  /// List of navigation destinations
  final List<NavigationDestination> destinations;

  /// Currently selected destination index
  final int selectedIndex;

  /// Callback when destination is selected
  final void Function(int index) onDestinationSelected;

  /// Optional drawer header
  final Widget? header;

  /// Optional drawer footer
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (header != null) header!,
          ...destinations.asMap().entries.map((entry) {
            final index = entry.key;
            final dest = entry.value;
            final isSelected = index == selectedIndex;
            
            return ListTile(
              leading: Icon(
                isSelected ? dest.selectedIcon : dest.icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              title: Text(
                dest.label,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onTap: () {
                onDestinationSelected(index);
                Navigator.of(context).pop(); // Close drawer after selection
              },
              trailing: dest.badge != null
                  ? Badge(
                      label: Text(dest.badge!),
                    )
                  : null,
            );
          }).toList(),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

/// Responsive navigation controller
/// 
/// Manages navigation state and provides methods for programmatic navigation.
class NavigationController extends ChangeNotifier {
  /// Creates a navigation controller
  NavigationController({int initialIndex = 0}) : _selectedIndex = initialIndex;

  int _selectedIndex;

  /// Currently selected navigation index
  int get selectedIndex => _selectedIndex;

  /// Select a navigation destination by index
  void selectDestination(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  /// Go to next destination (if available)
  void next(int maxIndex) {
    if (_selectedIndex < maxIndex) {
      selectDestination(_selectedIndex + 1);
    }
  }

  /// Go to previous destination (if available)
  void previous() {
    if (_selectedIndex > 0) {
      selectDestination(_selectedIndex - 1);
    }
  }

  /// Reset to first destination
  void reset() {
    selectDestination(0);
  }
}

/// Navigation wrapper that provides controller access
/// 
/// This widget provides a navigation controller to its descendants
/// and manages the adaptive navigation layout.
class NavigationWrapper extends StatefulWidget {
  /// Creates a navigation wrapper
  const NavigationWrapper({
    super.key,
    required this.destinations,
    required this.screens,
    this.initialIndex = 0,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.drawer,
  });

  /// List of navigation destinations
  final List<NavigationDestination> destinations;

  /// List of screen widgets corresponding to destinations
  final List<Widget> screens;

  /// Initial selected index
  final int initialIndex;

  /// Optional app bar
  final PreferredSizeWidget? appBar;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Background color
  final Color? backgroundColor;

  /// Optional drawer for mobile
  final Widget? drawer;

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  late NavigationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NavigationController(initialIndex: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final currentScreen = widget.screens[_controller.selectedIndex];
        
        return AdaptiveNavigation(
          destinations: widget.destinations,
          selectedIndex: _controller.selectedIndex,
          onDestinationSelected: _controller.selectDestination,
          appBar: widget.appBar,
          floatingActionButton: widget.floatingActionButton,
          backgroundColor: widget.backgroundColor,
          body: currentScreen,
        );
      },
    );
  }
}

/// Navigation utilities and helpers
class NavigationUtils {
  /// Private constructor
  NavigationUtils._();

  /// Get appropriate navigation height for current device
  static double getNavigationHeight(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 72.0; // Bottom navigation height
      case DeviceType.tablet:
        return 0.0; // Navigation rail doesn't add to height
      case DeviceType.desktop:
        return 0.0; // Navigation drawer doesn't add to height
    }
  }

  /// Get appropriate navigation width for current device
  static double getNavigationWidth(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 0.0; // Bottom navigation doesn't add to width
      case DeviceType.tablet:
        return 80.0; // Navigation rail width
      case DeviceType.desktop:
        return 280.0; // Navigation drawer width
    }
  }

  /// Check if navigation should be persistent (always visible)
  static bool isPersistent(DeviceType deviceType) {
    return deviceType != DeviceType.mobile;
  }

  /// Check if navigation should overlay content
  static bool isOverlay(DeviceType deviceType) {
    return deviceType == DeviceType.mobile;
  }
}