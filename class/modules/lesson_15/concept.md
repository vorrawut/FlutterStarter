# 🎯 Lesson 15: Mini Project - Auth + Theme App - Concepts

## 🎯 **Learning Objectives**

By the end of this lesson, you will master:
- **Hybrid State Management Architecture** - Strategic integration of multiple patterns in a single application
- **Authentication System Design** - Complete user authentication flows with secure state management
- **Advanced Theme Management** - Sophisticated theming system with user preferences and persistence
- **Clean Architecture Integration** - Combining multiple state management patterns with clean architecture principles
- **Production-Ready Patterns** - Building applications ready for real-world deployment and scaling
- **Comprehensive Testing Strategies** - Testing complex applications with multiple state management approaches

## 📚 **Project Overview: AuthFlow Pro**

### **What We're Building**

A comprehensive **Authentication & Theme Management System** that demonstrates strategic use of all four state management patterns in a single, production-ready application:

- **🔐 Complete Authentication System** - Registration, login, profile management, password reset
- **🎨 Advanced Theme Management** - Material 3 theming with user customization and persistence
- **⚙️ User Settings & Preferences** - Comprehensive user preference management
- **📊 Analytics Dashboard** - User activity tracking and insights
- **🔒 Security Features** - Secure token management, biometric authentication, session handling
- **🌐 Offline Support** - Offline-first authentication with sync capabilities

### **Hybrid Architecture Strategy**

This project strategically uses different state management patterns for different concerns:

```dart
// Strategic Pattern Assignment
Authentication Flow:    Bloc        (Complex business logic, audit trails)
Theme Management:       Riverpod    (Reactive updates, type safety)
User Settings:          Provider    (Shared state, simple updates)
Local UI State:         setState    (Forms, toggles, animations)
```

## 🏗️ **Architecture Deep Dive**

### **1. Clean Architecture with Multiple Patterns**

```dart
// Domain Layer - Pattern Agnostic
abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(UserRegistration registration);
  Future<void> logout();
  Stream<AuthState> get authStateChanges;
}

abstract class ThemeRepository {
  Future<ThemeSettings> getThemeSettings();
  Future<void> saveThemeSettings(ThemeSettings settings);
  Stream<ThemeSettings> watchThemeSettings();
}

abstract class UserPreferencesRepository {
  Future<UserPreferences> getUserPreferences();
  Future<void> updatePreferences(UserPreferences preferences);
}

// Data Layer - Implementation Details
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  final AuthLocalStorage _localStorage;
  final SecurityService _securityService;
  
  @override
  Future<User> login(String email, String password) async {
    // Complex authentication logic
    final credentials = await _securityService.encryptCredentials(email, password);
    final response = await _apiService.authenticate(credentials);
    await _localStorage.storeAuthToken(response.token);
    return response.user;
  }
}

// Presentation Layer - Pattern-Specific Implementations
// Different patterns handle different concerns
```

### **2. Authentication State Management with Bloc**

Authentication requires complex business logic, multiple states, and audit trails - perfect for Bloc:

```dart
// Authentication Events
abstract class AuthEvent extends Equatable {}

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

class AuthLogoutRequested extends AuthEvent {}

class AuthTokenRefreshRequested extends AuthEvent {}

class AuthBiometricRequested extends AuthEvent {}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  
  const AuthPasswordResetRequested(this.email);
  
  @override
  List<Object> get props => [email];
}

// Authentication States
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  final String? loadingMessage;
  
  const AuthLoading({this.loadingMessage});
  
  @override
  List<Object?> get props => [loadingMessage];
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
  final AuthError error;
  final String message;
  final DateTime occurredAt;
  
  const AuthError({
    required this.error,
    required this.message,
    required this.occurredAt,
  });
  
  @override
  List<Object> get props => [error, message, occurredAt];
}

class AuthPasswordResetSent extends AuthState {
  final String email;
  final DateTime sentAt;
  
  const AuthPasswordResetSent({
    required this.email,
    required this.sentAt,
  });
  
  @override
  List<Object> get props => [email, sentAt];
}

// Authentication Bloc Implementation
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final SecurityService _securityService;
  final AnalyticsService _analyticsService;
  final BiometricService _biometricService;
  
  AuthBloc({
    required AuthRepository authRepository,
    required SecurityService securityService,
    required AnalyticsService analyticsService,
    required BiometricService biometricService,
  })  : _authRepository = authRepository,
        _securityService = securityService,
        _analyticsService = analyticsService,
        _biometricService = biometricService,
        super(AuthInitial()) {
    
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegistrationRequested>(_onRegistrationRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthTokenRefreshRequested>(_onTokenRefreshRequested);
    on<AuthBiometricRequested>(_onBiometricRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    
    // Listen to auth state changes
    _authRepository.authStateChanges.listen((authState) {
      if (authState is AuthTokenExpired) {
        add(AuthTokenRefreshRequested());
      }
    });
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(loadingMessage: 'Signing in...'));
    
    try {
      // Input validation
      final validationResult = _validateLoginInput(event.email, event.password);
      if (!validationResult.isValid) {
        emit(AuthError(
          error: AuthErrorType.validation,
          message: validationResult.message,
          occurredAt: DateTime.now(),
        ));
        return;
      }
      
      // Security checks
      final securityCheck = await _securityService.performSecurityCheck(
        email: event.email,
        ipAddress: await _securityService.getCurrentIpAddress(),
      );
      
      if (securityCheck.requiresCaptcha) {
        emit(AuthCaptchaRequired(challengeId: securityCheck.challengeId));
        return;
      }
      
      if (securityCheck.isBlocked) {
        emit(AuthError(
          error: AuthErrorType.accountBlocked,
          message: 'Account temporarily blocked due to security concerns',
          occurredAt: DateTime.now(),
        ));
        return;
      }
      
      // Attempt authentication
      final result = await _authRepository.login(event.email, event.password);
      
      // Store login preferences
      if (event.rememberMe) {
        await _securityService.enableRememberMe(result.token);
      }
      
      // Track successful login
      await _analyticsService.trackAuthEvent(
        AuthAnalyticsEvent.loginSuccess,
        userId: result.user.id,
        method: AuthMethod.emailPassword,
      );
      
      emit(AuthAuthenticated(
        user: result.user,
        token: result.token,
        authenticatedAt: DateTime.now(),
        method: AuthMethod.emailPassword,
      ));
      
    } on AuthException catch (e) {
      await _analyticsService.trackAuthEvent(
        AuthAnalyticsEvent.loginFailure,
        error: e.toString(),
        method: AuthMethod.emailPassword,
      );
      
      emit(AuthError(
        error: e.type,
        message: e.message,
        occurredAt: DateTime.now(),
      ));
    } catch (e) {
      emit(AuthError(
        error: AuthErrorType.unknown,
        message: 'An unexpected error occurred',
        occurredAt: DateTime.now(),
      ));
    }
  }

  Future<void> _onBiometricRequested(
    AuthBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(loadingMessage: 'Verifying biometric...'));
    
    try {
      final isAvailable = await _biometricService.isAvailable();
      if (!isAvailable) {
        emit(AuthError(
          error: AuthErrorType.biometricNotAvailable,
          message: 'Biometric authentication is not available',
          occurredAt: DateTime.now(),
        ));
        return;
      }
      
      final biometricResult = await _biometricService.authenticate(
        reason: 'Use your fingerprint or face to sign in',
      );
      
      if (biometricResult.isSuccess) {
        final storedCredentials = await _securityService.getStoredCredentials();
        if (storedCredentials != null) {
          final result = await _authRepository.loginWithStoredCredentials(
            storedCredentials,
          );
          
          await _analyticsService.trackAuthEvent(
            AuthAnalyticsEvent.loginSuccess,
            userId: result.user.id,
            method: AuthMethod.biometric,
          );
          
          emit(AuthAuthenticated(
            user: result.user,
            token: result.token,
            authenticatedAt: DateTime.now(),
            method: AuthMethod.biometric,
          ));
        }
      } else {
        emit(AuthError(
          error: AuthErrorType.biometricFailed,
          message: biometricResult.error ?? 'Biometric authentication failed',
          occurredAt: DateTime.now(),
        ));
      }
    } catch (e) {
      emit(AuthError(
        error: AuthErrorType.unknown,
        message: 'Biometric authentication error',
        occurredAt: DateTime.now(),
      ));
    }
  }
}
```

