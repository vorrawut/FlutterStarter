import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final String countryCode;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String description;
  final String iconCode;
  final DateTime dateTime;
  final double latitude;
  final double longitude;

  const Weather({
    required this.cityName,
    required this.countryCode,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.iconCode,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List).first as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final coord = json['coord'] as Map<String, dynamic>;
    final sys = json['sys'] as Map<String, dynamic>;

    return Weather(
      cityName: json['name'] as String,
      countryCode: sys['country'] as String? ?? '',
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      pressure: main['pressure'] as int,
      description: weather['description'] as String,
      iconCode: weather['icon'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      latitude: (coord['lat'] as num).toDouble(),
      longitude: (coord['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {'country': countryCode},
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
      },
      'weather': [
        {
          'description': description,
          'icon': iconCode,
        }
      ],
      'wind': {'speed': windSpeed},
      'coord': {
        'lat': latitude,
        'lon': longitude,
      },
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
    };
  }

  String get temperatureString => '${temperature.round()}°';
  String get feelsLikeString => '${feelsLike.round()}°';
  String get windSpeedString => '${windSpeed.toStringAsFixed(1)} m/s';
  String get pressureString => '$pressure hPa';
  String get humidityString => '$humidity%';
  
  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  
  String get formattedLocation => '$cityName, $countryCode';
  
  bool get isHot => temperature > 30;
  bool get isCold => temperature < 0;
  bool get isWindy => windSpeed > 10;
  bool get isHumid => humidity > 80;

  @override
  List<Object> get props => [
        cityName,
        countryCode,
        temperature,
        feelsLike,
        humidity,
        windSpeed,
        pressure,
        description,
        iconCode,
        dateTime,
        latitude,
        longitude,
      ];

  @override
  String toString() {
    return 'Weather(city: $cityName, temp: $temperatureString, desc: $description)';
  }
}