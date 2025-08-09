import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class ThemeSettings extends Equatable {
  final ThemeMode themeMode;
  final String colorScheme;
  final double textScaleFactor;
  final bool highContrast;
  final bool dynamicColors;
  final String fontFamily;
  final Map<String, int> customColors;
  final bool reduceAnimations;
  final bool showAnimations;
  final String locale;
  final DateTime? lastModified;

  const ThemeSettings({
    this.themeMode = ThemeMode.system,
    this.colorScheme = 'material',
    this.textScaleFactor = 1.0,
    this.highContrast = false,
    this.dynamicColors = true,
    this.fontFamily = 'system',
    this.customColors = const {},
    this.reduceAnimations = false,
    this.showAnimations = true,
    this.locale = 'en',
    this.lastModified,
  });

  ThemeSettings copyWith({
    ThemeMode? themeMode,
    String? colorScheme,
    double? textScaleFactor,
    bool? highContrast,
    bool? dynamicColors,
    String? fontFamily,
    Map<String, int>? customColors,
    bool? reduceAnimations,
    bool? showAnimations,
    String? locale,
    DateTime? lastModified,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      colorScheme: colorScheme ?? this.colorScheme,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      highContrast: highContrast ?? this.highContrast,
      dynamicColors: dynamicColors ?? this.dynamicColors,
      fontFamily: fontFamily ?? this.fontFamily,
      customColors: customColors ?? this.customColors,
      reduceAnimations: reduceAnimations ?? this.reduceAnimations,
      showAnimations: showAnimations ?? this.showAnimations,
      locale: locale ?? this.locale,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'colorScheme': colorScheme,
      'textScaleFactor': textScaleFactor,
      'highContrast': highContrast,
      'dynamicColors': dynamicColors,
      'fontFamily': fontFamily,
      'customColors': customColors,
      'reduceAnimations': reduceAnimations,
      'showAnimations': showAnimations,
      'locale': locale,
      'lastModified': lastModified?.toIso8601String(),
    };
  }

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 0],
      colorScheme: json['colorScheme'] as String? ?? 'material',
      textScaleFactor: (json['textScaleFactor'] as num?)?.toDouble() ?? 1.0,
      highContrast: json['highContrast'] as bool? ?? false,
      dynamicColors: json['dynamicColors'] as bool? ?? true,
      fontFamily: json['fontFamily'] as String? ?? 'system',
      customColors: Map<String, int>.from(json['customColors'] as Map? ?? {}),
      reduceAnimations: json['reduceAnimations'] as bool? ?? false,
      showAnimations: json['showAnimations'] as bool? ?? true,
      locale: json['locale'] as String? ?? 'en',
      lastModified: json['lastModified'] != null 
          ? DateTime.parse(json['lastModified'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        colorScheme,
        textScaleFactor,
        highContrast,
        dynamicColors,
        fontFamily,
        customColors,
        reduceAnimations,
        showAnimations,
        locale,
        lastModified,
      ];
}
