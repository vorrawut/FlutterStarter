/// Onboarding repository interface
/// 
/// This file defines the repository interface for accessing onboarding
/// data and configurations in a clean architecture pattern.
library;

import '../entities/onboarding_page.dart';

/// Repository interface for onboarding data access
/// 
/// Defines the contract for accessing onboarding pages, flow configurations,
/// and user progress tracking with clean separation of concerns.
abstract class OnboardingRepository {
  /// Get the complete onboarding flow configuration
  /// 
  /// Returns the full onboarding flow with all pages and settings.
  Future<OnboardingFlowConfig> getOnboardingFlow();

  /// Get a specific onboarding page by ID
  /// 
  /// Returns null if the page with the given [pageId] is not found.
  Future<OnboardingPage?> getOnboardingPage(String pageId);

  /// Get all onboarding pages
  /// 
  /// Returns a list of all available onboarding pages in order.
  Future<List<OnboardingPage>> getAllOnboardingPages();

  /// Check if user has completed onboarding
  /// 
  /// Returns true if the user has successfully completed the onboarding flow.
  Future<bool> hasCompletedOnboarding();

  /// Mark onboarding as completed
  /// 
  /// Persists the user's completion status for future app launches.
  Future<void> markOnboardingCompleted();

  /// Get current onboarding progress
  /// 
  /// Returns the index of the last page the user viewed, or 0 if starting fresh.
  Future<int> getCurrentProgress();

  /// Save current onboarding progress
  /// 
  /// Persists the user's current position in the onboarding flow.
  Future<void> saveProgress(int pageIndex);

  /// Reset onboarding progress
  /// 
  /// Clears all saved progress and completion status, allowing user to restart.
  Future<void> resetOnboardingProgress();

  /// Check if user has skipped onboarding
  /// 
  /// Returns true if the user chose to skip the onboarding flow.
  Future<bool> hasSkippedOnboarding();

  /// Mark onboarding as skipped
  /// 
  /// Records that the user chose to skip the onboarding process.
  Future<void> markOnboardingSkipped();

  /// Get user preferences for onboarding
  /// 
  /// Returns user preferences such as animation settings, motion preferences, etc.
  Future<OnboardingPreferences> getUserPreferences();

  /// Save user preferences for onboarding
  /// 
  /// Persists user preferences for future onboarding experiences.
  Future<void> saveUserPreferences(OnboardingPreferences preferences);

  /// Get analytics data for onboarding
  /// 
  /// Returns analytics information about onboarding completion rates,
  /// drop-off points, and user engagement.
  Future<OnboardingAnalytics> getAnalytics();

  /// Record analytics event
  /// 
  /// Records an analytics event for onboarding tracking and optimization.
  Future<void> recordAnalyticsEvent(OnboardingAnalyticsEvent event);
}

/// Onboarding user preferences
/// 
/// Represents user preferences and settings for the onboarding experience.
class OnboardingPreferences {
  /// Creates onboarding preferences
  const OnboardingPreferences({
    this.animationsEnabled = true,
    this.reducedMotion = false,
    this.soundEnabled = false,
    this.hapticFeedbackEnabled = true,
    this.autoAdvanceEnabled = false,
    this.preferredLanguage = 'en',
    this.themeModePreference = 'system',
    this.fontSize = 1.0,
    this.highContrastMode = false,
  });

  /// Whether animations are enabled
  final bool animationsEnabled;

  /// Whether reduced motion is preferred (accessibility)
  final bool reducedMotion;

  /// Whether sound effects are enabled
  final bool soundEnabled;

  /// Whether haptic feedback is enabled
  final bool hapticFeedbackEnabled;

  /// Whether auto-advance is enabled
  final bool autoAdvanceEnabled;

  /// Preferred language code
  final String preferredLanguage;

  /// Theme mode preference ('light', 'dark', 'system')
  final String themeModePreference;

  /// Font size multiplier
  final double fontSize;

  /// Whether high contrast mode is enabled
  final bool highContrastMode;

  /// Create a copy with modified values
  OnboardingPreferences copyWith({
    bool? animationsEnabled,
    bool? reducedMotion,
    bool? soundEnabled,
    bool? hapticFeedbackEnabled,
    bool? autoAdvanceEnabled,
    String? preferredLanguage,
    String? themeModePreference,
    double? fontSize,
    bool? highContrastMode,
  }) {
    return OnboardingPreferences(
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      autoAdvanceEnabled: autoAdvanceEnabled ?? this.autoAdvanceEnabled,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      themeModePreference: themeModePreference ?? this.themeModePreference,
      fontSize: fontSize ?? this.fontSize,
      highContrastMode: highContrastMode ?? this.highContrastMode,
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'animationsEnabled': animationsEnabled,
      'reducedMotion': reducedMotion,
      'soundEnabled': soundEnabled,
      'hapticFeedbackEnabled': hapticFeedbackEnabled,
      'autoAdvanceEnabled': autoAdvanceEnabled,
      'preferredLanguage': preferredLanguage,
      'themeModePreference': themeModePreference,
      'fontSize': fontSize,
      'highContrastMode': highContrastMode,
    };
  }

