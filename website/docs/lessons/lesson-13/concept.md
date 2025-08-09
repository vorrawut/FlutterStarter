# 🎯 Lesson 13: Bloc & Cubit - Concepts

## 🎯 **Learning Objectives**

By the end of this lesson, you will master:
- **Bloc Pattern Fundamentals** - Understanding event-driven architecture and business logic separation
- **Cubit Simplification** - Using Cubit for simpler state management scenarios
- **Event-Driven Architecture** - Designing applications around events and state transitions
- **Business Logic Separation** - Clear separation between UI and business logic layers
- **Complex State Management** - Handling sophisticated application states with multiple flows
- **Testing Excellence** - Comprehensive testing strategies for Bloc-based applications
- **Clean Architecture Integration** - Combining Bloc with domain-driven design patterns

## 📚 **Core Concepts**

### **1. Understanding the Bloc Pattern**

Bloc (Business Logic Component) is a design pattern that helps separate presentation from business logic, making code more testable, reusable, and easier to understand.

#### **Core Principles of Bloc**
1. **Single Responsibility** - Each Bloc handles one specific feature or business concern
2. **Event-Driven** - State changes are triggered by events, not direct method calls
3. **Immutable State** - States are immutable objects that represent the current condition
4. **Predictable** - Given the same event and state, the outcome is always the same
5. **Testable** - Business logic is easily unit tested without UI dependencies

#### **Bloc Architecture Overview**
```dart
// Events - What happened (user interactions, API responses, etc.)
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  
  @override
  List<Object> get props => [];
}

class WeatherRequested extends WeatherEvent {
  final String city;
  
  const WeatherRequested(this.city);
  
  @override
  List<Object> get props => [city];
}

class WeatherRefreshed extends WeatherEvent {}

// States - Current condition of the application
abstract class WeatherState extends Equatable {
  const WeatherState();
  
  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  
  const WeatherLoaded(this.weather);
  
  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;
  
  const WeatherError(this.message);
  
  @override
  List<Object> get props => [message];
}

// Bloc - Business logic that transforms events into states
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;
  
  WeatherBloc({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(WeatherInitial()) {
    
    // Register event handlers
    on<WeatherRequested>(_onWeatherRequested);
    on<WeatherRefreshed>(_onWeatherRefreshed);
  }
  
  Future<void> _onWeatherRequested(
    WeatherRequested event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    
    try {
      final weather = await _weatherRepository.getWeather(event.city);
      emit(WeatherLoaded(weather));
    } catch (error) {
      emit(WeatherError('Failed to fetch weather: $error'));
    }
  }
  
  Future<void> _onWeatherRefreshed(
    WeatherRefreshed event,
    Emitter<WeatherState> emit,
  ) async {
    if (state is WeatherLoaded) {
      final currentWeather = (state as WeatherLoaded).weather;
      emit(WeatherLoading());
      
      try {
        final weather = await _weatherRepository.getWeather(currentWeather.city);
        emit(WeatherLoaded(weather));
      } catch (error) {
        emit(WeatherError('Failed to refresh weather: $error'));
      }
    }
  }
}
```

### **2. Cubit - Simplified Bloc**

Cubit is a subset of Bloc that doesn't require events. It's simpler to use when you don't need the full event-driven architecture.

#### **When to Use Cubit vs Bloc**

**Use Cubit when:**
- Simple state changes with direct method calls
- No complex event sequences or transformations
- Straightforward business logic
- Rapid prototyping or simple features

**Use Bloc when:**
- Complex event-driven logic
- Need for event transformations (debounce, throttle, etc.)
- Multiple event sources affecting the same state
- Advanced debugging and replay capabilities

#### **Cubit Implementation**
```dart
// Cubit uses the same states as Bloc
class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _weatherRepository;
  
  WeatherCubit({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(WeatherInitial());
  
  // Direct methods instead of events
  Future<void> getWeather(String city) async {
    emit(WeatherLoading());
    
    try {
      final weather = await _weatherRepository.getWeather(city);
      emit(WeatherLoaded(weather));
    } catch (error) {
      emit(WeatherError('Failed to fetch weather: $error'));
    }
  }
  
  Future<void> refreshWeather() async {
    if (state is WeatherLoaded) {
      final currentWeather = (state as WeatherLoaded).weather;
      emit(WeatherLoading());
      
      try {
        final weather = await _weatherRepository.getWeather(currentWeather.city);
        emit(WeatherLoaded(weather));
      } catch (error) {
        emit(WeatherError('Failed to refresh weather: $error'));
      }
    }
  }
  
  void reset() {
    emit(WeatherInitial());
  }
}
```

