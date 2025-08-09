// lib/core/review_management/review_tracker.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';
import 'dart:convert';
import 'dart:math' as math;

/// Comprehensive review and rating management system
/// Handles user reviews, app store ratings, feedback collection, and review strategy
class ReviewTracker {
  static final ReviewTracker _instance = ReviewTracker._internal();
  factory ReviewTracker() => _instance;
  ReviewTracker._internal();

  static const String _reviewPrefsKey = 'review_tracking_data';
  static const String _feedbackPrefsKey = 'user_feedback_data';
  late SharedPreferences _prefs;
  
  bool _isInitialized = false;
  ReviewTrackingData? _trackingData;
  List<UserFeedback> _userFeedback = [];

  /// Initialize the review tracker
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadTrackingData();
      await _loadUserFeedback();
      _isInitialized = true;
      
      debugPrint('✅ Review Tracker initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize Review Tracker: $e');
    }
  }

  /// Load review tracking data
  Future<void> _loadTrackingData() async {
    try {
      final dataJson = _prefs.getString(_reviewPrefsKey);
      if (dataJson != null) {
        final dataMap = jsonDecode(dataJson) as Map<String, dynamic>;
        _trackingData = ReviewTrackingData.fromJson(dataMap);
      } else {
        _trackingData = ReviewTrackingData.initial();
        await _saveTrackingData();
      }
    } catch (e) {
      debugPrint('Error loading review tracking data: $e');
      _trackingData = ReviewTrackingData.initial();
    }
  }

  /// Load user feedback
  Future<void> _loadUserFeedback() async {
    try {
      final feedbackJson = _prefs.getString(_feedbackPrefsKey);
      if (feedbackJson != null) {
        final feedbackList = jsonDecode(feedbackJson) as List;
        _userFeedback = feedbackList
            .map((json) => UserFeedback.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading user feedback: $e');
      _userFeedback = [];
    }
  }

  /// Save review tracking data
  Future<void> _saveTrackingData() async {
    if (_trackingData != null) {
      final dataJson = jsonEncode(_trackingData!.toJson());
      await _prefs.setString(_reviewPrefsKey, dataJson);
    }
  }

  /// Save user feedback
  Future<void> _saveUserFeedback() async {
    final feedbackJson = jsonEncode(_userFeedback.map((f) => f.toJson()).toList());
    await _prefs.setString(_feedbackPrefsKey, feedbackJson);
  }

  /// Check if we should request a review from the user
  Future<bool> shouldRequestReview() async {
    if (!_isInitialized) await initialize();
    if (_trackingData == null) return false;

    final now = DateTime.now();
    
    // Don't request if user already rated this version
    if (_trackingData!.hasRatedCurrentVersion) {
      return false;
    }

    // Don't request if user opted out
    if (_trackingData!.hasOptedOut) {
      return false;
    }

    // Don't request too frequently
    if (_trackingData!.lastRequestDate != null) {
      final daysSinceLastRequest = now.difference(_trackingData!.lastRequestDate!).inDays;
      if (daysSinceLastRequest < _trackingData!.minimumDaysBetweenRequests) {
        return false;
      }
    }

    // Check usage criteria
    if (_trackingData!.appLaunches < _trackingData!.minimumLaunchesBeforeRequest) {
      return false;
    }

    if (_trackingData!.daysUsed < _trackingData!.minimumDaysBeforeRequest) {
      return false;
    }

    // Check positive usage indicators
    if (_trackingData!.positiveActionCount < 3) {
      return false; // Wait for more positive interactions
    }

    // Check if user has had any negative experiences recently
    if (_trackingData!.recentNegativeExperiences > 0) {
      return false;
    }

    return true;
  }

  /// Request app store review
  Future<ReviewRequestResult> requestReview({bool force = false}) async {
    if (!_isInitialized) await initialize();
    
    if (!force && !await shouldRequestReview()) {
      return ReviewRequestResult(
        success: false,
        reason: 'Conditions not met for review request',
        action: ReviewAction.skipped,
      );
    }

    try {
      final inAppReview = InAppReview.instance;
      
      // Check if in-app review is available
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        
        // Update tracking data
        await _updateAfterReviewRequest(ReviewAction.prompted);
        
        return ReviewRequestResult(
          success: true,
          reason: 'In-app review prompted successfully',
          action: ReviewAction.prompted,
        );
      } else {
        // Fallback to opening app store
        await inAppReview.openStoreListing();
        
        // Update tracking data
        await _updateAfterReviewRequest(ReviewAction.redirectedToStore);
        
        return ReviewRequestResult(
          success: true,
          reason: 'Redirected to app store for review',
          action: ReviewAction.redirectedToStore,
        );
      }
    } catch (e) {
      debugPrint('Error requesting review: $e');
      return ReviewRequestResult(
        success: false,
        reason: 'Failed to request review: $e',
        action: ReviewAction.failed,
      );
    }
  }

  /// Update tracking data after review request
  Future<void> _updateAfterReviewRequest(ReviewAction action) async {
    if (_trackingData == null) return;

    _trackingData = _trackingData!.copyWith(
      lastRequestDate: DateTime.now(),
      totalRequestsMade: _trackingData!.totalRequestsMade + 1,
      lastAction: action,
    );

    await _saveTrackingData();
    debugPrint('Updated review tracking after $action');
  }

  /// Record positive user action (successful feature use, completion, etc.)
  Future<void> recordPositiveAction(String action) async {
    if (!_isInitialized) await initialize();
    if (_trackingData == null) return;

    _trackingData = _trackingData!.copyWith(
      positiveActionCount: _trackingData!.positiveActionCount + 1,
      lastPositiveAction: action,
      lastPositiveActionDate: DateTime.now(),
    );

    await _saveTrackingData();
    debugPrint('Recorded positive action: $action');
  }

  /// Record negative user experience (crash, error, frustration indicator)
  Future<void> recordNegativeExperience(String experience) async {
    if (!_isInitialized) await initialize();
    if (_trackingData == null) return;

    _trackingData = _trackingData!.copyWith(
      recentNegativeExperiences: _trackingData!.recentNegativeExperiences + 1,
      lastNegativeExperience: experience,
      lastNegativeExperienceDate: DateTime.now(),
    );

    await _saveTrackingData();
    debugPrint('Recorded negative experience: $experience');
  }

  /// Record app launch
  Future<void> recordAppLaunch() async {
    if (!_isInitialized) await initialize();
    if (_trackingData == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Check if this is a new day
    bool isNewDay = false;
    if (_trackingData!.lastLaunchDate == null) {
      isNewDay = true;
    } else {
      final lastLaunchDay = DateTime(
        _trackingData!.lastLaunchDate!.year,
        _trackingData!.lastLaunchDate!.month,
        _trackingData!.lastLaunchDate!.day,
      );
      isNewDay = today.isAfter(lastLaunchDay);
    }

    _trackingData = _trackingData!.copyWith(
      appLaunches: _trackingData!.appLaunches + 1,
      daysUsed: isNewDay ? _trackingData!.daysUsed + 1 : _trackingData!.daysUsed,
      lastLaunchDate: now,
      // Reset negative experiences daily
      recentNegativeExperiences: isNewDay ? 0 : _trackingData!.recentNegativeExperiences,
    );

    await _saveTrackingData();
    debugPrint('Recorded app launch (launches: ${_trackingData!.appLaunches}, days: ${_trackingData!.daysUsed})');
  }

  /// Collect user feedback
  Future<void> collectFeedback({
    required int rating,
    required String feedback,
    required FeedbackCategory category,
    Map<String, dynamic>? metadata,
  }) async {
    if (!_isInitialized) await initialize();

    final userFeedback = UserFeedback(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      rating: rating,
      feedback: feedback,
      category: category,
      timestamp: DateTime.now(),
      metadata: metadata ?? {},
      isResolved: false,
    );

    _userFeedback.add(userFeedback);
    await _saveUserFeedback();

    // If it's a high rating, mark as positive action
    if (rating >= 4) {
      await recordPositiveAction('High rating feedback: $rating stars');
    } else if (rating <= 2) {
      await recordNegativeExperience('Low rating feedback: $rating stars');
    }

    debugPrint('Collected user feedback: $rating stars - ${feedback.length} chars');
  }

  /// Mark user as having rated current version
  Future<void> markUserAsRated() async {
    if (!_isInitialized) await initialize();
    if (_trackingData == null) return;

    _trackingData = _trackingData!.copyWith(
      hasRatedCurrentVersion: true,
      ratingDate: DateTime.now(),
    );

    await _saveTrackingData();
    debugPrint('Marked user as having rated current version');
  }

  /// User opts out of review requests
  Future<void> optOutOfReviews() async {
    if (!_isInitialized) await initialize();
    if (_trackingData == null) return;

    _trackingData = _trackingData!.copyWith(
      hasOptedOut: true,
      optOutDate: DateTime.now(),
    );

    await _saveTrackingData();
    debugPrint('User opted out of review requests');
  }

  /// User opts back into review requests
  Future<void> optIntoReviews() async {
    if (!_isInitialized) await initialize();
    if (_trackingData == null) return;

    _trackingData = _trackingData!.copyWith(
      hasOptedOut: false,
      optOutDate: null,
    );

    await _saveTrackingData();
    debugPrint('User opted back into review requests');
  }

  /// Get review analytics summary
  ReviewAnalytics getAnalytics() {
    if (_trackingData == null || _userFeedback.isEmpty) {
      return ReviewAnalytics.empty();
    }

    final ratings = _userFeedback.map((f) => f.rating).toList();
    final averageRating = ratings.isNotEmpty ? ratings.reduce((a, b) => a + b) / ratings.length : 0.0;
    
    final ratingDistribution = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      ratingDistribution[i] = ratings.where((r) => r == i).length;
    }

    final categoryDistribution = <FeedbackCategory, int>{};
    for (final category in FeedbackCategory.values) {
      categoryDistribution[category] = _userFeedback.where((f) => f.category == category).length;
    }

    return ReviewAnalytics(
      totalFeedback: _userFeedback.length,
      averageRating: averageRating,
      ratingDistribution: ratingDistribution,
      categoryDistribution: categoryDistribution,
      positiveActionCount: _trackingData!.positiveActionCount,
      negativeExperienceCount: _trackingData!.recentNegativeExperiences,
      totalAppLaunches: _trackingData!.appLaunches,
      daysUsed: _trackingData!.daysUsed,
      reviewRequestsMade: _trackingData!.totalRequestsMade,
      hasRatedCurrentVersion: _trackingData!.hasRatedCurrentVersion,
      hasOptedOut: _trackingData!.hasOptedOut,
      lastFeedbackDate: _userFeedback.isNotEmpty ? _userFeedback.last.timestamp : null,
      lastPositiveActionDate: _trackingData!.lastPositiveActionDate,
      lastNegativeExperienceDate: _trackingData!.lastNegativeExperienceDate,
    );
  }

  /// Get smart review timing recommendation
  ReviewTiming getReviewTiming() {
    if (_trackingData == null) {
      return ReviewTiming(
        shouldRequest: false,
        reason: 'No tracking data available',
        recommendedDate: DateTime.now().add(Duration(days: 7)),
        confidence: 0.0,
      );
    }

    final analytics = getAnalytics();
    double confidence = 0.0;
    String reason = '';
    DateTime recommendedDate = DateTime.now();

    // Calculate confidence based on positive indicators
    if (analytics.positiveActionCount >= 5) confidence += 0.3;
    if (analytics.averageRating >= 4.0) confidence += 0.3;
    if (analytics.daysUsed >= 7) confidence += 0.2;
    if (analytics.negativeExperienceCount == 0) confidence += 0.2;

    // Adjust confidence based on negative indicators
    if (analytics.hasOptedOut) confidence = 0.0;
    if (analytics.hasRatedCurrentVersion) confidence = 0.0;
    if (analytics.negativeExperienceCount > 2) confidence -= 0.4;
    if (analytics.averageRating < 3.0) confidence -= 0.5;

    // Determine recommendation
    if (confidence >= 0.7) {
      reason = 'High confidence - user shows strong positive engagement';
      recommendedDate = DateTime.now();
    } else if (confidence >= 0.5) {
      reason = 'Medium confidence - wait for more positive indicators';
      recommendedDate = DateTime.now().add(Duration(days: 3));
    } else if (confidence >= 0.3) {
      reason = 'Low confidence - wait for significant positive engagement';
      recommendedDate = DateTime.now().add(Duration(days: 7));
    } else {
      reason = 'Not recommended - address user concerns first';
      recommendedDate = DateTime.now().add(Duration(days: 14));
    }

    return ReviewTiming(
      shouldRequest: confidence >= 0.7,
      reason: reason,
      recommendedDate: recommendedDate,
      confidence: math.max(0.0, math.min(1.0, confidence)),
    );
  }

  /// Get feedback insights
  List<FeedbackInsight> getFeedbackInsights() {
    final insights = <FeedbackInsight>[];
    
    if (_userFeedback.isEmpty) {
      return insights;
    }

    // Analyze rating trends
    final recentFeedback = _userFeedback
        .where((f) => DateTime.now().difference(f.timestamp).inDays <= 30)
        .toList();
    
    if (recentFeedback.isNotEmpty) {
      final averageRating = recentFeedback
          .map((f) => f.rating)
          .reduce((a, b) => a + b) / recentFeedback.length;
      
      if (averageRating >= 4.0) {
        insights.add(FeedbackInsight(
          type: InsightType.positive,
          title: 'Excellent User Satisfaction',
          description: 'Recent feedback shows high user satisfaction (${averageRating.toStringAsFixed(1)}/5.0)',
          actionable: true,
          recommendation: 'Great time to request more reviews from satisfied users',
        ));
      } else if (averageRating <= 2.5) {
        insights.add(FeedbackInsight(
          type: InsightType.negative,
          title: 'User Satisfaction Concerns',
          description: 'Recent feedback shows lower satisfaction (${averageRating.toStringAsFixed(1)}/5.0)',
          actionable: true,
          recommendation: 'Focus on addressing common issues before requesting more reviews',
        ));
      }
    }

    // Analyze feedback categories
    final categoryCount = <FeedbackCategory, int>{};
    for (final feedback in _userFeedback) {
      categoryCount[feedback.category] = (categoryCount[feedback.category] ?? 0) + 1;
    }

    final topCategory = categoryCount.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    
    insights.add(FeedbackInsight(
      type: InsightType.informational,
      title: 'Most Common Feedback Category',
      description: '${_categoryToString(topCategory.key)} accounts for ${topCategory.value} feedback items',
      actionable: topCategory.key == FeedbackCategory.bugReport || topCategory.key == FeedbackCategory.featureRequest,
      recommendation: _getRecommendationForCategory(topCategory.key),
    ));

    // Analyze feedback sentiment
    final negativeFeedback = _userFeedback.where((f) => f.rating <= 2).length;
    final positiveFeedback = _userFeedback.where((f) => f.rating >= 4).length;
    
    if (negativeFeedback > positiveFeedback) {
      insights.add(FeedbackInsight(
        type: InsightType.warning,
        title: 'More Negative Than Positive Feedback',
        description: '$negativeFeedback negative vs $positiveFeedback positive reviews',
        actionable: true,
        recommendation: 'Prioritize addressing negative feedback and improving user experience',
      ));
    }

    return insights;
  }

  /// Helper method to convert category to string
  String _categoryToString(FeedbackCategory category) {
    switch (category) {
      case FeedbackCategory.general:
        return 'General Feedback';
      case FeedbackCategory.bugReport:
        return 'Bug Reports';
      case FeedbackCategory.featureRequest:
        return 'Feature Requests';
      case FeedbackCategory.performance:
        return 'Performance Issues';
      case FeedbackCategory.usability:
        return 'Usability Concerns';
      case FeedbackCategory.content:
        return 'Content Feedback';
    }
  }

  /// Get recommendation for feedback category
  String _getRecommendationForCategory(FeedbackCategory category) {
    switch (category) {
      case FeedbackCategory.bugReport:
        return 'Focus on bug fixing and quality assurance to improve user experience';
      case FeedbackCategory.featureRequest:
        return 'Consider implementing popular feature requests in upcoming releases';
      case FeedbackCategory.performance:
        return 'Optimize app performance and loading times based on user feedback';
      case FeedbackCategory.usability:
        return 'Review and improve user interface design and user experience flows';
      case FeedbackCategory.content:
        return 'Evaluate and enhance app content based on user preferences';
      case FeedbackCategory.general:
        return 'Continue monitoring general feedback trends for overall satisfaction';
    }
  }

  /// Get current tracking data
  ReviewTrackingData? get trackingData => _trackingData;

  /// Get all user feedback
  List<UserFeedback> get userFeedback => _userFeedback;

  /// Reset all tracking data (for testing or new version)
  Future<void> resetTrackingData() async {
    _trackingData = ReviewTrackingData.initial();
    await _saveTrackingData();
    debugPrint('Reset review tracking data');
  }
}

