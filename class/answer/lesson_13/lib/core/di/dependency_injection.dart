import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> configureDependencies() async {
  // Check location permissions
  await _checkLocationPermissions();
  
  // Initialize shared preferences
  await SharedPreferences.getInstance();
  
  print('✅ Dependencies configured successfully');
}

Future<void> _checkLocationPermissions() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('⚠️ Location services are disabled.');
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('⚠️ Location permissions are denied');
      return;
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    print('⚠️ Location permissions are permanently denied');
    return;
  } 

  print('✅ Location permissions granted');
}