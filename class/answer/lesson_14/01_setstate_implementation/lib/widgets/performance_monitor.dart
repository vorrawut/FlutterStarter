import 'package:flutter/material.dart';

class PerformanceMonitor extends StatefulWidget {
  final String pattern;
  final int todosCount;
  final int filteredCount;
  final int rebuildsCount;

  const PerformanceMonitor({
    super.key,
    required this.pattern,
    required this.todosCount,
    required this.filteredCount,
    required this.rebuildsCount,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  DateTime? _lastUpdate;
  int _updateCount = 0;

  @override
  void didUpdateWidget(PerformanceMonitor oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.todosCount != widget.todosCount ||
        oldWidget.filteredCount != widget.filteredCount) {
      setState(() {
        _lastUpdate = DateTime.now();
        _updateCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: theme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Performance Monitor - ${widget.pattern}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _buildMetric('Todos', widget.todosCount),
              _buildMetric('Filtered', widget.filteredCount),
              _buildMetric('Rebuilds', widget.rebuildsCount),
              _buildMetric('Updates', _updateCount),
            ],
          ),
          if (_lastUpdate != null) ...[
            const SizedBox(height: 4),
            Text(
              'Last Update: ${_formatTime(_lastUpdate!)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetric(String label, int value) {
    return Text(
      '$label: $value',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}