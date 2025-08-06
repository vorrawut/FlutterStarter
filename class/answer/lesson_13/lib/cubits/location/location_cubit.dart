import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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
    emit(state.copyWith(status: LocationStatus.loading, clearError: true));

    try {
      final location = await _locationRepository.getCurrentLocation();
      emit(state.copyWith(
        status: LocationStatus.success,
        currentLocation: location,
        lastUpdated: DateTime.now(),
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LocationStatus.failure,
        errorMessage: _formatError(error),
      ));
    }
  }

  void startLocationTracking() {
    if (state.isTracking) return;

    emit(state.copyWith(isTracking: true));

    _locationStreamSubscription = _locationRepository
        .getLocationStream()
        .listen(
          (location) {
            emit(state.copyWith(
              currentLocation: location,
              lastUpdated: DateTime.now(),
              status: LocationStatus.success,
            ));
          },
          onError: (error) {
            emit(state.copyWith(
              errorMessage: _formatError(error),
              isTracking: false,
            ));
          },
        );
  }

  void stopLocationTracking() {
    _locationStreamSubscription?.cancel();
    _locationStreamSubscription = null;
    emit(state.copyWith(isTracking: false));
  }

  Future<void> checkPermissions() async {
    emit(state.copyWith(isCheckingPermissions: true));

    try {
      final permission = await _locationRepository.checkPermission();
      final serviceEnabled = await _locationRepository.isLocationServiceEnabled();

      emit(state.copyWith(
        permission: permission,
        serviceEnabled: serviceEnabled,
        isCheckingPermissions: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        isCheckingPermissions: false,
        errorMessage: _formatError(error),
      ));
    }
  }

  Future<void> requestPermission() async {
    emit(state.copyWith(isRequestingPermission: true));

    try {
      final permission = await _locationRepository.requestPermission();
      emit(state.copyWith(
        permission: permission,
        isRequestingPermission: false,
      ));

      // If permission granted, try to get current location
      if (permission == LocationPermission.always || 
          permission == LocationPermission.whileInUse) {
        await getCurrentLocation();
      }
    } catch (error) {
      emit(state.copyWith(
        isRequestingPermission: false,
        errorMessage: _formatError(error),
      ));
    }
  }

  void addLocationToHistory(Location location) {
    final updatedHistory = [location, ...state.locationHistory];
    // Keep only the last 10 locations
    final trimmedHistory = updatedHistory.take(10).toList();
    
    emit(state.copyWith(locationHistory: trimmedHistory));
  }

  void clearLocationHistory() {
    emit(state.copyWith(locationHistory: []));
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  String _formatError(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return error.toString();
  }

  String getPermissionStatusText(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return 'Permission denied';
      case LocationPermission.deniedForever:
        return 'Permission permanently denied';
      case LocationPermission.whileInUse:
        return 'Permission granted while app is in use';
      case LocationPermission.always:
        return 'Permission always granted';
      case LocationPermission.unableToDetermine:
        return 'Unable to determine permission status';
    }
  }

  bool get canRequestLocation {
    return state.permission != LocationPermission.deniedForever &&
           state.serviceEnabled;
  }

  bool get hasLocationPermission {
    return state.permission == LocationPermission.always ||
           state.permission == LocationPermission.whileInUse;
  }

  @override
  Future<void> close() {
    stopLocationTracking();
    return super.close();
  }
}