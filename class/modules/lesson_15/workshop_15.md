# 🎯 Workshop

## 🎯 **What We're Building**

Create **AuthFlow Pro** - a comprehensive authentication and theme management system that demonstrates strategic integration of all four state management patterns in a single, production-ready application:

- **🔐 Enterprise Authentication** - Complete auth flows with security features and audit trails
- **🎨 Advanced Theme System** - Material 3 theming with user customization and accessibility
- **⚙️ User Preferences** - Comprehensive settings with real-time updates and persistence
- **📊 Analytics Dashboard** - User activity tracking and behavioral insights
- **🔒 Security Features** - Biometric auth, session management, and threat protection
- **🌐 Offline Capabilities** - Offline-first architecture with intelligent sync

## ✅ **Expected Outcome**

A production-ready application demonstrating:
- 🎯 **Strategic Pattern Usage** - Right pattern for each concern with clean integration
- 🏗️ **Clean Architecture** - Proper separation of concerns across multiple patterns
- 🔒 **Enterprise Security** - Production-grade authentication and session management
- 🎨 **Advanced Theming** - Sophisticated theme system with user customization
- 📈 **Performance Excellence** - Optimized for real-world usage and scaling
- 🧪 **Comprehensive Testing** - Full test coverage across all state management patterns

## 🏗️ **Project Architecture**

We'll build a hybrid state management architecture strategically using each pattern:

```
authflow_pro/
├── lib/
│   ├── core/                          # 🔧 Shared infrastructure
│   │   ├── constants/                 # App constants and configuration
│   │   ├── errors/                    # Error handling and custom exceptions
│   │   ├── utils/                     # Utility functions and helpers
│   │   ├── theme/                     # Theme system foundation
│   │   └── security/                  # Security utilities and encryption
│   ├── domain/                        # 🎯 Business logic layer
│   │   ├── entities/                  # Domain entities (User, Theme, etc.)
│   │   ├── repositories/              # Repository interfaces
│   │   ├── usecases/                  # Business use cases
│   │   └── services/                  # Domain services
│   ├── data/                          # 💾 Data access layer
│   │   ├── models/                    # Data models and DTOs
│   │   ├── repositories/              # Repository implementations
│   │   ├── datasources/               # API and local data sources
│   │   └── mappers/                   # Entity-model mappers
│   ├── presentation/                  # 🎨 UI layer with hybrid patterns
│   │   ├── auth/                      # 🎯 Bloc - Authentication flows
│   │   │   ├── bloc/                  # AuthBloc for complex flows
│   │   │   ├── screens/               # Login, register, profile screens
│   │   │   └── widgets/               # Auth-specific widgets
│   │   ├── theme/                     # ⚡ Riverpod - Theme management
│   │   │   ├── providers/             # Theme providers and notifiers
│   │   │   ├── screens/               # Theme customization screens
│   │   │   └── widgets/               # Theme widgets and controls
│   │   ├── settings/                  # 🔄 Provider - User preferences
│   │   │   ├── providers/             # Settings ChangeNotifier
│   │   │   ├── screens/               # Settings and preferences screens
│   │   │   └── widgets/               # Settings widgets
│   │   ├── dashboard/                 # 📊 Analytics and overview
│   │   │   ├── screens/               # Dashboard and analytics screens
│   │   │   └── widgets/               # Dashboard widgets
│   │   ├── common/                    # 📱 setState - Local UI state
│   │   │   ├── widgets/               # Reusable UI components
│   │   │   ├── forms/                 # Form components with local state
│   │   │   └── animations/            # Animation components
│   │   └── app/                       # App-level configuration
│   │       ├── app.dart               # Main app widget with providers
│   │       ├── routes.dart            # Navigation configuration
│   │       └── providers.dart         # Dependency injection setup
│   └── main.dart                      # 🚀 Application entry point
├── test/                              # 🧪 Comprehensive testing
│   ├── unit/                          # Unit tests for each pattern
│   ├── widget/                        # Widget tests with pattern integration
│   ├── integration/                   # Integration tests
│   └── mocks/                         # Mock implementations
└── assets/                            # 🎨 App assets and resources
    ├── images/                        # App images and icons
    ├── fonts/                         # Custom fonts
    └── animations/                    # Lottie animations
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Project Setup & Dependencies** ⏱️ *20 minutes*

Set up the project with all necessary dependencies for hybrid state management:

```yaml
# pubspec.yaml
name: authflow_pro
description: Production-ready authentication and theme management system
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  flutter_riverpod: ^2.4.5
  provider: ^6.0.5
  
  # Data & Persistence
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  
  # Authentication & Security
  local_auth: ^2.1.6
  crypto: ^3.0.3
  jwt_decoder: ^2.0.1
  
  # Network & API
  dio: ^5.3.2
  connectivity_plus: ^4.0.2
  
  # UI & Theme
  google_fonts: ^6.1.0
  dynamic_color: ^1.6.6
  flex_color_scheme: ^7.3.1
  
  # Utils
  equatable: ^2.0.5
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  uuid: ^4.1.0
  intl: ^0.18.1
  
  # Development
  flutter_lints: ^3.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Testing
  bloc_test: ^9.1.5
  mocktail: ^1.0.0
  integration_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.6
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/animations/
  fonts:
    - family: CustomFont
      fonts:
        - asset: assets/fonts/CustomFont-Regular.ttf
        - asset: assets/fonts/CustomFont-Bold.ttf
          weight: 700
