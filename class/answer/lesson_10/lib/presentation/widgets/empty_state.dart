/// Empty state widget with animations and interactions
/// 
/// This file demonstrates StatefulWidget patterns for empty state displays
/// with subtle animations and user interaction handling.
library;

import 'package:flutter/material.dart';
import '../mixins/lifecycle_mixin.dart';

/// Empty state widget with animated feedback
/// 
/// Displays when no data is available with encouraging animations
/// and clear call-to-action buttons.
class EmptyState extends StatefulWidget {
  /// Creates an empty state widget
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.illustration,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.animateOnAppear = true,
  });

  /// Main title for the empty state
  final String title;

  /// Descriptive message
  final String message;

  /// Icon to display (if no illustration provided)
  final IconData? icon;

  /// Custom illustration widget
  final Widget? illustration;

  /// Primary action button label
  final String? actionLabel;

  /// Primary action callback
  final VoidCallback? onAction;

  /// Secondary action button label
  final String? secondaryActionLabel;

  /// Secondary action callback
  final VoidCallback? onSecondaryAction;

  /// Whether to animate on appearance
  final bool animateOnAppear;

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState>
    with TickerProviderStateMixin, LifecycleMixin<EmptyState> {

  /// Animation controllers
  late AnimationController _appearController;
  late AnimationController _floatController;
  late AnimationController _buttonController;

  /// Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _buttonScaleAnimation;

  /// UI state
  bool _isActionPressed = false;
  bool _isSecondaryActionPressed = false;

  @override
  String get widgetName => 'EmptyState';

  @override
  bool get enableLifecycleLogging => false; // Keep it simple for empty state

  @override
  void onInitStateCallback() {
    _initializeAnimations();
    if (widget.animateOnAppear) {
      _startAppearAnimation();
    }
  }

  @override
  void onDisposeCallback() {
    _appearController.dispose();
    _floatController.dispose();
    _buttonController.dispose();
  }

  /// Initialize animations
  void _initializeAnimations() {
    // Main appearance animation
    _appearController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _appearController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _appearController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _appearController,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));

    // Subtle floating animation for icon/illustration
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _floatAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    // Button press animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));
  }

  /// Start the appearance animation
  void _startAppearAnimation() {
    _appearController.forward().then((_) {
      // Start the floating animation after appearance
      if (mounted) {
        _floatController.repeat(reverse: true);
      }
    });
  }

  /// Handle primary action press
  void _handleActionPress() {
    setStateWithMonitoring(() {
      _isActionPressed = true;
    }, 'Primary action pressed');

    _buttonController.forward().then((_) {
      _buttonController.reverse().then((_) {
        if (mounted) {
          safeSetState(() {
            _isActionPressed = false;
          }, 'Primary action released');
          widget.onAction?.call();
        }
      });
    });
  }

  /// Handle secondary action press
  void _handleSecondaryActionPress() {
    setStateWithMonitoring(() {
      _isSecondaryActionPressed = true;
    }, 'Secondary action pressed');

    // Simple state feedback without animation
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        safeSetState(() {
          _isSecondaryActionPressed = false;
        }, 'Secondary action released');
        widget.onSecondaryAction?.call();
      }
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    final theme = Theme.of(context);
    
    if (!widget.animateOnAppear) {
      return _buildContent(theme);
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _fadeAnimation,
        _slideAnimation,
        _scaleAnimation,
        _floatAnimation,
        _buttonScaleAnimation,
      ]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildContent(theme),
            ),
          ),
        );
      },
    );
  }

  /// Build the main content
  Widget _buildContent(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon or illustration
            _buildIllustration(theme),
            
            const SizedBox(height: 24),
            
            // Title
            _buildTitle(theme),
            
            const SizedBox(height: 12),
            
            // Message
            _buildMessage(theme),
            
            const SizedBox(height: 32),
            
            // Action buttons
            _buildActionButtons(theme),
          ],
        ),
      ),
    );
  }

  /// Build illustration (icon or custom widget)
  Widget _buildIllustration(ThemeData theme) {
    Widget illustrationWidget;
    
    if (widget.illustration != null) {
      illustrationWidget = widget.illustration!;
    } else if (widget.icon != null) {
      illustrationWidget = Icon(
        widget.icon!,
        size: 80,
        color: theme.colorScheme.outline.withOpacity(0.5),
      );
    } else {
      // Default empty state icon
      illustrationWidget = Icon(
        Icons.inbox_outlined,
        size: 80,
        color: theme.colorScheme.outline.withOpacity(0.5),
      );
    }

    // Apply floating animation if enabled
    if (widget.animateOnAppear && _floatController.isAnimating) {
      return AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: illustrationWidget,
          );
        },
      );
    }

    return illustrationWidget;
  }

  /// Build title
  Widget _buildTitle(ThemeData theme) {
    return Text(
      widget.title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Build message
  Widget _buildMessage(ThemeData theme) {
    return Text(
      widget.message,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.7),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(ThemeData theme) {
    final hasActions = widget.actionLabel != null || widget.secondaryActionLabel != null;
    
    if (!hasActions) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Primary action button
        if (widget.actionLabel != null && widget.onAction != null)
          AnimatedBuilder(
            animation: _buttonScaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isActionPressed ? _buttonScaleAnimation.value : 1.0,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.onAction != null ? _handleActionPress : null,
                    icon: const Icon(Icons.add, size: 20),
                    label: Text(widget.actionLabel!),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        
        // Secondary action button
        if (widget.secondaryActionLabel != null && widget.onSecondaryAction != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onSecondaryAction != null ? _handleSecondaryActionPress : null,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: _isSecondaryActionPressed 
                    ? theme.colorScheme.outline.withOpacity(0.1)
                    : null,
              ),
              child: Text(widget.secondaryActionLabel!),
            ),
          ),
        ],
      ],
    );
  }
}

