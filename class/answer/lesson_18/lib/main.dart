import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/service_locator.dart';
import 'core/storage/database_helper.dart';
import 'presentation/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize Hive for NoSQL storage
  await Hive.initFlutter();
  
  // Initialize SQLite database
  await DatabaseHelper.initialize();
  
  // Setup dependency injection
  await setupServiceLocator();
  
  // Run the app
  runApp(
    const ProviderScope(
      child: NewsHubUltimateApp(),
    ),
  );
}
