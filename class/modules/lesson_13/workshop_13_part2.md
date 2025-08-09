# 🎯 Workshop (Part 2)

## **Step 3: Bloc & Cubit Implementation** ⏱️ *35 minutes*

Implement comprehensive Bloc and Cubit patterns for weather state management:

```dart
// lib/blocs/weather/weather_event.dart
import 'package:equatable/equatable.dart';
import '../../core/models/location.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class WeatherRequested extends WeatherEvent {
  final String city;

  const WeatherRequested(this.city);

  @override
  List<Object> get props => [city];
}

class WeatherLocationRequested extends WeatherEvent {
  final Location location;

  const WeatherLocationRequested(this.location);

  @override
  List<Object> get props => [location];
}

class WeatherRefreshed extends WeatherEvent {}

class WeatherCleared extends WeatherEvent {}

class WeatherAutoRefreshToggled extends WeatherEvent {
  final bool enabled;

  const WeatherAutoRefreshToggled(this.enabled);

  @override
  List<Object> get props => [enabled];
}

// lib/blocs/weather/weather_state.dart
import 'package:equatable/equatable.dart';
import '../../core/models/weather.dart';

enum WeatherStatus { initial, loading, success, failure }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather? weather;
  final String? errorMessage;
  final DateTime? lastUpdated;
  final bool isRefreshing;
  final bool autoRefreshEnabled;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.weather,
    this.errorMessage,
    this.lastUpdated,
    this.isRefreshing = false,
    this.autoRefreshEnabled = true,
  });

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    String? errorMessage,
    DateTime? lastUpdated,
    bool? isRefreshing,
    bool? autoRefreshEnabled,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      errorMessage: errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      autoRefreshEnabled: autoRefreshEnabled ?? this.autoRefreshEnabled,
    );
  }

  @override
  List<Object?> get props => [
        status,
        weather,
        errorMessage,
        lastUpdated,
        isRefreshing,
        autoRefreshEnabled,
      ];
}

// lib/blocs/weather/weather_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/weather_repository.dart';
import '../../core/models/weather.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;
  Timer? _autoRefreshTimer;
  StreamSubscription<Weather>? _weatherStreamSubscription;

  WeatherBloc({
    required WeatherRepository weatherRepository,
  })  : _weatherRepository = weatherRepository,
        super(const WeatherState()) {
    
    on<WeatherRequested>(_onWeatherRequested);
    on<WeatherLocationRequested>(_onWeatherLocationRequested);
    on<WeatherRefreshed>(_onWeatherRefreshed);
    on<WeatherCleared>(_onWeatherCleared);
    on<WeatherAutoRefreshToggled>(_onWeatherAutoRefreshToggled);
  }

  Future<void> _onWeatherRequested(
    WeatherRequested event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather = await _weatherRepository.getCurrentWeather(event.city);
      emit(state.copyWith(
        status: WeatherStatus.success,
        weather: weather,
        lastUpdated: DateTime.now(),
        errorMessage: null,
      ));

      _startAutoRefresh(event.city);
    } catch (error) {
      emit(state.copyWith(
        status: WeatherStatus.failure,
        errorMessage: _formatError(error),
      ));
    }
  }

  Future<void> _onWeatherLocationRequested(
    WeatherLocationRequested event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather = await _weatherRepository.getCurrentWeatherByLocation(event.location);
      emit(state.copyWith(
        status: WeatherStatus.success,
        weather: weather,
        lastUpdated: DateTime.now(),
        errorMessage: null,
      ));

      _startAutoRefresh(weather.city);
    } catch (error) {
      emit(state.copyWith(
        status: WeatherStatus.failure,
        errorMessage: _formatError(error),
      ));
    }
  }

  Future<void> _onWeatherRefreshed(
    WeatherRefreshed event,
    Emitter<WeatherState> emit,
  ) async {
    if (state.weather == null) return;

    emit(state.copyWith(isRefreshing: true));

    try {
      final weather = await _weatherRepository.getCurrentWeather(state.weather!.city);
      emit(state.copyWith(
        weather: weather,
        lastUpdated: DateTime.now(),
        isRefreshing: false,
        errorMessage: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        isRefreshing: false,
        errorMessage: _formatError(error),
      ));
    }
  }

  void _onWeatherCleared(
    WeatherCleared event,
    Emitter<WeatherState> emit,
  ) {
    _stopAutoRefresh();
    emit(const WeatherState());
  }

  void _onWeatherAutoRefreshToggled(
    WeatherAutoRefreshToggled event,
    Emitter<WeatherState> emit,
  ) {
    emit(state.copyWith(autoRefreshEnabled: event.enabled));
    
    if (event.enabled && state.weather != null) {
      _startAutoRefresh(state.weather!.city);
    } else {
      _stopAutoRefresh();
    }
  }

  void _startAutoRefresh(String city) {
    _stopAutoRefresh();
    
    if (!state.autoRefreshEnabled) return;

    _autoRefreshTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => add(WeatherRefreshed()),
    );

    // Also listen to weather stream for real-time updates
    _weatherStreamSubscription?.cancel();
    _weatherStreamSubscription = _weatherRepository.watchWeather(city).listen(
      (weather) {
        if (state.status == WeatherStatus.success && 
            state.weather?.timestamp != weather.timestamp) {
          emit(state.copyWith(
            weather: weather,
            lastUpdated: DateTime.now(),
          ));
        }
      },
      onError: (error) {
        // Handle stream errors gracefully
      },
    );
  }

  void _stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
    _weatherStreamSubscription?.cancel();
    _weatherStreamSubscription = null;
  }

  String _formatError(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'No internet connection. Showing cached data.';
    } else if (error.toString().contains('404')) {
      return 'City not found. Please check the spelling.';
    } else if (error.toString().contains('401')) {
      return 'API key invalid. Please contact support.';
    } else {
      return 'Failed to load weather data. Please try again.';
    }
  }

  @override
  Future<void> close() {
    _stopAutoRefresh();
    return super.close();
  }
}

// lib/blocs/location/location_state.dart
import 'package:equatable/equatable.dart';
import '../../core/models/location.dart';

enum LocationStatus { initial, loading, success, failure, disabled }

class LocationState extends Equatable {
  final LocationStatus status;
  final Location? location;
  final String? errorMessage;
  final bool hasPermission;

  const LocationState({
    this.status = LocationStatus.initial,
    this.location,
    this.errorMessage,
    this.hasPermission = false,
  });

  LocationState copyWith({
    LocationStatus? status,
    Location? location,
    String? errorMessage,
    bool? hasPermission,
  }) {
    return LocationState(
      status: status ?? this.status,
      location: location ?? this.location,
      errorMessage: errorMessage,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }

  @override
  List<Object?> get props => [status, location, errorMessage, hasPermission];
}

// lib/blocs/location/location_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/location_repository.dart';
import '../../core/models/location.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _locationRepository;
  StreamSubscription<Location>? _locationStreamSubscription;

  LocationCubit({
    required LocationRepository locationRepository,
  })  : _locationRepository = locationRepository,
        super(const LocationState());

  Future<void> getCurrentLocation() async {
    emit(state.copyWith(status: LocationStatus.loading));

    try {
      final hasPermission = await _locationRepository.hasLocationPermission();
      if (!hasPermission) {
        final permissionGranted = await _locationRepository.requestLocationPermission();
        if (!permissionGranted) {
          emit(state.copyWith(
            status: LocationStatus.disabled,
            errorMessage: 'Location permission denied',
            hasPermission: false,
          ));
          return;
        }
      }

      final location = await _locationRepository.getCurrentLocation();
      emit(state.copyWith(
        status: LocationStatus.success,
        location: location,
        hasPermission: true,
        errorMessage: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocationStatus.failure,
        errorMessage: _formatLocationError(error),
      ));
    }
  }

  Future<void> startLocationTracking() async {
    if (!state.hasPermission) {
      await getCurrentLocation();
      return;
    }

    _locationStreamSubscription?.cancel();
    _locationStreamSubscription = _locationRepository.watchLocation().listen(
      (location) {
        emit(state.copyWith(
          status: LocationStatus.success,
          location: location,
        ));
      },
      onError: (error) {
        emit(state.copyWith(
          status: LocationStatus.failure,
          errorMessage: _formatLocationError(error),
        ));
      },
    );
  }

  void stopLocationTracking() {
    _locationStreamSubscription?.cancel();
    _locationStreamSubscription = null;
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) return;

    emit(state.copyWith(status: LocationStatus.loading));

    try {
      final locations = await _locationRepository.searchLocations(query);
      if (locations.isNotEmpty) {
        emit(state.copyWith(
          status: LocationStatus.success,
          location: locations.first,
          errorMessage: null,
        ));
      } else {
        emit(state.copyWith(
          status: LocationStatus.failure,
          errorMessage: 'No locations found for "$query"',
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: LocationStatus.failure,
        errorMessage: _formatLocationError(error),
      ));
    }
  }

  String _formatLocationError(dynamic error) {
    if (error.toString().contains('PermissionDenied')) {
      return 'Location permission denied. Please enable location services.';
    } else if (error.toString().contains('ServiceDisabled')) {
      return 'Location services are disabled. Please enable in settings.';
    } else if (error.toString().contains('Timeout')) {
      return 'Location request timed out. Please try again.';
    } else {
      return 'Failed to get location. Please try again.';
    }
  }

  @override
  Future<void> close() {
    stopLocationTracking();
    return super.close();
  }
}

// lib/blocs/settings/settings_state.dart
import 'package:equatable/equatable.dart';
import '../../core/models/weather_settings.dart';

class SettingsState extends Equatable {
  final WeatherSettings settings;
  final bool isLoading;
  final String? errorMessage;

  const SettingsState({
    required this.settings,
    this.isLoading = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    WeatherSettings? settings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [settings, isLoading, errorMessage];
}

// lib/blocs/settings/settings_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/settings_repository.dart';
import '../../core/models/weather_settings.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsCubit({
    required SettingsRepository settingsRepository,
  })  : _settingsRepository = settingsRepository,
        super(SettingsState(settings: const WeatherSettings())) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    emit(state.copyWith(isLoading: true));

    try {
      final settings = await _settingsRepository.getSettings();
      emit(state.copyWith(
        settings: settings,
        isLoading: false,
        errorMessage: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load settings: $error',
      ));
    }
  }

  Future<void> updateTemperatureUnit(TemperatureUnit unit) async {
    final updatedSettings = state.settings.copyWith(temperatureUnit: unit);
    await _updateSettings(updatedSettings);
  }

  Future<void> updateWindSpeedUnit(WindSpeedUnit unit) async {
    final updatedSettings = state.settings.copyWith(windSpeedUnit: unit);
    await _updateSettings(updatedSettings);
  }

  Future<void> updatePressureUnit(PressureUnit unit) async {
    final updatedSettings = state.settings.copyWith(pressureUnit: unit);
    await _updateSettings(updatedSettings);
  }

  Future<void> toggleNotifications() async {
    final updatedSettings = state.settings.copyWith(
      enableNotifications: !state.settings.enableNotifications,
    );
    await _updateSettings(updatedSettings);
  }

  Future<void> toggleLocationServices() async {
    final updatedSettings = state.settings.copyWith(
      enableLocationServices: !state.settings.enableLocationServices,
    );
    await _updateSettings(updatedSettings);
  }

  Future<void> toggleAutoRefresh() async {
    final updatedSettings = state.settings.copyWith(
      enableAutoRefresh: !state.settings.enableAutoRefresh,
    );
    await _updateSettings(updatedSettings);
  }

  Future<void> updateRefreshInterval(int minutes) async {
    final updatedSettings = state.settings.copyWith(
      refreshIntervalMinutes: minutes,
    );
    await _updateSettings(updatedSettings);
  }

  Future<void> addFavoriteLocation(String location) async {
    final favoriteLocations = List<String>.from(state.settings.favoriteLocations);
    if (!favoriteLocations.contains(location)) {
      favoriteLocations.add(location);
      final updatedSettings = state.settings.copyWith(
        favoriteLocations: favoriteLocations,
      );
      await _updateSettings(updatedSettings);
    }
  }

  Future<void> removeFavoriteLocation(String location) async {
    final favoriteLocations = List<String>.from(state.settings.favoriteLocations);
    favoriteLocations.remove(location);
    final updatedSettings = state.settings.copyWith(
      favoriteLocations: favoriteLocations,
    );
    await _updateSettings(updatedSettings);
  }

  Future<void> setDefaultLocation(String? location) async {
    final updatedSettings = state.settings.copyWith(
      defaultLocation: location,
    );
    await _updateSettings(updatedSettings);
  }

  Future<void> resetSettings() async {
    emit(state.copyWith(isLoading: true));

    try {
      await _settingsRepository.resetSettings();
      final defaultSettings = const WeatherSettings();
      emit(state.copyWith(
        settings: defaultSettings,
        isLoading: false,
        errorMessage: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to reset settings: $error',
      ));
    }
  }

  Future<void> _updateSettings(WeatherSettings settings) async {
    try {
      await _settingsRepository.saveSettings(settings);
      emit(state.copyWith(
        settings: settings,
        errorMessage: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        errorMessage: 'Failed to save settings: $error',
      ));
    }
  }
}
```

