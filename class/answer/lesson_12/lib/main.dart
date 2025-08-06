import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/dependency_injection.dart';
import 'presentation/app.dart';

void main() {
  // Initialize dependency injection
  configureDependencies();
  
  runApp(
    const ProviderScope(
      child: TodoApp(),
    ),
  );
}