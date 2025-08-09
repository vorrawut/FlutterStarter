# 🛠 Workshop (Part 3)

## **Step 9: Theme UI Components** ⏱️ *20 minutes*

Create beautiful UI components for theme management:

```dart
// lib/presentation/widgets/theme_mode_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';

/// Widget for selecting theme mode (light, dark, system)
class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.brightness_6,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Theme Mode',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildThemeModeOption(
                  context,
                  themeController,
                  ThemeMode.system,
                  'System Default',
                  'Follow system settings',
                  Icons.settings_suggest,
                ),
                const SizedBox(height: 8),
                _buildThemeModeOption(
                  context,
                  themeController,
                  ThemeMode.light,
                  'Light Mode',
                  'Always use light theme',
                  Icons.light_mode,
                ),
                const SizedBox(height: 8),
                _buildThemeModeOption(
                  context,
                  themeController,
                  ThemeMode.dark,
                  'Dark Mode',
                  'Always use dark theme',
                  Icons.dark_mode,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeModeOption(
    BuildContext context,
    ThemeController controller,
    ThemeMode mode,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = controller.themeMode == mode;
    
    return InkWell(
      onTap: () => controller.setThemeMode(mode),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// lib/presentation/widgets/color_picker_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';

/// Widget for picking theme seed colors
class ColorPickerWidget extends StatelessWidget {
  const ColorPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.palette,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Theme Colors',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // System colors option
                _buildSystemColorsOption(context, themeController),
                
                const SizedBox(height: 16),
                
                // Custom colors
                if (!themeController.useSystemColors) ...[
                  Text(
                    'Choose a color',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildColorGrid(context, themeController),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSystemColorsOption(
    BuildContext context,
    ThemeController controller,
  ) {
    return InkWell(
      onTap: () => controller.setSeedColor(null),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: controller.useSystemColors 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: controller.useSystemColors ? 2 : 1,
          ),
          color: controller.useSystemColors 
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              Icons.settings,
              color: controller.useSystemColors 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use System Colors',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: controller.useSystemColors ? FontWeight.w600 : FontWeight.w400,
                      color: controller.useSystemColors 
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                  Text(
                    'Adapt to device wallpaper colors',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (controller.useSystemColors)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorGrid(BuildContext context, ThemeController controller) {
    final availableColors = [
      const Color(0xFF6750A4), // Purple
      const Color(0xFF1976D2), // Blue
      const Color(0xFF388E3C), // Green
      const Color(0xFFD32F2F), // Red
      const Color(0xFFFF9800), // Orange
      const Color(0xFF7B1FA2), // Deep Purple
      const Color(0xFF303F9F), // Indigo
      const Color(0xFF455A64), // Blue Grey
      const Color(0xFF5D4037), // Brown
      const Color(0xFF00695C), // Teal
      const Color(0xFFAD1457), // Pink
      const Color(0xFF00838F), // Cyan
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableColors.map((color) {
        final isSelected = controller.seedColor == color;
        
        return GestureDetector(
          onTap: () => controller.setSeedColor(color),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected 
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: _getContrastColor(color),
                    size: 24,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Color _getContrastColor(Color color) {
    // Calculate luminance to determine if we should use white or black text
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

// lib/presentation/widgets/accessibility_controls.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';

/// Widget for accessibility-related theme controls
class AccessibilityControls extends StatelessWidget {
  const AccessibilityControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.accessibility,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Accessibility',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // High contrast toggle
                _buildHighContrastToggle(context, themeController),
                
                const SizedBox(height: 16),
                
                // Text scale slider
                _buildTextScaleSlider(context, themeController),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHighContrastToggle(
    BuildContext context,
    ThemeController controller,
  ) {
    return InkWell(
      onTap: () => controller.toggleHighContrastMode(),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(
              Icons.contrast,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'High Contrast Mode',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Enhanced colors for better visibility',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Switch(
              value: controller.isHighContrastMode,
              onChanged: (_) => controller.toggleHighContrastMode(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextScaleSlider(
    BuildContext context,
    ThemeController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.format_size,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              'Text Size',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            Text(
              '${(controller.textScaleFactor * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: controller.textScaleFactor,
          min: 0.5,
          max: 2.0,
          divisions: 15,
          onChanged: (value) => controller.setTextScaleFactor(value),
          label: '${(controller.textScaleFactor * 100).toInt()}%',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Small',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Normal',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Large',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

// lib/presentation/widgets/theme_preview_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';

/// Widget showing a preview of the current theme
class ThemePreviewCard extends StatelessWidget {
  const ThemePreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.preview,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Theme Preview',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Preview content
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header example
                      Text(
                        'FlutterShop',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Body text example
                      Text(
                        'This is how your app content will look with the current theme settings.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      
                      // Button examples
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Primary Button'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('Secondary'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Card example
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Icon(
                                Icons.shopping_bag,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Product Card',
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    'Example product with theme colors',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$29.99',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Theme info
                _buildThemeInfo(context, themeController),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeInfo(BuildContext context, ThemeController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Settings',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(context, 'Mode', controller.themeMode.name.toUpperCase()),
          _buildInfoRow(
            context, 
            'Colors', 
            controller.useSystemColors ? 'System' : 'Custom'
          ),
          _buildInfoRow(
            context, 
            'High Contrast', 
            controller.isHighContrastMode ? 'Enabled' : 'Disabled'
          ),
          _buildInfoRow(
            context, 
            'Text Scale', 
            '${(controller.textScaleFactor * 100).toInt()}%'
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
```