## **Step 4: Advanced UI Components** ⏱️ *40 minutes*

Build sophisticated UI components using Bloc patterns:

```dart
// lib/presentation/widgets/weather_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/models/weather.dart';
import '../../core/models/weather_settings.dart';
import '../../blocs/settings/settings_cubit.dart';
import '../../blocs/settings/settings_state.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final VoidCallback? onRefresh;
  final bool isRefreshing;

  const WeatherCard({
    super.key,
    required this.weather,
    this.onRefresh,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: _getWeatherGradient(weather.condition),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, settingsState.settings),
                  const SizedBox(height: 16),
                  _buildMainWeatherInfo(context, settingsState.settings),
                  const SizedBox(height: 16),
                  _buildWeatherDetails(context, settingsState.settings),
                  const SizedBox(height: 12),
                  _buildSunriseSunset(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, WeatherSettings settings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weather.city,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              weather.country,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isRefreshing)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            Text(
              _formatLastUpdated(weather.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainWeatherInfo(BuildContext context, WeatherSettings settings) {
    final displayTemp = settings.convertTemperature(weather.temperature);
    final feelsLikeTemp = settings.convertTemperature(weather.feelsLike);
    
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${displayTemp.round()}${settings.temperatureSymbol}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                'Feels like ${feelsLikeTemp.round()}${settings.temperatureSymbol}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                weather.description.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            _buildWeatherIcon(weather.iconCode, weather.isDaytime),
            const SizedBox(height: 8),
            Text(
              'H: ${settings.convertTemperature(weather.maxTemperature).round()}° L: ${settings.convertTemperature(weather.minTemperature).round()}°',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherDetails(BuildContext context, WeatherSettings settings) {
    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            context,
            Icons.water_drop,
            'Humidity',
            '${weather.humidity}%',
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            context,
            Icons.air,
            'Wind',
            '${settings.convertWindSpeed(weather.windSpeed).round()} ${settings.windSpeedSymbol}',
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            context,
            Icons.compress,
            'Pressure',
            '${settings.convertPressure(weather.pressure).round()} ${settings.pressureSymbol}',
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            context,
            Icons.visibility,
            'Visibility',
            '${weather.visibility.round()} km',
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildSunriseSunset(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            const Icon(Icons.wb_sunny, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sunrise',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                Text(
                  _formatTime(weather.sunrise),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.nights_stay, color: Colors.indigo, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sunset',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                Text(
                  _formatTime(weather.sunset),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherIcon(String iconCode, bool isDaytime) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: Icon(
        _getWeatherIconData(iconCode, isDaytime),
        size: 40,
        color: Colors.white,
      ),
    );
  }

  LinearGradient _getWeatherGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF74b9ff), Color(0xFF0984e3)],
        );
      case 'clouds':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF636e72), Color(0xFF2d3436)],
        );
      case 'rain':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF74b9ff), Color(0xFF0984e3)],
        );
      case 'snow':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFddd6fe), Color(0xFFa855f7)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF74b9ff), Color(0xFF0984e3)],
        );
    }
  }

  IconData _getWeatherIconData(String iconCode, bool isDaytime) {
    // Simplified icon mapping - in a real app, use weather-specific icon fonts
    switch (iconCode.substring(0, 2)) {
      case '01': // clear sky
        return isDaytime ? Icons.wb_sunny : Icons.nights_stay;
      case '02': // few clouds
      case '03': // scattered clouds
      case '04': // broken clouds
        return isDaytime ? Icons.wb_cloudy : Icons.cloud;
      case '09': // shower rain
      case '10': // rain
        return Icons.umbrella;
      case '11': // thunderstorm
        return Icons.flash_on;
      case '13': // snow
        return Icons.ac_unit;
      case '50': // mist
        return Icons.foggy;
      default:
        return Icons.wb_sunny;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatLastUpdated(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

// lib/presentation/screens/weather/weather_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/weather/weather_bloc.dart';
import '../../../blocs/weather/weather_event.dart';
import '../../../blocs/weather/weather_state.dart';
import '../../../blocs/location/location_cubit.dart';
import '../../../blocs/location/location_state.dart';
import '../../widgets/weather_card.dart';
import 'city_search_screen.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadInitialWeather();
  }

  void _loadInitialWeather() {
    // Try to get location-based weather first
    context.read<LocationCubit>().getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _navigateToSearch(),
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () => _getCurrentLocationWeather(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LocationCubit, LocationState>(
            listenWhen: (previous, current) => 
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == LocationStatus.success && state.location != null) {
                context.read<WeatherBloc>().add(
                  WeatherLocationRequested(state.location!),
                );
              } else if (state.status == LocationStatus.failure) {
                // Fallback to default city
                context.read<WeatherBloc>().add(
                  const WeatherRequested('London'),
                );
              }
            },
          ),
          BlocListener<WeatherBloc, WeatherState>(
            listenWhen: (previous, current) => 
                previous.errorMessage != current.errorMessage,
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'Retry',
                      onPressed: () {
                        context.read<WeatherBloc>().add(WeatherRefreshed());
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<WeatherBloc>().add(WeatherRefreshed());
          },
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              switch (state.status) {
                case WeatherStatus.initial:
                  return _buildInitialView();
                case WeatherStatus.loading:
                  return _buildLoadingView();
                case WeatherStatus.success:
                  return _buildWeatherView(state);
                case WeatherStatus.failure:
                  return _buildErrorView(state);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInitialView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wb_cloudy, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Welcome to Weather App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Getting your location...'),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading weather data...'),
        ],
      ),
    );
  }

  Widget _buildWeatherView(WeatherState state) {
    return ListView(
      children: [
        WeatherCard(
          weather: state.weather!,
          onRefresh: () {
            context.read<WeatherBloc>().add(WeatherRefreshed());
          },
          isRefreshing: state.isRefreshing,
        ),
        _buildQuickActions(),
        _buildRecentLocations(),
      ],
    );
  }

  Widget _buildErrorView(WeatherState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage ?? 'Unknown error occurred',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<WeatherBloc>().add(WeatherRefreshed());
                  },
                  child: const Text('Retry'),
                ),
                OutlinedButton(
                  onPressed: _navigateToSearch,
                  child: const Text('Search City'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _navigateToForecast,
              icon: const Icon(Icons.calendar_today),
              label: const Text('5-Day Forecast'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _getCurrentLocationWeather,
              icon: const Icon(Icons.my_location),
              label: const Text('My Location'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLocations() {
    // In a real app, this would come from settings or stored searches
    final recentLocations = ['New York', 'Tokyo', 'London', 'Paris'];
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Locations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentLocations.length,
              itemBuilder: (context, index) {
                final city = recentLocations[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(city),
                    onPressed: () {
                      context.read<WeatherBloc>().add(WeatherRequested(city));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CitySearchScreen()),
    );
  }

  void _navigateToForecast() {
    // Navigate to forecast screen
  }

  void _navigateToSettings() {
    // Navigate to settings screen
  }

  void _getCurrentLocationWeather() {
    context.read<LocationCubit>().getCurrentLocation();
  }
}
```

