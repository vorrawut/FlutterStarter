import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/weather_repository.dart';
import '../../repositories/location_repository.dart';
import '../../core/models/weather.dart';
import '../../core/models/location.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;
  final LocationRepository _locationRepository;
  Timer? _autoRefreshTimer;
  StreamSubscription<Location>? _locationStreamSubscription;

  WeatherBloc({
    required WeatherRepository weatherRepository,
    required LocationRepository locationRepository,
  })  : _weatherRepository = weatherRepository,
        _locationRepository = locationRepository,
        super(const WeatherState()) {
    
    // Register event handlers
    on<WeatherRequested>(_onWeatherRequested);
    on<WeatherLocationRequested>(_onWeatherLocationRequested);
    on<WeatherRefreshed>(_onWeatherRefreshed);
    on<WeatherCleared>(_onWeatherCleared);
    on<WeatherAutoRefreshToggled>(_onWeatherAutoRefreshToggled);
    on<WeatherForecastRequested>(_onWeatherForecastRequested);
    on<WeatherCurrentLocationRequested>(_onWeatherCurrentLocationRequested);
    on<WeatherSearchRequested>(_onWeatherSearchRequested);
  }

  Future<void> _onWeatherRequested(
    WeatherRequested event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: WeatherStatus.loading, clearError: true));

    try {
      final weather = await _weatherRepository.getCurrentWeather(event.city);
      emit(state.copyWith(
        status: WeatherStatus.success,
        weather: weather,
        lastUpdated: DateTime.now(),
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
    emit(state.copyWith(status: WeatherStatus.loading, clearError: true));

    try {
      final weather = await _weatherRepository.getCurrentWeatherByLocation(event.location);
      emit(state.copyWith(
        status: WeatherStatus.success,
        weather: weather,
        lastUpdated: DateTime.now(),
      ));

      _startAutoRefreshForLocation(event.location);
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

    emit(state.copyWith(isRefreshing: true, clearError: true));

    try {
      final weather = await _weatherRepository.getCurrentWeather(state.weather!.cityName);
      emit(state.copyWith(
        status: WeatherStatus.success,
        weather: weather,
        lastUpdated: DateTime.now(),
        isRefreshing: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        isRefreshing: false,
        errorMessage: _formatError(error),
      ));
    }
  }

  Future<void> _onWeatherCleared(
    WeatherCleared event,
    Emitter<WeatherState> emit,
  ) async {
    _stopAutoRefresh();
    _stopLocationTracking();
    
    emit(const WeatherState());
  }

  Future<void> _onWeatherAutoRefreshToggled(
    WeatherAutoRefreshToggled event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(autoRefreshEnabled: event.enabled));

    if (event.enabled && state.weather != null) {
      _startAutoRefresh(state.weather!.cityName);
    } else {
      _stopAutoRefresh();
    }
  }

  Future<void> _onWeatherForecastRequested(
    WeatherForecastRequested event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(isLoadingForecast: true));

    try {
      final forecast = await _weatherRepository.getForecast(event.city, days: event.days);
      emit(state.copyWith(
        forecast: forecast,
        isLoadingForecast: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoadingForecast: false,
        errorMessage: _formatError(error),
      ));
    }
  }

  Future<void> _onWeatherCurrentLocationRequested(
    WeatherCurrentLocationRequested event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: WeatherStatus.loading, clearError: true));

    try {
      final location = await _locationRepository.getCurrentLocation();
      add(WeatherLocationRequested(location));
      
      // Start tracking location changes
      _startLocationTracking();
    } catch (error) {
      emit(state.copyWith(
        status: WeatherStatus.failure,
        errorMessage: _formatError(error),
      ));
    }
  }

  Future<void> _onWeatherSearchRequested(
    WeatherSearchRequested event,
    Emitter<WeatherState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(searchResults: [], isSearching: false));
      return;
    }

    emit(state.copyWith(isSearching: true));

    try {
      final results = await _weatherRepository.searchCities(event.query);
      emit(state.copyWith(
        searchResults: results,
        isSearching: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        isSearching: false,
        errorMessage: _formatError(error),
      ));
    }
  }

  void _startAutoRefresh(String cityName) {
    _stopAutoRefresh();
    
    if (!state.autoRefreshEnabled) return;

    _autoRefreshTimer = Timer.periodic(
      const Duration(minutes: 30), // Auto-refresh every 30 minutes
      (_) => add(WeatherRefreshed()),
    );
  }

  void _startAutoRefreshForLocation(Location location) {
    _stopAutoRefresh();
    
    if (!state.autoRefreshEnabled) return;

    _autoRefreshTimer = Timer.periodic(
      const Duration(minutes: 30),
      (_) => add(WeatherLocationRequested(location)),
    );
  }

  void _stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  void _startLocationTracking() {
    _stopLocationTracking();
    
    _locationStreamSubscription = _locationRepository
        .getLocationStream()
        .listen((location) {
      // Only update if location changed significantly (more than 1km)
      if (state.weather != null) {
        _locationRepository.getDistanceBetween(
          Location.fromPosition(state.weather!.latitude, state.weather!.longitude),
          location,
        ).then((distance) {
          if (distance > 1000) { // 1km
            add(WeatherLocationRequested(location));
          }
        });
      }
    });
  }

  void _stopLocationTracking() {
    _locationStreamSubscription?.cancel();
    _locationStreamSubscription = null;
  }

  String _formatError(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return error.toString();
  }

  @override
  Future<void> close() {
    _stopAutoRefresh();
    _stopLocationTracking();
    return super.close();
  }
}