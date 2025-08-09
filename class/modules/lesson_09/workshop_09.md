# 🎬 Workshop

## 🎯 **What We're Building**

Create a **comprehensive animated onboarding experience** that showcases Flutter's animation capabilities:
- **Animated Onboarding Flow** with smooth page transitions and micro-interactions
- **Hero Animations** for seamless navigation between screens
- **Staggered Animations** for elegant content reveals
- **Custom Animation Controllers** for complex, coordinated animations
- **Physics-Based Animations** for natural, realistic motion
- **Performance-Optimized** animations that maintain 60fps on all devices

## ✅ **Expected Outcome**

A stunning onboarding application featuring:
- 🎬 **Smooth Page Transitions** - Custom transitions with physics-based easing
- ✨ **Micro-Interactions** - Delightful hover effects, button animations, and feedback
- 🦸 **Hero Animations** - Seamless shared element transitions
- 📱 **Responsive Animations** - Animations that adapt to different screen sizes
- 🎯 **Staggered Reveals** - Coordinated animation sequences
- ⚡ **Performance Optimized** - Smooth 60fps animations with proper memory management

## 🏗️ **Project Structure**

We'll build a clean architecture animation system:

```
lib/
├── core/
│   ├── animations/               # 🎬 Animation framework
│   │   ├── animation_controller_manager.dart  # Controller lifecycle management
│   │   ├── custom_curves.dart   # Custom easing functions
│   │   ├── animation_mixins.dart # Reusable animation behaviors
│   │   └── performance_utils.dart # Animation performance utilities
│   ├── constants/
│   │   └── animation_constants.dart # Animation timing and values
│   └── theme/
│       └── animation_theme.dart     # Animation-aware theming
├── domain/
│   ├── entities/
│   │   ├── onboarding_page.dart    # Onboarding content entity
│   │   └── animation_config.dart   # Animation configuration
│   └── repositories/
│       └── onboarding_repository.dart # Onboarding data interface
├── data/
│   ├── models/
│   │   └── onboarding_page_model.dart # Data models
│   └── repositories/
│       └── onboarding_repository_impl.dart # Data implementation
├── presentation/
│   ├── controllers/
│   │   ├── onboarding_controller.dart # Onboarding state management
│   │   └── animation_coordinator.dart # Animation orchestration
│   ├── screens/
│   │   ├── splash_screen.dart         # Animated splash screen
│   │   ├── onboarding_screen.dart     # Main onboarding flow
│   │   └── welcome_screen.dart        # Final welcome screen
│   ├── widgets/
│   │   ├── animated_page_view.dart    # Custom page transitions
│   │   ├── staggered_list.dart        # Staggered reveal animations
│   │   ├── hero_button.dart           # Hero animated buttons
│   │   ├── floating_action_button.dart # Animated FAB
│   │   └── progress_indicator.dart    # Animated progress indicator
│   └── animations/
│       ├── page_transitions.dart      # Custom page transition animations
│       ├── entrance_animations.dart   # Content entrance effects
│       └── micro_interactions.dart    # Button and gesture animations
└── main.dart                          # App entry with animation setup
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Animation Foundation** ⏱️ *20 minutes*

Create the core animation framework with professional patterns:

```dart
// lib/core/animations/animation_controller_manager.dart
import 'package:flutter/material.dart';

/// Manages multiple animation controllers with automatic disposal
class AnimationControllerManager {
  final TickerProvider tickerProvider;
  final List<AnimationController> _controllers = [];

  AnimationControllerManager(this.tickerProvider);

  /// Create and register a new animation controller
  AnimationController createController({
    required Duration duration,
    Duration? reverseDuration,
    String? debugLabel,
    double lowerBound = 0.0,
    double upperBound = 1.0,
  }) {
    final controller = AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      debugLabel: debugLabel,
      lowerBound: lowerBound,
      upperBound: upperBound,
      vsync: tickerProvider,
    );
    
