/// Onboarding repository implementation
/// 
/// This file provides the concrete implementation of the onboarding repository
/// with sample data and local storage for persistence.
library;

import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../domain/repositories/onboarding_repository.dart';

/// Implementation of onboarding repository with sample data
/// 
/// Provides sample onboarding content and simulates persistence
/// for demonstration purposes. In a real app, this would connect
/// to actual storage services, APIs, or databases.
class OnboardingRepositoryImpl implements OnboardingRepository {
  /// Creates the repository implementation
  OnboardingRepositoryImpl();

  /// Simulated storage for user progress
  static int _currentProgress = 0;
  static bool _hasCompleted = false;
  static bool _hasSkipped = false;
  static OnboardingPreferences _userPreferences = const OnboardingPreferences();
  static final List<OnboardingAnalyticsEvent> _analyticsEvents = [];

  /// Cached onboarding flow
  OnboardingFlowConfig? _cachedFlow;

  @override
  Future<OnboardingFlowConfig> getOnboardingFlow() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (_cachedFlow != null) {
      return _cachedFlow!;
    }

    // Create sample onboarding flow
    _cachedFlow = OnboardingFlowConfig(
      pages: [
        _createWelcomePage(),
        _createFeaturesPage(),
        _createBenefitsPage(),
        _createCallToActionPage(),
      ],
      allowSkip: true,
      showProgress: true,
      autoAdvance: false,
      persistProgress: true,
    );