### **3. Theme Management with Riverpod**

Theme management benefits from Riverpod's reactive nature and type safety:

```dart
// Theme Models
@freezed
class ThemeSettings with _$ThemeSettings {
  const factory ThemeSettings({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(AppColorScheme.material) AppColorScheme colorScheme,
    @Default(1.0) double textScaleFactor,
    @Default(false) bool highContrast,
    @Default(true) bool dynamicColors,
    @Default(AppFont.system) AppFont fontFamily,
    @Default({}) Map<String, dynamic> customColors,
    @Default(false) bool reduceAnimations,
    @Default(true) bool showAnimations,
  }) = _ThemeSettings;

  factory ThemeSettings.fromJson(Map<String, dynamic> json) =>
      _$ThemeSettingsFromJson(json);
}

// Riverpod Providers
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return ThemeRepositoryImpl(
    localStorage: ref.read(localStorageProvider),
    apiService: ref.read(apiServiceProvider),
  );
});

final themeSettingsProvider = StateNotifierProvider<ThemeSettingsNotifier, AsyncValue<ThemeSettings>>((ref) {
  return ThemeSettingsNotifier(ref.read(themeRepositoryProvider));
});

final currentThemeDataProvider = Provider<ThemeData>((ref) {
  final settingsAsync = ref.watch(themeSettingsProvider);
  
  return settingsAsync.when(
    loading: () => _getDefaultTheme(),
    error: (error, stack) => _getDefaultTheme(),
    data: (settings) => _buildThemeFromSettings(settings),
  );
});

final darkThemeDataProvider = Provider<ThemeData>((ref) {
  final settingsAsync = ref.watch(themeSettingsProvider);
  
  return settingsAsync.when(
    loading: () => _getDefaultDarkTheme(),
    error: (error, stack) => _getDefaultDarkTheme(),
    data: (settings) => _buildDarkThemeFromSettings(settings),
  );
});

// Advanced computed providers
final accessibilityThemeProvider = Provider<ThemeData>((ref) {
  final settings = ref.watch(themeSettingsProvider).valueOrNull;
  final baseTheme = ref.watch(currentThemeDataProvider);
  
  if (settings == null) return baseTheme;
  
  return baseTheme.copyWith(
    // High contrast adjustments
    colorScheme: settings.highContrast 
        ? _enhanceContrastForAccessibility(baseTheme.colorScheme)
        : baseTheme.colorScheme,
    
    // Text scaling
    textTheme: baseTheme.textTheme.apply(
      fontSizeFactor: settings.textScaleFactor,
    ),
    
    // Animation adjustments
    pageTransitionsTheme: settings.reduceAnimations
        ? const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          )
        : null,
  );
});

// Theme State Notifier
class ThemeSettingsNotifier extends StateNotifier<AsyncValue<ThemeSettings>> {
  final ThemeRepository _repository;
  StreamSubscription? _streamSubscription;

  ThemeSettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final settings = await _repository.getThemeSettings();
      state = AsyncValue.data(settings);
      
      // Listen for external changes
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
    final currentSettings = state.valueOrNull;
    if (currentSettings == null) return;

    final updatedSettings = currentSettings.copyWith(themeMode: mode);
    state = AsyncValue.data(updatedSettings);

    try {
      await _repository.saveThemeSettings(updatedSettings);
    } catch (error, stackTrace) {
      // Revert on error
      state = AsyncValue.data(currentSettings);
      rethrow;
    }
  }

  Future<void> updateColorScheme(AppColorScheme colorScheme) async {
    await _updateSettings((settings) => settings.copyWith(colorScheme: colorScheme));
  }

  Future<void> updateTextScale(double scale) async {
    await _updateSettings((settings) => settings.copyWith(textScaleFactor: scale));
  }

  Future<void> toggleHighContrast() async {
    await _updateSettings((settings) => settings.copyWith(highContrast: !settings.highContrast));
  }

  Future<void> updateCustomColor(String key, Color color) async {
    final currentSettings = state.valueOrNull;
    if (currentSettings == null) return;

    final updatedColors = Map<String, dynamic>.from(currentSettings.customColors);
    updatedColors[key] = color.value;

    await _updateSettings((settings) => settings.copyWith(customColors: updatedColors));
  }

  Future<void> _updateSettings(ThemeSettings Function(ThemeSettings) updater) async {
    final currentSettings = state.valueOrNull;
    if (currentSettings == null) return;

    final updatedSettings = updater(currentSettings);
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

// Theme Builder Utilities
ThemeData _buildThemeFromSettings(ThemeSettings settings) {
  final colorScheme = _getColorScheme(settings.colorScheme, Brightness.light);
  
  return ThemeData(
    useMaterial3: true,
    colorScheme: settings.dynamicColors 
        ? colorScheme 
        : _getStaticColorScheme(settings.colorScheme, Brightness.light),
    fontFamily: _getFontFamily(settings.fontFamily),
    textTheme: _getTextTheme(settings.fontFamily, settings.textScaleFactor),
    pageTransitionsTheme: settings.showAnimations 
        ? _getAnimatedTransitions() 
        : _getReducedTransitions(),
    // Apply custom colors
    extensions: [
      CustomColorsExtension.fromMap(settings.customColors),
    ],
  );
}
```

