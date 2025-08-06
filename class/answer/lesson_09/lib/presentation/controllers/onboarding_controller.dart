/// Onboarding controller for state management
/// 
/// This file provides the main controller for managing onboarding flow state,
/// page navigation, progress tracking, and integration with animation systems.
library;

import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import 'animation_coordinator.dart';

/// Main controller for onboarding flow state management
/// 
/// Manages the overall onboarding experience including page navigation,
/// progress tracking, user preferences, and animation coordination.
class OnboardingController extends ChangeNotifier {
  /// Creates an onboarding controller
  OnboardingController({
    OnboardingRepository? repository,
    AnimationCoordinator? animationCoordinator,
  }) : _repository = repository ?? OnboardingRepositoryImpl(),
        _animationCoordinator = animationCoordinator ?? AnimationCoordinator();

  /// Repository for onboarding data access
  final OnboardingRepository _repository;

  /// Animation coordinator for managing complex animations
  final AnimationCoordinator _animationCoordinator;

  /// Current onboarding flow configuration
  OnboardingFlowConfig? _flowConfig;

  /// Current page index
  int _currentPageIndex = 0;

  /// Whether onboarding is loading
  bool _isLoading = true;

  /// Current error message
  String? _errorMessage;

  /// Whether onboarding has been completed
  bool _isCompleted = false;

  /// Whether onboarding has been skipped
  bool _isSkipped = false;

  /// User preferences
  OnboardingPreferences _userPreferences = const OnboardingPreferences();

  /// Page controller for PageView
  PageController? _pageController;

  /// Whether animations are currently playing
  bool _isAnimating = false;

  /// Animation completion status for current page
  bool _currentPageAnimationComplete = false;

  // Getters

  /// Current onboarding flow configuration
  OnboardingFlowConfig? get flowConfig => _flowConfig;

  /// Current page index
  int get currentPageIndex => _currentPageIndex;

  /// Whether onboarding is loading
  bool get isLoading => _isLoading;

  /// Current error message
  String? get errorMessage => _errorMessage;

  /// Whether there's an error
  bool get hasError => _errorMessage != null;

  /// Whether onboarding has been completed
  bool get isCompleted => _isCompleted;

  /// Whether onboarding has been skipped
  bool get isSkipped => _isSkipped;

  /// User preferences
  OnboardingPreferences get userPreferences => _userPreferences;

  /// Page controller
  PageController? get pageController => _pageController;

  /// Whether animations are currently playing
  bool get isAnimating => _isAnimating;

  /// Whether current page animation is complete
  bool get currentPageAnimationComplete => _currentPageAnimationComplete;

  /// Current onboarding page
  OnboardingPage? get currentPage {
    if (_flowConfig == null || _currentPageIndex >= _flowConfig!.pages.length) {
      return null;
    }
    return _flowConfig!.pages[_currentPageIndex];
  }

  /// Total number of pages
  int get totalPages => _flowConfig?.pages.length ?? 0;

  /// Whether this is the first page
  bool get isFirstPage => _currentPageIndex == 0;

  /// Whether this is the last page
  bool get isLastPage => _flowConfig?.isLastPage(_currentPageIndex) ?? false;

  /// Progress percentage (0.0 to 1.0)
  double get progress => totalPages > 0 ? (_currentPageIndex + 1) / totalPages : 0.0;

  /// Animation coordinator
  AnimationCoordinator get animationCoordinator => _animationCoordinator;

  /// Initialize the onboarding controller
  /// 
  /// Loads onboarding configuration, user preferences, and sets up
  /// the initial state for the onboarding experience.
  Future<void> initialize() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Load onboarding flow configuration
      _flowConfig = await _repository.getOnboardingFlow();

      // Load user preferences
      _userPreferences = await _repository.getUserPreferences();

      // Check if onboarding was already completed or skipped
      _isCompleted = await _repository.hasCompletedOnboarding();
      _isSkipped = await _repository.hasSkippedOnboarding();