### **3. Advanced State Management Patterns**

#### **Complex State Composition**
```dart
// Multiple state properties in a single state class
class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather? currentWeather;
  final List<Weather> forecast;
  final String? errorMessage;
  final DateTime? lastUpdated;
  final bool isRefreshing;
  
  const WeatherState({
    this.status = WeatherStatus.initial,
    this.currentWeather,
    this.forecast = const [],
    this.errorMessage,
    this.lastUpdated,
    this.isRefreshing = false,
  });
  
  WeatherState copyWith({
    WeatherStatus? status,
    Weather? currentWeather,
    List<Weather>? forecast,
    String? errorMessage,
    DateTime? lastUpdated,
    bool? isRefreshing,
  }) {
    return WeatherState(
      status: status ?? this.status,
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
      errorMessage: errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
  
  @override
  List<Object?> get props => [
        status,
        currentWeather,
        forecast,
        errorMessage,
        lastUpdated,
        isRefreshing,
      ];
}

enum WeatherStatus { initial, loading, success, failure }

// Advanced Cubit with complex state management
class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _weatherRepository;
  Timer? _refreshTimer;
  
  WeatherCubit({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(const WeatherState());
  
  Future<void> fetchWeather(String city) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    
    try {
      final results = await Future.wait([
        _weatherRepository.getCurrentWeather(city),
        _weatherRepository.getForecast(city),
      ]);
      
      final currentWeather = results[0] as Weather;
      final forecast = results[1] as List<Weather>;
      
      emit(state.copyWith(
        status: WeatherStatus.success,
        currentWeather: currentWeather,
        forecast: forecast,
        lastUpdated: DateTime.now(),
        errorMessage: null,
      ));
      
      _startAutoRefresh();
    } catch (error) {
      emit(state.copyWith(
        status: WeatherStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
  
  Future<void> refreshWeather() async {
    if (state.currentWeather != null) {
      emit(state.copyWith(isRefreshing: true));
      
      try {
        final results = await Future.wait([
          _weatherRepository.getCurrentWeather(state.currentWeather!.city),
          _weatherRepository.getForecast(state.currentWeather!.city),
        ]);
        
        final currentWeather = results[0] as Weather;
        final forecast = results[1] as List<Weather>;
        
        emit(state.copyWith(
          currentWeather: currentWeather,
          forecast: forecast,
          lastUpdated: DateTime.now(),
          isRefreshing: false,
        ));
      } catch (error) {
        emit(state.copyWith(
          isRefreshing: false,
          errorMessage: error.toString(),
        ));
      }
    }
  }
  
  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 10),
      (_) => refreshWeather(),
    );
  }
  
  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
```

### **4. Event Transformations and Advanced Patterns**

Bloc provides powerful event transformation capabilities for handling complex user interactions:

#### **Debouncing Events**
```dart
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  
  SearchBloc({required SearchRepository searchRepository})
      : _searchRepository = searchRepository,
        super(SearchInitial()) {
    
    // Debounce search queries to avoid excessive API calls
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }
  
  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    
    emit(SearchLoading());
    
    try {
      final results = await _searchRepository.search(event.query);
      emit(SearchLoaded(results));
    } catch (error) {
      emit(SearchError(error.toString()));
    }
  }
}

// Custom event transformer
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(duration).flatMap(mapper);
  };
}
```

#### **Throttling Events**
```dart
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    // Throttle location updates to prevent overwhelming the UI
    on<LocationUpdated>(
      _onLocationUpdated,
      transformer: throttle(const Duration(seconds: 1)),
    );
  }
  
  void _onLocationUpdated(
    LocationUpdated event,
    Emitter<LocationState> emit,
  ) {
    emit(LocationLoaded(event.location));
  }
}

EventTransformer<E> throttle<E>(Duration duration) {
  return (events, mapper) {
    return events.throttleTime(duration).flatMap(mapper);
  };
}
```

### **5. Bloc-to-Bloc Communication**

Handle complex scenarios where multiple Blocs need to communicate:

#### **Using StreamSubscription**
```dart
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final LocationBloc _locationBloc;
  final WeatherRepository _weatherRepository;
  late StreamSubscription _locationSubscription;
  
  WeatherBloc({
    required LocationBloc locationBloc,
    required WeatherRepository weatherRepository,
  })  : _locationBloc = locationBloc,
        _weatherRepository = weatherRepository,
        super(WeatherInitial()) {
    
    on<WeatherRequested>(_onWeatherRequested);
    on<WeatherLocationChanged>(_onWeatherLocationChanged);
    
    // Listen to location changes
    _locationSubscription = _locationBloc.stream.listen((locationState) {
      if (locationState is LocationLoaded) {
        add(WeatherLocationChanged(locationState.location));
      }
    });
  }
  
  Future<void> _onWeatherLocationChanged(
    WeatherLocationChanged event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    
    try {
      final weather = await _weatherRepository.getWeatherByLocation(event.location);
      emit(WeatherLoaded(weather));
    } catch (error) {
      emit(WeatherError(error.toString()));
    }
  }
  
  @override
  Future<void> close() {
    _locationSubscription.cancel();
    return super.close();
  }
}
```

