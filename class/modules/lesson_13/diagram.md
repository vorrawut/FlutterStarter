# 📜 Diagram for Lesson 13: Bloc & Cubit

## 🎯 **Bloc & Cubit - Event-Driven Architecture**

This lesson demonstrates event-driven architecture patterns through Bloc and Cubit, showcasing business logic separation, complex state management, and comprehensive testing strategies through building a professional weather application with real-time updates and location services.

---

## **Bloc Pattern Architecture Overview**

```mermaid
graph LR
    subgraph "UI Layer"
        A[User Interaction]
        B[Widget]
        C[BlocBuilder]
        D[BlocListener]
    end
    
    subgraph "Business Logic Layer"
        E[Event]
        F[Bloc]
        G[State]
    end
    
    subgraph "Data Layer"
        H[Repository]
        I[Data Source]
        J[API/Cache]
    end
    
    A --> E
    E --> F
    F --> G
    G --> C
    G --> D
    C --> B
    D --> B
    
    F --> H
    H --> I
    I --> J
    
    style A fill:#e3f2fd
    style F fill:#fff3e0
    style H fill:#f3e5f5
    style J fill:#e8f5e8
```

---

## **Bloc vs Cubit Comparison**

```mermaid
graph TB
    subgraph "Bloc Pattern"
        A[User Action]
        A --> B[Event]
        B --> C[Bloc]
        C --> D[State]
        D --> E[UI Update]
        
        C --> F[Event Handler]
        F --> G[Business Logic]
        G --> H[Repository Call]
        H --> I[Emit State]
    end
    
    subgraph "Cubit Pattern"
        J[User Action]
        J --> K[Method Call]
        K --> L[Cubit]
        L --> M[State]
        M --> N[UI Update]
        
        L --> O[Direct Method]
        O --> P[Business Logic]
        P --> Q[Repository Call]
        Q --> R[Emit State]
    end
    
    style B fill:#ff9800
    style C fill:#2196f3
    style K fill:#4caf50
    style L fill:#2196f3
```

---

## **Weather App Bloc Architecture**

```mermaid
graph TD
    subgraph "Presentation Layer"
        A[WeatherHomeScreen]
        B[CitySearchScreen]
        C[ForecastScreen]
        D[SettingsScreen]
    end
    
    subgraph "Bloc/Cubit Layer"
        E[WeatherBloc]
        F[LocationCubit]
        G[SettingsCubit]
        H[ForecastBloc]
    end
    
    subgraph "Repository Layer"
        I[WeatherRepository]
        J[LocationRepository]
        K[SettingsRepository]
    end
    
    subgraph "Data Sources"
        L[WeatherAPI]
        M[LocationService]
        N[StorageService]
        O[NotificationService]
    end
    
    A --> E
    A --> F
    B --> E
    C --> H
    D --> G
    
    E --> I
    F --> J
    G --> K
    H --> I
    
    I --> L
    I --> N
    J --> M
    K --> N
    E --> O
    
    style A fill:#e3f2fd
    style E fill:#fff3e0
    style I fill:#f3e5f5
    style L fill:#e8f5e8
```

---

## **WeatherBloc Event Flow**

```mermaid
stateDiagram-v2
    [*] --> Initial
    
    Initial --> Loading : WeatherRequested
    Initial --> Loading : WeatherLocationRequested
    
    Loading --> Success : API Success
    Loading --> Failure : API Error
    
    Success --> Refreshing : WeatherRefreshed
    Success --> Loading : WeatherRequested
    Success --> Initial : WeatherCleared
    
    Refreshing --> Success : Refresh Success
    Refreshing --> Failure : Refresh Error
    
    Failure --> Loading : WeatherRequested
    Failure --> Loading : WeatherRefreshed
    
    state Success {
        [*] --> DisplayWeather
        DisplayWeather --> AutoRefresh : Timer Triggered
        AutoRefresh --> DisplayWeather : Updated Data
    }
    
    state Failure {
        [*] --> ShowError
        ShowError --> ShowCachedData : Cache Available
        ShowCachedData --> ShowRetryOption
    }
    
    note right of Success
        Auto-refresh enabled
        Real-time updates
        Cache management
    end note
    
    note left of Failure
        Error handling
        Fallback to cache
        User-friendly messages
    end note
```