### **4. User Settings with Provider**

User settings benefit from Provider's simplicity and shared state capabilities:

```dart
// User Settings Model
class UserSettings extends ChangeNotifier {
  bool _emailNotifications;
  bool _pushNotifications;
  bool _locationServices;
  bool _analytics;
  String _language;
  String _currency;
  int _autoLockTimer;
  bool _biometricEnabled;
  List<String> _interests;
  Map<String, dynamic> _customSettings;

  UserSettings({
    bool emailNotifications = true,
    bool pushNotifications = true,
    bool locationServices = false,
    bool analytics = true,
    String language = 'en',
    String currency = 'USD',
    int autoLockTimer = 300, // 5 minutes
    bool biometricEnabled = false,
    List<String> interests = const [],
    Map<String, dynamic> customSettings = const {},
  })  : _emailNotifications = emailNotifications,
        _pushNotifications = pushNotifications,
        _locationServices = locationServices,
        _analytics = analytics,
        _language = language,
        _currency = currency,
        _autoLockTimer = autoLockTimer,
        _biometricEnabled = biometricEnabled,
        _interests = List.from(interests),
        _customSettings = Map.from(customSettings);

  // Getters
  bool get emailNotifications => _emailNotifications;
  bool get pushNotifications => _pushNotifications;
  bool get locationServices => _locationServices;
  bool get analytics => _analytics;
  String get language => _language;
  String get currency => _currency;
  int get autoLockTimer => _autoLockTimer;
  bool get biometricEnabled => _biometricEnabled;
  List<String> get interests => List.unmodifiable(_interests);
  Map<String, dynamic> get customSettings => Map.unmodifiable(_customSettings);

  // Update methods with automatic persistence
  Future<void> toggleEmailNotifications() async {
    _emailNotifications = !_emailNotifications;
    notifyListeners();
    await _persistSettings();
  }

  Future<void> togglePushNotifications() async {
    _pushNotifications = !_pushNotifications;
    notifyListeners();
    await _persistSettings();
    
    // Update push notification subscription
    if (_pushNotifications) {
      await _enablePushNotifications();
    } else {
      await _disablePushNotifications();
    }
  }

  Future<void> updateLanguage(String newLanguage) async {
    if (_language != newLanguage) {
      _language = newLanguage;
      notifyListeners();
      await _persistSettings();
      
      // Trigger app-wide language change
      await _updateAppLanguage(newLanguage);
    }
  }

  Future<void> updateCurrency(String newCurrency) async {
    if (_currency != newCurrency) {
      _currency = newCurrency;
      notifyListeners();
      await _persistSettings();
    }
  }

  Future<void> updateAutoLockTimer(int minutes) async {
    _autoLockTimer = minutes;
    notifyListeners();
    await _persistSettings();
    
    // Update security service
    await _updateAutoLockSettings(minutes);
  }

  Future<void> addInterest(String interest) async {
    if (!_interests.contains(interest)) {
      _interests.add(interest);
      notifyListeners();
      await _persistSettings();
      
      // Update recommendation engine
      await _updateInterestBasedRecommendations();
    }
  }

  Future<void> removeInterest(String interest) async {
    if (_interests.remove(interest)) {
      notifyListeners();
      await _persistSettings();
      await _updateInterestBasedRecommendations();
    }
  }

  Future<void> updateCustomSetting(String key, dynamic value) async {
    _customSettings[key] = value;
    notifyListeners();
    await _persistSettings();
  }

  // Bulk operations
  Future<void> resetToDefaults() async {
    _emailNotifications = true;
    _pushNotifications = true;
    _locationServices = false;
    _analytics = true;
    _language = 'en';
    _currency = 'USD';
    _autoLockTimer = 300;
    _biometricEnabled = false;
    _interests.clear();
    _customSettings.clear();
    
    notifyListeners();
    await _persistSettings();
  }

  Future<void> importSettings(Map<String, dynamic> settings) async {
    _emailNotifications = settings['emailNotifications'] ?? true;
    _pushNotifications = settings['pushNotifications'] ?? true;
    _locationServices = settings['locationServices'] ?? false;
    _analytics = settings['analytics'] ?? true;
    _language = settings['language'] ?? 'en';
    _currency = settings['currency'] ?? 'USD';
    _autoLockTimer = settings['autoLockTimer'] ?? 300;
    _biometricEnabled = settings['biometricEnabled'] ?? false;
    _interests = List<String>.from(settings['interests'] ?? []);
    _customSettings = Map<String, dynamic>.from(settings['customSettings'] ?? {});
    
    notifyListeners();
    await _persistSettings();
  }

  Map<String, dynamic> exportSettings() {
    return {
      'emailNotifications': _emailNotifications,
      'pushNotifications': _pushNotifications,
      'locationServices': _locationServices,
      'analytics': _analytics,
      'language': _language,
      'currency': _currency,
      'autoLockTimer': _autoLockTimer,
      'biometricEnabled': _biometricEnabled,
      'interests': _interests,
      'customSettings': _customSettings,
    };
  }

  // Private helper methods
  Future<void> _persistSettings() async {
    // Implementation would save to SharedPreferences, Hive, or API
  }

  Future<void> _enablePushNotifications() async {
    // Implementation would handle push notification registration
  }

  Future<void> _disablePushNotifications() async {
    // Implementation would handle push notification deregistration
  }

  Future<void> _updateAppLanguage(String language) async {
    // Implementation would trigger app-wide localization change
  }

  Future<void> _updateAutoLockSettings(int minutes) async {
    // Implementation would update security service
  }

  Future<void> _updateInterestBasedRecommendations() async {
    // Implementation would update recommendation algorithms
  }
}
```