    return _cachedFlow!;
  }

  @override
  Future<OnboardingPage?> getOnboardingPage(String pageId) async {
    final flow = await getOnboardingFlow();
    
    try {
      return flow.pages.firstWhere((page) => page.id == pageId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<OnboardingPage>> getAllOnboardingPages() async {
    final flow = await getOnboardingFlow();
    return flow.pages;
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    // Simulate storage access delay
    await Future.delayed(const Duration(milliseconds: 100));
    return _hasCompleted;
  }

  @override
  Future<void> markOnboardingCompleted() async {
    // Simulate storage write delay
    await Future.delayed(const Duration(milliseconds: 200));
    _hasCompleted = true;
    
    // Record analytics event
    await recordAnalyticsEvent(OnboardingAnalyticsEvent(
      eventType: OnboardingAnalyticsEvent.complete,
      pageId: 'onboarding_flow',
      timestamp: DateTime.now(),
    ));
  }

  @override
  Future<int> getCurrentProgress() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentProgress;
  }

  @override
  Future<void> saveProgress(int pageIndex) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _currentProgress = pageIndex;
  }

  @override
  Future<void> resetOnboardingProgress() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentProgress = 0;
    _hasCompleted = false;
    _hasSkipped = false;
    _analyticsEvents.clear();
  }

  @override
  Future<bool> hasSkippedOnboarding() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _hasSkipped;
  }

  @override
  Future<void> markOnboardingSkipped() async {
    await Future.delayed(const Duration(milliseconds: 150));
    _hasSkipped = true;
    
    // Record analytics event
    await recordAnalyticsEvent(OnboardingAnalyticsEvent(
      eventType: OnboardingAnalyticsEvent.skip,
      pageId: 'page_${_currentProgress}',
      timestamp: DateTime.now(),
    ));
  }

  @override
  Future<OnboardingPreferences> getUserPreferences() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _userPreferences;
  }

  @override
  Future<void> saveUserPreferences(OnboardingPreferences preferences) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _userPreferences = preferences;
  }

  @override
  Future<OnboardingAnalytics> getAnalytics() async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Calculate analytics from events
    final totalViews = _analyticsEvents
        .where((event) => event.eventType == OnboardingAnalyticsEvent.pageView)
        .length;
    
    final completions = _analyticsEvents
        .where((event) => event.eventType == OnboardingAnalyticsEvent.complete)
        .length;
    
    final skips = _analyticsEvents
        .where((event) => event.eventType == OnboardingAnalyticsEvent.skip)
        .length;
    
    final pageViewCounts = <String, int>{};
    final userActions = <String, int>{};
    
    for (final event in _analyticsEvents) {
      // Count page views
      if (event.eventType == OnboardingAnalyticsEvent.pageView) {
        pageViewCounts[event.pageId] = (pageViewCounts[event.pageId] ?? 0) + 1;
      }
      
      // Count user actions
      userActions[event.eventType] = (userActions[event.eventType] ?? 0) + 1;
    }
    
    return OnboardingAnalytics(
      totalViews: totalViews,
      completionRate: totalViews > 0 ? completions / totalViews : 0.0,
      averageTimeSpent: _calculateAverageTimeSpent(),
      dropOffPoints: _calculateDropOffPoints(),
      skipRate: totalViews > 0 ? skips / totalViews : 0.0,
      pageViewCounts: pageViewCounts,
      userActions: userActions,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<void> recordAnalyticsEvent(OnboardingAnalyticsEvent event) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _analyticsEvents.add(event);
    
    // Keep only recent events (last 1000) to prevent memory issues
    if (_analyticsEvents.length > 1000) {
      _analyticsEvents.removeRange(0, _analyticsEvents.length - 1000);
    }
  }

  /// Calculate average time spent from analytics events
  double _calculateAverageTimeSpent() {
    final durations = _analyticsEvents
        .where((event) => event.duration != null)
        .map((event) => event.duration!.inSeconds)
        .toList();
    
    if (durations.isEmpty) return 0.0;
    
    return durations.reduce((a, b) => a + b) / durations.length;
  }

  /// Calculate common drop-off points
  List<String> _calculateDropOffPoints() {
    final exitEvents = _analyticsEvents
        .where((event) => 
            event.eventType == OnboardingAnalyticsEvent.pageExit ||
            event.eventType == OnboardingAnalyticsEvent.skip)
        .toList();
    
    final exitCounts = <String, int>{};
    for (final event in exitEvents) {
      exitCounts[event.pageId] = (exitCounts[event.pageId] ?? 0) + 1;
    }
    
    // Return pages with highest exit rates
    final sortedExits = exitCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedExits.take(3).map((entry) => entry.key).toList();
  }

  /// Create welcome page with dramatic animations
  OnboardingPage _createWelcomePage() {
    return OnboardingPage(
      id: 'welcome',
      title: 'Welcome to FlutterMaster',
      subtitle: 'Master Flutter animations like a pro',
      description: 'Get ready to explore the most comprehensive Flutter animation tutorial. Learn to create smooth, delightful animations that bring your apps to life.',
      imagePath: 'assets/images/welcome_hero.png',
      primaryColor: const Color(0xFF6366F1),
      secondaryColor: const Color(0xFF8B5CF6),
      features: [],
      animationConfig: OnboardingAnimationConfig.dramatic(),
      backgroundGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE0E7FF),
          Color(0xFFF3E8FF),
        ],
      ),
    );
  }

  /// Create features page with staggered animations
  OnboardingPage _createFeaturesPage() {
    return OnboardingPage(
      id: 'features',
      title: 'Powerful Animation Features',
      subtitle: 'Everything you need to create amazing animations',
      description: 'Discover the comprehensive animation toolkit that will transform your Flutter development experience.',
      imagePath: 'assets/images/features_showcase.png',
      primaryColor: const Color(0xFF10B981),
      secondaryColor: const Color(0xFF34D399),
      features: [
        const OnboardingFeature(
          icon: Icons.auto_awesome,
          title: 'Auto-Coordinated Sequences',
          description: 'Perfect timing between multiple animated elements',
          animationDelay: Duration(milliseconds: 100),
        ),
        const OnboardingFeature(
          icon: Icons.physics,
          title: 'Physics-Based Motion',
          description: 'Natural spring and elastic curves for realistic motion',
          animationDelay: Duration(milliseconds: 200),
        ),
        const OnboardingFeature(
          icon: Icons.speed,
          title: 'Performance Optimized',
          description: 'Smooth 60fps animations with intelligent resource management',
          animationDelay: Duration(milliseconds: 300),
        ),
        const OnboardingFeature(
          icon: Icons.palette,
          title: 'Beautiful Presets',
          description: 'Ready-to-use animation patterns for common scenarios',
          animationDelay: Duration(milliseconds: 400),
        ),
      ],
      animationConfig: OnboardingAnimationConfig.staggered(),
      backgroundGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFECFDF5),
          Color(0xFFD1FAE5),
        ],
      ),
    );
  }

  /// Create benefits page with elegant animations
  OnboardingPage _createBenefitsPage() {
    return OnboardingPage(
      id: 'benefits',
      title: 'Transform Your Apps',
      subtitle: 'Create experiences users will love',
      description: 'Professional animations aren\'t just beautiful—they improve user engagement, perceived performance, and overall app quality.',
      imagePath: 'assets/images/benefits_illustration.png',
      primaryColor: const Color(0xFFF59E0B),
      secondaryColor: const Color(0xFFFBBF24),
      features: [
        const OnboardingFeature(
          icon: Icons.favorite,
          title: 'Increased User Engagement',
          description: 'Well-crafted animations keep users interested and engaged',
        ),
        const OnboardingFeature(
          icon: Icons.flash_on,
          title: 'Perceived Performance',
          description: 'Smart animations make your app feel faster and more responsive',
        ),
        const OnboardingFeature(
          icon: Icons.star,
          title: 'Professional Polish',
          description: 'Animations add the professional finish that sets great apps apart',
        ),
      ],
      animationConfig: OnboardingAnimationConfig.elegant(),
      backgroundGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFF7ED),
          Color(0xFFFED7AA),
        ],
      ),
    );
  }

  /// Create call-to-action page with playful animations
  OnboardingPage _createCallToActionPage() {
    return OnboardingPage(
      id: 'get_started',
      title: 'Ready to Animate?',
      subtitle: 'Let\'s build something amazing together',
      description: 'You\'ve seen what\'s possible. Now it\'s time to start creating your own stunning Flutter animations. The journey begins with a single tap.',
      imagePath: 'assets/images/rocket_launch.png',
      primaryColor: const Color(0xFFEF4444),
      secondaryColor: const Color(0xFFF87171),
      features: [],
      animationConfig: OnboardingAnimationConfig.playful(),
      backgroundGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFEF2F2),
          Color(0xFFFECACA),
        ],
      ),
      ctaText: 'Start Animating',
      nextText: 'Get Started',
    );
  }
}