  /// Create from map
  factory OnboardingPreferences.fromMap(Map<String, dynamic> map) {
    return OnboardingPreferences(
      animationsEnabled: map['animationsEnabled'] ?? true,
      reducedMotion: map['reducedMotion'] ?? false,
      soundEnabled: map['soundEnabled'] ?? false,
      hapticFeedbackEnabled: map['hapticFeedbackEnabled'] ?? true,
      autoAdvanceEnabled: map['autoAdvanceEnabled'] ?? false,
      preferredLanguage: map['preferredLanguage'] ?? 'en',
      themeModePreference: map['themeModePreference'] ?? 'system',
      fontSize: map['fontSize'] ?? 1.0,
      highContrastMode: map['highContrastMode'] ?? false,
    );
  }

  @override
  String toString() {
    return 'OnboardingPreferences('
        'animationsEnabled: $animationsEnabled, '
        'reducedMotion: $reducedMotion, '
        'soundEnabled: $soundEnabled'
        ')';
  }
}

/// Onboarding analytics data
/// 
/// Contains analytics information about onboarding performance and user behavior.
class OnboardingAnalytics {
  /// Creates onboarding analytics
  const OnboardingAnalytics({
    required this.totalViews,
    required this.completionRate,
    required this.averageTimeSpent,
    required this.dropOffPoints,
    required this.skipRate,
    required this.pageViewCounts,
    required this.userActions,
    this.lastUpdated,
  });

  /// Total number of onboarding views
  final int totalViews;

  /// Completion rate (0.0 to 1.0)
  final double completionRate;

  /// Average time spent in onboarding (in seconds)
  final double averageTimeSpent;

  /// Pages where users commonly drop off
  final List<String> dropOffPoints;

  /// Rate at which users skip onboarding (0.0 to 1.0)
  final double skipRate;

  /// View count for each page
  final Map<String, int> pageViewCounts;

  /// User actions and their frequency
  final Map<String, int> userActions;

  /// When analytics were last updated
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'OnboardingAnalytics('
        'totalViews: $totalViews, '
        'completionRate: ${(completionRate * 100).toStringAsFixed(1)}%, '
        'skipRate: ${(skipRate * 100).toStringAsFixed(1)}%'
        ')';
  }
}

/// Onboarding analytics event
/// 
/// Represents a single analytics event in the onboarding flow.
class OnboardingAnalyticsEvent {
  /// Creates an analytics event
  const OnboardingAnalyticsEvent({
    required this.eventType,
    required this.pageId,
    required this.timestamp,
    this.duration,
    this.additionalData,
  });

  /// Type of event
  final String eventType;

  /// Page where event occurred
  final String pageId;

  /// When the event occurred
  final DateTime timestamp;

  /// Duration of the event (if applicable)
  final Duration? duration;

  /// Additional event data
  final Map<String, dynamic>? additionalData;

  /// Common event types
  static const String pageView = 'page_view';
  static const String pageExit = 'page_exit';
  static const String buttonTap = 'button_tap';
  static const String skip = 'skip';
  static const String complete = 'complete';
  static const String animationStart = 'animation_start';
  static const String animationComplete = 'animation_complete';
  static const String errorOccurred = 'error_occurred';

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'eventType': eventType,
      'pageId': pageId,
      'timestamp': timestamp.toIso8601String(),
      'duration': duration?.inMilliseconds,
      'additionalData': additionalData,
    };
  }

  /// Create from map
  factory OnboardingAnalyticsEvent.fromMap(Map<String, dynamic> map) {
    return OnboardingAnalyticsEvent(
      eventType: map['eventType'],
      pageId: map['pageId'],
      timestamp: DateTime.parse(map['timestamp']),
      duration: map['duration'] != null 
          ? Duration(milliseconds: map['duration'])
          : null,
      additionalData: map['additionalData'],
    );
  }

  @override
  String toString() {
    return 'OnboardingAnalyticsEvent('
        'eventType: $eventType, '
        'pageId: $pageId, '
        'timestamp: $timestamp'
        ')';
  }
}