    _controllers.add(controller);
    return controller;
  }

  /// Create animation with custom curve
  Animation<T> createAnimation<T>({
    required AnimationController controller,
    required Tween<T> tween,
    Curve curve = Curves.easeInOut,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return tween.animate(CurvedAnimation(
      parent: controller,
      curve: Interval(begin, end, curve: curve),
    ));
  }

  /// Create staggered animation sequence
  List<Animation<double>> createStaggeredAnimations({
    required AnimationController controller,
    required int count,
    double stagger = 0.1,
    Curve curve = Curves.easeOut,
  }) {
    return List.generate(count, (index) {
      final start = index * stagger;
      final end = start + (1.0 - (count - 1) * stagger);
      
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end.clamp(0.0, 1.0), curve: curve),
        ),
      );
    });
  }

  /// Dispose all controllers
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
  }

  /// Get controller count for debugging
  int get controllerCount => _controllers.length;
}

// lib/core/animations/custom_curves.dart
import 'package:flutter/animation.dart';
import 'dart:math';

/// Custom spring curve with configurable damping and stiffness
class SpringCurve extends Curve {
  const SpringCurve({
    this.damping = 20.0,
    this.stiffness = 180.0,
    this.mass = 1.0,
  });

  final double damping;
  final double stiffness;
  final double mass;

  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) return t;
    
    final omega = sqrt(stiffness / mass);
    final zeta = damping / (2 * sqrt(stiffness * mass));
    
    if (zeta < 1) {
      // Underdamped spring
      final omegad = omega * sqrt(1 - zeta * zeta);
      final amplitude = 1 / sqrt(1 - zeta * zeta);
      final phase = atan(zeta / sqrt(1 - zeta * zeta));
      
      return 1 - amplitude * exp(-zeta * omega * t) * cos(omegad * t + phase);
    } else if (zeta == 1) {
      // Critically damped
      return 1 - exp(-omega * t) * (1 + omega * t);
    } else {
      // Overdamped
      final r1 = -omega * (zeta - sqrt(zeta * zeta - 1));
      final r2 = -omega * (zeta + sqrt(zeta * zeta - 1));
      final c1 = r2 / (r2 - r1);
      final c2 = -r1 / (r2 - r1);
      
      return 1 - c1 * exp(r1 * t) - c2 * exp(r2 * t);
    }
  }
}

/// Elastic curve with configurable bounce
class ElasticCurve extends Curve {
  const ElasticCurve({
    this.period = 0.4,
    this.amplitude = 1.0,
  });

  final double period;
  final double amplitude;

  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) return t;
    
    final s = period / 4.0;
    return amplitude * exp(-10 * t) * sin((t - s) * (2 * pi) / period) + 1;
  }
}

/// Custom anticipation curve that overshoots before settling
class AnticipationCurve extends Curve {
  const AnticipationCurve({this.anticipation = 0.2});

  final double anticipation;

  @override
  double transform(double t) {
    if (t == 0.0 || t == 1.0) return t;
    
    final c = anticipation;
    return t * t * ((c + 1) * t - c);
  }
}

// lib/core/animations/animation_mixins.dart
import 'package:flutter/material.dart';
import 'animation_controller_manager.dart';

/// Mixin for widgets that need complex animation management
mixin AnimationManagerMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationControllerManager _animationManager;

  AnimationControllerManager get animationManager => _animationManager;

  @override
  void initState() {
    super.initState();
    _animationManager = AnimationControllerManager(this);
  }

  @override
  void dispose() {
    _animationManager.dispose();
    super.dispose();
  }
}

/// Mixin for entrance animations
mixin EntranceAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupEntranceAnimations();
    _startEntranceAnimation();
  }

  void _setupEntranceAnimations() {
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: SpringCurve()),
    ));
  }

  void _startEntranceAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entranceController.forward();
    });
  }

  Widget buildWithEntranceAnimation(Widget child) {
    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, animatedChild) {
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }
}

