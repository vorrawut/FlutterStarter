import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/weather/weather_bloc.dart';
import '../../../blocs/weather/weather_event.dart';
import '../../../blocs/weather/weather_state.dart';
import '../../../cubits/location/location_cubit.dart';
import '../../../cubits/location/location_state.dart';
import '../../../cubits/favorites/favorites_cubit.dart';
import '../../../cubits/settings/settings_cubit.dart';
import '../../widgets/weather_display.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/forecast_list.dart';
import '../../widgets/favorites_list.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Check location permissions on startup
    context.read<LocationCubit>().checkPermissions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherMaster Pro'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocationWeather,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.wb_sunny), text: 'Current'),
            Tab(icon: Icon(Icons.schedule), text: 'Forecast'),
            Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: WeatherSearchBar(
              controller: _searchController,
              onSearch: _searchWeather,
              onCitySelected: _selectCity,
            ),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCurrentTab(),
                _buildForecastTab(),
                _buildFavoritesTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (!state.hasWeather) return const SizedBox();
          
          return FloatingActionButton(
            onPressed: _refreshWeather,
            child: state.isRefreshing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.refresh),
          );
        },
      ),
    );
  }

  Widget _buildCurrentTab() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, weatherState) {
        return BlocBuilder<LocationCubit, LocationState>(
          builder: (context, locationState) {
            if (weatherState.isInitial) {
              return _buildWelcomeMessage(locationState);
            }
            
            if (weatherState.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading weather data...'),
                  ],
                ),
              );
            }
            
            if (weatherState.isFailure) {
              return _buildErrorState(weatherState.errorMessage);
            }
            
            if (weatherState.hasWeather) {
              return WeatherDisplay(weather: weatherState.weather!);
            }
            
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget _buildForecastTab() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (!state.hasWeather) {
          return const Center(
            child: Text('Search for a city to see the forecast'),
          );
        }
        
        return ForecastList(
          forecast: state.forecast,
          isLoading: state.isLoadingForecast,
          onRequestForecast: () {
            context.read<WeatherBloc>().add(
              WeatherForecastRequested(state.weather!.cityName),
            );
          },
        );
      },
    );
  }

  Widget _buildFavoritesTab() {
    return FavoritesList(
      onCitySelected: _selectCity,
    );
  }

  Widget _buildWelcomeMessage(LocationState locationState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wb_sunny_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to WeatherMaster Pro',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Search for a city or use your current location to get started',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            if (locationState.canUseLocation) ...[
              ElevatedButton.icon(
                onPressed: _getCurrentLocationWeather,
                icon: const Icon(Icons.my_location),
                label: const Text('Use Current Location'),
              ),
              const SizedBox(height: 16),
            ],
            
            OutlinedButton.icon(
              onPressed: () {
                _tabController.animateTo(2); // Go to favorites tab
              },
              icon: const Icon(Icons.favorite),
              label: const Text('Browse Favorites'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Weather Error',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Unknown error occurred',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<WeatherBloc>().add(WeatherCleared());
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _searchWeather(String query) {
    if (query.trim().isEmpty) return;
    
    context.read<WeatherBloc>().add(WeatherRequested(query.trim()));
    context.read<FavoritesCubit>().addRecentSearch(query.trim());
    _searchController.clear();
  }

  void _selectCity(String cityName) {
    context.read<WeatherBloc>().add(WeatherRequested(cityName));
    context.read<FavoritesCubit>().addRecentSearch(cityName);
    _tabController.animateTo(0); // Go to current weather tab
  }

  void _getCurrentLocationWeather() {
    final locationCubit = context.read<LocationCubit>();
    
    if (!locationCubit.state.canUseLocation) {
      if (!locationCubit.state.hasPermission) {
        locationCubit.requestPermission();
      } else {
        _showLocationErrorDialog();
      }
      return;
    }
    
    context.read<WeatherBloc>().add(WeatherCurrentLocationRequested());
  }

  void _refreshWeather() {
    context.read<WeatherBloc>().add(WeatherRefreshed());
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _showLocationErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Error'),
        content: const Text(
          'Location services are disabled or permission is denied. '
          'Please enable location services and grant permission to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}