/// Review tracking data model
class ReviewTrackingData {
  final int appLaunches;
  final int daysUsed;
  final int positiveActionCount;
  final int recentNegativeExperiences;
  final int totalRequestsMade;
  final int minimumLaunchesBeforeRequest;
  final int minimumDaysBeforeRequest;
  final int minimumDaysBetweenRequests;
  final bool hasRatedCurrentVersion;
  final bool hasOptedOut;
  final DateTime? lastLaunchDate;
  final DateTime? lastRequestDate;
  final DateTime? lastPositiveActionDate;
  final DateTime? lastNegativeExperienceDate;
  final DateTime? ratingDate;
  final DateTime? optOutDate;
  final String? lastPositiveAction;
  final String? lastNegativeExperience;
  final ReviewAction? lastAction;

  const ReviewTrackingData({
    required this.appLaunches,
    required this.daysUsed,
    required this.positiveActionCount,
    required this.recentNegativeExperiences,
    required this.totalRequestsMade,
    required this.minimumLaunchesBeforeRequest,
    required this.minimumDaysBeforeRequest,
    required this.minimumDaysBetweenRequests,
    required this.hasRatedCurrentVersion,
    required this.hasOptedOut,
    this.lastLaunchDate,
    this.lastRequestDate,
    this.lastPositiveActionDate,
    this.lastNegativeExperienceDate,
    this.ratingDate,
    this.optOutDate,
    this.lastPositiveAction,
    this.lastNegativeExperience,
    this.lastAction,
  });

