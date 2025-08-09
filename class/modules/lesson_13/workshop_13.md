# 🎯 Workshop

## 🎯 **What We're Building**

Create a **comprehensive weather application** that demonstrates advanced Bloc and Cubit patterns:
- **Event-Driven Architecture** with Bloc for complex weather state management
- **Simplified State Management** with Cubit for settings and preferences
- **Multi-Location Weather** with real-time updates and location services
- **Advanced State Patterns** with loading, success, error, and refresh states
- **Bloc-to-Bloc Communication** for coordinated features across the app
- **Offline Support** with cached data and background sync
- **Clean Architecture** separating business logic from presentation
- **Comprehensive Testing** with bloc_test and comprehensive state coverage

## ✅ **Expected Outcome**

A professional weather application featuring:
- 🌤️ **Current Weather Display** - Real-time weather with detailed metrics
- 📍 **Location-Based Weather** - Automatic location detection and manual city search
- 📊 **Weather Forecast** - 5-day forecast with hourly details
- ⚙️ **Settings Management** - Temperature units, notifications, and preferences
- 🔄 **Auto-Refresh** - Background updates and pull-to-refresh functionality
- 🧪 **Fully Tested** - Comprehensive test coverage for all Bloc and Cubit logic

## 🏗️ **Project Architecture**

We'll build a clean architecture weather application with Bloc patterns:

