/// Dashboard controller for state management
/// 
/// This controller manages the dashboard state including navigation,
/// data refreshing, and responsive layout state transitions.
library;

import 'package:flutter/material.dart';
import '../../core/responsive/breakpoints.dart';

/// Dashboard controller managing responsive dashboard state
/// 
/// Handles navigation state, data loading, and responsive
/// layout transitions with appropriate state management.
class DashboardController extends ChangeNotifier {
  /// Creates a dashboard controller
  DashboardController();

  // Navigation state
  int _selectedNavigationIndex = 0;
  
  // Data loading state
  bool _isLoading = false;
  bool _isRefreshing = false;
  
  // Error state
  String? _errorMessage;
  
  // Last refresh time
  DateTime? _lastRefresh;
  
  // Current device type for responsive behavior
  DeviceType? _currentDeviceType;

  /// Currently selected navigation index
  int get selectedNavigationIndex => _selectedNavigationIndex;

  /// Whether data is currently loading
  bool get isLoading => _isLoading;

  /// Whether data is currently refreshing
  bool get isRefreshing => _isRefreshing;

  /// Current error message (null if no error)
  String? get errorMessage => _errorMessage;

  /// Last data refresh time
  DateTime? get lastRefresh => _lastRefresh;

  /// Current device type
  DeviceType? get currentDeviceType => _currentDeviceType;

  /// Whether there's an active error
  bool get hasError => _errorMessage != null;

  /// Whether data is fresh (refreshed within last 5 minutes)
  bool get isDataFresh {
    if (_lastRefresh == null) return false;
    return DateTime.now().difference(_lastRefresh!).inMinutes < 5;
  }

  /// Select a navigation destination
  /// 
  /// Updates the selected navigation index and notifies listeners.
  /// Automatically handles any device-specific navigation behavior.
  void selectNavigationDestination(int index) {
    if (_selectedNavigationIndex != index) {
      _selectedNavigationIndex = index;
      notifyListeners();
      
      // Clear any errors when navigating
      _clearError();
    }
  }

  /// Update current device type
  /// 
  /// Called when the device type changes due to screen resize
  /// or orientation change. Handles responsive state transitions.
  void updateDeviceType(DeviceType deviceType) {
    if (_currentDeviceType != deviceType) {
      final previousDeviceType = _currentDeviceType;
      _currentDeviceType = deviceType;
      
      // Handle device type transition
      _handleDeviceTypeTransition(previousDeviceType, deviceType);
      
      notifyListeners();
    }
  }

  /// Refresh dashboard data
  /// 
  /// Simulates data refresh with loading states and error handling.
  /// In a real app, this would fetch data from APIs or databases.
  Future<void> refreshData() async {
    if (_isRefreshing) return; // Prevent multiple simultaneous refreshes
    
    _isRefreshing = true;
    _clearError();
    notifyListeners();
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate occasional errors (10% chance)
      if (DateTime.now().millisecond % 10 == 0) {
        throw Exception('Network error: Unable to refresh data');
      }
      
      _lastRefresh = DateTime.now();
      
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Load initial dashboard data
  /// 
  /// Called when the dashboard is first loaded. Shows loading state
  /// during initial data fetch.
  Future<void> loadInitialData() async {
    if (_isLoading) return; // Prevent multiple loads
    
    _isLoading = true;
    _clearError();
    notifyListeners();
    
    try {
      // Simulate initial data loading
      await Future.delayed(const Duration(seconds: 1));
      
      _lastRefresh = DateTime.now();
      
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear current error
  /// 
  /// Removes any existing error message and notifies listeners.
  void clearError() {
    _clearError();
    notifyListeners();
  }

  /// Get appropriate grid column count for current device
  /// 
  /// Returns optimal column count based on current device type
  /// and available space considerations.
  int getGridColumnCount() {
    if (_currentDeviceType == null) return 2;
    
    switch (_currentDeviceType!) {
      case DeviceType.mobile:
        return 2;
      case DeviceType.tablet:
        return 3;
      case DeviceType.desktop:
        return 4;
    }
  }

  /// Get appropriate card aspect ratio for current device
  /// 
  /// Returns optimal aspect ratio for dashboard cards based
  /// on current device type and layout requirements.
  double getCardAspectRatio() {
    if (_currentDeviceType == null) return 1.2;
    
    switch (_currentDeviceType!) {
      case DeviceType.mobile:
        return 1.5;
      case DeviceType.tablet:
        return 1.3;
      case DeviceType.desktop:
        return 1.2;
    }
  }

  /// Get navigation destinations with responsive considerations
  /// 
  /// Returns navigation destinations with potential modifications
  /// based on current device type (e.g., different labels or icons).
  List<String> getNavigationDestinations() {
    const baseDestinations = [
      'Dashboard',
      'Analytics',
      'Reports',
      'Settings',
    ];
    
    // On mobile, we might use shorter labels
    if (_currentDeviceType == DeviceType.mobile) {
      return [
        'Home',
        'Stats',
        'Reports',
        'Settings',
      ];
    }
    
    return baseDestinations;
  }

  /// Handle responsive layout transitions
  /// 
  /// Called when device type changes to handle any necessary
  /// state transitions or layout adjustments.
  void _handleDeviceTypeTransition(
    DeviceType? previous,
    DeviceType current,
  ) {
    // Handle specific transitions
    if (previous == DeviceType.mobile && current != DeviceType.mobile) {
      // Transitioning from mobile to larger screen
      // Could expand navigation, show more content, etc.
    } else if (previous != DeviceType.mobile && current == DeviceType.mobile) {
      // Transitioning to mobile
      // Could collapse navigation, hide secondary content, etc.
    }
    
    // Force refresh of responsive elements
    // In a real app, you might want to recalculate layouts,
    // adjust grid configurations, etc.
  }

  /// Clear error message without notifying listeners
  void _clearError() {
    _errorMessage = null;
  }

  /// Reset controller state
  /// 
  /// Resets all state to initial values. Useful for testing
  /// or when reinitializing the dashboard.
  void reset() {
    _selectedNavigationIndex = 0;
    _isLoading = false;
    _isRefreshing = false;
    _errorMessage = null;
    _lastRefresh = null;
    _currentDeviceType = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up any resources
    super.dispose();
  }
}

/// Responsive dashboard state mixin
/// 
/// Provides common responsive dashboard functionality
/// to widgets that need dashboard state management.
mixin DashboardStateMixin<T extends StatefulWidget> on State<T> {
  late DashboardController _controller;
  
  /// Dashboard controller instance
  DashboardController get dashboardController => _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = DashboardController();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  /// Update controller with current device type
  void updateControllerDeviceType(DeviceType deviceType) {
    _controller.updateDeviceType(deviceType);
  }
  
  /// Refresh dashboard data
  Future<void> refreshDashboard() => _controller.refreshData();
  
  /// Load initial dashboard data
  Future<void> loadDashboard() => _controller.loadInitialData();
}