// lib/core/constants/animation_constants.dart
class AnimationConstants {
  // Duration constants
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 400);
  static const Duration slowDuration = Duration(milliseconds: 600);
  static const Duration extraSlowDuration = Duration(milliseconds: 1000);

  // Stagger constants
  static const double staggerDelay = 0.1;
  static const double fastStagger = 0.05;
  static const double slowStagger = 0.2;

  // Offset constants for slide animations
  static const Offset slideInFromRight = Offset(1.0, 0.0);
  static const Offset slideInFromLeft = Offset(-1.0, 0.0);
  static const Offset slideInFromTop = Offset(0.0, -1.0);
  static const Offset slideInFromBottom = Offset(0.0, 1.0);

  // Scale constants
  static const double scaleStart = 0.8;
  static const double scaleEnd = 1.0;
  static const double scaleOvershoot = 1.1;

  // Rotation constants
  static const double rotationQuarter = 0.25;
  static const double rotationHalf = 0.5;
  static const double rotationFull = 1.0;

  // Opacity constants
  static const double fadeStart = 0.0;
  static const double fadeEnd = 1.0;
  static const double fadeHalf = 0.5;

  // Page transition constants
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve pageTransitionCurve = Curves.easeInOut;

  // Hero animation constants
  static const Duration heroAnimationDuration = Duration(milliseconds: 400);
  static const String heroTagPrefix = 'hero_';

  // Physics simulation constants
  static const double springDamping = 15.0;
  static const double springStiffness = 200.0;
  static const double springMass = 1.0;

  // Performance constants
  static const int maxFPS = 60;
  static const Duration frameTime = Duration(microseconds: 16667); // 1/60 second
}
```

### **Step 2: Onboarding Data Layer** ⏱️ *15 minutes*

Create the data structures for our animated onboarding:

```dart
// lib/domain/entities/onboarding_page.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Onboarding page entity with animation configuration
class OnboardingPage extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final Color primaryColor;
  final Color secondaryColor;
  final AnimationConfig animationConfig;
  final List<FeatureItem> features;

  const OnboardingPage({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.primaryColor,
    required this.secondaryColor,
    required this.animationConfig,
    this.features = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        description,
        imagePath,
        primaryColor,
        secondaryColor,
        animationConfig,
        features,
      ];
}

/// Feature item for staggered animations
class FeatureItem extends Equatable {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const FeatureItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [title, description, icon, color];
}

// lib/domain/entities/animation_config.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Animation configuration for onboarding pages
class AnimationConfig extends Equatable {
  final Duration entranceDuration;
  final Duration exitDuration;
  final Curve entranceCurve;
  final Curve exitCurve;
  final double staggerDelay;
  final AnimationType animationType;
  final Map<String, dynamic> customProperties;

  const AnimationConfig({
    this.entranceDuration = const Duration(milliseconds: 800),
    this.exitDuration = const Duration(milliseconds: 400),
    this.entranceCurve = Curves.easeOut,
    this.exitCurve = Curves.easeIn,
    this.staggerDelay = 0.1,
    this.animationType = AnimationType.slideUp,
    this.customProperties = const {},
  });

  AnimationConfig copyWith({
    Duration? entranceDuration,
    Duration? exitDuration,
    Curve? entranceCurve,
    Curve? exitCurve,
    double? staggerDelay,
    AnimationType? animationType,
    Map<String, dynamic>? customProperties,
  }) {
    return AnimationConfig(
      entranceDuration: entranceDuration ?? this.entranceDuration,
      exitDuration: exitDuration ?? this.exitDuration,
      entranceCurve: entranceCurve ?? this.entranceCurve,
      exitCurve: exitCurve ?? this.exitCurve,
      staggerDelay: staggerDelay ?? this.staggerDelay,
      animationType: animationType ?? this.animationType,
      customProperties: customProperties ?? this.customProperties,
    );
  }

  @override
  List<Object?> get props => [
        entranceDuration,
        exitDuration,
        entranceCurve,
        exitCurve,
        staggerDelay,
        animationType,
        customProperties,
      ];
}

/// Types of entrance animations
enum AnimationType {
  slideUp,
  slideDown,
  slideLeft,
  slideRight,
  fade,
  scale,
  rotate,
  spring,
  elastic,
  bounce,
}

// lib/data/repositories/onboarding_repository_impl.dart
import '../../domain/entities/onboarding_page.dart';
import '../../domain/entities/animation_config.dart';