### **6. UI Integration with BlocBuilder and BlocListener**

Integrate Bloc/Cubit with Flutter UI using the provided widgets:

#### **BlocBuilder for UI Updates**
```dart
class WeatherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        switch (state.status) {
          case WeatherStatus.initial:
            return const _WeatherInitialView();
          case WeatherStatus.loading:
            return const _WeatherLoadingView();
          case WeatherStatus.success:
            return _WeatherSuccessView(
              weather: state.currentWeather!,
              forecast: state.forecast,
              lastUpdated: state.lastUpdated!,
              isRefreshing: state.isRefreshing,
            );
          case WeatherStatus.failure:
            return _WeatherErrorView(
              message: state.errorMessage!,
              onRetry: () => context.read<WeatherCubit>().refreshWeather(),
            );
        }
      },
    );
  }
}
```

#### **BlocListener for Side Effects**
```dart
class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherCubit, WeatherState>(
      listenWhen: (previous, current) {
        // Only listen when error state changes
        return previous.errorMessage != current.errorMessage;
      },
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () => context.read<WeatherCubit>().refreshWeather(),
              ),
            ),
          );
        }
      },
      child: WeatherView(),
    );
  }
}
```

#### **BlocConsumer for Both Building and Listening**
```dart
class WeatherConsumerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == WeatherStatus.success) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Weather updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          children: [
            if (state.currentWeather != null)
              WeatherDisplay(weather: state.currentWeather!),
            if (state.forecast.isNotEmpty)
              ForecastList(forecast: state.forecast),
            if (state.isRefreshing)
              const LinearProgressIndicator(),
          ],
        );
      },
    );
  }
}
```

### **7. Testing Bloc and Cubit**

Comprehensive testing strategies for Bloc-based applications:

#### **Unit Testing Cubit**
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('WeatherCubit', () {
    late WeatherRepository mockWeatherRepository;
    late WeatherCubit weatherCubit;

    setUp(() {
      mockWeatherRepository = MockWeatherRepository();
      weatherCubit = WeatherCubit(weatherRepository: mockWeatherRepository);
    });

    tearDown(() {
      weatherCubit.close();
    });

    test('initial state is WeatherState with initial status', () {
      expect(weatherCubit.state, equals(const WeatherState()));
    });

    blocTest<WeatherCubit, WeatherState>(
      'emits [loading, success] when getWeather succeeds',
      build: () {
        when(mockWeatherRepository.getCurrentWeather(any))
            .thenAnswer((_) async => mockWeather);
        when(mockWeatherRepository.getForecast(any))
            .thenAnswer((_) async => mockForecast);
        return weatherCubit;
      },
      act: (cubit) => cubit.fetchWeather('London'),
      expect: () => [
        const WeatherState(status: WeatherStatus.loading),
        WeatherState(
          status: WeatherStatus.success,
          currentWeather: mockWeather,
          forecast: mockForecast,
          lastUpdated: any,
        ),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [loading, failure] when getWeather fails',
      build: () {
        when(mockWeatherRepository.getCurrentWeather(any))
            .thenThrow(Exception('Network error'));
        return weatherCubit;
      },
      act: (cubit) => cubit.fetchWeather('London'),
      expect: () => [
        const WeatherState(status: WeatherStatus.loading),
        const WeatherState(
          status: WeatherStatus.failure,
          errorMessage: 'Exception: Network error',
        ),
      ],
    );
  });
}
```

#### **Unit Testing Bloc**
```dart
void main() {
  group('WeatherBloc', () {
    late WeatherRepository mockWeatherRepository;
    late WeatherBloc weatherBloc;

    setUp(() {
      mockWeatherRepository = MockWeatherRepository();
      weatherBloc = WeatherBloc(weatherRepository: mockWeatherRepository);
    });

    tearDown(() {
      weatherBloc.close();
    });

    blocTest<WeatherBloc, WeatherState>(
      'emits [loading, loaded] when WeatherRequested succeeds',
      build: () {
        when(mockWeatherRepository.getWeather(any))
            .thenAnswer((_) async => mockWeather);
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const WeatherRequested('London')),
      expect: () => [
        WeatherLoading(),
        WeatherLoaded(mockWeather),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [loading, error] when WeatherRequested fails',
      build: () {
        when(mockWeatherRepository.getWeather(any))
            .thenThrow(Exception('Network error'));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const WeatherRequested('London')),
      expect: () => [
        WeatherLoading(),
        const WeatherError('Failed to fetch weather: Exception: Network error'),
      ],
    );
  });
}
```

### **8. Clean Architecture with Bloc**

Integrate Bloc with clean architecture principles:

#### **Repository Pattern Integration**
```dart
// Domain layer - Repository interface
abstract class WeatherRepository {
  Future<Weather> getCurrentWeather(String city);
  Future<List<Weather>> getForecast(String city);
  Stream<Weather> watchWeather(String city);
}

// Data layer - Repository implementation
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiDataSource _apiDataSource;
  final WeatherLocalDataSource _localDataSource;
  final NetworkService _networkService;

  WeatherRepositoryImpl({
    required WeatherApiDataSource apiDataSource,
    required WeatherLocalDataSource localDataSource,
    required NetworkService networkService,
  })  : _apiDataSource = apiDataSource,
        _localDataSource = localDataSource,
        _networkService = networkService;

  @override
  Future<Weather> getCurrentWeather(String city) async {
    try {
      if (await _networkService.isConnected) {
        final weather = await _apiDataSource.getCurrentWeather(city);
        await _localDataSource.cacheWeather(weather);
        return weather;
      } else {
        return await _localDataSource.getCachedWeather(city);
      }
    } catch (error) {
      // Fallback to cached data
      try {
        return await _localDataSource.getCachedWeather(city);
      } catch (_) {
        rethrow;
      }
    }
  }

  @override
  Future<List<Weather>> getForecast(String city) async {
    try {
      if (await _networkService.isConnected) {
        final forecast = await _apiDataSource.getForecast(city);
        await _localDataSource.cacheForecast(city, forecast);
        return forecast;
      } else {
        return await _localDataSource.getCachedForecast(city);
      }
    } catch (error) {
      try {
        return await _localDataSource.getCachedForecast(city);
      } catch (_) {
        rethrow;
      }
    }
  }

  @override
  Stream<Weather> watchWeather(String city) {
    return Stream.periodic(
      const Duration(minutes: 15),
      (_) => getCurrentWeather(city),
    ).asyncMap((future) => future);
  }
}

// Presentation layer - Bloc with dependency injection
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;
  final LocationService _locationService;
  final NotificationService _notificationService;
  
  WeatherBloc({
    required WeatherRepository weatherRepository,
    required LocationService locationService,
    required NotificationService notificationService,
  })  : _weatherRepository = weatherRepository,
        _locationService = locationService,
        _notificationService = notificationService,
        super(WeatherInitial()) {
    
    on<WeatherRequested>(_onWeatherRequested);
    on<WeatherLocationRequested>(_onWeatherLocationRequested);
    on<WeatherNotificationToggled>(_onWeatherNotificationToggled);
  }
  
  Future<void> _onWeatherLocationRequested(
    WeatherLocationRequested event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    
    try {
      final location = await _locationService.getCurrentLocation();
      final weather = await _weatherRepository.getCurrentWeatherByLocation(location);
      emit(WeatherLoaded(weather));
    } catch (error) {
      emit(WeatherError('Failed to get weather for current location: $error'));
    }
  }
  
  Future<void> _onWeatherNotificationToggled(
    WeatherNotificationToggled event,
    Emitter<WeatherState> emit,
  ) async {
    if (event.enabled) {
      await _notificationService.scheduleWeatherNotifications();
    } else {
      await _notificationService.cancelWeatherNotifications();
    }
  }
}
```

## 🌟 **Key Takeaways**

1. **Event-Driven Architecture** - Bloc promotes clear separation between events and state changes
2. **Business Logic Separation** - Keep business logic separate from UI for better testing and reusability
3. **Immutable State** - States are immutable, making the application more predictable
4. **Cubit Simplicity** - Use Cubit for simpler scenarios where events aren't necessary
5. **Advanced Patterns** - Event transformations and Bloc communication for complex scenarios
6. **Testing Excellence** - Bloc provides excellent testing capabilities with bloc_test package
7. **Clean Architecture** - Bloc integrates well with clean architecture principles

Understanding Bloc and Cubit is essential for building scalable Flutter applications with complex business logic. These patterns provide structure, testability, and maintainability for sophisticated state management scenarios.

**Ready to master event-driven architecture with Bloc and Cubit? 🎯✨**