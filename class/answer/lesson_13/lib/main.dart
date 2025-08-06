import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'core/di/dependency_injection.dart';
import 'repositories/weather_repository.dart';
import 'repositories/location_repository.dart';
import 'blocs/weather/weather_bloc.dart';
import 'cubits/location/location_cubit.dart';
import 'cubits/settings/settings_cubit.dart';
import 'cubits/favorites/favorites_cubit.dart';
import 'presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await configureDependencies();
  
  runApp(
    MultiBlocProvider(
      providers: [
        // Repositories
        RepositoryProvider<WeatherRepository>(
          create: (context) => WeatherRepository(
            httpClient: http.Client(),
            apiKey: 'demo-api-key', // In production, use environment variables
          ),
        ),
        RepositoryProvider<LocationRepository>(
          create: (context) => LocationRepository(),
        ),
        
        // Cubits (simpler state management)
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (context) => FavoritesCubit(),
        ),
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit(
            locationRepository: context.read<LocationRepository>(),
          ),
        ),
        
        // Bloc (complex event-driven state management)
        BlocProvider<WeatherBloc>(
          create: (context) => WeatherBloc(
            weatherRepository: context.read<WeatherRepository>(),
            locationRepository: context.read<LocationRepository>(),
          ),
        ),
      ],
      child: const WeatherApp(),
    ),
  );
}