## **Step 5: Comprehensive Testing** ⏱️ *30 minutes*

Implement advanced testing patterns for Bloc applications:

```dart
// test/blocs/weather_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../lib/blocs/weather/weather_bloc.dart';
import '../lib/blocs/weather/weather_event.dart';
import '../lib/blocs/weather/weather_state.dart';
import '../lib/repositories/weather_repository.dart';
import '../lib/core/models/weather.dart';
import '../lib/core/models/location.dart';

@GenerateMocks([WeatherRepository])
import 'weather_bloc_test.mocks.dart';

void main() {
  group('WeatherBloc', () {
    late WeatherRepository mockWeatherRepository;
    late WeatherBloc weatherBloc;
    late Weather mockWeather;
    late Location mockLocation;

    setUp(() {
      mockWeatherRepository = MockWeatherRepository();
      weatherBloc = WeatherBloc(weatherRepository: mockWeatherRepository);
      
      mockWeather = Weather(
        city: 'London',
        country: 'UK',
        latitude: 51.5074,
        longitude: -0.1278,
        condition: 'Clear',
        description: 'clear sky',
        temperature: 20.0,
        feelsLike: 22.0,
        minTemperature: 18.0,
        maxTemperature: 24.0,
        humidity: 65,
        pressure: 1013.25,
        windSpeed: 10.0,
        windDirection: 180,
        visibility: 10.0,
        cloudiness: 0,
        sunrise: DateTime.now().subtract(const Duration(hours: 6)),
        sunset: DateTime.now().add(const Duration(hours: 6)),
        timestamp: DateTime.now(),
        iconCode: '01d',
      );
      
      mockLocation = Location(
        latitude: 51.5074,
        longitude: -0.1278,
        city: 'London',
        country: 'UK',
        timestamp: DateTime.now(),
      );
    });

    tearDown(() {
      weatherBloc.close();
    });

    test('initial state is correct', () {
      expect(weatherBloc.state, const WeatherState());
    });

    group('WeatherRequested', () {
      blocTest<WeatherBloc, WeatherState>(
        'emits [loading, success] when weather request succeeds',
        build: () {
          when(mockWeatherRepository.getCurrentWeather(any))
              .thenAnswer((_) async => mockWeather);
          return weatherBloc;
        },
        act: (bloc) => bloc.add(const WeatherRequested('London')),
        expect: () => [
          const WeatherState(status: WeatherStatus.loading),
          WeatherState(
            status: WeatherStatus.success,
            weather: mockWeather,
            lastUpdated: any,
          ),
        ],
        verify: (_) {
          verify(mockWeatherRepository.getCurrentWeather('London')).called(1);
        },
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits [loading, failure] when weather request fails',
        build: () {
          when(mockWeatherRepository.getCurrentWeather(any))
              .thenThrow(Exception('Network error'));
          return weatherBloc;
        },
        act: (bloc) => bloc.add(const WeatherRequested('InvalidCity')),
        expect: () => [
          const WeatherState(status: WeatherStatus.loading),
          const WeatherState(
            status: WeatherStatus.failure,
            errorMessage: 'Failed to load weather data. Please try again.',
          ),
        ],
      );
    });

    group('WeatherLocationRequested', () {
      blocTest<WeatherBloc, WeatherState>(
        'emits [loading, success] when location weather request succeeds',
        build: () {
          when(mockWeatherRepository.getCurrentWeatherByLocation(any))
              .thenAnswer((_) async => mockWeather);
          return weatherBloc;
        },
        act: (bloc) => bloc.add(WeatherLocationRequested(mockLocation)),
        expect: () => [
          const WeatherState(status: WeatherStatus.loading),
          WeatherState(
            status: WeatherStatus.success,
            weather: mockWeather,
            lastUpdated: any,
          ),
        ],
        verify: (_) {
          verify(mockWeatherRepository.getCurrentWeatherByLocation(mockLocation))
              .called(1);
        },
      );
    });

    group('WeatherRefreshed', () {
      blocTest<WeatherBloc, WeatherState>(
        'emits updated weather when refresh succeeds',
        build: () {
          when(mockWeatherRepository.getCurrentWeather(any))
              .thenAnswer((_) async => mockWeather);
          return weatherBloc;
        },
        seed: () => WeatherState(
          status: WeatherStatus.success,
          weather: mockWeather,
          lastUpdated: DateTime.now(),
        ),
        act: (bloc) => bloc.add(WeatherRefreshed()),
        expect: () => [
          WeatherState(
            status: WeatherStatus.success,
            weather: mockWeather,
            lastUpdated: any,
            isRefreshing: true,
          ),
          WeatherState(
            status: WeatherStatus.success,
            weather: mockWeather,
            lastUpdated: any,
            isRefreshing: false,
          ),
        ],
      );

      blocTest<WeatherBloc, WeatherState>(
        'does not emit when no weather is loaded',
        build: () => weatherBloc,
        act: (bloc) => bloc.add(WeatherRefreshed()),
        expect: () => [],
      );
    });

    group('WeatherCleared', () {
      blocTest<WeatherBloc, WeatherState>(
        'emits initial state when weather is cleared',
        build: () => weatherBloc,
        seed: () => WeatherState(
          status: WeatherStatus.success,
          weather: mockWeather,
          lastUpdated: DateTime.now(),
        ),
        act: (bloc) => bloc.add(WeatherCleared()),
        expect: () => [const WeatherState()],
      );
    });

    group('WeatherAutoRefreshToggled', () {
      blocTest<WeatherBloc, WeatherState>(
        'updates autoRefreshEnabled when toggled',
        build: () => weatherBloc,
        act: (bloc) => bloc.add(const WeatherAutoRefreshToggled(false)),
        expect: () => [
          const WeatherState(autoRefreshEnabled: false),
        ],
      );
    });
  });
}

// test/blocs/location_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../lib/blocs/location/location_cubit.dart';
import '../lib/blocs/location/location_state.dart';
import '../lib/repositories/location_repository.dart';
import '../lib/core/models/location.dart';

@GenerateMocks([LocationRepository])
import 'location_cubit_test.mocks.dart';

void main() {
  group('LocationCubit', () {
    late LocationRepository mockLocationRepository;
    late LocationCubit locationCubit;
    late Location mockLocation;

    setUp(() {
      mockLocationRepository = MockLocationRepository();
      locationCubit = LocationCubit(locationRepository: mockLocationRepository);
      
      mockLocation = Location(
        latitude: 51.5074,
        longitude: -0.1278,
        city: 'London',
        country: 'UK',
        timestamp: DateTime.now(),
      );
    });

    tearDown(() {
      locationCubit.close();
    });

    test('initial state is correct', () {
      expect(locationCubit.state, const LocationState());
    });

    group('getCurrentLocation', () {
      blocTest<LocationCubit, LocationState>(
        'emits [loading, success] when location request succeeds',
        build: () {
          when(mockLocationRepository.hasLocationPermission())
              .thenAnswer((_) async => true);
          when(mockLocationRepository.getCurrentLocation())
              .thenAnswer((_) async => mockLocation);
          return locationCubit;
        },
        act: (cubit) => cubit.getCurrentLocation(),
        expect: () => [
          const LocationState(status: LocationStatus.loading),
          LocationState(
            status: LocationStatus.success,
            location: mockLocation,
            hasPermission: true,
          ),
        ],
      );

      blocTest<LocationCubit, LocationState>(
        'emits [loading, disabled] when permission is denied',
        build: () {
          when(mockLocationRepository.hasLocationPermission())
              .thenAnswer((_) async => false);
          when(mockLocationRepository.requestLocationPermission())
              .thenAnswer((_) async => false);
          return locationCubit;
        },
        act: (cubit) => cubit.getCurrentLocation(),
        expect: () => [
          const LocationState(status: LocationStatus.loading),
          const LocationState(
            status: LocationStatus.disabled,
            errorMessage: 'Location permission denied',
            hasPermission: false,
          ),
        ],
      );
    });

    group('searchLocation', () {
      blocTest<LocationCubit, LocationState>(
        'emits [loading, success] when search succeeds',
        build: () {
          when(mockLocationRepository.searchLocations('London'))
              .thenAnswer((_) async => [mockLocation]);
          return locationCubit;
        },
        act: (cubit) => cubit.searchLocation('London'),
        expect: () => [
          const LocationState(status: LocationStatus.loading),
          LocationState(
            status: LocationStatus.success,
            location: mockLocation,
          ),
        ],
      );

      blocTest<LocationCubit, LocationState>(
        'emits [loading, failure] when no locations found',
        build: () {
          when(mockLocationRepository.searchLocations('InvalidCity'))
              .thenAnswer((_) async => []);
          return locationCubit;
        },
        act: (cubit) => cubit.searchLocation('InvalidCity'),
        expect: () => [
          const LocationState(status: LocationStatus.loading),
          const LocationState(
            status: LocationStatus.failure,
            errorMessage: 'No locations found for "InvalidCity"',
          ),
        ],
      );

      blocTest<LocationCubit, LocationState>(
        'does not emit when query is empty',
        build: () => locationCubit,
        act: (cubit) => cubit.searchLocation(''),
        expect: () => [],
      );
    });
  });
}
```