```

### **Step 2: Domain Layer Foundation** ⏱️ *40 minutes*

Create the business entities and repository interfaces:

```dart
// lib/domain/entities/user.dart
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    String? avatar,
    required DateTime createdAt,
    DateTime? lastLoginAt,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isTwoFactorEnabled,
    @Default([]) List<String> roles,
    Map<String, dynamic>? metadata,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// Computed properties
extension UserExtension on User {
  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
  bool get isAdmin => roles.contains('admin');
  bool get isPremium => roles.contains('premium');
}

// lib/domain/entities/auth_token.dart
@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required String tokenType,
    Map<String, dynamic>? claims,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) => _$AuthTokenFromJson(json);
}

extension AuthTokenExtension on AuthToken {
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isExpiringSoon => 
      DateTime.now().add(const Duration(minutes: 5)).isAfter(expiresAt);
  Duration get timeUntilExpiry => expiresAt.difference(DateTime.now());
}

// lib/domain/entities/theme_settings.dart
@freezed
class ThemeSettings with _$ThemeSettings {
  const factory ThemeSettings({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default('material') String colorScheme,
    @Default(1.0) double textScaleFactor,
    @Default(false) bool highContrast,
    @Default(true) bool dynamicColors,
    @Default('system') String fontFamily,
    @Default({}) Map<String, int> customColors,
    @Default(false) bool reduceAnimations,
    @Default(true) bool showAnimations,
    @Default('en') String locale,
    DateTime? lastModified,
  }) = _ThemeSettings;

  factory ThemeSettings.fromJson(Map<String, dynamic> json) => 
      _$ThemeSettingsFromJson(json);
}

// lib/domain/entities/user_preferences.dart
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default(true) bool emailNotifications,
    @Default(true) bool pushNotifications,
    @Default(false) bool locationServices,
    @Default(true) bool analytics,
    @Default('en') String language,
    @Default('USD') String currency,
    @Default(300) int autoLockTimer, // seconds
    @Default(false) bool biometricEnabled,
    @Default([]) List<String> interests,
    @Default({}) Map<String, dynamic> customSettings,
    DateTime? lastSyncAt,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) => 
      _$UserPreferencesFromJson(json);
}

// lib/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  // Authentication operations
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> register(UserRegistration registration);
  Future<void> logout();
  Future<AuthResult> refreshToken(String refreshToken);
  
  // Password operations
  Future<void> resetPassword(String email);
  Future<void> changePassword(String currentPassword, String newPassword);
  
  // Session management
  Future<User?> getCurrentUser();
  Stream<AuthState> get authStateChanges;
  Future<bool> isAuthenticated();
  
  // Security features
  Future<BiometricAuthResult> authenticateWithBiometrics();
  Future<void> enableTwoFactor();
  Future<void> disableTwoFactor();
  Future<bool> verifyTwoFactorCode(String code);
  
  // Account management
  Future<void> updateProfile(UserProfile profile);
  Future<void> deleteAccount();
  Future<void> verifyEmail(String verificationCode);
}

// lib/domain/repositories/theme_repository.dart
abstract class ThemeRepository {
  Future<ThemeSettings> getThemeSettings();
  Future<void> saveThemeSettings(ThemeSettings settings);
  Stream<ThemeSettings> watchThemeSettings();
  Future<void> resetToDefaults();
  Future<Map<String, Color>> getSystemColors();
  Future<void> applySystemTheme();
}

// lib/domain/repositories/user_preferences_repository.dart
abstract class UserPreferencesRepository {
  Future<UserPreferences> getUserPreferences();
  Future<void> updatePreferences(UserPreferences preferences);
  Stream<UserPreferences> watchPreferences();
  Future<void> syncWithServer();
  Future<Map<String, dynamic>> exportPreferences();
  Future<void> importPreferences(Map<String, dynamic> data);
}

// lib/domain/usecases/auth_usecases.dart
class LoginUseCase {
  final AuthRepository _repository;
  final SecurityService _securityService;
  final AnalyticsService _analytics;

