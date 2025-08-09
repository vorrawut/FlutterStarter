import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';

/// Main Navigation Wrapper
///
/// Demonstrates:
/// - Responsive navigation patterns (Lesson 8: Responsive UI)
/// - Adaptive UI for different screen sizes
/// - Professional navigation implementation
/// - Bottom navigation for mobile
/// - Navigation rail for tablet/desktop
/// - Consistent navigation state management
class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  // Navigation destinations
  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
      tooltip: 'Home Feed',
    ),
    const NavigationDestination(
      icon: Icon(Icons.groups_outlined),
      selectedIcon: Icon(Icons.groups),
      label: 'Groups',
      tooltip: 'Study Groups',
    ),
    const NavigationDestination(
      icon: Icon(Icons.chat_outlined),
      selectedIcon: Icon(Icons.chat),
      label: 'Chat',
      tooltip: 'Messages',
    ),
    const NavigationDestination(
      icon: Icon(Icons.quiz_outlined),
      selectedIcon: Icon(Icons.quiz),
      label: 'Quiz',
      tooltip: 'Take Quizzes',
    ),
    const NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
      tooltip: 'Your Profile',
    ),
  ];

  // Routes corresponding to navigation destinations
  final List<String> _routes = [
    AppRoutes.home,
    AppRoutes.groups,
    AppRoutes.chat,
    AppRoutes.quiz,
    AppRoutes.profile,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final location = GoRouterState.of(context).fullPath;

    // Determine which tab should be selected based on current route
    for (int i = 0; i < _routes.length; i++) {
      if (location?.startsWith(_routes[i]) == true) {
        if (_selectedIndex != i) {
          setState(() {
            _selectedIndex = i;
          });
        }
        break;
      }
    }
  }

  void _onDestinationSelected(int index) {
    if (index != _selectedIndex) {
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = DeviceType.fromWidth(screenWidth);

    // Use different navigation patterns based on screen size
    switch (deviceType) {
      case DeviceType.mobile:
        return _buildMobileLayout(context);
      case DeviceType.tablet:
      case DeviceType.desktop:
      case DeviceType.wideScreen:
        return _buildDesktopLayout(context);
    }
  }

  Widget _buildMobileLayout(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations,
        backgroundColor: theme.colorScheme.surfaceContainer,
        elevation: 8,
        height: 65,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            backgroundColor: theme.colorScheme.surfaceContainer,
            leading: _buildRailHeader(context),
            trailing: _buildRailTrailing(context),
            destinations: _destinations.map((destination) {
              return NavigationRailDestination(
                icon: destination.icon,
                selectedIcon: destination.selectedIcon,
                label: Text(destination.label),
              );
            }).toList(),
          ),

          // Vertical divider
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),

          // Main content
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildRailHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing),
      child: Column(
        children: [
          // App Logo
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.school_rounded,
              color: theme.colorScheme.onPrimary,
              size: 24,
            ),
          ),

          const SizedBox(height: AppConstants.spacing),

          // Create button
          FloatingActionButton.small(
            onPressed: () => _showCreateMenu(context),
            tooltip: 'Create',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildRailTrailing(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing),
      child: Column(
        children: [
          // Settings button
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
          ),

          const SizedBox(height: AppConstants.smallSpacing),

          // Notifications button
          Badge(
            label: const Text('3'),
            child: IconButton(
              onPressed: () => _showNotifications(context),
              icon: const Icon(Icons.notifications_outlined),
              tooltip: 'Notifications',
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    // Show FAB only on certain tabs
    if (_selectedIndex == 0 || _selectedIndex == 1) {
      // Home or Groups
      return FloatingActionButton(
        onPressed: () => _showCreateMenu(context),
        tooltip: 'Create',
        child: const Icon(Icons.add),
      );
    }
    return null;
  }

  void _showCreateMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateMenuBottomSheet(),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _NotificationsDialog(),
    );
  }
}

/// Create Menu Bottom Sheet
///
/// Demonstrates:
/// - Bottom sheet patterns
/// - Action menus
/// - Material 3 design
class _CreateMenuBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Text(
                'Create New',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Actions
            _CreateMenuItem(
              icon: Icons.post_add,
              title: 'Create Post',
              subtitle: 'Share knowledge with the community',
              onTap: () {
                Navigator.pop(context);
                // Navigate to create post
              },
            ),

            _CreateMenuItem(
              icon: Icons.group_add,
              title: 'Create Study Group',
              subtitle: 'Start a new learning group',
              onTap: () {
                Navigator.pop(context);
                // Navigate to create group
              },
            ),

            _CreateMenuItem(
              icon: Icons.quiz,
              title: 'Create Quiz',
              subtitle: 'Test others\' knowledge',
              onTap: () {
                Navigator.pop(context);
                // Navigate to create quiz
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CreateMenuItem extends StatelessWidget {
  const _CreateMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 4,
      ),
    );
  }
}

/// Notifications Dialog
///
/// Demonstrates:
/// - Dialog patterns
/// - Notification UI
/// - Scrollable content
class _NotificationsDialog extends StatelessWidget {
  const _NotificationsDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 400,
        height: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Notifications list
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.notifications,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Text('Notification ${index + 1}'),
                    subtitle: const Text('This is a demo notification'),
                    trailing: const Text('2m ago'),
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
            ),

            // View all button
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('View All Notifications'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