### **5. Local UI State with setState**

For local component state, setState remains optimal:

```dart
// Login Form with Local State Management
class LoginForm extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  
  const LoginForm({super.key, this.onLoginSuccess});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  // Form state
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Local UI state
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  
  // Animation state
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  // Input validation state
  String? _emailError;
  String? _passwordError;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    
    // Start fade animation
    _fadeController.forward();
    
    // Listen to text changes for real-time validation
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      final email = _emailController.text;
      if (email.isEmpty) {
        _emailError = null;
        _isEmailValid = false;
      } else if (!_isValidEmail(email)) {
        _emailError = 'Please enter a valid email address';
        _isEmailValid = false;
      } else {
        _emailError = null;
        _isEmailValid = true;
      }
    });
  }

  void _validatePassword() {
    setState(() {
      final password = _passwordController.text;
      if (password.isEmpty) {
        _passwordError = null;
        _isPasswordValid = false;
      } else if (password.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
        _isPasswordValid = false;
      } else {
        _passwordError = null;
        _isPasswordValid = true;
      }
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  void _handleLoginError() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _handleLoginError();
        } else if (state is AuthAuthenticated) {
          widget.onLoginSuccess?.call();
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: child,
            );
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email field with real-time validation
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    suffixIcon: _isEmailValid 
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    errorText: _emailError,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                
                const SizedBox(height: 16),
                
                // Password field with visibility toggle
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isPasswordValid)
                          const Icon(Icons.check, color: Colors.green),
                        IconButton(
                          icon: Icon(
                            _isPasswordVisible 
                                ? Icons.visibility_off 
                                : Icons.visibility,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ],
                    ),
                    errorText: _passwordError,
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(),
                ),
                
                const SizedBox(height: 12),
                
                // Remember me checkbox
                CheckboxListTile(
                  title: const Text('Remember me'),
                  value: _rememberMe,
                  onChanged: _toggleRememberMe,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                
                const SizedBox(height: 24),
                
                // Login button with loading state
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    final canSubmit = _isEmailValid && _isPasswordValid && !isLoading;
                    
                    return ElevatedButton(
                      onPressed: canSubmit ? _handleLogin : null,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign In'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        ),
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```

