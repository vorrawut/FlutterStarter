import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Core
import 'core/constants/app_constants.dart';

// Data layer
import 'data/datasources/theme_datasource.dart';
import 'data/repositories/theme_repository_impl.dart';

// Domain layer
import 'domain/usecases/get_theme_settings_usecase.dart';
import 'domain/usecases/update_theme_settings_usecase.dart';

// Presentation layer
import 'presentation/controllers/theme_controller.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/settings/theme_settings_screen.dart';

/// Main application entry point demonstrating professional Flutter theming
/// with Material 3, clean architecture, and comprehensive accessibility features
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI overlay
  await _configureSystemUI();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ThemingMasterclassApp());
}

/// Configure system UI overlay for better theming integration
Future<void> _configureSystemUI() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
}

/// Main application widget with comprehensive theming system
class ThemingMasterclassApp extends StatelessWidget {
  const ThemingMasterclassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _createProviders(),
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            // App configuration
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            
            // Theme configuration - The heart of this lesson!
            theme: themeController.lightTheme,
            darkTheme: themeController.darkTheme,
            themeMode: themeController.themeMode,
            
            // High contrast theme support
            highContrastTheme: themeController.highContrastLightTheme,
            highContrastDarkTheme: themeController.highContrastDarkTheme,
            
            // Home screen
            home: const HomeScreen(),
            
            // Routes for navigation
            routes: {
              '/theme-settings': (context) => const ThemeSettingsScreen(),
            },
            
            // Global builder for text scaling and responsive features
            builder: (context, child) {
              return MediaQuery(
                // Apply user-configured text scaling with safe bounds
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: themeController.textScaleFactor.clamp(0.5, 3.0),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }

  /// Create dependency injection providers following clean architecture
  List<ChangeNotifierProvider> _createProviders() {
    // Data layer - Local storage implementation
    final themeDataSource = LocalThemeDataSource();
    
    // Data layer - Repository implementation
    final themeRepository = ThemeRepositoryImpl(themeDataSource);
    
    // Domain layer - Use cases for business logic
    final getThemeSettingsUseCase = GetThemeSettingsUseCase(themeRepository);
    final updateThemeSettingsUseCase = UpdateThemeSettingsUseCase(themeRepository);
    
    return [
      // Presentation layer - Theme state management
      ChangeNotifierProvider<ThemeController>(
        create: (_) => ThemeController(
          getThemeSettingsUseCase,
          updateThemeSettingsUseCase,
        ),
      ),
    ];
  }
}

/// Home screen demonstrating theming in action
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppConstants.appName} - Theming Demo',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () {
              Navigator.of(context).pushNamed('/theme-settings');
            },
            tooltip: 'Theme Settings',
          ),
        ],
      ),
      body: const _HomeContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/theme-settings');
        },
        tooltip: 'Open Theme Settings',
        child: const Icon(Icons.color_lens),
      ),
    );
  }
}

/// Home screen content showcasing various themed components
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.palette,
                      size: 32,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Flutter Theming Masterclass',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome to Lesson 7! This app demonstrates professional Flutter theming with Material 3 design system, clean architecture, and comprehensive accessibility features.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/theme-settings');
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Open Theme Settings'),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Material 3 features section
        Text(
          'Material 3 Components',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Button showcase
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Button Variants',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Elevated'),
                    ),
                    FilledButton(
                      onPressed: () {},
                      child: const Text('Filled'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Outlined'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Text'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Color scheme showcase
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Material 3 Color Roles',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildColorChip(context, 'Primary', colorScheme.primary, colorScheme.onPrimary),
                _buildColorChip(context, 'Secondary', colorScheme.secondary, colorScheme.onSecondary),
                _buildColorChip(context, 'Tertiary', colorScheme.tertiary, colorScheme.onTertiary),
                _buildColorChip(context, 'Surface', colorScheme.surface, colorScheme.onSurface),
                _buildColorChip(context, 'Error', colorScheme.error, colorScheme.onError),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Typography showcase
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Typography Scale',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text('Display Large', style: theme.textTheme.displayLarge),
                Text('Headline Large', style: theme.textTheme.headlineLarge),
                Text('Title Large', style: theme.textTheme.titleLarge),
                Text('Body Large', style: theme.textTheme.bodyLarge),
                Text('Label Large', style: theme.textTheme.labelLarge),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Accessibility features
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.accessibility,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Accessibility Features',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Consumer<ThemeController>(
                  builder: (context, themeController, child) {
                    return Column(
                      children: [
                        _buildAccessibilityInfo(
                          context,
                          'High Contrast Mode',
                          themeController.isHighContrastMode ? 'Enabled' : 'Disabled',
                          themeController.isHighContrastMode ? Icons.check_circle : Icons.circle_outlined,
                        ),
                        _buildAccessibilityInfo(
                          context,
                          'Text Scale Factor',
                          '${(themeController.textScaleFactor * 100).toInt()}%',
                          Icons.format_size,
                        ),
                        _buildAccessibilityInfo(
                          context,
                          'Theme Mode',
                          themeController.themeMode.name.toUpperCase(),
                          _getThemeModeIcon(themeController.themeMode),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Footer
        Center(
          child: Column(
            children: [
              Text(
                'Flutter Masterclass - Lesson 7',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Professional Theming with Material 3',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildColorChip(BuildContext context, String label, Color color, Color onColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            color.value.toRadixString(16).toUpperCase().padLeft(8, '0'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityInfo(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getThemeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.settings_suggest;
    }
  }
}