  factory ReviewTrackingData.initial() {
    return ReviewTrackingData(
      appLaunches: 0,
      daysUsed: 0,
      positiveActionCount: 0,
      recentNegativeExperiences: 0,
      totalRequestsMade: 0,
      minimumLaunchesBeforeRequest: 10,
      minimumDaysBeforeRequest: 3,
      minimumDaysBetweenRequests: 30,
      hasRatedCurrentVersion: false,
      hasOptedOut: false,
    );
  }

  ReviewTrackingData copyWith({
    int? appLaunches,
    int? daysUsed,
    int? positiveActionCount,
    int? recentNegativeExperiences,
    int? totalRequestsMade,
    int? minimumLaunchesBeforeRequest,
    int? minimumDaysBeforeRequest,
    int? minimumDaysBetweenRequests,
    bool? hasRatedCurrentVersion,
    bool? hasOptedOut,
    DateTime? lastLaunchDate,
    DateTime? lastRequestDate,
    DateTime? lastPositiveActionDate,
    DateTime? lastNegativeExperienceDate,
    DateTime? ratingDate,
    DateTime? optOutDate,
    String? lastPositiveAction,
    String? lastNegativeExperience,
    ReviewAction? lastAction,
  }) {
    return ReviewTrackingData(
      appLaunches: appLaunches ?? this.appLaunches,
      daysUsed: daysUsed ?? this.daysUsed,
      positiveActionCount: positiveActionCount ?? this.positiveActionCount,
      recentNegativeExperiences: recentNegativeExperiences ?? this.recentNegativeExperiences,
      totalRequestsMade: totalRequestsMade ?? this.totalRequestsMade,
      minimumLaunchesBeforeRequest: minimumLaunchesBeforeRequest ?? this.minimumLaunchesBeforeRequest,
      minimumDaysBeforeRequest: minimumDaysBeforeRequest ?? this.minimumDaysBeforeRequest,
      minimumDaysBetweenRequests: minimumDaysBetweenRequests ?? this.minimumDaysBetweenRequests,
      hasRatedCurrentVersion: hasRatedCurrentVersion ?? this.hasRatedCurrentVersion,
      hasOptedOut: hasOptedOut ?? this.hasOptedOut,
      lastLaunchDate: lastLaunchDate ?? this.lastLaunchDate,
      lastRequestDate: lastRequestDate ?? this.lastRequestDate,
      lastPositiveActionDate: lastPositiveActionDate ?? this.lastPositiveActionDate,
      lastNegativeExperienceDate: lastNegativeExperienceDate ?? this.lastNegativeExperienceDate,
      ratingDate: ratingDate ?? this.ratingDate,
      optOutDate: optOutDate ?? this.optOutDate,
      lastPositiveAction: lastPositiveAction ?? this.lastPositiveAction,
      lastNegativeExperience: lastNegativeExperience ?? this.lastNegativeExperience,
      lastAction: lastAction ?? this.lastAction,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appLaunches': appLaunches,
      'daysUsed': daysUsed,
      'positiveActionCount': positiveActionCount,
      'recentNegativeExperiences': recentNegativeExperiences,
      'totalRequestsMade': totalRequestsMade,
      'minimumLaunchesBeforeRequest': minimumLaunchesBeforeRequest,
      'minimumDaysBeforeRequest': minimumDaysBeforeRequest,
      'minimumDaysBetweenRequests': minimumDaysBetweenRequests,
      'hasRatedCurrentVersion': hasRatedCurrentVersion,
      'hasOptedOut': hasOptedOut,
      'lastLaunchDate': lastLaunchDate?.toIso8601String(),
      'lastRequestDate': lastRequestDate?.toIso8601String(),
      'lastPositiveActionDate': lastPositiveActionDate?.toIso8601String(),
      'lastNegativeExperienceDate': lastNegativeExperienceDate?.toIso8601String(),
      'ratingDate': ratingDate?.toIso8601String(),
      'optOutDate': optOutDate?.toIso8601String(),
      'lastPositiveAction': lastPositiveAction,
      'lastNegativeExperience': lastNegativeExperience,
      'lastAction': lastAction?.toString(),
    };
  }

