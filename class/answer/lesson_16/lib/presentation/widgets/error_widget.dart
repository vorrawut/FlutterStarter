import 'package:flutter/material.dart';
import '../../core/errors/api_error.dart';

class CustomErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final errorInfo = _getErrorInfo();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              errorInfo['icon'] as IconData,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              errorInfo['title'] as String,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              errorInfo['message'] as String,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getErrorInfo() {
    if (error is ApiError) {
      final apiError = error as ApiError;
      
      if (apiError is ConnectionError) {
        return {
          'icon': Icons.wifi_off,
          'title': 'Connection Error',
          'message': 'Please check your internet connection and try again.',
        };
      }
      
      if (apiError is TimeoutError) {
        return {
          'icon': Icons.timer_off,
          'title': 'Request Timeout',
          'message': 'The request took too long to complete. Please try again.',
        };
      }
      
      if (apiError is ServerError) {
        return {
          'icon': Icons.server_error,
          'title': 'Server Error',
          'message': 'Our servers are experiencing issues. Please try again later.',
        };
      }
      
      if (apiError is AuthenticationError || apiError is AuthorizationError) {
        return {
          'icon': Icons.lock,
          'title': 'Authentication Error',
          'message': 'Please check your credentials and try again.',
        };
      }
      
      if (apiError is NotFoundError) {
        return {
          'icon': Icons.search_off,
          'title': 'Not Found',
          'message': 'The requested content could not be found.',
        };
      }
      
      if (apiError is RateLimitError) {
        return {
          'icon': Icons.speed,
          'title': 'Rate Limit Exceeded',
          'message': 'Too many requests. Please wait a moment and try again.',
        };
      }
      
      return {
        'icon': Icons.error,
        'title': 'Error',
        'message': apiError.message,
      };
    }
    
    // Generic error
    return {
      'icon': Icons.error_outline,
      'title': 'Something went wrong',
      'message': 'An unexpected error occurred. Please try again.',
    };
  }
}