import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/firebase/firebase_config.dart';
import 'services/fcm_service.dart';
import 'presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseConfig.initialize();
  
  // Initialize FCM Service
  await FCMService.initialize(
    onNavigate: (route, arguments) {
      // Handle navigation from notifications
      // This would be integrated with your app's navigation system
      debugPrint('Navigate to: $route with arguments: $arguments');
    },
  );
  
  runApp(
    const ProviderScope(
      child: SocialHubEnhancedApp(),
    ),
  );
}
