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

class WeatherForecastRequested extends WeatherEvent {
  final String city;
  final int days;

  const WeatherForecastRequested(this.city, {this.days = 5});

  @override
  List<Object> get props => [city, days];
}

class WeatherCurrentLocationRequested extends WeatherEvent {}

class WeatherSearchRequested extends WeatherEvent {
  final String query;

  const WeatherSearchRequested(this.query);

  @override
  List<Object> get props => [query];
}