---

## **Event-Driven Data Flow**

```mermaid
sequenceDiagram
    participant U as User
    participant W as Widget
    participant B as WeatherBloc
    participant R as Repository
    participant API as Weather API
    participant C as Cache
    
    Note over U,C: Weather Request Flow
    U->>W: Tap "Search London"
    W->>B: WeatherRequested('London')
    
    Note over B: Emit Loading State
    B->>B: emit(WeatherLoading())
    B->>W: State Update
    W->>U: Show Loading Spinner
    
    Note over B,API: Data Fetching
    B->>R: getCurrentWeather('London')
    R->>API: HTTP Request
    
    alt Success
        API-->>R: Weather Data
        R->>C: Cache Weather Data
        R-->>B: Weather Object
        
        Note over B: Emit Success State
        B->>B: emit(WeatherLoaded(weather))
        B->>W: State Update
        W->>U: Display Weather
        
        Note over B: Start Auto-Refresh
        B->>B: Timer.periodic(15min)
        
    else Failure
        API-->>R: Error Response
        R->>C: Try Cache
        
        alt Cache Hit
            C-->>R: Cached Weather
            R-->>B: Cached Weather Object
            B->>B: emit(WeatherLoaded(cachedWeather))
            B->>W: State Update (with Cache Notice)
        else Cache Miss
            R-->>B: Exception
            B->>B: emit(WeatherError(message))
            B->>W: State Update
            W->>U: Show Error + Retry
        end
    end
```

---

## **Cubit State Management Pattern**

```mermaid
flowchart TD
    A[User Interaction] --> B{Cubit Method}
    
    B --> C[emit(LoadingState)]
    C --> D[Repository Call]
    
    D --> E{Success?}
    E -->|Yes| F[emit(SuccessState)]
    E -->|No| G[emit(ErrorState)]
    
    F --> H[UI Rebuilds]
    G --> I[Show Error + Retry]
    
    I --> J[User Retries]
    J --> B
    
    subgraph "LocationCubit Example"
        K[getCurrentLocation()]
        K --> L[emit(LocationLoading)]
        L --> M[locationRepository.getCurrentLocation()]
        M --> N{Permission?}
        N -->|Granted| O[emit(LocationSuccess)]
        N -->|Denied| P[emit(LocationDisabled)]
    end
    
    subgraph "SettingsCubit Example"
        Q[updateTemperatureUnit()]
        Q --> R[settingsRepository.saveSettings()]
        R --> S[emit(updated settings)]
        S --> T[UI Updates Immediately]
    end
    
    style F fill:#4caf50
    style G fill:#f44336
    style O fill:#4caf50
    style P fill:#ff9800
```

---

## **Bloc-to-Bloc Communication**

```mermaid
graph LR
    subgraph "Location Feature"
        A[LocationCubit]
        A --> A1[LocationChanged]
    end
    
    subgraph "Weather Feature"
        B[WeatherBloc]
        B --> B1[WeatherLocationRequested]
    end
    
    subgraph "Settings Feature"
        C[SettingsCubit]
        C --> C1[SettingsChanged]
    end
    
    subgraph "Communication Patterns"
        D[Stream Subscription]
        E[BlocListener]
        F[Context Communication]
    end
    
    A1 --> D
    D --> B1
    
    C1 --> E
    E --> B
    
    B --> F
    F --> A
    
    style D fill:#2196f3
    style E fill:#ff9800
    style F fill:#9c27b0
```

---

## **Advanced State Composition**