  factory ReviewTrackingData.fromJson(Map<String, dynamic> json) {
    return ReviewTrackingData(
      appLaunches: json['appLaunches'] as int,
      daysUsed: json['daysUsed'] as int,
      positiveActionCount: json['positiveActionCount'] as int,
      recentNegativeExperiences: json['recentNegativeExperiences'] as int,
      totalRequestsMade: json['totalRequestsMade'] as int,
      minimumLaunchesBeforeRequest: json['minimumLaunchesBeforeRequest'] as int,
      minimumDaysBeforeRequest: json['minimumDaysBeforeRequest'] as int,
      minimumDaysBetweenRequests: json['minimumDaysBetweenRequests'] as int,
      hasRatedCurrentVersion: json['hasRatedCurrentVersion'] as bool,
      hasOptedOut: json['hasOptedOut'] as bool,
      lastLaunchDate: json['lastLaunchDate'] != null 
          ? DateTime.parse(json['lastLaunchDate'] as String) 
          : null,
      lastRequestDate: json['lastRequestDate'] != null 
          ? DateTime.parse(json['lastRequestDate'] as String) 
          : null,
      lastPositiveActionDate: json['lastPositiveActionDate'] != null 
          ? DateTime.parse(json['lastPositiveActionDate'] as String) 
          : null,
      lastNegativeExperienceDate: json['lastNegativeExperienceDate'] != null 
          ? DateTime.parse(json['lastNegativeExperienceDate'] as String) 
          : null,
      ratingDate: json['ratingDate'] != null 
          ? DateTime.parse(json['ratingDate'] as String) 
          : null,
      optOutDate: json['optOutDate'] != null 
          ? DateTime.parse(json['optOutDate'] as String) 
          : null,
      lastPositiveAction: json['lastPositiveAction'] as String?,
      lastNegativeExperience: json['lastNegativeExperience'] as String?,
      lastAction: json['lastAction'] != null 
          ? ReviewAction.values.firstWhere(
              (e) => e.toString() == json['lastAction'],
              orElse: () => ReviewAction.skipped,
            )
          : null,
    );
  }
}

