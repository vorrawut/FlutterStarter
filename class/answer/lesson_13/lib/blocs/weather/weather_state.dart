import 'package:equatable/equatable.dart';
import '../../core/models/weather.dart';

enum WeatherStatus { initial, loading, success, failure }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather? weather;
  final List<Weather> forecast;
  final List<String> searchResults;
  final String? errorMessage;
  final DateTime? lastUpdated;
  final bool isRefreshing;
  final bool autoRefreshEnabled;
  final bool isLoadingForecast;
  final bool isSearching;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.weather,
    this.forecast = const [],
    this.searchResults = const [],
    this.errorMessage,
    this.lastUpdated,
    this.isRefreshing = false,
    this.autoRefreshEnabled = true,
    this.isLoadingForecast = false,
    this.isSearching = false,
  });

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    List<Weather>? forecast,
    List<String>? searchResults,
    String? errorMessage,
    DateTime? lastUpdated,
    bool? isRefreshing,
    bool? autoRefreshEnabled,
    bool? isLoadingForecast,
    bool? isSearching,
    bool clearError = false,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      forecast: forecast ?? this.forecast,
      searchResults: searchResults ?? this.searchResults,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      autoRefreshEnabled: autoRefreshEnabled ?? this.autoRefreshEnabled,
      isLoadingForecast: isLoadingForecast ?? this.isLoadingForecast,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  bool get hasWeather => weather != null;
  bool get hasForecast => forecast.isNotEmpty;
  bool get hasError => errorMessage != null;
  bool get isLoading => status == WeatherStatus.loading;
  bool get isSuccess => status == WeatherStatus.success;
  bool get isFailure => status == WeatherStatus.failure;
  bool get isInitial => status == WeatherStatus.initial;

  String get statusText {
    switch (status) {
      case WeatherStatus.initial:
        return 'Ready';
      case WeatherStatus.loading:
        return 'Loading...';
      case WeatherStatus.success:
        return 'Success';
      case WeatherStatus.failure:
        return 'Error';
    }
  }

  @override
  List<Object?> get props => [
        status,
        weather,
        forecast,
        searchResults,
        errorMessage,
        lastUpdated,
        isRefreshing,
        autoRefreshEnabled,
        isLoadingForecast,
        isSearching,
      ];

  @override
  String toString() {
    return 'WeatherState(status: $status, hasWeather: $hasWeather, error: $errorMessage)';
  }
}