## 🎯 **Integration Patterns**

### **1. Cross-Pattern Communication**

Different patterns need to communicate effectively:

```dart
// Theme changes affecting authentication UI
class AuthScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(accessibilityThemeProvider);
    
    return Theme(
      data: themeData,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return Scaffold(
            backgroundColor: themeData.colorScheme.background,
            body: Column(
              children: [
                // Theme-aware auth content
                if (authState is AuthLoading)
                  LinearProgressIndicator(
                    color: themeData.colorScheme.primary,
                  ),
                
                // Settings affect auth behavior
                Consumer<UserSettings>(
                  builder: (context, settings, child) {
                    return AuthForm(
                      biometricEnabled: settings.biometricEnabled,
                      autoLockEnabled: settings.autoLockTimer > 0,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Settings changes affecting theme
class SettingsProvider extends ChangeNotifier {
  void updateAccessibilitySettings(bool highContrast, double textScale) {
    // Update settings
    _updateLocalSettings(highContrast, textScale);
    notifyListeners();
    
    // Update theme through Riverpod
    ProviderScope.containerOf(context).read(themeSettingsProvider.notifier)
        .updateAccessibilitySettings(highContrast, textScale);
  }
}

// Authentication affecting app state
class AppStateManager {
  void handleAuthenticationChange(AuthState authState) {
    if (authState is AuthAuthenticated) {
      // Load user-specific theme settings
      _loadUserThemeSettings(authState.user.id);
      
      // Load user settings
      _loadUserSettings(authState.user.id);
      
      // Update analytics
      _updateAnalyticsContext(authState.user);
    } else if (authState is AuthUnauthenticated) {
      // Reset to default settings
      _resetToDefaultSettings();
    }
  }
}
```