  LoginUseCase(this._repository, this._securityService, this._analytics);

  Future<AuthResult> execute(String email, String password) async {
    // Input validation
    if (email.isEmpty || password.isEmpty) {
      throw AuthException('Email and password are required');
    }

    // Security checks
    await _securityService.checkRateLimit(email);
    await _securityService.validateIpAddress();

    // Attempt login
    final result = await _repository.login(email, password);

    // Track successful login
    await _analytics.trackLoginSuccess(result.user.id);

    return result;
  }
}

class LogoutUseCase {
  final AuthRepository _repository;
  final SecurityService _securityService;
  final AnalyticsService _analytics;

  LogoutUseCase(this._repository, this._securityService, this._analytics);

  Future<void> execute() async {
    final user = await _repository.getCurrentUser();
    
    // Perform logout
    await _repository.logout();
    
    // Clear security data
    await _securityService.clearStoredCredentials();
    
    // Track logout
    if (user != null) {
      await _analytics.trackLogout(user.id);
    }
  }
}
```

### **Step 3: Authentication Bloc Implementation** ⏱️ *60 minutes*

Create the comprehensive authentication system using Bloc:

```dart
// lib/presentation/auth/bloc/auth_event.dart
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class AuthInitializationRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;
  
  const AuthLoginRequested({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
  
  @override
  List<Object> get props => [email, password, rememberMe];
}

class AuthRegistrationRequested extends AuthEvent {
  final UserRegistration registration;
  
  const AuthRegistrationRequested(this.registration);
  
  @override
  List<Object> get props => [registration];
}

class AuthBiometricRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthTokenRefreshRequested extends AuthEvent {}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  
  const AuthPasswordResetRequested(this.email);
  
  @override
  List<Object> get props => [email];
}

class AuthEmailVerificationRequested extends AuthEvent {
  final String verificationCode;
  
  const AuthEmailVerificationRequested(this.verificationCode);
  
  @override
  List<Object> get props => [verificationCode];
}

class AuthTwoFactorToggled extends AuthEvent {
  final bool enabled;
  
  const AuthTwoFactorToggled(this.enabled);
  
  @override
  List<Object> get props => [enabled];
}

// lib/presentation/auth/bloc/auth_state.dart
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final String? message;
  
  const AuthLoading({this.message});
  
  @override
  List<Object?> get props => [message];
}

class AuthAuthenticated extends AuthState {
  final User user;
  final AuthToken token;
  final DateTime authenticatedAt;
  final AuthMethod method;
  
  const AuthAuthenticated({
    required this.user,
    required this.token,
    required this.authenticatedAt,
    required this.method,
  });
  
  @override
  List<Object> get props => [user, token, authenticatedAt, method];
}

class AuthUnauthenticated extends AuthState {
  final String? reason;
  
  const AuthUnauthenticated({this.reason});
  
  @override
  List<Object?> get props => [reason];
}

class AuthError extends AuthState {
  final String message;
  final AuthErrorType type;
  final DateTime timestamp;
  
  const AuthError({
    required this.message,
    required this.type,
    required this.timestamp,
  });
  
  @override
  List<Object> get props => [message, type, timestamp];
}

class AuthPasswordResetEmailSent extends AuthState {
  final String email;
  
  const AuthPasswordResetEmailSent(this.email);
  
  @override
  List<Object> get props => [email];
}

class AuthEmailVerificationRequired extends AuthState {
  final User user;
  
  const AuthEmailVerificationRequired(this.user);
  
  @override
  List<Object> get props => [user];
}

