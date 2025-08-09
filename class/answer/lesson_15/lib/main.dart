import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/service_locator.dart';
import 'presentation/app/app.dart';
import 'presentation/app/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Initialize dependency injection
  await setupServiceLocator();
  
  // Run the app with hybrid state management
  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: AppProviders.providers,
        child: const AuthFlowProApp(),
      ),
    ),
  );
}
