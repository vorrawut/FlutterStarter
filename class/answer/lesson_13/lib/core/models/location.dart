import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? countryCode;
  final DateTime timestamp;

  const Location({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.countryCode,
    required this.timestamp,
  });

  factory Location.fromPosition(double latitude, double longitude) {
    return Location(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
    );
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      cityName: json['cityName'] as String?,
      countryCode: json['countryCode'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'countryCode': countryCode,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  Location copyWith({
    double? latitude,
    double? longitude,
    String? cityName,
    String? countryCode,
    DateTime? timestamp,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      countryCode: countryCode ?? this.countryCode,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  String get coordinatesString => '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
  
  String get displayName {
    if (cityName != null && countryCode != null) {
      return '$cityName, $countryCode';
    } else if (cityName != null) {
      return cityName!;
    } else {
      return coordinatesString;
    }
  }

  @override
  List<Object?> get props => [latitude, longitude, cityName, countryCode, timestamp];

  @override
  String toString() => 'Location(${displayName})';
}