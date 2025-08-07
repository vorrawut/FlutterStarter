import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/hive_config.dart';
import 'core/storage/sqlite_config.dart';
import 'presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage systems
  await HiveConfig.initialize();
  // SQLite initializes lazily when first accessed
  
  runApp(
    const ProviderScope(
      child: NoteMasterApp(),
    ),
  );
}