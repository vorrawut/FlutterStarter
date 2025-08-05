/// Dashboard screen showcasing responsive design patterns
/// 
/// This screen demonstrates adaptive layouts with dashboard cards,
/// metrics, charts, and responsive grid systems that work beautifully
/// across mobile, tablet, and desktop devices.
library;

import 'package:flutter/material.dart';
import '../../core/responsive/responsive_builder.dart';
import '../../core/responsive/adaptive_widgets.dart';
import '../../core/responsive/screen_size.dart';
import '../widgets/dashboard_widgets.dart';

/// Main dashboard screen with responsive layout
/// 
/// Features adaptive layouts that change based on screen size:
/// - Mobile: Single column with stacked cards
/// - Tablet: Two-column grid with larger cards
/// - Desktop: Multi-column layout with complex arrangements
class DashboardScreen extends StatelessWidget {
  /// Creates a dashboard screen
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                ScreenSize.of(context).getPadding(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dashboard header
                  _buildHeader(context, deviceType),
                  const ResponsiveSpacing(baseSpacing: 24.0),
                  
                  // Metrics cards section
                  _buildMetricsSection(context, deviceType),
                  const ResponsiveSpacing(baseSpacing: 32.0),
                  
                  // Charts and analytics section
                  _buildChartsSection(context, deviceType),
                  const ResponsiveSpacing(baseSpacing: 32.0),
                  
                  // Recent activity section
                  _buildActivitySection(context, deviceType),
                  const ResponsiveSpacing(baseSpacing: 32.0),
                  
                  // Quick actions section
                  _buildQuickActionsSection(context, deviceType),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build responsive dashboard header
  Widget _buildHeader(BuildContext context, DeviceType deviceType) {
    return ResponsiveWidget(
      mobile: _buildMobileHeader(context),
      tablet: _buildTabletHeader(context),
      desktop: _buildDesktopHeader(context),
    );
  }

  /// Mobile header layout
  Widget _buildMobileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'Dashboard',
          baseFontSize: 28,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ResponsiveText(
          'Welcome back! Here\'s your overview.',
          baseFontSize: 16,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  /// Tablet header layout
  Widget _buildTabletHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                'Dashboard',
                baseFontSize: 32,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ResponsiveText(
                'Welcome back! Here\'s your comprehensive overview.',
                baseFontSize: 18,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        AdaptiveButton(
          onPressed: () {},
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh, size: 20),
              SizedBox(width: 8),
              Text('Refresh'),
            ],
          ),
        ),
      ],
    );
  }

  /// Desktop header layout
  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                'Executive Dashboard',
                baseFontSize: 36,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ResponsiveText(
                'Real-time analytics and insights for data-driven decisions.',
                baseFontSize: 20,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Row(
          children: [
            AdaptiveButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download, size: 20),
                  SizedBox(width: 8),
                  Text('Export'),
                ],
              ),
            ),
            const SizedBox(width: 16),
            AdaptiveButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, size: 20),
                  SizedBox(width: 8),
                  Text('Refresh'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build responsive metrics section
  Widget _buildMetricsSection(BuildContext context, DeviceType deviceType) {
    final metrics = [
      MetricData(
        title: 'Total Users',
        value: '12,847',
        change: '+12.5%',
        isPositive: true,
        icon: Icons.people,
        color: Colors.blue,
      ),
      MetricData(
        title: 'Revenue',
        value: '\$54,329',
        change: '+8.2%',
        isPositive: true,
        icon: Icons.monetization_on,
        color: Colors.green,
      ),
      MetricData(
        title: 'Conversion Rate',
        value: '3.24%',
        change: '-2.1%',
        isPositive: false,
        icon: Icons.trending_up,
        color: Colors.orange,
      ),
      MetricData(
        title: 'Active Sessions',
        value: '1,429',
        change: '+18.7%',
        isPositive: true,
        icon: Icons.computer,
        color: Colors.purple,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'Key Metrics',
          baseFontSize: 24,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const ResponsiveSpacing(baseSpacing: 16.0),
        ResponsiveGrid(
          spacing: ScreenSize.of(context).getPadding(16.0),
          runSpacing: ScreenSize.of(context).getPadding(16.0),
          childAspectRatio: deviceType == DeviceType.mobile ? 1.5 : 1.8,
          children: metrics.map((metric) => MetricCard(metric: metric)).toList(),
        ),
      ],
    );
  }

  /// Build responsive charts section
  Widget _buildChartsSection(BuildContext context, DeviceType deviceType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'Analytics',
          baseFontSize: 24,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const ResponsiveSpacing(baseSpacing: 16.0),
        ResponsiveWidget(
          mobile: Column(
            children: [
              const ChartCard(
                title: 'Revenue Trend',
                chartType: ChartType.line,
              ),
              const ResponsiveSpacing(baseSpacing: 16.0),
              const ChartCard(
                title: 'User Distribution',
                chartType: ChartType.pie,
              ),
            ],
          ),
          tablet: Row(
            children: [
              const Expanded(
                child: ChartCard(
                  title: 'Revenue Trend',
                  chartType: ChartType.line,
                ),
              ),
              SizedBox(width: ScreenSize.of(context).getPadding(16.0)),
              const Expanded(
                child: ChartCard(
                  title: 'User Distribution',
                  chartType: ChartType.pie,
                ),
              ),
            ],
          ),
          desktop: Row(
            children: [
              const Expanded(
                flex: 2,
                child: ChartCard(
                  title: 'Revenue Trend',
                  chartType: ChartType.line,
                ),
              ),
              SizedBox(width: ScreenSize.of(context).getPadding(16.0)),
              const Expanded(
                child: ChartCard(
                  title: 'User Distribution',
                  chartType: ChartType.pie,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build responsive activity section
  Widget _buildActivitySection(BuildContext context, DeviceType deviceType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'Recent Activity',
          baseFontSize: 24,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const ResponsiveSpacing(baseSpacing: 16.0),
        const ActivityCard(),
      ],
    );
  }

  /// Build responsive quick actions section
  Widget _buildQuickActionsSection(BuildContext context, DeviceType deviceType) {
    final actions = [
      QuickActionData(
        title: 'Add User',
        subtitle: 'Create new account',
        icon: Icons.person_add,
        color: Colors.blue,
        onTap: () {},
      ),
      QuickActionData(
        title: 'Generate Report',
        subtitle: 'Export analytics',
        icon: Icons.assessment,
        color: Colors.green,
        onTap: () {},
      ),
      QuickActionData(
        title: 'Settings',
        subtitle: 'Configure system',
        icon: Icons.settings,
        color: Colors.orange,
        onTap: () {},
      ),
      QuickActionData(
        title: 'Support',
        subtitle: 'Get help',
        icon: Icons.help,
        color: Colors.purple,
        onTap: () {},
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'Quick Actions',
          baseFontSize: 24,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const ResponsiveSpacing(baseSpacing: 16.0),
        ResponsiveGrid(
          spacing: ScreenSize.of(context).getPadding(16.0),
          runSpacing: ScreenSize.of(context).getPadding(16.0),
          mobileColumns: 2,
          tabletColumns: 4,
          desktopColumns: 4,
          childAspectRatio: 1.2,
          children: actions.map((action) => QuickActionCard(action: action)).toList(),
        ),
      ],
    );
  }
}