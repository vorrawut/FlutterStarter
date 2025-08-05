/// Dashboard widgets for responsive layouts
/// 
/// This file contains specialized dashboard components that adapt
/// their appearance and behavior based on screen size and device type.
library;

import 'package:flutter/material.dart';
import '../../core/responsive/adaptive_widgets.dart';
import '../../core/responsive/responsive_builder.dart';
import '../../core/responsive/screen_size.dart';

/// Data model for metric cards
class MetricData {
  const MetricData({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;
}

/// Responsive metric card widget
/// 
/// Displays key performance indicators with adaptive sizing
/// and visual hierarchy based on screen size.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.metric,
  });

  final MetricData metric;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        return AdaptiveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    metric.icon,
                    color: metric.color,
                    size: _getIconSize(deviceType),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _getPadding(deviceType) * 0.5,
                      vertical: _getPadding(deviceType) * 0.25,
                    ),
                    decoration: BoxDecoration(
                      color: metric.isPositive 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          metric.isPositive ? Icons.trending_up : Icons.trending_down,
                          color: metric.isPositive ? Colors.green : Colors.red,
                          size: _getSmallIconSize(deviceType),
                        ),
                        const SizedBox(width: 4),
                        ResponsiveText(
                          metric.change,
                          baseFontSize: 12,
                          style: TextStyle(
                            color: metric.isPositive ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: _getSpacing(deviceType)),
              ResponsiveText(
                metric.value,
                baseFontSize: _getValueFontSize(deviceType),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headlineMedium?.color,
                ),
              ),
              ResponsiveText(
                metric.title,
                baseFontSize: _getTitleFontSize(deviceType),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _getIconSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 24.0;
      case DeviceType.tablet:
        return 28.0;
      case DeviceType.desktop:
        return 32.0;
    }
  }

  double _getSmallIconSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 14.0;
      case DeviceType.tablet:
        return 16.0;
      case DeviceType.desktop:
        return 18.0;
    }
  }

  double _getSpacing(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 12.0;
      case DeviceType.tablet:
        return 16.0;
      case DeviceType.desktop:
        return 20.0;
    }
  }

  double _getValueFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 24.0;
      case DeviceType.tablet:
        return 28.0;
      case DeviceType.desktop:
        return 32.0;
    }
  }

  double _getTitleFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 14.0;
      case DeviceType.tablet:
        return 16.0;
      case DeviceType.desktop:
        return 18.0;
    }
  }

  double _getPadding(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 8.0;
      case DeviceType.tablet:
        return 12.0;
      case DeviceType.desktop:
        return 16.0;
    }
  }
}

/// Chart types enumeration
enum ChartType { line, bar, pie, area }

/// Responsive chart card widget
/// 
/// Displays various chart types with adaptive sizing and placeholder content
/// that scales appropriately across devices.
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.chartType,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final ChartType chartType;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        return AdaptiveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveText(
                        title,
                        baseFontSize: _getTitleFontSize(deviceType),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        ResponsiveText(
                          subtitle!,
                          baseFontSize: _getSubtitleFontSize(deviceType),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                    iconSize: _getIconSize(deviceType),
                  ),
                ],
              ),
              SizedBox(height: _getSpacing(deviceType)),
              
              // Chart placeholder
              Container(
                height: _getChartHeight(deviceType),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getChartIcon(),
                        size: _getChartIconSize(deviceType),
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 8),
                      ResponsiveText(
                        '${_getChartTypeName()} Chart',
                        baseFontSize: _getChartLabelFontSize(deviceType),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getChartIcon() {
    switch (chartType) {
      case ChartType.line:
        return Icons.show_chart;
      case ChartType.bar:
        return Icons.bar_chart;
      case ChartType.pie:
        return Icons.pie_chart;
      case ChartType.area:
        return Icons.area_chart;
    }
  }

  String _getChartTypeName() {
    switch (chartType) {
      case ChartType.line:
        return 'Line';
      case ChartType.bar:
        return 'Bar';
      case ChartType.pie:
        return 'Pie';
      case ChartType.area:
        return 'Area';
    }
  }

  double _getTitleFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 18.0;
      case DeviceType.tablet:
        return 20.0;
      case DeviceType.desktop:
        return 22.0;
    }
  }

  double _getSubtitleFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 14.0;
      case DeviceType.tablet:
        return 15.0;
      case DeviceType.desktop:
        return 16.0;
    }
  }

  double _getIconSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 20.0;
      case DeviceType.tablet:
        return 22.0;
      case DeviceType.desktop:
        return 24.0;
    }
  }

  double _getSpacing(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 16.0;
      case DeviceType.tablet:
        return 20.0;
      case DeviceType.desktop:
        return 24.0;
    }
  }

  double _getChartHeight(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 200.0;
      case DeviceType.tablet:
        return 250.0;
      case DeviceType.desktop:
        return 300.0;
    }
  }

  double _getChartIconSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 48.0;
      case DeviceType.tablet:
        return 56.0;
      case DeviceType.desktop:
        return 64.0;
    }
  }

  double _getChartLabelFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 16.0;
      case DeviceType.tablet:
        return 18.0;
      case DeviceType.desktop:
        return 20.0;
    }
  }
}

