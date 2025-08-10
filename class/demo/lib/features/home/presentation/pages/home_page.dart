import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/providers/auth_provider.dart';

/// Enhanced Dashboard/Home Page
/// 
/// Demonstrates:
/// - Dashboard UI patterns with stats cards
/// - Material 3 design components
/// - Responsive layout design
/// - Activity feed patterns
/// - State management integration
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context, theme, user?.fullName ?? 'Student'),
            
            const SizedBox(height: AppConstants.largeSpacing),
            
            // Stats Cards
            _buildStatsSection(context, theme),
            
            const SizedBox(height: AppConstants.largeSpacing * 2),
            
            // Recent Activities
            _buildActivitiesSection(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, ThemeData theme, String userName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, $userName! 👋',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Continue your Flutter learning journey',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacing),
        
        // First Row of Stats
        Row(
          children: [
            Expanded(
              child: _buildStatsCard(
                context,
                'Lessons\nCompleted',
                '15',
                Icons.book,
                Colors.blue,
              ),
            ),
            const SizedBox(width: AppConstants.spacing),
            Expanded(
              child: _buildStatsCard(
                context,
                'Current\nStreak',
                '7 days',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppConstants.spacing),
        
        // Second Row of Stats
        Row(
          children: [
            Expanded(
              child: _buildStatsCard(
                context,
                'Total\nPoints',
                '1,250',
                Icons.star,
                Colors.amber,
              ),
            ),
            const SizedBox(width: AppConstants.spacing),
            Expanded(
              child: _buildStatsCard(
                context,
                'Groups\nJoined',
                '3',
                Icons.groups,
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacing),
        
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _sampleActivities.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final activity = _sampleActivities[index];
            return _buildActivityItem(
              context,
              activity['title']!,
              activity['subtitle']!,
              activity['icon'] as IconData,
              activity['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityItem(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Handle navigation to specific activity
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigating to: $title')),
          );
        },
      ),
    );
  }

  static final List<Map<String, dynamic>> _sampleActivities = [
    {
      'title': 'Completed Quiz: Dart Fundamentals',
      'subtitle': 'Score: 85% • 2 hours ago',
      'icon': Icons.quiz,
      'color': Colors.blue,
    },
    {
      'title': 'Joined Group: Flutter Beginners',
      'subtitle': '25 members • 1 day ago',
      'icon': Icons.groups,
      'color': Colors.green,
    },
    {
      'title': 'Finished Lesson: State Management',
      'subtitle': 'Provider Pattern • 2 days ago',
      'icon': Icons.book,
      'color': Colors.purple,
    },
    {
      'title': 'Started Chat: Help with Layouts',
      'subtitle': '3 new messages • 3 days ago',
      'icon': Icons.chat,
      'color': Colors.orange,
    },
  ];
}
