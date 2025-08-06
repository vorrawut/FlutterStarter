import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/weather_settings.dart';

class SettingsCubit extends Cubit<WeatherSettings> {
  SettingsCubit() : super(const WeatherSettings()) {
    _loadSettings();
  }

  static const String _settingsKey = 'weather_settings';

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      
      if (settingsJson != null) {
        final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
        final settings = WeatherSettings.fromJson(settingsMap);
        emit(settings);
      }
    } catch (error) {
      // If loading fails, keep default settings
      print('Error loading settings: $error');
    }
  }

  Future<void> _saveSettings(WeatherSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(settings.toJson());
      await prefs.setString(_settingsKey, settingsJson);
    } catch (error) {
      print('Error saving settings: $error');
    }
  }

  void updateTemperatureUnit(TemperatureUnit unit) {
    final updatedSettings = state.copyWith(temperatureUnit: unit);
    emit(updatedSettings);
    _saveSettings(updatedSettings);
  }

  void updateWindSpeedUnit(WindSpeedUnit unit) {
    final updatedSettings = state.copyWith(windSpeedUnit: unit);
    emit(updatedSettings);
    _saveSettings(updatedSettings);
  }

  void updatePressureUnit(PressureUnit unit) {
    final updatedSettings = state.copyWith(pressureUnit: unit);
    emit(updatedSettings);
    _saveSettings(updatedSettings);
  }

  void toggleAutoRefresh() {
    final updatedSettings = state.copyWith(autoRefresh: !state.autoRefresh);
    emit(updatedSettings);
    _saveSettings(updatedSettings);
  }

  void updateRefreshInterval(int minutes) {
    final updatedSettings = state.copyWith(refreshIntervalMinutes: minutes);
    emit(updatedSettings);
    _saveSettings(updatedSettings);
  }

  void toggleNotifications() {
    final updatedSettings = state.copyWith(showNotifications: !state.showNotifications);
    emit(updatedSettings);
    _saveSettings(updatedSettings);
  }

  void toggleDarkMode() {
    final updatedSettings = state.copyWith(useDarkMode: !state.useDarkMode);
    emit(updatedSettings);
    _saveSettings(updatedSettings);
  }

  void toggleCurrentLocation() {
    final updatedSettings = state.copyWith(useCurrentLocation: !state.useCurrentLocation);
    emit(updatedSettings);
    _saveSettings(updatedSettings);
  }

  void resetToDefaults() {
    const defaultSettings = WeatherSettings();
    emit(defaultSettings);
    _saveSettings(defaultSettings);
  }

  void updateSettings(WeatherSettings settings) {
    emit(settings);
    _saveSettings(settings);
  }

  // Helper methods for formatted values
  String formatTemperature(double celsius) {
    final converted = state.convertTemperature(celsius);
    return '${converted.round()}${state.temperatureSymbol}';
  }

  String formatWindSpeed(double metersPerSecond) {
    final converted = state.convertWindSpeed(metersPerSecond);
    return '${converted.toStringAsFixed(1)} ${state.windSpeedSymbol}';
  }

  String formatPressure(double hpa) {
    final converted = state.convertPressure(hpa);
    return '${converted.toStringAsFixed(converted >= 100 ? 0 : 1)} ${state.pressureSymbol}';
  }
}