/// Activity card showing recent activities
/// 
/// Displays a list of recent activities with adaptive item sizing
/// and appropriate visual hierarchy.
class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      _ActivityItem(
        title: 'New user registration',
        subtitle: 'john.doe@email.com',
        timestamp: '2 min ago',
        icon: Icons.person_add,
        color: Colors.green,
      ),
      _ActivityItem(
        title: 'Payment processed',
        subtitle: '\$1,299.00 from ABC Corp',
        timestamp: '15 min ago',
        icon: Icons.payment,
        color: Colors.blue,
      ),
      _ActivityItem(
        title: 'System backup completed',
        subtitle: 'Database backup successful',
        timestamp: '1 hour ago',
        icon: Icons.backup,
        color: Colors.orange,
      ),
      _ActivityItem(
        title: 'New feature deployed',
        subtitle: 'Dashboard v2.1.0',
        timestamp: '3 hours ago',
        icon: Icons.rocket_launch,
        color: Colors.purple,
      ),
    ];

    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        return AdaptiveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ResponsiveText(
                    'Recent Activity',
                    baseFontSize: _getTitleFontSize(deviceType),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: ResponsiveText(
                      'View All',
                      baseFontSize: _getButtonFontSize(deviceType),
                    ),
                  ),
                ],
              ),
              SizedBox(height: _getSpacing(deviceType)),
              ...activities.map((activity) => Padding(
                padding: EdgeInsets.only(bottom: _getItemSpacing(deviceType)),
                child: _buildActivityItem(context, activity, deviceType),
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivityItem(BuildContext context, _ActivityItem activity, DeviceType deviceType) {
    return Row(
      children: [
        Container(
          width: _getAvatarSize(deviceType),
          height: _getAvatarSize(deviceType),
          decoration: BoxDecoration(
            color: activity.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(_getAvatarSize(deviceType) / 2),
          ),
          child: Icon(
            activity.icon,
            color: activity.color,
            size: _getAvatarIconSize(deviceType),
          ),
        ),
        SizedBox(width: _getItemSpacing(deviceType)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                activity.title,
                baseFontSize: _getItemTitleFontSize(deviceType),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              ResponsiveText(
                activity.subtitle,
                baseFontSize: _getItemSubtitleFontSize(deviceType),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
        ResponsiveText(
          activity.timestamp,
          baseFontSize: _getTimestampFontSize(deviceType),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  double _getTitleFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 18.0;
      case DeviceType.tablet:
        return 20.0;
      case DeviceType.desktop:
        return 22.0;
    }
  }

  double _getButtonFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 14.0;
      case DeviceType.tablet:
        return 15.0;
      case DeviceType.desktop:
        return 16.0;
    }
  }

  double _getSpacing(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 16.0;
      case DeviceType.tablet:
        return 20.0;
      case DeviceType.desktop:
        return 24.0;
    }
  }

  double _getItemSpacing(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 12.0;
      case DeviceType.tablet:
        return 14.0;
      case DeviceType.desktop:
        return 16.0;
    }
  }

  double _getAvatarSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 40.0;
      case DeviceType.tablet:
        return 44.0;
      case DeviceType.desktop:
        return 48.0;
    }
  }

  double _getAvatarIconSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 20.0;
      case DeviceType.tablet:
        return 22.0;
      case DeviceType.desktop:
        return 24.0;
    }
  }

  double _getItemTitleFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 14.0;
      case DeviceType.tablet:
        return 15.0;
      case DeviceType.desktop:
        return 16.0;
    }
  }

  double _getItemSubtitleFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 12.0;
      case DeviceType.tablet:
        return 13.0;
      case DeviceType.desktop:
        return 14.0;
    }
  }

  double _getTimestampFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 11.0;
      case DeviceType.tablet:
        return 12.0;
      case DeviceType.desktop:
        return 13.0;
    }
  }
}

/// Activity item data model
class _ActivityItem {
  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String timestamp;
  final IconData icon;
  final Color color;
}

/// Quick action data model
class QuickActionData {
  const QuickActionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

/// Quick action card widget
/// 
/// Displays actionable items with adaptive sizing and touch targets
/// appropriate for each device type.
class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.action,
  });

  final QuickActionData action;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        return AdaptiveCard(
          onTap: action.onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: _getIconContainerSize(deviceType),
                height: _getIconContainerSize(deviceType),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(_getIconContainerSize(deviceType) / 2),
                ),
                child: Icon(
                  action.icon,
                  color: action.color,
                  size: _getIconSize(deviceType),
                ),
              ),
              SizedBox(height: _getSpacing(deviceType)),
              ResponsiveText(
                action.title,
                baseFontSize: _getTitleFontSize(deviceType),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              ResponsiveText(
                action.subtitle,
                baseFontSize: _getSubtitleFontSize(deviceType),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  double _getIconContainerSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 48.0;
      case DeviceType.tablet:
        return 56.0;
      case DeviceType.desktop:
        return 64.0;
    }
  }

  double _getIconSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 24.0;
      case DeviceType.tablet:
        return 28.0;
      case DeviceType.desktop:
        return 32.0;
    }
  }

  double _getSpacing(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 12.0;
      case DeviceType.tablet:
        return 14.0;
      case DeviceType.desktop:
        return 16.0;
    }
  }

  double _getTitleFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 14.0;
      case DeviceType.tablet:
        return 15.0;
      case DeviceType.desktop:
        return 16.0;
    }
  }

  double _getSubtitleFontSize(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 11.0;
      case DeviceType.tablet:
        return 12.0;
      case DeviceType.desktop:
        return 13.0;
    }
  }
}