/// Mock implementation of onboarding repository
class OnboardingRepositoryImpl {
  /// Get onboarding pages with animation configurations
  Future<List<OnboardingPage>> getOnboardingPages() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      OnboardingPage(
        id: 'welcome',
        title: 'Welcome to\nFlutter Animations',
        subtitle: 'Master the Art of Motion',
        description: 'Learn to create stunning, performant animations that bring your Flutter apps to life with smooth transitions and delightful micro-interactions.',
        imagePath: 'assets/images/onboarding_1.png',
        primaryColor: const Color(0xFF6C63FF),
        secondaryColor: const Color(0xFF8B7CFF),
        animationConfig: const AnimationConfig(
          animationType: AnimationType.slideUp,
          entranceDuration: Duration(milliseconds: 1000),
          staggerDelay: 0.15,
        ),
        features: const [
          FeatureItem(
            title: 'Smooth Transitions',
            description: 'Seamless navigation between screens',
            icon: Icons.swap_horiz,
            color: Color(0xFF6C63FF),
          ),
          FeatureItem(
            title: 'Micro-Interactions',
            description: 'Delightful feedback for user actions',
            icon: Icons.touch_app,
            color: Color(0xFF8B7CFF),
          ),
          FeatureItem(
            title: 'Performance Optimized',
            description: '60fps animations on all devices',
            icon: Icons.speed,
            color: Color(0xFFB19BFF),
          ),
        ],
      ),
      OnboardingPage(
        id: 'hero_animations',
        title: 'Hero Animations',
        subtitle: 'Seamless Shared Elements',
        description: 'Create magical transitions where elements smoothly transform between screens, providing visual continuity and professional polish.',
        imagePath: 'assets/images/onboarding_2.png',
        primaryColor: const Color(0xFF4ECDC4),
        secondaryColor: const Color(0xFF7FEBE3),
        animationConfig: const AnimationConfig(
          animationType: AnimationType.scale,
          entranceDuration: Duration(milliseconds: 800),
          entranceCurve: SpringCurve(),
          staggerDelay: 0.12,
        ),
        features: const [
          FeatureItem(
            title: 'Shared Elements',
            description: 'Elements that transform between screens',
            icon: Icons.compare_arrows,
            color: Color(0xFF4ECDC4),
          ),
          FeatureItem(
            title: 'Visual Continuity',
            description: 'Maintain context during navigation',
            icon: Icons.link,
            color: Color(0xFF7FEBE3),
          ),
          FeatureItem(
            title: 'Professional Polish',
            description: 'Industry-standard transition effects',
            icon: Icons.star,
            color: Color(0xFFABF5EF),
          ),
        ],
      ),
      OnboardingPage(
        id: 'performance',
        title: 'Performance\nOptimization',
        subtitle: 'Buttery Smooth Animations',
        description: 'Learn the secrets of creating animations that run at perfect 60fps with proper memory management and efficient rendering techniques.',
        imagePath: 'assets/images/onboarding_3.png',
        primaryColor: const Color(0xFFFF6B9D),
        secondaryColor: const Color(0xFFFF8FAC),
        animationConfig: const AnimationConfig(
          animationType: AnimationType.spring,
          entranceDuration: Duration(milliseconds: 900),
          entranceCurve: ElasticCurve(),
          staggerDelay: 0.08,
        ),
        features: const [
          FeatureItem(
            title: '60fps Guaranteed',
            description: 'Smooth animations on all devices',
            icon: Icons.timeline,
            color: Color(0xFFFF6B9D),
          ),
          FeatureItem(
            title: 'Memory Efficient',
            description: 'Proper resource management',
            icon: Icons.memory,
            color: Color(0xFFFF8FAC),
          ),
          FeatureItem(
            title: 'Battery Friendly',
            description: 'Optimized for mobile devices',
            icon: Icons.battery_charging_full,
            color: Color(0xFFFFB3CA),
          ),
        ],
      ),
    ];
  }

  /// Get animation presets
  Map<String, AnimationConfig> getAnimationPresets() {
    return {
      'gentle': const AnimationConfig(
        entranceDuration: Duration(milliseconds: 600),
        entranceCurve: Curves.easeOut,
        staggerDelay: 0.1,
      ),
      'energetic': const AnimationConfig(
        entranceDuration: Duration(milliseconds: 400),
        entranceCurve: Curves.easeInOut,
        staggerDelay: 0.05,
      ),
      'playful': const AnimationConfig(
        entranceDuration: Duration(milliseconds: 800),
        entranceCurve: ElasticCurve(),
        staggerDelay: 0.15,
      ),
      'professional': const AnimationConfig(
        entranceDuration: Duration(milliseconds: 500),
        entranceCurve: Curves.easeInOut,
        staggerDelay: 0.08,
      ),
    };
  }
}
```

### **Step 3: Animation State Management** ⏱️ *20 minutes*

Create controllers for orchestrating complex animations:

```dart
// lib/presentation/controllers/onboarding_controller.dart
import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../data/repositories/onboarding_repository_impl.dart';