### **2. Testing Strategies for Hybrid Architecture**

Testing applications with multiple state management patterns requires different approaches:

```dart
// Testing Bloc Authentication
void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;
    late MockSecurityService mockSecurityService;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockSecurityService = MockSecurityService();
      authBloc = AuthBloc(
        authRepository: mockAuthRepository,
        securityService: mockSecurityService,
        analyticsService: MockAnalyticsService(),
        biometricService: MockBiometricService(),
      );
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(mockAuthRepository.login(any, any)).thenAnswer(
          (_) async => AuthResult(user: mockUser, token: mockToken),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(
          email: 'test@example.com',
          password: 'password123',
        ),
      ),
      expect: () => [
        const AuthLoading(loadingMessage: 'Signing in...'),
        AuthAuthenticated(
          user: mockUser,
          token: mockToken,
          authenticatedAt: any,
          method: AuthMethod.emailPassword,
        ),
      ],
    );
  });
}

// Testing Riverpod Theme Management
void main() {
  group('ThemeSettingsProvider', () {
    late ProviderContainer container;
    late MockThemeRepository mockRepository;

    setUp(() {
      mockRepository = MockThemeRepository();
      container = ProviderContainer(
        overrides: [
          themeRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    test('updates theme mode correctly', () async {
      when(mockRepository.getThemeSettings()).thenAnswer(
        (_) async => const ThemeSettings(),
      );
      
      final notifier = container.read(themeSettingsProvider.notifier);
      await notifier.updateThemeMode(ThemeMode.dark);
      
      final state = container.read(themeSettingsProvider);
      expect(
        state.value?.themeMode,
        equals(ThemeMode.dark),
      );
    });
  });
}

// Testing Provider Settings
void main() {
  group('UserSettings', () {
    late UserSettings userSettings;

    setUp(() {
      userSettings = UserSettings();
    });

    test('toggles email notifications correctly', () async {
      final initialValue = userSettings.emailNotifications;
      
      await userSettings.toggleEmailNotifications();
      
      expect(userSettings.emailNotifications, equals(!initialValue));
    });

    test('notifies listeners when settings change', () {
      bool notified = false;
      userSettings.addListener(() => notified = true);
      
      userSettings.togglePushNotifications();
      
      expect(notified, isTrue);
    });
  });
}

// Integration Testing
void main() {
  group('App Integration', () {
    testWidgets('auth state affects theme loading', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (_) => mockAuthBloc),
            ChangeNotifierProvider<UserSettings>(
              create: (_) => UserSettings(),
            ),
          ],
          child: ProviderScope(
            overrides: [
              themeRepositoryProvider.overrideWithValue(mockThemeRepository),
            ],
            child: const MyApp(),
          ),
        ),
      );

      // Simulate authentication
      mockAuthBloc.add(const AuthLoginRequested(
        email: 'test@example.com',
        password: 'password',
      ));
      
      await tester.pump();
      
      // Verify theme loads user-specific settings
      verify(mockThemeRepository.loadUserThemeSettings('user-id')).called(1);
    });
  });
}
```

## 🌟 **Key Takeaways**

1. **Strategic Pattern Selection** - Different concerns benefit from different patterns
2. **Clean Architecture Integration** - Patterns can coexist in well-architected applications
3. **Cross-Pattern Communication** - Patterns need clear communication channels
4. **Testing Strategies** - Each pattern requires specific testing approaches
5. **Performance Considerations** - Monitor overhead of multiple patterns
6. **Maintainability** - Clear boundaries prevent pattern mixing chaos

This hybrid approach demonstrates that modern Flutter applications don't need to choose just one pattern - they can strategically use the best pattern for each specific concern while maintaining clean architecture principles.

**Ready to build production-ready applications with strategic state management? 🎯✨**