## **Step 10: Theme Settings Screen** ⏱️ *10 minutes*

Create a complete theme settings screen:

```dart
// lib/presentation/screens/settings/theme_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/theme_controller.dart';
import '../../widgets/theme_mode_selector.dart';
import '../../widgets/color_picker_widget.dart';
import '../../widgets/accessibility_controls.dart';
import '../../widgets/theme_preview_card.dart';

/// Screen for managing theme settings
class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ThemeController>().refresh();
            },
            tooltip: 'Refresh',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reset') {
                _showResetDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restore),
                    SizedBox(width: 12),
                    Text('Reset to Defaults'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          if (themeController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (themeController.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading theme settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    themeController.errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => themeController.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              ThemePreviewCard(),
              SizedBox(height: 16),
              ThemeModeSelector(),
              SizedBox(height: 16),
              ColorPickerWidget(),
              SizedBox(height: 16),
              AccessibilityControls(),
              SizedBox(height: 32),
              _ThemeInfoCard(),
            ],
          );
        },
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset Theme Settings'),
        content: const Text(
          'This will reset all theme settings to their default values. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ThemeController>().resetToDefaults();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Theme settings reset to defaults'),
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _ThemeInfoCard extends StatelessWidget {
  const _ThemeInfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'About Themes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This app uses Material 3 design system with dynamic color generation. '
              'Themes adapt automatically to provide the best user experience while '
              'maintaining accessibility standards.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildFeatureChip(context, 'Material 3'),
                _buildFeatureChip(context, 'Dynamic Colors'),
                _buildFeatureChip(context, 'Accessibility'),
                _buildFeatureChip(context, 'WCAG Compliant'),
                _buildFeatureChip(context, 'Dark Mode'),
                _buildFeatureChip(context, 'High Contrast'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(BuildContext context, String label) {
    return Chip(
      label: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
```

## **Step 11: Integration with Main App** ⏱️ *10 minutes*

Update your main app to use the theme system:

```dart
// lib/main.dart (Update your existing main.dart)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

// Import new theme-related classes
import 'data/datasources/theme_datasource.dart';
import 'data/repositories/theme_repository_impl.dart';
import 'domain/usecases/get_theme_settings_usecase.dart';
import 'domain/usecases/update_theme_settings_usecase.dart';
import 'presentation/controllers/theme_controller.dart';

// Import existing controllers
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/navigation_controller.dart';
// ... other imports

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const FlutterShopApp());
}

class FlutterShopApp extends StatelessWidget {
  const FlutterShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _createProviders(),
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp.router(
            title: 'FlutterShop',
            debugShowCheckedModeBanner: false,
            
            // Theme configuration from ThemeController
            theme: themeController.lightTheme,
            darkTheme: themeController.darkTheme,
            themeMode: themeController.themeMode,
            
            // Router configuration
            routerConfig: AppRouter.createRouter(),
            
            // Builder for additional setup including text scaling
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: themeController.textScaleFactor.clamp(0.5, 2.0),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }

  List<ChangeNotifierProvider> _createProviders() {
    // Initialize theme-related dependencies
    final themeDataSource = LocalThemeDataSource();
    final themeRepository = ThemeRepositoryImpl(themeDataSource);
    final getThemeSettingsUseCase = GetThemeSettingsUseCase(themeRepository);
    final updateThemeSettingsUseCase = UpdateThemeSettingsUseCase(themeRepository);

    // Initialize other dependencies (existing code)
    // ... auth, navigation, product dependencies

    return [
      // Theme controller - Add this first
      ChangeNotifierProvider<ThemeController>(
        create: (_) => ThemeController(
          getThemeSettingsUseCase,
          updateThemeSettingsUseCase,
        ),
      ),
      
      // Existing controllers
      ChangeNotifierProvider<AuthController>(
        create: (_) => AuthController(/* existing dependencies */),
      ),
      ChangeNotifierProvider<NavigationController>(
        create: (_) => NavigationController(/* existing dependencies */),
      ),
      // ... other existing providers
    ];
  }
}
```