/// Controller for managing onboarding state and animations
class OnboardingController extends ChangeNotifier {
  final OnboardingRepositoryImpl _repository = OnboardingRepositoryImpl();

  List<OnboardingPage> _pages = [];
  int _currentPageIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAnimating = false;

  // Getters
  List<OnboardingPage> get pages => _pages;
  int get currentPageIndex => _currentPageIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAnimating => _isAnimating;
  bool get isLastPage => _currentPageIndex >= _pages.length - 1;
  bool get isFirstPage => _currentPageIndex <= 0;
  
  OnboardingPage? get currentPage {
    if (_pages.isEmpty || _currentPageIndex < 0 || _currentPageIndex >= _pages.length) {
      return null;
    }
    return _pages[_currentPageIndex];
  }

  double get progress => _pages.isEmpty ? 0.0 : (_currentPageIndex + 1) / _pages.length;

  /// Initialize onboarding data
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pages = await _repository.getOnboardingPages();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load onboarding: $e';
      _pages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Navigate to next page with animation
  Future<void> nextPage({Duration? animationDuration}) async {
    if (isLastPage || _isAnimating) return;

    _isAnimating = true;
    notifyListeners();

    try {
      // Simulate animation delay
      await Future.delayed(animationDuration ?? const Duration(milliseconds: 300));
      _currentPageIndex++;
    } finally {
      _isAnimating = false;
      notifyListeners();
    }
  }

  /// Navigate to previous page with animation
  Future<void> previousPage({Duration? animationDuration}) async {
    if (isFirstPage || _isAnimating) return;

    _isAnimating = true;
    notifyListeners();

    try {
      // Simulate animation delay
      await Future.delayed(animationDuration ?? const Duration(milliseconds: 300));
      _currentPageIndex--;
    } finally {
      _isAnimating = false;
      notifyListeners();
    }
  }

  /// Jump to specific page
  Future<void> goToPage(int index, {Duration? animationDuration}) async {
    if (index < 0 || index >= _pages.length || index == _currentPageIndex || _isAnimating) {
      return;
    }

    _isAnimating = true;
    notifyListeners();

    try {
      // Simulate animation delay
      await Future.delayed(animationDuration ?? const Duration(milliseconds: 300));
      _currentPageIndex = index;
    } finally {
      _isAnimating = false;
      notifyListeners();
    }
  }

  /// Skip to last page
  Future<void> skipToEnd() async {
    await goToPage(_pages.length - 1, animationDuration: const Duration(milliseconds: 500));
  }