/// User feedback model
class UserFeedback {
  final String id;
  final int rating;
  final String feedback;
  final FeedbackCategory category;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final bool isResolved;

  const UserFeedback({
    required this.id,
    required this.rating,
    required this.feedback,
    required this.category,
    required this.timestamp,
    required this.metadata,
    required this.isResolved,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'feedback': feedback,
      'category': category.toString(),
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'isResolved': isResolved,
    };
  }

  factory UserFeedback.fromJson(Map<String, dynamic> json) {
    return UserFeedback(
      id: json['id'] as String,
      rating: json['rating'] as int,
      feedback: json['feedback'] as String,
      category: FeedbackCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => FeedbackCategory.general,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>,
      isResolved: json['isResolved'] as bool,
    );
  }
}

/// Review analytics model
class ReviewAnalytics {
  final int totalFeedback;
  final double averageRating;
  final Map<int, int> ratingDistribution;
  final Map<FeedbackCategory, int> categoryDistribution;
  final int positiveActionCount;
  final int negativeExperienceCount;
  final int totalAppLaunches;
  final int daysUsed;
  final int reviewRequestsMade;
  final bool hasRatedCurrentVersion;
  final bool hasOptedOut;
  final DateTime? lastFeedbackDate;
  final DateTime? lastPositiveActionDate;
  final DateTime? lastNegativeExperienceDate;