## **Step 12: Add Theme Settings to Navigation** ⏱️ *5 minutes*

Add theme settings to your app's navigation:

```dart
// Update your existing navigation items to include theme settings
// This could be in your drawer, settings screen, or profile screen

// Example: Add to profile screen navigation
ListTile(
  leading: const Icon(Icons.palette),
  title: const Text('Theme Settings'),
  subtitle: const Text('Customize app appearance'),
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ThemeSettingsScreen(),
      ),
    );
  },
),

// Or add to your app drawer
ListTile(
  leading: Icon(
    Theme.of(context).brightness == Brightness.dark 
        ? Icons.dark_mode 
        : Icons.light_mode,
  ),
  title: const Text('Theme'),
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ThemeSettingsScreen(),
      ),
    );
  },
),
```

## **Step 13: Testing Your Theme System** ⏱️ *10 minutes*

### **Manual Testing Checklist**

1. **Theme Mode Testing**
   - [ ] Switch between light, dark, and system modes
   - [ ] Verify themes persist after app restart
   - [ ] Test automatic system theme switching

2. **Color Testing**
   - [ ] Try different seed colors
   - [ ] Switch between system and custom colors
   - [ ] Verify color harmony across all components

3. **Accessibility Testing**
   - [ ] Toggle high contrast mode
   - [ ] Adjust text scale from 50% to 200%
   - [ ] Verify color contrast ratios
   - [ ] Test with screen readers (if available)

4. **UI Component Testing**
   - [ ] Verify all buttons render correctly
   - [ ] Check text readability in all modes
   - [ ] Test card and container styling
   - [ ] Validate form input appearance

5. **Performance Testing**
   - [ ] Theme switching should be instant
   - [ ] No memory leaks from theme changes
   - [ ] Smooth animations during transitions

### **Unit Test Examples**

```dart
// test/presentation/controllers/theme_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';

void main() {
  group('ThemeController', () {
    late ThemeController themeController;
    late MockGetThemeSettingsUseCase mockGetUseCase;
    late MockUpdateThemeSettingsUseCase mockUpdateUseCase;

    setUp(() {
      mockGetUseCase = MockGetThemeSettingsUseCase();
      mockUpdateUseCase = MockUpdateThemeSettingsUseCase();
      themeController = ThemeController(mockGetUseCase, mockUpdateUseCase);
    });

    test('should update theme mode correctly', () async {
      // Arrange
      final expectedSettings = ThemeSettings.defaultSettings().copyWith(
        themeMode: ThemeMode.dark,
      );
      when(mockUpdateUseCase.updateThemeMode(ThemeMode.dark))
          .thenAnswer((_) async => ThemeUpdateResult.success('Success', expectedSettings));

      // Act
      await themeController.setThemeMode(ThemeMode.dark);

      // Assert
      expect(themeController.themeMode, ThemeMode.dark);
      expect(themeController.isDarkMode, true);
    });

    test('should generate correct light and dark themes', () {
      // Arrange
      const seedColor = Color(0xFF6750A4);
      themeController.setSeedColor(seedColor);

      // Act
      final lightTheme = themeController.lightTheme;
      final darkTheme = themeController.darkTheme;

      // Assert
      expect(lightTheme.colorScheme.brightness, Brightness.light);
      expect(darkTheme.colorScheme.brightness, Brightness.dark);
      expect(lightTheme.useMaterial3, true);
      expect(darkTheme.useMaterial3, true);
    });
  });
}
```

## 🎉 **Congratulations!**

You've successfully implemented a comprehensive theming system with:

✅ **Material 3 Design System** - Modern, accessible themes  
✅ **Dynamic Color Generation** - Harmonious color schemes  
✅ **Dark/Light Mode** - Complete theme switching  
✅ **Clean Architecture** - Maintainable, testable code  
✅ **Accessibility Features** - WCAG compliant themes  
✅ **State Management** - Persistent theme preferences  
✅ **Beautiful UI** - Professional theme management interface

## 🎯 **Next Steps**

- Explore custom theme extensions for brand-specific styling
- Add animation themes for consistent motion design
- Implement seasonal or promotional theme variations
- Create theme presets for different user personas
- Add theme analytics to understand user preferences

**Your app now has professional-grade theming that rivals the best mobile applications! 🎨✨**