// lib/presentation/auth/bloc/auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final SecurityService _securityService;
  final AnalyticsService _analyticsService;
  final BiometricService _biometricService;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  
  StreamSubscription<AuthState>? _authStreamSubscription;
  Timer? _tokenRefreshTimer;

  AuthBloc({
    required AuthRepository authRepository,
    required SecurityService securityService,
    required AnalyticsService analyticsService,
    required BiometricService biometricService,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _authRepository = authRepository,
        _securityService = securityService,
        _analyticsService = analyticsService,
        _biometricService = biometricService,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthInitial()) {
    
    // Register event handlers
    on<AuthInitializationRequested>(_onInitializationRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegistrationRequested>(_onRegistrationRequested);
    on<AuthBiometricRequested>(_onBiometricRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthTokenRefreshRequested>(_onTokenRefreshRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthEmailVerificationRequested>(_onEmailVerificationRequested);
    on<AuthTwoFactorToggled>(_onTwoFactorToggled);
    
    // Listen to auth state changes
    _authStreamSubscription = _authRepository.authStateChanges.listen(
      (authState) {
        if (authState is AuthTokenExpired) {
          add(AuthTokenRefreshRequested());
        }
      },
    );
    
    // Initialize authentication state
    add(AuthInitializationRequested());
  }

  Future<void> _onInitializationRequested(
    AuthInitializationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Initializing...'));
    
    try {
      final user = await _authRepository.getCurrentUser();
      
      if (user != null) {
        // Check if token is still valid
        final isAuthenticated = await _authRepository.isAuthenticated();
        
        if (isAuthenticated) {
          // Get current token
          final token = await _securityService.getCurrentToken();
          
          if (token != null) {
            emit(AuthAuthenticated(
              user: user,
              token: token,
              authenticatedAt: DateTime.now(),
              method: AuthMethod.storedCredentials,
            ));
            
            _scheduleTokenRefresh(token);
            return;
          }
        }
      }
      
      emit(const AuthUnauthenticated());
    } catch (error) {
      emit(AuthError(
        message: 'Failed to initialize authentication',
        type: AuthErrorType.initialization,
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Signing in...'));
    
    try {
      final result = await _loginUseCase.execute(event.email, event.password);
      
      // Check if email verification is required
      if (!result.user.isEmailVerified) {
        emit(AuthEmailVerificationRequired(result.user));
        return;
      }
      
      // Store credentials if remember me is enabled
      if (event.rememberMe) {
        await _securityService.storeCredentials(result.token);
      }
      
      emit(AuthAuthenticated(
        user: result.user,
        token: result.token,
        authenticatedAt: DateTime.now(),
        method: AuthMethod.emailPassword,
      ));
      
      _scheduleTokenRefresh(result.token);
      
    } on AuthException catch (e) {
      emit(AuthError(
        message: e.message,
        type: e.type,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      emit(AuthError(
        message: 'An unexpected error occurred during login',
        type: AuthErrorType.unknown,
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _onBiometricRequested(
    AuthBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Verifying biometric...'));
    
    try {
      final isAvailable = await _biometricService.isAvailable();
      if (!isAvailable) {
        emit(AuthError(
          message: 'Biometric authentication is not available on this device',
          type: AuthErrorType.biometricNotAvailable,
          timestamp: DateTime.now(),
        ));
        return;
      }
      
      final biometricResult = await _biometricService.authenticate(
        localizedFallbackTitle: 'Use PIN',
        reason: 'Authenticate to access your account',
      );
      
      if (biometricResult.isSuccess) {
        final result = await _authRepository.authenticateWithBiometrics();
        
        emit(AuthAuthenticated(
          user: result.user,
          token: result.token,
          authenticatedAt: DateTime.now(),
          method: AuthMethod.biometric,
        ));
        
        _scheduleTokenRefresh(result.token);
      } else {
        emit(AuthError(
          message: biometricResult.errorMessage ?? 'Biometric authentication failed',
          type: AuthErrorType.biometricFailed,
          timestamp: DateTime.now(),
        ));
      }
    } catch (e) {
      emit(AuthError(
        message: 'Biometric authentication error',
        type: AuthErrorType.biometricError,
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Signing out...'));
    
    try {
      await _logoutUseCase.execute();
      _cancelTokenRefresh();
      emit(const AuthUnauthenticated(reason: 'User logged out'));
    } catch (e) {
      emit(AuthError(
        message: 'Failed to logout properly',
        type: AuthErrorType.logout,
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _onTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) return;
    
    final currentState = state as AuthAuthenticated;
    
    try {
      final result = await _authRepository.refreshToken(
        currentState.token.refreshToken,
      );
      
      emit(currentState.copyWith(token: result.token));
      _scheduleTokenRefresh(result.token);
      
    } catch (e) {
      // Token refresh failed, force logout
      emit(const AuthUnauthenticated(reason: 'Session expired'));
    }
  }

  void _scheduleTokenRefresh(AuthToken token) {
    _cancelTokenRefresh();
    
    // Refresh token 5 minutes before expiry
    final refreshTime = token.expiresAt.subtract(const Duration(minutes: 5));
    final delay = refreshTime.difference(DateTime.now());
    
    if (delay.isNegative) {
      // Token is already expired or about to expire
      add(AuthTokenRefreshRequested());
    } else {
      _tokenRefreshTimer = Timer(delay, () {
        add(AuthTokenRefreshRequested());
      });
    }
  }

  void _cancelTokenRefresh() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = null;
  }

  @override
  Future<void> close() {
    _authStreamSubscription?.cancel();
    _cancelTokenRefresh();
    return super.close();
  }
}
```

### **Step 4: Theme Management with Riverpod** ⏱️ *45 minutes*

Implement advanced theme management using Riverpod:

```dart
// lib/presentation/theme/providers/theme_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';

// Repository provider
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return ThemeRepositoryImpl(
    localStorage: ref.read(localStorageProvider),
    systemService: ref.read(systemServiceProvider),
  );
});

// Theme settings provider
final themeSettingsProvider = StateNotifierProvider<ThemeSettingsNotifier, AsyncValue<ThemeSettings>>((ref) {
  return ThemeSettingsNotifier(ref.read(themeRepositoryProvider));
});

// System color scheme provider
final systemColorSchemeProvider = FutureProvider<ColorScheme?>((ref) async {
  try {
    final corePalette = await DynamicColorPlugin.getCorePalette();
    if (corePalette != null) {
      return ColorScheme.fromSeed(seedColor: Color(corePalette.primary.get(40)));
    }
  } catch (e) {
    // System colors not available
  }
  return null;
});

// Current theme data provider
final currentThemeDataProvider = Provider<ThemeData>((ref) {
  final settingsAsync = ref.watch(themeSettingsProvider);
  final systemColorScheme = ref.watch(systemColorSchemeProvider).valueOrNull;
  
  return settingsAsync.when(
    loading: () => _getDefaultTheme(systemColorScheme),
    error: (error, stack) => _getDefaultTheme(systemColorScheme),
    data: (settings) => _buildThemeFromSettings(settings, systemColorScheme),
  );
});

// Dark theme data provider
final darkThemeDataProvider = Provider<ThemeData>((ref) {
  final settingsAsync = ref.watch(themeSettingsProvider);
  final systemColorScheme = ref.watch(systemColorSchemeProvider).valueOrNull;
  
  return settingsAsync.when(
    loading: () => _getDefaultDarkTheme(systemColorScheme),
    error: (error, stack) => _getDefaultDarkTheme(systemColorScheme),
    data: (settings) => _buildDarkThemeFromSettings(settings, systemColorScheme),
  );
});

// Accessibility theme provider
final accessibilityThemeProvider = Provider.family<ThemeData, Brightness>((ref, brightness) {
  final settings = ref.watch(themeSettingsProvider).valueOrNull;
  final baseTheme = brightness == Brightness.light 
      ? ref.watch(currentThemeDataProvider)
      : ref.watch(darkThemeDataProvider);
  
  if (settings == null) return baseTheme;
  
  return _applyAccessibilitySettings(baseTheme, settings);
});

// Theme mode provider
final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(themeSettingsProvider).valueOrNull;
  return settings?.themeMode ?? ThemeMode.system;
});

// Theme settings notifier
class ThemeSettingsNotifier extends StateNotifier<AsyncValue<ThemeSettings>> {
  final ThemeRepository _repository;
  StreamSubscription<ThemeSettings>? _streamSubscription;

  ThemeSettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final settings = await _repository.getThemeSettings();
      state = AsyncValue.data(settings);
      
      // Listen for external changes (e.g., from settings sync)
      _streamSubscription = _repository.watchThemeSettings().listen(
        (settings) {
          if (mounted) {
            state = AsyncValue.data(settings);
          }
        },
        onError: (error, stackTrace) {
          if (mounted) {
            state = AsyncValue.error(error, stackTrace);
          }
        },
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    await _updateSettings((settings) => settings.copyWith(themeMode: mode));
  }

  Future<void> updateColorScheme(String colorScheme) async {
    await _updateSettings((settings) => settings.copyWith(colorScheme: colorScheme));
  }

  Future<void> updateTextScaleFactor(double factor) async {
    await _updateSettings((settings) => settings.copyWith(textScaleFactor: factor));
  }

  Future<void> toggleHighContrast() async {
    final current = state.valueOrNull;
    if (current != null) {
      await _updateSettings((settings) => settings.copyWith(highContrast: !settings.highContrast));
    }
  }

  Future<void> toggleDynamicColors() async {
    final current = state.valueOrNull;
    if (current != null) {
      await _updateSettings((settings) => settings.copyWith(dynamicColors: !settings.dynamicColors));
    }
  }

  Future<void> updateFontFamily(String fontFamily) async {
    await _updateSettings((settings) => settings.copyWith(fontFamily: fontFamily));
  }

  Future<void> updateCustomColor(String colorKey, Color color) async {
    final current = state.valueOrNull;
    if (current != null) {
      final updatedColors = Map<String, int>.from(current.customColors);
      updatedColors[colorKey] = color.value;
      
      await _updateSettings((settings) => settings.copyWith(customColors: updatedColors));
    }
  }

  Future<void> removeCustomColor(String colorKey) async {
    final current = state.valueOrNull;
    if (current != null) {
      final updatedColors = Map<String, int>.from(current.customColors);
      updatedColors.remove(colorKey);
      
      await _updateSettings((settings) => settings.copyWith(customColors: updatedColors));
    }
  }

  Future<void> toggleAnimations() async {
    final current = state.valueOrNull;
    if (current != null) {
      await _updateSettings((settings) => settings.copyWith(
        showAnimations: !settings.showAnimations,
        reduceAnimations: settings.showAnimations, // Inverse relationship
      ));
    }
  }

  Future<void> resetToDefaults() async {
    const defaultSettings = ThemeSettings();
    state = const AsyncValue.data(defaultSettings);
    
    try {
      await _repository.saveThemeSettings(defaultSettings);
    } catch (error, stackTrace) {
      // Revert on error
      await _initialize();
      rethrow;
    }
  }

  Future<void> applySystemTheme() async {
    try {
      await _repository.applySystemTheme();
      await _initialize(); // Reload settings
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> _updateSettings(ThemeSettings Function(ThemeSettings) updater) async {
    final currentSettings = state.valueOrNull;
    if (currentSettings == null) return;

    final updatedSettings = updater(currentSettings).copyWith(
      lastModified: DateTime.now(),
    );
    
    state = AsyncValue.data(updatedSettings);

    try {
      await _repository.saveThemeSettings(updatedSettings);
    } catch (error, stackTrace) {
      // Revert on error
      state = AsyncValue.data(currentSettings);
      rethrow;
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}

// Theme building utilities
ThemeData _buildThemeFromSettings(ThemeSettings settings, ColorScheme? systemColorScheme) {
  ColorScheme colorScheme;
  
  if (settings.dynamicColors && systemColorScheme != null) {
    colorScheme = systemColorScheme;
  } else {
    colorScheme = _getColorSchemeByName(settings.colorScheme, Brightness.light);
  }
  
  // Apply custom colors
  if (settings.customColors.isNotEmpty) {
    colorScheme = _applyCustomColors(colorScheme, settings.customColors);
  }
  
  // Apply high contrast
  if (settings.highContrast) {
    colorScheme = _enhanceContrast(colorScheme);
  }
  
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: _getFontFamily(settings.fontFamily),
    textTheme: _buildTextTheme(settings),
    pageTransitionsTheme: _buildPageTransitions(settings),
    extensions: [
      CustomThemeExtension.fromSettings(settings),
    ],
  );
}

ThemeData _applyAccessibilitySettings(ThemeData baseTheme, ThemeSettings settings) {
  var theme = baseTheme;
  
  // Apply text scaling
  if (settings.textScaleFactor != 1.0) {
    theme = theme.copyWith(
      textTheme: theme.textTheme.apply(
        fontSizeFactor: settings.textScaleFactor,
      ),
    );
  }
  
  // Apply animation preferences
  if (settings.reduceAnimations) {
    theme = theme.copyWith(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
  
  return theme;
}

// Custom theme extension
@immutable
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color? accentColor;
  final Color? warningColor;
  final double borderRadius;
  final EdgeInsets defaultPadding;
  
  const CustomThemeExtension({
    this.accentColor,
    this.warningColor,
    this.borderRadius = 8.0,
    this.defaultPadding = const EdgeInsets.all(16.0),
  });

  factory CustomThemeExtension.fromSettings(ThemeSettings settings) {
    return CustomThemeExtension(
      accentColor: settings.customColors.containsKey('accent')
          ? Color(settings.customColors['accent']!)
          : null,
      warningColor: settings.customColors.containsKey('warning')
          ? Color(settings.customColors['warning']!)
          : null,
      borderRadius: settings.reduceAnimations ? 4.0 : 8.0,
    );
  }

  @override
  CustomThemeExtension copyWith({
    Color? accentColor,
    Color? warningColor,
    double? borderRadius,
    EdgeInsets? defaultPadding,
  }) {
    return CustomThemeExtension(
      accentColor: accentColor ?? this.accentColor,
      warningColor: warningColor ?? this.warningColor,
      borderRadius: borderRadius ?? this.borderRadius,
      defaultPadding: defaultPadding ?? this.defaultPadding,
    );
  }

  @override
  CustomThemeExtension lerp(ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      accentColor: Color.lerp(accentColor, other.accentColor, t),
      warningColor: Color.lerp(warningColor, other.warningColor, t),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t) ?? borderRadius,
      defaultPadding: EdgeInsets.lerp(defaultPadding, other.defaultPadding, t) ?? defaultPadding,
    );
  }
}
```

### **Step 5: User Settings with Provider** ⏱️ *35 minutes*

Implement user preferences management using Provider:

```dart
// lib/presentation/settings/providers/user_settings_provider.dart
class UserSettingsProvider extends ChangeNotifier {
  final UserPreferencesRepository _repository;
  final NotificationService _notificationService;
  final AnalyticsService _analyticsService;
  final SecurityService _securityService;
  
  UserPreferences _preferences = const UserPreferences();
  bool _isLoading = false;
  String? _error;
  DateTime? _lastSyncAt;

  UserSettingsProvider({
    required UserPreferencesRepository repository,
    required NotificationService notificationService,
    required AnalyticsService analyticsService,
    required SecurityService securityService,
  })  : _repository = repository,
        _notificationService = notificationService,
        _analyticsService = analyticsService,
        _securityService = securityService {
    _initialize();
  }

  // Getters
  UserPreferences get preferences => _preferences;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastSyncAt => _lastSyncAt;

  bool get emailNotifications => _preferences.emailNotifications;
  bool get pushNotifications => _preferences.pushNotifications;
  bool get locationServices => _preferences.locationServices;
  bool get analytics => _preferences.analytics;
  String get language => _preferences.language;
  String get currency => _preferences.currency;
  int get autoLockTimer => _preferences.autoLockTimer;
  bool get biometricEnabled => _preferences.biometricEnabled;
  List<String> get interests => _preferences.interests;
  Map<String, dynamic> get customSettings => _preferences.customSettings;

  Future<void> _initialize() async {
    _setLoading(true);
    
    try {
      _preferences = await _repository.getUserPreferences();
      _error = null;
      _lastSyncAt = _preferences.lastSyncAt;
      
      // Listen for server-side changes
      _repository.watchPreferences().listen(
        (preferences) {
          if (preferences != _preferences) {
            _preferences = preferences;
            _lastSyncAt = preferences.lastSyncAt;
            notifyListeners();
          }
        },
        onError: (error) {
          _error = error.toString();
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
    }
    
    _setLoading(false);
  }

  Future<void> toggleEmailNotifications() async {
    await _updatePreferences(
      _preferences.copyWith(emailNotifications: !_preferences.emailNotifications),
    );
  }

  Future<void> togglePushNotifications() async {
    final newValue = !_preferences.pushNotifications;
    
    await _updatePreferences(
      _preferences.copyWith(pushNotifications: newValue),
    );
    
    // Update notification service
    if (newValue) {
      await _notificationService.requestPermission();
      await _notificationService.subscribeToTopics(_preferences.interests);
    } else {
      await _notificationService.unsubscribeFromAllTopics();
    }
  }

  Future<void> toggleLocationServices() async {
    final newValue = !_preferences.locationServices;
    
    if (newValue) {
      final hasPermission = await _requestLocationPermission();
      if (!hasPermission) {
        _error = 'Location permission denied';
        notifyListeners();
        return;
      }
    }
    
    await _updatePreferences(
      _preferences.copyWith(locationServices: newValue),
    );
  }

  Future<void> toggleAnalytics() async {
    final newValue = !_preferences.analytics;
    
    await _updatePreferences(
      _preferences.copyWith(analytics: newValue),
    );
    
    // Update analytics service
    await _analyticsService.setAnalyticsEnabled(newValue);
  }

  Future<void> updateLanguage(String language) async {
    if (_preferences.language != language) {
      await _updatePreferences(
        _preferences.copyWith(language: language),
      );
      
      // Trigger app-wide language change
      await _applyLanguageChange(language);
    }
  }

  Future<void> updateCurrency(String currency) async {
    await _updatePreferences(
      _preferences.copyWith(currency: currency),
    );
  }

  Future<void> updateAutoLockTimer(int seconds) async {
    await _updatePreferences(
      _preferences.copyWith(autoLockTimer: seconds),
    );
    
    // Update security service
    await _securityService.updateAutoLockTimer(seconds);
  }

  Future<void> toggleBiometric() async {
    final newValue = !_preferences.biometricEnabled;
    
    if (newValue) {
      final canUseBiometric = await _securityService.canUseBiometric();
      if (!canUseBiometric) {
        _error = 'Biometric authentication is not available';
        notifyListeners();
        return;
      }
      
      final isAuthenticated = await _securityService.authenticateWithBiometric();
      if (!isAuthenticated) {
        _error = 'Biometric authentication failed';
        notifyListeners();
        return;
      }
    }
    
    await _updatePreferences(
      _preferences.copyWith(biometricEnabled: newValue),
    );
    
    // Update security service
    await _securityService.setBiometricEnabled(newValue);
  }

  Future<void> addInterest(String interest) async {
    if (!_preferences.interests.contains(interest)) {
      final updatedInterests = [..._preferences.interests, interest];
      await _updatePreferences(
        _preferences.copyWith(interests: updatedInterests),
      );
      
      // Update notification topics
      if (_preferences.pushNotifications) {
        await _notificationService.subscribeToTopic(interest);
      }
    }
  }

  Future<void> removeInterest(String interest) async {
    if (_preferences.interests.contains(interest)) {
      final updatedInterests = _preferences.interests
          .where((i) => i != interest)
          .toList();
      
      await _updatePreferences(
        _preferences.copyWith(interests: updatedInterests),
      );
      
      // Update notification topics
      await _notificationService.unsubscribeFromTopic(interest);
    }
  }

  Future<void> updateCustomSetting(String key, dynamic value) async {
    final updatedSettings = Map<String, dynamic>.from(_preferences.customSettings);
    updatedSettings[key] = value;
    
    await _updatePreferences(
      _preferences.copyWith(customSettings: updatedSettings),
    );
  }

  Future<void> removeCustomSetting(String key) async {
    final updatedSettings = Map<String, dynamic>.from(_preferences.customSettings);
    updatedSettings.remove(key);
    
    await _updatePreferences(
      _preferences.copyWith(customSettings: updatedSettings),
    );
  }

  Future<void> resetToDefaults() async {
    const defaultPreferences = UserPreferences();
    
    await _updatePreferences(defaultPreferences);
    
    // Reset all related services
    await _notificationService.reset();
    await _securityService.resetToDefaults();
    await _analyticsService.reset();
  }

  Future<void> syncWithServer() async {
    _setLoading(true);
    
    try {
      await _repository.syncWithServer();
      _preferences = await _repository.getUserPreferences();
      _lastSyncAt = _preferences.lastSyncAt;
      _error = null;
    } catch (e) {
      _error = 'Failed to sync settings: $e';
    }
    
    _setLoading(false);
  }

  Future<Map<String, dynamic>> exportSettings() async {
    return await _repository.exportPreferences();
  }

  Future<void> importSettings(Map<String, dynamic> data) async {
    _setLoading(true);
    
    try {
      await _repository.importPreferences(data);
      _preferences = await _repository.getUserPreferences();
      _error = null;
      
      // Apply imported settings
      await _applyAllSettings();
    } catch (e) {
      _error = 'Failed to import settings: $e';
    }
    
    _setLoading(false);
  }

  Future<void> _updatePreferences(UserPreferences newPreferences) async {
    _preferences = newPreferences;
    notifyListeners();
    
    try {
      await _repository.updatePreferences(newPreferences);
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> _requestLocationPermission() async {
    // Implementation would request location permission
    return true; // Simplified for demo
  }

  Future<void> _applyLanguageChange(String language) async {
    // Implementation would trigger app-wide language change
  }

  Future<void> _applyAllSettings() async {
    // Apply all settings to their respective services
    await _notificationService.applySettings(_preferences);
    await _securityService.applySettings(_preferences);
    await _analyticsService.applySettings(_preferences);
  }
}

// lib/presentation/settings/providers/settings_providers.dart
final userSettingsProvider = ChangeNotifierProvider<UserSettingsProvider>((ref) {
  return UserSettingsProvider(
    repository: ref.read(userPreferencesRepositoryProvider),
    notificationService: ref.read(notificationServiceProvider),
    analyticsService: ref.read(analyticsServiceProvider),
    securityService: ref.read(securityServiceProvider),
  );
});

// Computed providers for specific settings
final notificationSettingsProvider = Provider<NotificationSettings>((ref) {
  final settings = ref.watch(userSettingsProvider);
  return NotificationSettings(
    emailEnabled: settings.emailNotifications,
    pushEnabled: settings.pushNotifications,
    interests: settings.interests,
  );
});

final securitySettingsProvider = Provider<SecuritySettings>((ref) {
  final settings = ref.watch(userSettingsProvider);
  return SecuritySettings(
    biometricEnabled: settings.biometricEnabled,
    autoLockTimer: settings.autoLockTimer,
  );
});

final localizationSettingsProvider = Provider<LocalizationSettings>((ref) {
  final settings = ref.watch(userSettingsProvider);
  return LocalizationSettings(
    language: settings.language,
    currency: settings.currency,
  );
});
```

*This is part 1 of the workshop. Continue with UI implementation, local state management with setState, integration patterns, and comprehensive testing...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_15

# Install dependencies
flutter pub get
flutter pub add flutter_bloc flutter_riverpod provider hive local_auth crypto

# Generate code
flutter packages pub run build_runner build

# Run the app
flutter run

# Test the hybrid architecture
# 1. Test authentication flows with Bloc
# 2. Customize themes with Riverpod
# 3. Adjust settings with Provider
# 4. Interact with local UI state (setState)
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **Hybrid State Management** - Strategic integration of multiple patterns in a single application
- **Clean Architecture** - Proper separation of concerns across different state management approaches
- **Production Patterns** - Building applications ready for real-world deployment and scaling
- **Testing Strategies** - Comprehensive testing across multiple state management patterns
- **Performance Optimization** - Monitoring and optimizing applications with multiple patterns
- **Team Guidelines** - Establishing standards for hybrid state management architectures

**Ready to build production-ready applications with strategic state management? 🎯✨**