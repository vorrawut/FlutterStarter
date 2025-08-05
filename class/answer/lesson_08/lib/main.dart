/// Responsive Layouts - Lesson 8 Implementation
/// 
/// This application demonstrates comprehensive responsive design patterns
/// in Flutter, featuring adaptive navigation, responsive grids, and 
/// dashboard components that work beautifully across mobile, tablet, and desktop.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/responsive/breakpoints.dart';
import 'core/responsive/screen_size.dart';
import 'presentation/controllers/dashboard_controller.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'presentation/widgets/adaptive_navigation.dart';

void main() {
  runApp(const ResponsiveLayoutsApp());
}

/// Main application widget showcasing responsive design
/// 
/// Demonstrates adaptive layouts, navigation patterns, and responsive
/// components that automatically adjust based on screen size.
class ResponsiveLayoutsApp extends StatelessWidget {
  const ResponsiveLayoutsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Layouts - Lesson 8',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const ResponsiveDashboard(),
    );
  }

  /// Build light theme with Material 3 design
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// Build dark theme with Material 3 design
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

/// Main responsive dashboard with adaptive navigation
/// 
/// This widget demonstrates the complete responsive system with:
/// - Adaptive navigation (bottom nav → nav rail → nav drawer)
/// - Responsive screen layouts
/// - State management for responsive features
class ResponsiveDashboard extends StatefulWidget {
  const ResponsiveDashboard({super.key});

  @override
  State<ResponsiveDashboard> createState() => _ResponsiveDashboardState();
}

class _ResponsiveDashboardState extends State<ResponsiveDashboard> 
    with DashboardStateMixin, ScreenSizeMixin {
  
  // Navigation destinations for the responsive navigation system
  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      label: 'Analytics',
    ),
    NavigationDestination(
      icon: Icons.assessment_outlined,
      selectedIcon: Icons.assessment,
      label: 'Reports',
    ),
    NavigationDestination(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  // Screen widgets corresponding to navigation destinations
  final List<Widget> _screens = const [
    DashboardScreen(),
    AnalyticsScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load initial data when the dashboard starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Update controller with current device type
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceType = Breakpoints.getDeviceType(screenSize.width);
      updateControllerDeviceType(deviceType);
    });

    return ChangeNotifierProvider.value(
      value: dashboardController,
      child: Consumer<DashboardController>(
        builder: (context, controller, child) {
          // Show loading screen during initial load
          if (controller.isLoading) {
            return const LoadingScreen();
          }

          // Show error screen if there's an error
          if (controller.hasError) {
            return ErrorScreen(
              message: controller.errorMessage!,
              onRetry: () => loadDashboard(),
            );
          }

          // Build responsive navigation wrapper
          return NavigationWrapper(
            destinations: _destinations,
            screens: _screens,
            initialIndex: controller.selectedNavigationIndex,
            appBar: _buildAppBar(context),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          );
        },
      ),
    );
  }

  /// Build adaptive app bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(_getScreenTitle()),
      actions: [
        // Refresh button
        Consumer<DashboardController>(
          builder: (context, controller, child) {
            return IconButton(
              onPressed: controller.isRefreshing ? null : () => refreshDashboard(),
              icon: controller.isRefreshing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              tooltip: 'Refresh Data',
            );
          },
        ),
        
        // Theme toggle (demo feature)
        IconButton(
          onPressed: () {
            // In a real app, this would toggle theme mode
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Theme toggle - implement with ThemeData switching'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(Icons.brightness_6),
          tooltip: 'Toggle Theme',
        ),
        
        // Profile menu (demo feature)
        PopupMenuButton(
          icon: const CircleAvatar(
            radius: 16,
            child: Icon(Icons.person, size: 20),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          onSelected: (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Selected: $value'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        
        const SizedBox(width: 8),
      ],
    );
  }

  /// Get title for current screen
  String _getScreenTitle() {
    final index = dashboardController.selectedNavigationIndex;
    if (index < _destinations.length) {
      return _destinations[index].label;
    }
    return 'Dashboard';
  }
}

/// Placeholder analytics screen
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, size: 64, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Analytics Screen',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Detailed analytics and insights would go here.'),
        ],
      ),
    );
  }
}

/// Placeholder reports screen
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assessment, size: 64, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Reports Screen',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Comprehensive reports and data exports would go here.'),
        ],
      ),
    );
  }
}

/// Placeholder settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 64, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'Settings Screen',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Application settings and preferences would go here.'),
        ],
      ),
    );
  }
}

/// Loading screen shown during initial data load
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Loading Dashboard...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we prepare your data.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error screen shown when data loading fails
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}