## 🎉 **Congratulations!**

You've successfully implemented a comprehensive weather application demonstrating:

✅ **Bloc Pattern Mastery** - Understanding event-driven architecture and business logic separation  
✅ **Cubit Simplification** - Using Cubit for simpler state management scenarios  
✅ **Event-Driven Architecture** - Designing applications around events and state transitions  
✅ **Business Logic Separation** - Clear separation between UI and business logic layers  
✅ **Complex State Management** - Handling sophisticated application states with multiple flows  
✅ **Testing Excellence** - Comprehensive testing strategies for Bloc-based applications

## 🎯 **Key Learning Achievements**

### **Event-Driven Architecture:**
1. **Bloc Pattern Understanding** - Complete grasp of events, states, and business logic separation
2. **Cubit Simplification** - Knowing when to use Cubit vs full Bloc patterns
3. **State Composition** - Building complex states with multiple properties and transitions
4. **Event Transformations** - Advanced patterns like debouncing and throttling
5. **Bloc Communication** - Coordinating multiple Blocs for complex features
6. **Testing Excellence** - Comprehensive testing with bloc_test package

### **This implementation demonstrates:**
- **✅ Production-ready patterns** used in complex Flutter applications
- **✅ Clean architecture** with proper separation of concerns
- **✅ Advanced state management** with event-driven patterns
- **✅ Comprehensive testing** strategies for Bloc-based applications
- **✅ Real-world complexity** with location services, API integration, and offline support
- **✅ User experience** excellence with loading states, error handling, and refresh capabilities

## 🎯 **Ready for State Management Comparison!**

With this solid foundation in Bloc and Cubit, you're now ready to:
- **Understand event-driven architecture** and its benefits for complex business logic
- **Choose appropriate patterns** between setState, Provider, Riverpod, and Bloc
- **Test complex state management** comprehensively with bloc_test
- **Continue to Lesson 14** - State Management Comparison for making informed decisions
- **Build scalable applications** with proper business logic separation

**You've mastered event-driven architecture with Bloc and Cubit! 🎯✨🔥**