      // Load saved progress if onboarding is not completed
      if (!_isCompleted && !_isSkipped) {
        _currentPageIndex = await _repository.getCurrentProgress();
      }

      // Create page controller
      _pageController = PageController(initialPage: _currentPageIndex);

      // Initialize animation coordinator
      await _animationCoordinator.initialize();

      _isLoading = false;
      notifyListeners();

      // Record analytics event
      await _repository.recordAnalyticsEvent(OnboardingAnalyticsEvent(
        eventType: OnboardingAnalyticsEvent.pageView,
        pageId: currentPage?.id ?? 'unknown',
        timestamp: DateTime.now(),
      ));

    } catch (error) {
      _errorMessage = error.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Navigate to the next page
  /// 
  /// Advances to the next page in the onboarding flow with appropriate
  /// animations and state updates.
  Future<void> nextPage() async {
    if (isLastPage || _pageController == null) {
      await completeOnboarding();
      return;
    }

    try {
      _isAnimating = true;
      notifyListeners();

      // Record analytics event
      await _repository.recordAnalyticsEvent(OnboardingAnalyticsEvent(
        eventType: OnboardingAnalyticsEvent.pageExit,
        pageId: currentPage?.id ?? 'unknown',
        timestamp: DateTime.now(),
      ));

      // Start exit animation for current page
      await _animationCoordinator.playExitAnimation();

      // Navigate to next page
      _currentPageIndex++;
      await _pageController!.nextPage(
        duration: currentPage?.animationConfig.pageTransitionDuration ?? 
                  const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Save progress
      await _repository.saveProgress(_currentPageIndex);

      // Start entrance animation for new page
      _currentPageAnimationComplete = false;
      await _animationCoordinator.playEntranceAnimation(currentPage!);
      _currentPageAnimationComplete = true;

      // Record analytics event
      await _repository.recordAnalyticsEvent(OnboardingAnalyticsEvent(
        eventType: OnboardingAnalyticsEvent.pageView,
        pageId: currentPage?.id ?? 'unknown',
        timestamp: DateTime.now(),
      ));

      _isAnimating = false;
      notifyListeners();

    } catch (error) {
      _errorMessage = error.toString();
      _isAnimating = false;
      notifyListeners();
    }
  }

  /// Navigate to the previous page
  /// 
  /// Goes back to the previous page in the onboarding flow.
  Future<void> previousPage() async {
    if (isFirstPage || _pageController == null) {
      return;
    }

    try {
      _isAnimating = true;
      notifyListeners();

      // Start exit animation for current page
      await _animationCoordinator.playExitAnimation();

      // Navigate to previous page
      _currentPageIndex--;
      await _pageController!.previousPage(
        duration: currentPage?.animationConfig.pageTransitionDuration ?? 
                  const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Save progress
      await _repository.saveProgress(_currentPageIndex);

      // Start entrance animation for new page
      _currentPageAnimationComplete = false;
      await _animationCoordinator.playEntranceAnimation(currentPage!);
      _currentPageAnimationComplete = true;

      _isAnimating = false;
      notifyListeners();

    } catch (error) {
      _errorMessage = error.toString();
      _isAnimating = false;
      notifyListeners();
    }
  }

  /// Navigate to a specific page by index
  /// 
  /// Jumps directly to the specified page with appropriate animations.
  Future<void> goToPage(int pageIndex) async {
    if (pageIndex < 0 || pageIndex >= totalPages || _pageController == null) {
      return;
    }

    if (pageIndex == _currentPageIndex) {
      return;
    }

    try {
      _isAnimating = true;
      notifyListeners();

      // Start exit animation for current page
      await _animationCoordinator.playExitAnimation();

      // Navigate to target page
      _currentPageIndex = pageIndex;
      await _pageController!.animateToPage(
        pageIndex,
        duration: currentPage?.animationConfig.pageTransitionDuration ?? 
                  const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Save progress
      await _repository.saveProgress(_currentPageIndex);

      // Start entrance animation for new page
      _currentPageAnimationComplete = false;
      await _animationCoordinator.playEntranceAnimation(currentPage!);
      _currentPageAnimationComplete = true;

      // Record analytics event
      await _repository.recordAnalyticsEvent(OnboardingAnalyticsEvent(
        eventType: OnboardingAnalyticsEvent.pageView,
        pageId: currentPage?.id ?? 'unknown',
        timestamp: DateTime.now(),
      ));

      _isAnimating = false;
      notifyListeners();

    } catch (error) {
      _errorMessage = error.toString();
      _isAnimating = false;
      notifyListeners();
    }
  }

  /// Skip the onboarding flow
  /// 
  /// Marks onboarding as skipped and navigates to the main app.
  Future<void> skipOnboarding() async {
    try {
      _isAnimating = true;
      notifyListeners();

      // Record analytics event
      await _repository.recordAnalyticsEvent(OnboardingAnalyticsEvent(
        eventType: OnboardingAnalyticsEvent.skip,
        pageId: currentPage?.id ?? 'unknown',
        timestamp: DateTime.now(),
      ));

      // Mark as skipped
      await _repository.markOnboardingSkipped();
      _isSkipped = true;

      _isAnimating = false;
      notifyListeners();

    } catch (error) {
      _errorMessage = error.toString();
      _isAnimating = false;
      notifyListeners();
    }
  }

  /// Complete the onboarding flow
  /// 
  /// Marks onboarding as completed and navigates to the main app.
  Future<void> completeOnboarding() async {
    try {
      _isAnimating = true;
      notifyListeners();

      // Record analytics event
      await _repository.recordAnalyticsEvent(OnboardingAnalyticsEvent(
        eventType: OnboardingAnalyticsEvent.complete,
        pageId: currentPage?.id ?? 'unknown',
        timestamp: DateTime.now(),
      ));

      // Mark as completed
      await _repository.markOnboardingCompleted();
      _isCompleted = true;

      _isAnimating = false;
      notifyListeners();

    } catch (error) {
      _errorMessage = error.toString();
      _isAnimating = false;
      notifyListeners();
    }
  }

  /// Update user preferences
  /// 
  /// Saves updated user preferences and applies them to the current session.
  Future<void> updatePreferences(OnboardingPreferences preferences) async {
    try {
      await _repository.saveUserPreferences(preferences);
      _userPreferences = preferences;
      
      // Update animation coordinator with new preferences
      _animationCoordinator.updatePreferences(preferences);
      
      notifyListeners();

    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  /// Reset onboarding progress
  /// 
  /// Clears all saved progress and restarts the onboarding flow.
  Future<void> resetOnboarding() async {
    try {
      await _repository.resetOnboardingProgress();
      
      _currentPageIndex = 0;
      _isCompleted = false;
      _isSkipped = false;
      _currentPageAnimationComplete = false;
      
      // Reset page controller
      _pageController?.dispose();
      _pageController = PageController(initialPage: 0);
      
      notifyListeners();

    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  /// Clear any error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Set page animation completion status
  /// 
  /// Called when page entrance animations complete.
  void setPageAnimationComplete(bool complete) {
    if (_currentPageAnimationComplete != complete) {
      _currentPageAnimationComplete = complete;
      notifyListeners();
    }
  }

  /// Handle page change from PageView
  /// 
  /// Called when the user manually swipes between pages.
  void onPageChanged(int pageIndex) {
    if (pageIndex != _currentPageIndex) {
      _currentPageIndex = pageIndex;
      _currentPageAnimationComplete = false;
      
      // Save progress
      _repository.saveProgress(pageIndex);
      
      // Record analytics event
      _repository.recordAnalyticsEvent(OnboardingAnalyticsEvent(
        eventType: OnboardingAnalyticsEvent.pageView,
        pageId: currentPage?.id ?? 'unknown',
        timestamp: DateTime.now(),
      ));
      
      notifyListeners();
      
      // Start entrance animation for the new page
      if (currentPage != null) {
        _animationCoordinator.playEntranceAnimation(currentPage!).then((_) {
          setPageAnimationComplete(true);
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _animationCoordinator.dispose();
    super.dispose();
  }
}