  const ReviewAnalytics({
    required this.totalFeedback,
    required this.averageRating,
    required this.ratingDistribution,
    required this.categoryDistribution,
    required this.positiveActionCount,
    required this.negativeExperienceCount,
    required this.totalAppLaunches,
    required this.daysUsed,
    required this.reviewRequestsMade,
    required this.hasRatedCurrentVersion,
    required this.hasOptedOut,
    this.lastFeedbackDate,
    this.lastPositiveActionDate,
    this.lastNegativeExperienceDate,
  });

  factory ReviewAnalytics.empty() {
    return ReviewAnalytics(
      totalFeedback: 0,
      averageRating: 0.0,
      ratingDistribution: {},
      categoryDistribution: {},
      positiveActionCount: 0,
      negativeExperienceCount: 0,
      totalAppLaunches: 0,
      daysUsed: 0,
      reviewRequestsMade: 0,
      hasRatedCurrentVersion: false,
      hasOptedOut: false,
    );
  }
}

/// Review timing recommendation model
class ReviewTiming {
  final bool shouldRequest;
  final String reason;
  final DateTime recommendedDate;
  final double confidence;

  const ReviewTiming({
    required this.shouldRequest,
    required this.reason,
    required this.recommendedDate,
    required this.confidence,
  });
}

/// Feedback insight model
class FeedbackInsight {
  final InsightType type;
  final String title;
  final String description;
  final bool actionable;
  final String recommendation;

  const FeedbackInsight({
    required this.type,
    required this.title,
    required this.description,
    required this.actionable,
    required this.recommendation,
  });
}

/// Review request result model
class ReviewRequestResult {
  final bool success;
  final String reason;
  final ReviewAction action;

  const ReviewRequestResult({
    required this.success,
    required this.reason,
    required this.action,
  });
}

/// Feedback category enumeration
enum FeedbackCategory {
  general,
  bugReport,
  featureRequest,
  performance,
  usability,
  content,
}

/// Review action enumeration
enum ReviewAction {
  prompted,
  redirectedToStore,
  skipped,
  failed,
}

/// Insight type enumeration
enum InsightType {
  positive,
  negative,
  warning,
  informational,
}

