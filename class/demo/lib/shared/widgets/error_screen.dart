import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';

/// Error Screen Widget
///
/// Demonstrates:
/// - Error handling UI patterns (Lesson 24: Error Handling)
/// - User-friendly error presentation
/// - Recovery actions and retry mechanisms
/// - Accessibility considerations
/// - Professional error screen design
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.error,
    this.onRetry,
    this.title,
    this.description,
    this.showDetails = false,
    this.stackTrace,
  });

  final String error;
  final VoidCallback? onRetry;
  final String? title;
  final String? description;
  final bool showDetails;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largeSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              _buildErrorIcon(theme),

              const SizedBox(height: AppConstants.largeSpacing),

              // Error Title
              Text(
                title ?? 'Oops! Something went wrong',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.spacing),

              // Error Description
              Text(
                description ??
                    'We encountered an unexpected error. Please try again.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.largeSpacing),

              // Error Details (Expandable)
              if (showDetails) _buildErrorDetails(theme),

              // Action Buttons
              _buildActionButtons(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon(ThemeData theme) {
    return TweenAnimationBuilder<double>(
      duration: AppConstants.mediumAnimation,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.bounceOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.error.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: theme.colorScheme.error,
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorDetails(ThemeData theme) {
    return Column(
      children: [
        ExpansionTile(
          title: Text(
            'Error Details',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: Icon(
            Icons.info_outline,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.spacing),
              margin:
                  const EdgeInsets.symmetric(horizontal: AppConstants.spacing),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(
                  color: theme.colorScheme.outline..withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Error Message
                  Text(
                    'Error Message:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallSpacing),
                  SelectableText(
                    error,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),

                  // Stack Trace (if available)
                  if (stackTrace != null) ...[
                    const SizedBox(height: AppConstants.spacing),
                    Text(
                      'Stack Trace:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: AppConstants.smallSpacing),
                    SelectableText(
                      stackTrace.toString(),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],

                  // Copy Button
                  const SizedBox(height: AppConstants.spacing),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () => _copyErrorToClipboard(),
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy Error'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacing),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Retry Button
        if (onRetry != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

        const SizedBox(height: AppConstants.spacing),

        // Report Issue Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _reportIssue(context),
            icon: const Icon(Icons.bug_report),
            label: const Text('Report Issue'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),

        const SizedBox(height: AppConstants.smallSpacing),

        // Go Back Button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Go Back'),
        ),
      ],
    );
  }

  void _copyErrorToClipboard() {
    final errorText = [
      'Error: $error',
      if (stackTrace != null) 'Stack Trace:\n$stackTrace',
    ].join('\n\n');

    Clipboard.setData(ClipboardData(text: errorText));
  }

  void _reportIssue(BuildContext context) {
    // In a real app, this would open a bug reporting system
    // For demo purposes, show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Issue'),
        content: const Text(
          'This would normally open your bug reporting system or email client to report the issue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Network Error Screen
///
/// Demonstrates:
/// - Specific error types handling
/// - Network connectivity awareness
/// - Specialized recovery actions
class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({
    super.key,
    this.onRetry,
  });

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      error: 'Network connection failed',
      title: 'No Internet Connection',
      description: 'Please check your internet connection and try again.',
      onRetry: onRetry,
    );
  }
}

/// Not Found Error Screen
///
/// Demonstrates:
/// - 404-style error handling
/// - Navigation error recovery
/// - User-friendly messaging
class NotFoundErrorScreen extends StatelessWidget {
  const NotFoundErrorScreen({
    super.key,
    this.resourceName,
  });

  final String? resourceName;

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      error: 'Resource not found',
      title: 'Page Not Found',
      description: resourceName != null
          ? 'The $resourceName you\'re looking for doesn\'t exist.'
          : 'The page you\'re looking for doesn\'t exist.',
    );
  }
}

/// Permission Error Screen
///
/// Demonstrates:
/// - Permission-specific error handling
/// - System settings guidance
/// - User education about permissions
class PermissionErrorScreen extends StatelessWidget {
  const PermissionErrorScreen({
    super.key,
    required this.permissionName,
    this.onOpenSettings,
  });

  final String permissionName;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largeSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppConstants.largeSpacing),
              Text(
                'Permission Required',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacing),
              Text(
                'This app needs $permissionName permission to function properly.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.largeSpacing),
              if (onOpenSettings != null)
                ElevatedButton.icon(
                  onPressed: onOpenSettings,
                  icon: const Icon(Icons.settings),
                  label: const Text('Open Settings'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
