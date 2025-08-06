import 'package:equatable/equatable.dart';

enum TemperatureUnit { celsius, fahrenheit }
enum WindSpeedUnit { metersPerSecond, milesPerHour, kilometersPerHour }
enum PressureUnit { hpa, inHg, mmHg }

class WeatherSettings extends Equatable {
  final TemperatureUnit temperatureUnit;
  final WindSpeedUnit windSpeedUnit;
  final PressureUnit pressureUnit;
  final bool autoRefresh;
  final int refreshIntervalMinutes;
  final bool showNotifications;
  final bool useDarkMode;
  final bool useCurrentLocation;

  const WeatherSettings({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.windSpeedUnit = WindSpeedUnit.metersPerSecond,
    this.pressureUnit = PressureUnit.hpa,
    this.autoRefresh = true,
    this.refreshIntervalMinutes = 30,
    this.showNotifications = true,
    this.useDarkMode = false,
    this.useCurrentLocation = true,
  });

  WeatherSettings copyWith({
    TemperatureUnit? temperatureUnit,
    WindSpeedUnit? windSpeedUnit,
    PressureUnit? pressureUnit,
    bool? autoRefresh,
    int? refreshIntervalMinutes,
    bool? showNotifications,
    bool? useDarkMode,
    bool? useCurrentLocation,
  }) {
    return WeatherSettings(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
      pressureUnit: pressureUnit ?? this.pressureUnit,
      autoRefresh: autoRefresh ?? this.autoRefresh,
      refreshIntervalMinutes: refreshIntervalMinutes ?? this.refreshIntervalMinutes,
      showNotifications: showNotifications ?? this.showNotifications,
      useDarkMode: useDarkMode ?? this.useDarkMode,
      useCurrentLocation: useCurrentLocation ?? this.useCurrentLocation,
    );
  }

  factory WeatherSettings.fromJson(Map<String, dynamic> json) {
    return WeatherSettings(
      temperatureUnit: TemperatureUnit.values.firstWhere(
        (unit) => unit.name == json['temperatureUnit'],
        orElse: () => TemperatureUnit.celsius,
      ),
      windSpeedUnit: WindSpeedUnit.values.firstWhere(
        (unit) => unit.name == json['windSpeedUnit'],
        orElse: () => WindSpeedUnit.metersPerSecond,
      ),
      pressureUnit: PressureUnit.values.firstWhere(
        (unit) => unit.name == json['pressureUnit'],
        orElse: () => PressureUnit.hpa,
      ),
      autoRefresh: json['autoRefresh'] as bool? ?? true,
      refreshIntervalMinutes: json['refreshIntervalMinutes'] as int? ?? 30,
      showNotifications: json['showNotifications'] as bool? ?? true,
      useDarkMode: json['useDarkMode'] as bool? ?? false,
      useCurrentLocation: json['useCurrentLocation'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperatureUnit': temperatureUnit.name,
      'windSpeedUnit': windSpeedUnit.name,
      'pressureUnit': pressureUnit.name,
      'autoRefresh': autoRefresh,
      'refreshIntervalMinutes': refreshIntervalMinutes,
      'showNotifications': showNotifications,
      'useDarkMode': useDarkMode,
      'useCurrentLocation': useCurrentLocation,
    };
  }

  // Helper methods for unit conversions
  double convertTemperature(double celsius) {
    switch (temperatureUnit) {
      case TemperatureUnit.celsius:
        return celsius;
      case TemperatureUnit.fahrenheit:
        return (celsius * 9 / 5) + 32;
    }
  }

  double convertWindSpeed(double metersPerSecond) {
    switch (windSpeedUnit) {
      case WindSpeedUnit.metersPerSecond:
        return metersPerSecond;
      case WindSpeedUnit.milesPerHour:
        return metersPerSecond * 2.237;
      case WindSpeedUnit.kilometersPerHour:
        return metersPerSecond * 3.6;
    }
  }

  double convertPressure(double hpa) {
    switch (pressureUnit) {
      case PressureUnit.hpa:
        return hpa;
      case PressureUnit.inHg:
        return hpa * 0.02953;
      case PressureUnit.mmHg:
        return hpa * 0.75006;
    }
  }

  String get temperatureSymbol {
    switch (temperatureUnit) {
      case TemperatureUnit.celsius:
        return '°C';
      case TemperatureUnit.fahrenheit:
        return '°F';
    }
  }

  String get windSpeedSymbol {
    switch (windSpeedUnit) {
      case WindSpeedUnit.metersPerSecond:
        return 'm/s';
      case WindSpeedUnit.milesPerHour:
        return 'mph';
      case WindSpeedUnit.kilometersPerHour:
        return 'km/h';
    }
  }

  String get pressureSymbol {
    switch (pressureUnit) {
      case PressureUnit.hpa:
        return 'hPa';
      case PressureUnit.inHg:
        return 'inHg';
      case PressureUnit.mmHg:
        return 'mmHg';
    }
  }

  @override
  List<Object> get props => [
        temperatureUnit,
        windSpeedUnit,
        pressureUnit,
        autoRefresh,
        refreshIntervalMinutes,
        showNotifications,
        useDarkMode,
        useCurrentLocation,
      ];
}