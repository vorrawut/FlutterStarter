import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../core/models/weather.dart';
import '../core/models/location.dart';

class WeatherRepository {
  final http.Client httpClient;
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherRepository({
    required this.httpClient,
    required this.apiKey,
  });

  Future<Weather> getCurrentWeather(String cityName) async {
    // For demo purposes, return mock data to avoid API key requirements
    return _getMockWeather(cityName);
    
    // Real implementation would be:
    /*
    final url = '$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric';
    
    final response = await httpClient.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
    */
  }

  Future<Weather> getCurrentWeatherByLocation(Location location) async {
    // For demo purposes, return mock data
    return _getMockWeatherByLocation(location);
    
    // Real implementation would be:
    /*
    final url = '$baseUrl/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric';
    
    final response = await httpClient.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
    */
  }

  Future<List<Weather>> getForecast(String cityName, {int days = 5}) async {
    // For demo purposes, return mock forecast data
    return _getMockForecast(cityName, days);
    
    // Real implementation would be:
    /*
    final url = '$baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric&cnt=${days * 8}';
    
    final response = await httpClient.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final list = json['list'] as List;
      return list.map((item) => Weather.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load forecast data: ${response.statusCode}');
    }
    */
  }

  Future<List<String>> searchCities(String query) async {
    // Mock city search for demo
    await Future.delayed(const Duration(milliseconds: 500));
    
    final cities = [
      'Bangkok, TH',
      'London, GB',
      'New York, US',
      'Paris, FR',
      'Tokyo, JP',
      'Sydney, AU',
      'Berlin, DE',
      'Singapore, SG',
      'Dubai, AE',
      'Moscow, RU',
    ];
    
    return cities.where((city) => 
      city.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Mock data generators for demo purposes
  Weather _getMockWeather(String cityName) {
    final random = Random();
    final baseTemp = 20.0 + (random.nextDouble() * 20.0); // 20-40°C
    
    final mockData = {
      'name': cityName,
      'sys': {'country': 'XX'},
      'main': {
        'temp': baseTemp,
        'feels_like': baseTemp + (random.nextDouble() * 4.0 - 2.0),
        'humidity': 40 + random.nextInt(40),
        'pressure': 1000 + random.nextInt(50),
      },
      'weather': [
        {
          'description': _getRandomWeatherDescription(),
          'icon': _getRandomWeatherIcon(),
        }
      ],
      'wind': {'speed': random.nextDouble() * 15.0},
      'coord': {
        'lat': random.nextDouble() * 180.0 - 90.0,
        'lon': random.nextDouble() * 360.0 - 180.0,
      },
      'dt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
    
    return Weather.fromJson(mockData);
  }

  Weather _getMockWeatherByLocation(Location location) {
    final random = Random();
    final baseTemp = 20.0 + (random.nextDouble() * 20.0);
    
    final mockData = {
      'name': location.cityName ?? 'Current Location',
      'sys': {'country': location.countryCode ?? 'XX'},
      'main': {
        'temp': baseTemp,
        'feels_like': baseTemp + (random.nextDouble() * 4.0 - 2.0),
        'humidity': 40 + random.nextInt(40),
        'pressure': 1000 + random.nextInt(50),
      },
      'weather': [
        {
          'description': _getRandomWeatherDescription(),
          'icon': _getRandomWeatherIcon(),
        }
      ],
      'wind': {'speed': random.nextDouble() * 15.0},
      'coord': {
        'lat': location.latitude,
        'lon': location.longitude,
      },
      'dt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
    
    return Weather.fromJson(mockData);
  }

  List<Weather> _getMockForecast(String cityName, int days) {
    final random = Random();
    final forecast = <Weather>[];
    
    for (int i = 0; i < days; i++) {
      final baseTemp = 20.0 + (random.nextDouble() * 20.0);
      final date = DateTime.now().add(Duration(days: i));
      
      final mockData = {
        'name': cityName,
        'sys': {'country': 'XX'},
        'main': {
          'temp': baseTemp,
          'feels_like': baseTemp + (random.nextDouble() * 4.0 - 2.0),
          'humidity': 40 + random.nextInt(40),
          'pressure': 1000 + random.nextInt(50),
        },
        'weather': [
          {
            'description': _getRandomWeatherDescription(),
            'icon': _getRandomWeatherIcon(),
          }
        ],
        'wind': {'speed': random.nextDouble() * 15.0},
        'coord': {
          'lat': random.nextDouble() * 180.0 - 90.0,
          'lon': random.nextDouble() * 360.0 - 180.0,
        },
        'dt': date.millisecondsSinceEpoch ~/ 1000,
      };
      
      forecast.add(Weather.fromJson(mockData));
    }
    
    return forecast;
  }

  String _getRandomWeatherDescription() {
    final descriptions = [
      'clear sky',
      'few clouds',
      'scattered clouds',
      'broken clouds',
      'shower rain',
      'rain',
      'thunderstorm',
      'snow',
      'mist',
    ];
    
    return descriptions[Random().nextInt(descriptions.length)];
  }

  String _getRandomWeatherIcon() {
    final icons = [
      '01d', '01n', // clear sky
      '02d', '02n', // few clouds
      '03d', '03n', // scattered clouds
      '04d', '04n', // broken clouds
      '09d', '09n', // shower rain
      '10d', '10n', // rain
      '11d', '11n', // thunderstorm
      '13d', '13n', // snow
      '50d', '50n', // mist
    ];
    
    return icons[Random().nextInt(icons.length)];
  }

  void dispose() {
    httpClient.close();
  }
}