  /// Complete onboarding
  void completeOnboarding() {
    // Here you would typically save onboarding completion state
    // and navigate to the main app
    debugPrint('Onboarding completed!');
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// lib/presentation/controllers/animation_coordinator.dart
import 'package:flutter/material.dart';
import '../../core/animations/animation_controller_manager.dart';

/// Coordinates complex animation sequences across the app
class AnimationCoordinator extends ChangeNotifier {
  final TickerProvider tickerProvider;
  late AnimationControllerManager _animationManager;

  // Page transition animations
  late AnimationController _pageTransitionController;
  late Animation<double> _pageOpacityAnimation;
  late Animation<Offset> _pageSlideAnimation;
  late Animation<double> _pageScaleAnimation;

  // Staggered content animations
  late AnimationController _contentController;
  late List<Animation<double>> _staggeredAnimations;

  // Button animations
  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _buttonOpacityAnimation;

  // Progress indicator animation
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  AnimationCoordinator(this.tickerProvider) {
    _animationManager = AnimationControllerManager(tickerProvider);
    _setupAnimations();
  }

  void _setupAnimations() {
    // Page transition animations
    _pageTransitionController = _animationManager.createController(
      duration: const Duration(milliseconds: 600),
      debugLabel: 'PageTransition',
    );

    _pageOpacityAnimation = _animationManager.createAnimation(
      controller: _pageTransitionController,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeInOut,
    );

    _pageSlideAnimation = _animationManager.createAnimation(
      controller: _pageTransitionController,
      tween: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero),
      curve: Curves.easeOut,
    );

    _pageScaleAnimation = _animationManager.createAnimation(
      controller: _pageTransitionController,
      tween: Tween<double>(begin: 0.8, end: 1.0),
      curve: Curves.easeOut,
    );

    // Content staggered animations
    _contentController = _animationManager.createController(
      duration: const Duration(milliseconds: 1200),
      debugLabel: 'ContentStagger',
    );

    _staggeredAnimations = _animationManager.createStaggeredAnimations(
      controller: _contentController,
      count: 5, // Title, subtitle, description, features
      stagger: 0.1,
      curve: Curves.easeOut,
    );

    // Button animations
    _buttonController = _animationManager.createController(
      duration: const Duration(milliseconds: 200),
      debugLabel: 'Button',
    );

    _buttonScaleAnimation = _animationManager.createAnimation(
      controller: _buttonController,
      tween: Tween<double>(begin: 1.0, end: 0.95),
      curve: Curves.easeInOut,
    );

    _buttonOpacityAnimation = _animationManager.createAnimation(
      controller: _buttonController,
      tween: Tween<double>(begin: 1.0, end: 0.8),
      curve: Curves.easeInOut,
    );

    // Progress indicator animation
    _progressController = _animationManager.createController(
      duration: const Duration(milliseconds: 400),
      debugLabel: 'Progress',
    );

    _progressAnimation = _animationManager.createAnimation(
      controller: _progressController,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeInOut,
    );
  }

  // Animation getters
  Animation<double> get pageOpacity => _pageOpacityAnimation;
  Animation<Offset> get pageSlide => _pageSlideAnimation;
  Animation<double> get pageScale => _pageScaleAnimation;
  List<Animation<double>> get staggeredAnimations => _staggeredAnimations;
  Animation<double> get buttonScale => _buttonScaleAnimation;
  Animation<double> get buttonOpacity => _buttonOpacityAnimation;
  Animation<double> get progressAnimation => _progressAnimation;

  /// Animate page entrance
  Future<void> animatePageEntrance() async {
    await _pageTransitionController.forward(from: 0.0);
  }

  /// Animate page exit
  Future<void> animatePageExit() async {
    await _pageTransitionController.reverse();
  }

  /// Animate content with stagger
  Future<void> animateContent() async {
    await _contentController.forward(from: 0.0);
  }

  /// Reset content animations
  void resetContentAnimations() {
    _contentController.reset();
  }

  /// Animate button press
  Future<void> animateButtonPress() async {
    await _buttonController.forward();
    await _buttonController.reverse();
  }

  /// Update progress indicator
  Future<void> updateProgress(double progress) async {
    await _progressController.animateTo(progress);
  }

  /// Reset all animations
  void resetAll() {
    _pageTransitionController.reset();
    _contentController.reset();
    _buttonController.reset();
    _progressController.reset();
  }

  @override
  void dispose() {
    _animationManager.dispose();
    super.dispose();
  }
}
```

*This is part 1 of the workshop. Continue with the remaining steps to build the complete animated onboarding experience...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_09

# Install dependencies
flutter pub get

# Run the app
flutter run

# Test animations
# 1. Observe smooth page transitions
# 2. Notice staggered content reveals
# 3. Test button micro-interactions
# 4. Experience hero animations
# 5. Validate performance with 60fps
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **Animation Controllers** - Managing complex animation lifecycles
- **Tweens & Curves** - Creating natural, physics-based motion
- **Hero Animations** - Seamless shared element transitions
- **Staggered Animations** - Coordinated sequential reveals
- **Performance Optimization** - 60fps animations with proper memory management
- **Animation Patterns** - Professional animation techniques for real-world applications

**Ready to bring your Flutter apps to life with stunning animations? 🎬✨**