```mermaid
classDiagram
    class WeatherState {
        +WeatherStatus status
        +Weather? weather
        +String? errorMessage
        +DateTime? lastUpdated
        +bool isRefreshing
        +bool autoRefreshEnabled
        +copyWith() WeatherState
    }
    
    class Weather {
        +String city
        +double temperature
        +String condition
        +DateTime timestamp
        +bool isDaytime
        +String temperatureCategory
    }
    
    class LocationState {
        +LocationStatus status
        +Location? location
        +String? errorMessage
        +bool hasPermission
        +copyWith() LocationState
    }
    
    class SettingsState {
        +WeatherSettings settings
        +bool isLoading
        +String? errorMessage
        +copyWith() SettingsState
    }
    
    WeatherState --> Weather
    LocationState --> Location
    SettingsState --> WeatherSettings
    
    class WeatherStatus {
        <<enumeration>>
        initial
        loading
        success
        failure
    }
    
    class LocationStatus {
        <<enumeration>>
        initial
        loading
        success
        failure
        disabled
    }
```

---

## **Testing Architecture with bloc_test**

```mermaid
graph TB
    subgraph "Test Setup"
        A[MockRepository]
        B[Test Data]
        C[Bloc Instance]
        D[Expected States]
    end
    
    subgraph "bloc_test Pattern"
        E[build: () => bloc]
        F[act: (bloc) => bloc.add(event)]
        G[expect: () => [states]]
        H[verify: (_) => verify(mock)]
    end
    
    subgraph "Test Categories"
        I[Unit Tests]
        J[Integration Tests]
        K[Widget Tests]
        L[Golden Tests]
    end
    
    A --> E
    B --> F
    C --> G
    D --> H
    
    E --> I
    F --> J
    G --> K
    H --> L
    
    style A fill:#ff9800
    style E fill:#4caf50
    style I fill:#2196f3
```

---

## **Weather App Event System**

```mermaid
flowchart LR
    subgraph "Weather Events"
        A[WeatherRequested]
        B[WeatherLocationRequested]
        C[WeatherRefreshed]
        D[WeatherCleared]
        E[WeatherAutoRefreshToggled]
    end
    
    subgraph "Location Events"
        F[getCurrentLocation]
        G[searchLocation]
        H[startLocationTracking]
        I[stopLocationTracking]
    end
    
    subgraph "Settings Events"
        J[updateTemperatureUnit]
        K[toggleNotifications]
        L[addFavoriteLocation]
        M[resetSettings]
    end
    
    subgraph "Event Handlers"
        N[_onWeatherRequested]
        O[_onWeatherLocationRequested]
        P[_onWeatherRefreshed]
        Q[Business Logic Methods]
    end
    
    A --> N
    B --> O
    C --> P
    F --> Q
    G --> Q
    J --> Q
    K --> Q
    
    style A fill:#e3f2fd
    style F fill:#fff3e0
    style J fill:#f3e5f5
    style N fill:#e8f5e8
```

---

## **Error Handling & Recovery Patterns**

```mermaid
flowchart TD
    A[API Call] --> B{Network Available?}
    
    B -->|Yes| C[Make Request]
    B -->|No| D[Check Cache]
    
    C --> E{Success?}
    E -->|Yes| F[Update Cache]
    E -->|No| G[Handle Error]
    
    F --> H[Emit Success State]
    
    G --> I{Error Type?}
    I -->|404| J[City Not Found]
    I -->|401| K[Invalid API Key]
    I -->|Timeout| L[Network Timeout]
    I -->|Other| M[Generic Error]
    
    D --> N{Cache Hit?}
    N -->|Yes| O[Emit Cached Data + Warning]
    N -->|No| P[Emit Error State]
    
    J --> Q[Emit User-Friendly Error]
    K --> Q
    L --> Q
    M --> Q
    
    Q --> R[Show Retry Option]
    O --> S[Show Refresh Option]
    P --> R
    
    style F fill:#4caf50
    style O fill:#ff9800
    style Q fill:#f44336
```

---

## **Real-time Updates & Auto-Refresh**

