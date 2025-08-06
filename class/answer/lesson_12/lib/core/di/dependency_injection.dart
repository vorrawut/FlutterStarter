import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

// Service providers
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Configuration providers
final apiBaseUrlProvider = Provider<String>((ref) {
  return 'https://api.todomaster.com'; // Mock API URL
});

final appVersionProvider = Provider<String>((ref) {
  return '1.0.0';
});

// Environment configuration
final isDebugModeProvider = Provider<bool>((ref) {
  return true; // In production, this would come from build configuration
});

// Initialize all dependencies
void configureDependencies() {
  // In a real app, this might initialize:
  // - Database connections
  // - HTTP clients
  // - Analytics services
  // - Crash reporting
  // - Feature flags
  
  // For demo purposes, we'll just ensure the API service is ready
  print('✅ Dependencies configured successfully');
}