/// Predefined empty state configurations
class EmptyStateConfigs {
  /// Private constructor
  const EmptyStateConfigs._();

  /// No tasks available
  static const EmptyState noTasks = EmptyState(
    title: 'No tasks yet',
    message: 'Create your first task to get started with organizing your work.',
    icon: Icons.checklist_outlined,
    actionLabel: 'Create Task',
    secondaryActionLabel: 'Learn More',
  );

  /// No filtered results
  static const EmptyState noFilteredTasks = EmptyState(
    title: 'No matching tasks',
    message: 'Try adjusting your filters or search criteria to find the tasks you\'re looking for.',
    icon: Icons.search_off,
    actionLabel: 'Clear Filters',
    secondaryActionLabel: 'Create Task',
  );

  /// No completed tasks
  static const EmptyState noCompletedTasks = EmptyState(
    title: 'No completed tasks',
    message: 'Complete some tasks to see them here and track your progress.',
    icon: Icons.task_alt,
    actionLabel: 'View All Tasks',
  );

  /// Loading state
  static const EmptyState loading = EmptyState(
    title: 'Loading tasks...',
    message: 'Please wait while we fetch your tasks.',
    icon: Icons.hourglass_empty,
    animateOnAppear: false,
  );

  /// Error state
  static const EmptyState error = EmptyState(
    title: 'Something went wrong',
    message: 'We couldn\'t load your tasks. Please check your connection and try again.',
    icon: Icons.error_outline,
    actionLabel: 'Retry',
    secondaryActionLabel: 'Refresh',
  );

  /// Offline state
  static const EmptyState offline = EmptyState(
    title: 'You\'re offline',
    message: 'Please check your internet connection to sync your tasks.',
    icon: Icons.wifi_off,
    actionLabel: 'Retry Connection',
  );
}

/// Helper widget for creating custom empty states
class CustomEmptyState extends StatelessWidget {
  /// Creates a custom empty state
  const CustomEmptyState({
    super.key,
    required this.config,
    this.onAction,
    this.onSecondaryAction,
  });

  /// Empty state configuration
  final EmptyState config;

  /// Primary action callback
  final VoidCallback? onAction;

  /// Secondary action callback
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: config.title,
      message: config.message,
      icon: config.icon,
      illustration: config.illustration,
      actionLabel: config.actionLabel,
      onAction: onAction ?? config.onAction,
      secondaryActionLabel: config.secondaryActionLabel,
      onSecondaryAction: onSecondaryAction ?? config.onSecondaryAction,
      animateOnAppear: config.animateOnAppear,
    );
  }
}