```mermaid
sequenceDiagram
    participant W as WeatherBloc
    participant T as Timer
    participant S as WeatherStream
    participant R as Repository
    participant U as UI
    
    Note over W,U: Auto-Refresh Setup
    W->>W: Weather Loaded Successfully
    W->>T: Timer.periodic(15 minutes)
    W->>S: Subscribe to weatherStream
    
    loop Auto-Refresh Cycle
        T->>W: Timer Triggered
        W->>W: add(WeatherRefreshed)
        W->>R: getCurrentWeather()
        R-->>W: Updated Weather Data
        W->>U: emit(new state)
    end
    
    loop Real-time Stream
        S->>W: New Weather Data
        W->>W: Check if different
        alt Data Changed
            W->>U: emit(updated state)
        else Same Data
            W->>W: Ignore Update
        end
    end
    
    Note over W: Auto-Refresh Control
    W->>W: WeatherAutoRefreshToggled(false)
    W->>T: Cancel Timer
    W->>S: Unsubscribe Stream
```

---

## **Complex State Transitions**

```mermaid
stateDiagram-v2
    [*] --> AppInitial
    
    AppInitial --> CheckingLocation : App Starts
    CheckingLocation --> LocationPermissionGranted : Permission OK
    CheckingLocation --> LocationPermissionDenied : Permission Denied
    
    LocationPermissionGranted --> LoadingLocationWeather : GPS Available
    LocationPermissionDenied --> PromptForManualSearch : Show Search
    
    LoadingLocationWeather --> WeatherDisplayed : Success
    LoadingLocationWeather --> WeatherError : Location/API Error
    
    PromptForManualSearch --> LoadingCityWeather : User Searches
    LoadingCityWeather --> WeatherDisplayed : Success
    LoadingCityWeather --> WeatherError : City Not Found
    
    WeatherDisplayed --> RefreshingWeather : Pull to Refresh
    WeatherDisplayed --> LoadingCityWeather : Search New City
    WeatherDisplayed --> UpdatingSettings : Change Units
    
    RefreshingWeather --> WeatherDisplayed : Success
    RefreshingWeather --> WeatherError : Refresh Failed
    
    UpdatingSettings --> WeatherDisplayed : Settings Applied
    
    WeatherError --> LoadingCityWeather : Retry Action
    WeatherError --> PromptForManualSearch : Search Action
    
    state WeatherDisplayed {
        [*] --> ShowingCurrent
        ShowingCurrent --> ShowingForecast : Tap Forecast
        ShowingForecast --> ShowingCurrent : Back to Current
        
        ShowingCurrent --> AutoRefreshing : Timer
        AutoRefreshing --> ShowingCurrent : Updated
    }
```

---

## **Performance Optimization Patterns**

```mermaid
flowchart LR
    subgraph "State Optimization"
        A[Immutable States]
        B[Efficient copyWith]
        C[Selective Rebuilds]
        D[State Caching]
    end
    
    subgraph "Bloc Optimization"
        E[Event Debouncing]
        F[Auto Disposal]
        G[Stream Management]
        H[Timer Cleanup]
    end
    
    subgraph "UI Optimization"
        I[BlocBuilder Optimization]
        J[BlocListener Conditions]
        K[Widget Separation]
        L[Const Constructors]
    end
    
    subgraph "Memory Management"
        M[Stream Subscriptions]
        N[Timer Disposal]
        O[Resource Cleanup]
        P[Cache Limits]
    end
    
    A --> I
    B --> J
    E --> C
    F --> K
    G --> M
    H --> N
    
    style A fill:#4caf50
    style E fill:#2196f3
    style I fill:#ff9800
    style M fill:#9c27b0
```

---

## **Repository Pattern Integration**