```
lib/
├── core/
│   ├── models/                   # 📊 Domain models
│   │   ├── weather.dart         # Weather entity with comprehensive data
│   │   ├── location.dart        # Location model with coordinates
│   │   ├── forecast.dart        # Weather forecast data
│   │   └── weather_settings.dart # User preferences and settings
│   ├── services/                # 🔧 External services
│   │   ├── weather_api_service.dart # HTTP weather API client
│   │   ├── location_service.dart    # GPS and location services
│   │   ├── storage_service.dart     # Local data persistence
│   │   └── notification_service.dart # Weather notifications
│   └── utils/
│       ├── weather_utils.dart   # Weather calculations and formatting
│       └── constants.dart       # App constants and configuration
├── blocs/                       # 🎯 Bloc state management
│   ├── weather/                 # Weather feature Bloc
│   │   ├── weather_bloc.dart    # Event-driven weather management
│   │   ├── weather_event.dart   # Weather events definition
│   │   └── weather_state.dart   # Weather states definition
│   ├── location/                # Location feature Bloc
│   │   ├── location_cubit.dart  # Simplified location management
│   │   └── location_state.dart  # Location states
│   ├── settings/                # Settings feature Cubit
│   │   ├── settings_cubit.dart  # User preferences management
│   │   └── settings_state.dart  # Settings states
│   └── forecast/                # Forecast feature Bloc
│       ├── forecast_bloc.dart   # Advanced forecast management
│       ├── forecast_event.dart  # Forecast events
│       └── forecast_state.dart  # Forecast states
├── repositories/                # 🗃️ Data access layer
│   ├── weather_repository.dart  # Weather data abstraction
│   ├── location_repository.dart # Location data abstraction
│   └── settings_repository.dart # Settings data abstraction
├── presentation/
│   ├── screens/                 # 📱 Application screens
│   │   ├── weather/             # Weather display screens
│   │   │   ├── weather_home_screen.dart
│   │   │   ├── weather_detail_screen.dart
│   │   │   └── city_search_screen.dart
│   │   ├── forecast/            # Forecast screens
│   │   │   └── forecast_screen.dart
│   │   └── settings/            # Settings and preferences
│   │       └── settings_screen.dart
│   ├── widgets/                 # 🧩 Reusable components
│   │   ├── weather_card.dart    # Current weather display
│   │   ├── forecast_item.dart   # Individual forecast item
│   │   ├── location_selector.dart # Location search and selection
│   │   ├── weather_chart.dart   # Weather data visualization
│   │   └── loading_widgets.dart # Loading states and animations
│   └── bloc_providers.dart      # Bloc dependency injection
└── main.dart                    # 🚀 Application entry point
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Core Data Models** ⏱️ *20 minutes*

Create comprehensive data models for our weather application:

```dart
// lib/core/models/weather.dart
import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final String condition;
  final String description;
  final double temperature;
  final double feelsLike;
  final double minTemperature;
  final double maxTemperature;
  final int humidity;
  final double pressure;
  final double windSpeed;
  final int windDirection;
  final double visibility;
  final int cloudiness;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime timestamp;
  final String iconCode;

  const Weather({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.condition,
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.minTemperature,
    required this.maxTemperature,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
    required this.visibility,
    required this.cloudiness,
    required this.sunrise,
    required this.sunset,
    required this.timestamp,
    required this.iconCode,
  });

  Weather copyWith({
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    String? condition,
    String? description,
    double? temperature,
    double? feelsLike,
    double? minTemperature,
    double? maxTemperature,
    int? humidity,
    double? pressure,
    double? windSpeed,
    int? windDirection,
    double? visibility,
    int? cloudiness,
    DateTime? sunrise,
    DateTime? sunset,
    DateTime? timestamp,
    String? iconCode,
  }) {
    return Weather(
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      visibility: visibility ?? this.visibility,
      cloudiness: cloudiness ?? this.cloudiness,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      timestamp: timestamp ?? this.timestamp,
      iconCode: iconCode ?? this.iconCode,
    );
  }

  // Business logic methods
  bool get isDaytime {
    final now = DateTime.now();
    return now.isAfter(sunrise) && now.isBefore(sunset);
  }

  String get windDirectionText {
    const directions = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
                       'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
    final index = ((windDirection + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }

  String get temperatureCategory {
    if (temperature < 0) return 'Freezing';
    if (temperature < 10) return 'Cold';
    if (temperature < 20) return 'Cool';
    if (temperature < 30) return 'Warm';
    return 'Hot';
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'condition': condition,
      'description': description,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'humidity': humidity,
      'pressure': pressure,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'visibility': visibility,
      'cloudiness': cloudiness,
      'sunrise': sunrise.toIso8601String(),
      'sunset': sunset.toIso8601String(),
      'timestamp': timestamp.toIso8601String(),
      'iconCode': iconCode,
    };
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['city'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      condition: json['condition'] as String,
      description: json['description'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      minTemperature: (json['minTemperature'] as num).toDouble(),
      maxTemperature: (json['maxTemperature'] as num).toDouble(),
      humidity: json['humidity'] as int,
      pressure: (json['pressure'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: json['windDirection'] as int,
      visibility: (json['visibility'] as num).toDouble(),
      cloudiness: json['cloudiness'] as int,
      sunrise: DateTime.parse(json['sunrise'] as String),
      sunset: DateTime.parse(json['sunset'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      iconCode: json['iconCode'] as String,
    );
  }

  @override
  List<Object?> get props => [
        city,
        country,
        latitude,
        longitude,
        condition,
        description,
        temperature,
        feelsLike,
        minTemperature,
        maxTemperature,
        humidity,
        pressure,
        windSpeed,
        windDirection,
        visibility,
        cloudiness,
        sunrise,
        sunset,
        timestamp,
        iconCode,
      ];

  @override
  String toString() {
    return 'Weather(city: $city, temperature: ${temperature}°C, condition: $condition)';
  }
}

// lib/core/models/location.dart
import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String? city;
  final String? country;
  final String? adminArea;
  final String? locality;
  final DateTime timestamp;

  const Location({
    required this.latitude,
    required this.longitude,
    this.city,
    this.country,
    this.adminArea,
    this.locality,
    required this.timestamp,
  });

  Location copyWith({
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    String? adminArea,
    String? locality,
    DateTime? timestamp,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      adminArea: adminArea ?? this.adminArea,
      locality: locality ?? this.locality,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  String get displayName {
    if (city != null && country != null) {
      return '$city, $country';
    } else if (locality != null && adminArea != null) {
      return '$locality, $adminArea';
    } else if (city != null) {
      return city!;
    } else {
      return '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';
    }
  }

  // Calculate distance between two locations
  double distanceTo(Location other) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final double lat1Rad = latitude * (3.14159 / 180);
    final double lat2Rad = other.latitude * (3.14159 / 180);
    final double deltaLatRad = (other.latitude - latitude) * (3.14159 / 180);
    final double deltaLonRad = (other.longitude - longitude) * (3.14159 / 180);

    final double a = (sin(deltaLatRad / 2) * sin(deltaLatRad / 2)) +
        (cos(lat1Rad) * cos(lat2Rad) * sin(deltaLonRad / 2) * sin(deltaLonRad / 2));
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'country': country,
      'adminArea': adminArea,
      'locality': locality,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      city: json['city'] as String?,
      country: json['country'] as String?,
      adminArea: json['adminArea'] as String?,
      locality: json['locality'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        city,
        country,
        adminArea,
        locality,
        timestamp,
      ];
}

// lib/core/models/forecast.dart
import 'package:equatable/equatable.dart';
import 'weather.dart';

class WeatherForecast extends Equatable {
  final String city;
  final List<DailyForecast> dailyForecasts;
  final List<HourlyForecast> hourlyForecasts;
  final DateTime lastUpdated;

  const WeatherForecast({
    required this.city,
    required this.dailyForecasts,
    required this.hourlyForecasts,
    required this.lastUpdated,
  });

  WeatherForecast copyWith({
    String? city,
    List<DailyForecast>? dailyForecasts,
    List<HourlyForecast>? hourlyForecasts,
    DateTime? lastUpdated,
  }) {
    return WeatherForecast(
      city: city ?? this.city,
      dailyForecasts: dailyForecasts ?? this.dailyForecasts,
      hourlyForecasts: hourlyForecasts ?? this.hourlyForecasts,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [city, dailyForecasts, hourlyForecasts, lastUpdated];
}

class DailyForecast extends Equatable {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final String condition;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final double precipitationChance;

  const DailyForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.precipitationChance,
  });

  @override
  List<Object?> get props => [
        date,
        maxTemperature,
        minTemperature,
        condition,
        description,
        iconCode,
        humidity,
        windSpeed,
        precipitationChance,
      ];
}

class HourlyForecast extends Equatable {
  final DateTime dateTime;
  final double temperature;
  final String condition;
  final String iconCode;
  final double precipitationChance;
  final double windSpeed;
  final int humidity;

  const HourlyForecast({
    required this.dateTime,
    required this.temperature,
    required this.condition,
    required this.iconCode,
    required this.precipitationChance,
    required this.windSpeed,
    required this.humidity,
  });

  @override
  List<Object?> get props => [
        dateTime,
        temperature,
        condition,
        iconCode,
        precipitationChance,
        windSpeed,
        humidity,
      ];
}

// lib/core/models/weather_settings.dart
import 'package:equatable/equatable.dart';

enum TemperatureUnit { celsius, fahrenheit }
enum WindSpeedUnit { kmh, mph, ms }
enum PressureUnit { hpa, mmhg, inHg }

class WeatherSettings extends Equatable {
  final TemperatureUnit temperatureUnit;
  final WindSpeedUnit windSpeedUnit;
  final PressureUnit pressureUnit;
  final bool is24HourFormat;
  final bool enableNotifications;
  final bool enableLocationServices;
  final bool enableAutoRefresh;
  final int refreshIntervalMinutes;
  final List<String> favoriteLocations;
  final String? defaultLocation;

  const WeatherSettings({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.windSpeedUnit = WindSpeedUnit.kmh,
    this.pressureUnit = PressureUnit.hpa,
    this.is24HourFormat = true,
    this.enableNotifications = true,
    this.enableLocationServices = true,
    this.enableAutoRefresh = true,
    this.refreshIntervalMinutes = 30,
    this.favoriteLocations = const [],
    this.defaultLocation,
  });

  WeatherSettings copyWith({
    TemperatureUnit? temperatureUnit,
    WindSpeedUnit? windSpeedUnit,
    PressureUnit? pressureUnit,
    bool? is24HourFormat,
    bool? enableNotifications,
    bool? enableLocationServices,
    bool? enableAutoRefresh,
    int? refreshIntervalMinutes,
    List<String>? favoriteLocations,
    String? defaultLocation,
  }) {
    return WeatherSettings(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
      pressureUnit: pressureUnit ?? this.pressureUnit,
      is24HourFormat: is24HourFormat ?? this.is24HourFormat,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableLocationServices: enableLocationServices ?? this.enableLocationServices,
      enableAutoRefresh: enableAutoRefresh ?? this.enableAutoRefresh,
      refreshIntervalMinutes: refreshIntervalMinutes ?? this.refreshIntervalMinutes,
      favoriteLocations: favoriteLocations ?? this.favoriteLocations,
      defaultLocation: defaultLocation ?? this.defaultLocation,
    );
  }

  // Unit conversion methods
  double convertTemperature(double celsius) {
    switch (temperatureUnit) {
      case TemperatureUnit.celsius:
        return celsius;
      case TemperatureUnit.fahrenheit:
        return (celsius * 9 / 5) + 32;
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

  double convertWindSpeed(double kmh) {
    switch (windSpeedUnit) {
      case WindSpeedUnit.kmh:
        return kmh;
      case WindSpeedUnit.mph:
        return kmh * 0.621371;
      case WindSpeedUnit.ms:
        return kmh / 3.6;
    }
  }

  String get windSpeedSymbol {
    switch (windSpeedUnit) {
      case WindSpeedUnit.kmh:
        return 'km/h';
      case WindSpeedUnit.mph:
        return 'mph';
      case WindSpeedUnit.ms:
        return 'm/s';
    }
  }

  double convertPressure(double hpa) {
    switch (pressureUnit) {
      case PressureUnit.hpa:
        return hpa;
      case PressureUnit.mmhg:
        return hpa * 0.750062;
      case PressureUnit.inHg:
        return hpa * 0.029530;
    }
  }

  String get pressureSymbol {
    switch (pressureUnit) {
      case PressureUnit.hpa:
        return 'hPa';
      case PressureUnit.mmhg:
        return 'mmHg';
      case PressureUnit.inHg:
        return 'inHg';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'temperatureUnit': temperatureUnit.name,
      'windSpeedUnit': windSpeedUnit.name,
      'pressureUnit': pressureUnit.name,
      'is24HourFormat': is24HourFormat,
      'enableNotifications': enableNotifications,
      'enableLocationServices': enableLocationServices,
      'enableAutoRefresh': enableAutoRefresh,
      'refreshIntervalMinutes': refreshIntervalMinutes,
      'favoriteLocations': favoriteLocations,
      'defaultLocation': defaultLocation,
    };
  }

  factory WeatherSettings.fromJson(Map<String, dynamic> json) {
    return WeatherSettings(
      temperatureUnit: TemperatureUnit.values.firstWhere(
        (unit) => unit.name == json['temperatureUnit'],
        orElse: () => TemperatureUnit.celsius,
      ),
      windSpeedUnit: WindSpeedUnit.values.firstWhere(
        (unit) => unit.name == json['windSpeedUnit'],
        orElse: () => WindSpeedUnit.kmh,
      ),
      pressureUnit: PressureUnit.values.firstWhere(
        (unit) => unit.name == json['pressureUnit'],
        orElse: () => PressureUnit.hpa,
      ),
      is24HourFormat: json['is24HourFormat'] as bool? ?? true,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableLocationServices: json['enableLocationServices'] as bool? ?? true,
      enableAutoRefresh: json['enableAutoRefresh'] as bool? ?? true,
      refreshIntervalMinutes: json['refreshIntervalMinutes'] as int? ?? 30,
      favoriteLocations: List<String>.from(json['favoriteLocations'] ?? []),
      defaultLocation: json['defaultLocation'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        temperatureUnit,
        windSpeedUnit,
        pressureUnit,
        is24HourFormat,
        enableNotifications,
        enableLocationServices,
        enableAutoRefresh,
        refreshIntervalMinutes,
        favoriteLocations,
        defaultLocation,
      ];
}
```

### **Step 2: Repository Layer** ⏱️ *25 minutes*

Implement the data access layer with clean architecture principles:

```dart
// lib/repositories/weather_repository.dart
import '../core/models/weather.dart';
import '../core/models/location.dart';
import '../core/models/forecast.dart';

abstract class WeatherRepository {
  Future<Weather> getCurrentWeather(String city);
  Future<Weather> getCurrentWeatherByLocation(Location location);
  Future<WeatherForecast> getForecast(String city);
  Future<WeatherForecast> getForecastByLocation(Location location);
  Future<List<String>> searchCities(String query);
  Stream<Weather> watchWeather(String city);
  Future<void> cacheWeather(Weather weather);
  Future<Weather?> getCachedWeather(String city);
}

// lib/repositories/weather_repository_impl.dart
import 'dart:async';
import '../core/services/weather_api_service.dart';
import '../core/services/storage_service.dart';
import '../core/models/weather.dart';
import '../core/models/location.dart';
import '../core/models/forecast.dart';
import 'weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService _apiService;
  final StorageService _storageService;
  final Map<String, StreamController<Weather>> _weatherStreams = {};

  WeatherRepositoryImpl({
    required WeatherApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  @override
  Future<Weather> getCurrentWeather(String city) async {
    try {
      final weather = await _apiService.getCurrentWeather(city);
      await cacheWeather(weather);
      
      // Emit to stream if exists
      if (_weatherStreams.containsKey(city)) {
        _weatherStreams[city]!.add(weather);
      }
      
      return weather;
    } catch (error) {
      // Try to return cached data
      final cachedWeather = await getCachedWeather(city);
      if (cachedWeather != null) {
        return cachedWeather;
      }
      rethrow;
    }
  }

  @override
  Future<Weather> getCurrentWeatherByLocation(Location location) async {
    try {
      final weather = await _apiService.getCurrentWeatherByCoordinates(
        location.latitude,
        location.longitude,
      );
      await cacheWeather(weather);
      return weather;
    } catch (error) {
      // Try to find cached weather for nearby location
      final cachedWeather = await _findNearestCachedWeather(location);
      if (cachedWeather != null) {
        return cachedWeather;
      }
      rethrow;
    }
  }

  @override
  Future<WeatherForecast> getForecast(String city) async {
    try {
      final forecast = await _apiService.getForecast(city);
      await _storageService.cacheForecast(city, forecast);
      return forecast;
    } catch (error) {
      final cachedForecast = await _storageService.getCachedForecast(city);
      if (cachedForecast != null) {
        return cachedForecast;
      }
      rethrow;
    }
  }

  @override
  Future<WeatherForecast> getForecastByLocation(Location location) async {
    try {
      final forecast = await _apiService.getForecastByCoordinates(
        location.latitude,
        location.longitude,
      );
      await _storageService.cacheForecast(location.displayName, forecast);
      return forecast;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<String>> searchCities(String query) async {
    if (query.length < 2) return [];
    
    try {
      return await _apiService.searchCities(query);
    } catch (error) {
      // Return cached search results or recent searches
      return await _storageService.getRecentSearches();
    }
  }

  @override
  Stream<Weather> watchWeather(String city) {
    if (!_weatherStreams.containsKey(city)) {
      _weatherStreams[city] = StreamController<Weather>.broadcast();
      
      // Initial data load
      getCurrentWeather(city).then((weather) {
        if (_weatherStreams.containsKey(city)) {
          _weatherStreams[city]!.add(weather);
        }
      }).catchError((error) {
        if (_weatherStreams.containsKey(city)) {
          _weatherStreams[city]!.addError(error);
        }
      });
      
      // Periodic updates
      Timer.periodic(const Duration(minutes: 15), (timer) {
        if (_weatherStreams.containsKey(city)) {
          getCurrentWeather(city).catchError((error) {
            // Ignore periodic update errors
          });
        } else {
          timer.cancel();
        }
      });
    }
    
    return _weatherStreams[city]!.stream;
  }

  @override
  Future<void> cacheWeather(Weather weather) async {
    await _storageService.cacheWeather(weather);
  }

  @override
  Future<Weather?> getCachedWeather(String city) async {
    return await _storageService.getCachedWeather(city);
  }

  Future<Weather?> _findNearestCachedWeather(Location location) async {
    final cachedWeathers = await _storageService.getAllCachedWeathers();
    
    Weather? nearest;
    double nearestDistance = double.infinity;
    
    for (final weather in cachedWeathers) {
      final weatherLocation = Location(
        latitude: weather.latitude,
        longitude: weather.longitude,
        city: weather.city,
        country: weather.country,
        timestamp: weather.timestamp,
      );
      
      final distance = location.distanceTo(weatherLocation);
      if (distance < nearestDistance && distance < 50) { // Within 50km
        nearest = weather;
        nearestDistance = distance;
      }
    }
    
    return nearest;
  }

  void dispose() {
    for (final controller in _weatherStreams.values) {
      controller.close();
    }
    _weatherStreams.clear();
  }
}

// lib/repositories/location_repository.dart
import '../core/models/location.dart';

abstract class LocationRepository {
  Future<Location> getCurrentLocation();
  Future<List<Location>> searchLocations(String query);
  Future<Location> getLocationFromCoordinates(double latitude, double longitude);
  Stream<Location> watchLocation();
  Future<bool> hasLocationPermission();
  Future<bool> requestLocationPermission();
}

// lib/repositories/settings_repository.dart
import '../core/models/weather_settings.dart';

abstract class SettingsRepository {
  Future<WeatherSettings> getSettings();
  Future<void> saveSettings(WeatherSettings settings);
  Future<void> resetSettings();
  Stream<WeatherSettings> watchSettings();
}
```

*This is part 1 of the workshop. Continue with the remaining steps to build the complete Bloc weather application...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_13

# Install dependencies
flutter pub get
flutter pub add flutter_bloc
flutter pub add bloc_test
flutter pub add equatable
flutter pub add geolocator
flutter pub add http

# Run the app
flutter run

# Test Bloc patterns
# 1. Test weather loading with different cities
# 2. Try location-based weather detection
# 3. Test offline scenarios and cached data
# 4. Verify settings persistence and unit conversions
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **Bloc Pattern Fundamentals** - Understanding event-driven architecture and business logic separation
- **Cubit Simplification** - Using Cubit for simpler state management scenarios
- **Event-Driven Architecture** - Designing applications around events and state transitions
- **Business Logic Separation** - Clear separation between UI and business logic layers
- **Complex State Management** - Handling sophisticated application states with multiple flows
- **Testing Excellence** - Comprehensive testing strategies for Bloc-based applications

**Ready to master event-driven architecture with Bloc and Cubit? 🎯✨**