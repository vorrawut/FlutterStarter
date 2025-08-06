import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/models/location.dart';

enum LocationStatus { initial, loading, success, failure }

class LocationState extends Equatable {
  final LocationStatus status;
  final Location? currentLocation;
  final List<Location> locationHistory;
  final LocationPermission permission;
  final bool serviceEnabled;
  final bool isTracking;
  final bool isCheckingPermissions;
  final bool isRequestingPermission;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const LocationState({
    this.status = LocationStatus.initial,
    this.currentLocation,
    this.locationHistory = const [],
    this.permission = LocationPermission.denied,
    this.serviceEnabled = false,
    this.isTracking = false,
    this.isCheckingPermissions = false,
    this.isRequestingPermission = false,
    this.errorMessage,
    this.lastUpdated,
  });

  LocationState copyWith({
    LocationStatus? status,
    Location? currentLocation,
    List<Location>? locationHistory,
    LocationPermission? permission,
    bool? serviceEnabled,
    bool? isTracking,
    bool? isCheckingPermissions,
    bool? isRequestingPermission,
    String? errorMessage,
    DateTime? lastUpdated,
    bool clearError = false,
  }) {
    return LocationState(
      status: status ?? this.status,
      currentLocation: currentLocation ?? this.currentLocation,
      locationHistory: locationHistory ?? this.locationHistory,
      permission: permission ?? this.permission,
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      isTracking: isTracking ?? this.isTracking,
      isCheckingPermissions: isCheckingPermissions ?? this.isCheckingPermissions,
      isRequestingPermission: isRequestingPermission ?? this.isRequestingPermission,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool get hasLocation => currentLocation != null;
  bool get hasError => errorMessage != null;
  bool get isLoading => status == LocationStatus.loading;
  bool get isSuccess => status == LocationStatus.success;
  bool get isFailure => status == LocationStatus.failure;
  bool get isInitial => status == LocationStatus.initial;

  bool get hasPermission => 
      permission == LocationPermission.always || 
      permission == LocationPermission.whileInUse;

  bool get canUseLocation => hasPermission && serviceEnabled;

  String get statusText {
    switch (status) {
      case LocationStatus.initial:
        return 'Ready';
      case LocationStatus.loading:
        return 'Getting location...';
      case LocationStatus.success:
        return 'Location found';
      case LocationStatus.failure:
        return 'Location error';
    }
  }

  @override
  List<Object?> get props => [
        status,
        currentLocation,
        locationHistory,
        permission,
        serviceEnabled,
        isTracking,
        isCheckingPermissions,
        isRequestingPermission,
        errorMessage,
        lastUpdated,
      ];

  @override
  String toString() {
    return 'LocationState(status: $status, hasLocation: $hasLocation, isTracking: $isTracking)';
  }
}