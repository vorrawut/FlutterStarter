import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';

import '../../../domain/entities/theme_settings.dart';
import '../../../domain/repositories/theme_repository.dart';
import '../../../core/di/service_locator.dart';

// Repository provider
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return getIt<ThemeRepository>();
});

// Theme settings provider
final themeSettingsProvider = StateNotifierProvider<ThemeSettingsNotifier, AsyncValue<ThemeSettings>>((ref) {
  return ThemeSettingsNotifier(ref.read(themeRepositoryProvider));
});

// System color scheme provider
final systemColorSchemeProvider = FutureProvider<ColorScheme?>((ref) async {
  try {
    final corePalette = await DynamicColorPlugin.getCorePalette();
    if (corePalette != null) {
      return ColorScheme.fromSeed(seedColor: Color(corePalette.primary.get(40)));
    }
  } catch (e) {
    // System colors not available
  }
  return null;
});

// Current theme data provider
final currentThemeDataProvider = Provider<ThemeData>((ref) {
  final settingsAsync = ref.watch(themeSettingsProvider);
  final systemColorScheme = ref.watch(systemColorSchemeProvider).valueOrNull;
  
  return settingsAsync.when(
    loading: () => _getDefaultTheme(systemColorScheme),
    error: (error, stack) => _getDefaultTheme(systemColorScheme),
    data: (settings) => _buildThemeFromSettings(settings, systemColorScheme),
  );
});

// Dark theme data provider
final darkThemeDataProvider = Provider<ThemeData>((ref) {
  final settingsAsync = ref.watch(themeSettingsProvider);
  final systemColorScheme = ref.watch(systemColorSchemeProvider).valueOrNull;
  
  return settingsAsync.when(
    loading: () => _getDefaultDarkTheme(systemColorScheme),
    error: (error, stack) => _getDefaultDarkTheme(systemColorScheme),
    data: (settings) => _buildDarkThemeFromSettings(settings, systemColorScheme),
  );
});

// Theme mode provider
final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(themeSettingsProvider).valueOrNull;
  return settings?.themeMode ?? ThemeMode.system;
});

// Theme Settings Notifier
class ThemeSettingsNotifier extends StateNotifier<AsyncValue<ThemeSettings>> {
  final ThemeRepository _repository;

  ThemeSettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final settings = await _repository.getThemeSettings();
      state = AsyncValue.data(settings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    await _updateSettings((settings) => settings.copyWith(themeMode: mode));
  }

  Future<void> updateColorScheme(String colorScheme) async {
    await _updateSettings((settings) => settings.copyWith(colorScheme: colorScheme));
  }

  Future<void> updateTextScaleFactor(double factor) async {
    await _updateSettings((settings) => settings.copyWith(textScaleFactor: factor));
  }

  Future<void> toggleHighContrast() async {
    final current = state.valueOrNull;
    if (current != null) {
      await _updateSettings((settings) => settings.copyWith(highContrast: !settings.highContrast));
    }
  }

  Future<void> toggleDynamicColors() async {
    final current = state.valueOrNull;
    if (current != null) {
      await _updateSettings((settings) => settings.copyWith(dynamicColors: !settings.dynamicColors));
    }
  }

  Future<void> updateFontFamily(String fontFamily) async {
    await _updateSettings((settings) => settings.copyWith(fontFamily: fontFamily));
  }

  Future<void> updateCustomColor(String colorKey, Color color) async {
    final current = state.valueOrNull;
    if (current != null) {
      final updatedColors = Map<String, int>.from(current.customColors);
      updatedColors[colorKey] = color.value;
      
      await _updateSettings((settings) => settings.copyWith(customColors: updatedColors));
    }
  }

  Future<void> toggleAnimations() async {
    final current = state.valueOrNull;
    if (current != null) {
      await _updateSettings((settings) => settings.copyWith(
        showAnimations: !settings.showAnimations,
        reduceAnimations: settings.showAnimations,
      ));
    }
  }

  Future<void> resetToDefaults() async {
    const defaultSettings = ThemeSettings();
    state = const AsyncValue.data(defaultSettings);
    
    try {
      await _repository.saveThemeSettings(defaultSettings);
    } catch (error, stackTrace) {
      await _initialize();
      rethrow;
    }
  }