```mermaid
graph LR
    subgraph "Domain Layer"
        A[Weather Entity]
        B[Location Entity]
        C[WeatherRepository Interface]
        D[LocationRepository Interface]
    end
    
    subgraph "Data Layer"
        E[WeatherRepositoryImpl]
        F[LocationRepositoryImpl]
        G[WeatherApiDataSource]
        H[LocationServiceDataSource]
        I[CacheDataSource]
    end
    
    subgraph "Bloc Layer"
        J[WeatherBloc]
        K[LocationCubit]
    end
    
    C --> E
    D --> F
    E --> G
    E --> I
    F --> H
    F --> I
    
    J --> C
    K --> D
    
    A --> J
    B --> K
    
    style C fill:#e3f2fd
    style E fill:#fff3e0
    style J fill:#f3e5f5
```

---

## **Testing Strategy Overview**

```mermaid
graph TB
    subgraph "Unit Testing"
        A[Bloc Logic Tests]
        B[Repository Tests]
        C[Model Tests]
        D[Utility Tests]
    end
    
    subgraph "Integration Testing"
        E[Bloc + Repository]
        F[API Integration]
        G[Cache Integration]
        H[Service Integration]
    end
    
    subgraph "Widget Testing"
        I[BlocBuilder Tests]
        J[BlocListener Tests]
        K[User Interaction Tests]
        L[Error State Tests]
    end
    
    subgraph "End-to-End Testing"
        M[Complete User Flows]
        N[Multi-Bloc Scenarios]
        O[Real API Tests]
        P[Performance Tests]
    end
    
    A --> E
    B --> F
    E --> I
    F --> J
    I --> M
    J --> N
    
    style A fill:#4caf50
    style E fill:#2196f3
    style I fill:#ff9800
    style M fill:#9c27b0
```

---

## **Weather App Architecture Summary**

### **🎯 Bloc Pattern Advantages**
- **Event-Driven**: Clear separation between user actions and business logic
- **Testable**: Comprehensive testing with bloc_test package and mock repositories
- **Predictable**: Same event + state always produces same result
- **Debuggable**: Event stream provides clear audit trail of state changes
- **Scalable**: Multiple Blocs can coordinate complex application features
- **Maintainable**: Business logic separated from UI for better code organization

### **🧩 Key Components**
- **Events**: Represent what happened (user interactions, API responses)
- **States**: Represent current application condition (loading, success, error)
- **Bloc/Cubit**: Transform events into states with business logic
- **Repository**: Abstract data access for clean architecture
- **BlocBuilder**: UI rebuilds based on state changes
- **BlocListener**: Side effects like navigation and snackbars

### **⚡ Advanced Patterns**
- **Event Transformations**: Debounce, throttle, and switchMap for complex user interactions
- **Bloc Communication**: StreamSubscription and BlocListener for coordinated features
- **State Composition**: Complex state objects with multiple properties and transitions
- **Auto-Refresh**: Timer-based updates with stream subscriptions for real-time data
- **Error Recovery**: Graceful fallback to cached data with user-friendly error messages
- **Testing Excellence**: Comprehensive coverage with unit, widget, and integration tests

### **🏗️ Clean Architecture Benefits**
- **Separation of Concerns**: UI, business logic, and data layers clearly separated
- **Dependency Inversion**: Blocs depend on repository interfaces, not implementations
- **Testability**: Mock repositories and data sources for comprehensive testing
- **Maintainability**: Changes in one layer don't affect others
- **Scalability**: Easy to add new features without affecting existing code
- **Team Collaboration**: Clear boundaries enable multiple developers to work efficiently

### **🎯 Production Ready Features**
- **Offline Support**: Cached data with background sync when connection restored
- **Real-time Updates**: Stream providers for live weather data
- **Error Resilience**: Comprehensive error handling with graceful degradation
- **Performance Optimization**: Efficient state updates and memory management
- **User Experience**: Loading states, pull-to-refresh, and immediate feedback
- **Testing Coverage**: All critical paths validated with automated tests

**This Bloc foundation enables building scalable, maintainable Flutter applications with sophisticated business logic and excellent user experience! 🎯✨🔥**