  Future<void> _updateSettings(ThemeSettings Function(ThemeSettings) updater) async {
    final currentSettings = state.valueOrNull;
    if (currentSettings == null) return;

    final updatedSettings = updater(currentSettings).copyWith(
      lastModified: DateTime.now(),
    );
    
    state = AsyncValue.data(updatedSettings);

    try {
      await _repository.saveThemeSettings(updatedSettings);
    } catch (error, stackTrace) {
      state = AsyncValue.data(currentSettings);
      rethrow;
    }
  }
}

// Theme building utilities
ThemeData _getDefaultTheme(ColorScheme? systemColorScheme) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: systemColorScheme ?? ColorScheme.fromSeed(seedColor: Colors.blue),
  );
}

ThemeData _getDefaultDarkTheme(ColorScheme? systemColorScheme) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: systemColorScheme?.copyWith(brightness: Brightness.dark) ?? 
                 ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
  );
}

ThemeData _buildThemeFromSettings(ThemeSettings settings, ColorScheme? systemColorScheme) {
  ColorScheme colorScheme;
  
  if (settings.dynamicColors && systemColorScheme != null) {
    colorScheme = systemColorScheme;
  } else {
    colorScheme = _getColorSchemeByName(settings.colorScheme, Brightness.light);
  }
  
  // Apply custom colors
  if (settings.customColors.isNotEmpty) {
    colorScheme = _applyCustomColors(colorScheme, settings.customColors);
  }
  
  // Apply high contrast
  if (settings.highContrast) {
    colorScheme = _enhanceContrast(colorScheme);
  }
  
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: _getFontFamily(settings.fontFamily),
    textTheme: _buildTextTheme(settings),
    pageTransitionsTheme: _buildPageTransitions(settings),
  );
}

ThemeData _buildDarkThemeFromSettings(ThemeSettings settings, ColorScheme? systemColorScheme) {
  ColorScheme colorScheme;
  
  if (settings.dynamicColors && systemColorScheme != null) {
    colorScheme = systemColorScheme.copyWith(brightness: Brightness.dark);
  } else {
    colorScheme = _getColorSchemeByName(settings.colorScheme, Brightness.dark);
  }
  
  // Apply custom colors
  if (settings.customColors.isNotEmpty) {
    colorScheme = _applyCustomColors(colorScheme, settings.customColors);
  }
  
  // Apply high contrast
  if (settings.highContrast) {
    colorScheme = _enhanceContrast(colorScheme);
  }
  
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    fontFamily: _getFontFamily(settings.fontFamily),
    textTheme: _buildTextTheme(settings),
    pageTransitionsTheme: _buildPageTransitions(settings),
  );
}

ColorScheme _getColorSchemeByName(String name, Brightness brightness) {
  switch (name) {
    case 'green':
      return ColorScheme.fromSeed(seedColor: Colors.green, brightness: brightness);
    case 'purple':
      return ColorScheme.fromSeed(seedColor: Colors.purple, brightness: brightness);
    case 'orange':
      return ColorScheme.fromSeed(seedColor: Colors.orange, brightness: brightness);
    case 'red':
      return ColorScheme.fromSeed(seedColor: Colors.red, brightness: brightness);
    default:
      return ColorScheme.fromSeed(seedColor: Colors.blue, brightness: brightness);
  }
}

ColorScheme _applyCustomColors(ColorScheme colorScheme, Map<String, int> customColors) {
  return colorScheme.copyWith(
    primary: customColors.containsKey('primary') 
        ? Color(customColors['primary']!) 
        : colorScheme.primary,
    secondary: customColors.containsKey('secondary') 
        ? Color(customColors['secondary']!) 
        : colorScheme.secondary,
  );
}

ColorScheme _enhanceContrast(ColorScheme colorScheme) {
  return colorScheme.copyWith(
    background: colorScheme.brightness == Brightness.light 
        ? Colors.white 
        : Colors.black,
    surface: colorScheme.brightness == Brightness.light 
        ? Colors.white 
        : Colors.black,
  );
}

String? _getFontFamily(String fontFamily) {
  switch (fontFamily) {
    case 'roboto':
      return 'Roboto';
    case 'opensans':
      return 'Open Sans';
    case 'lato':
      return 'Lato';
    default:
      return null; // Use system font
  }
}

TextTheme _buildTextTheme(ThemeSettings settings) {
  return ThemeData().textTheme.apply(
    fontSizeFactor: settings.textScaleFactor,
    fontFamily: _getFontFamily(settings.fontFamily),
  );
}

PageTransitionsTheme _buildPageTransitions(ThemeSettings settings) {
  if (settings.reduceAnimations) {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    );
  }
  
  return const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );
}
