import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/storage_providers.dart';

class StorageComparisonPage extends ConsumerStatefulWidget {
  const StorageComparisonPage({super.key});

  @override
  ConsumerState<StorageComparisonPage> createState() => _StorageComparisonPageState();
}

class _StorageComparisonPageState extends ConsumerState<StorageComparisonPage> {
  @override
  Widget build(BuildContext context) {
    final hiveStats = ref.watch(hiveStatsProvider);
    final sqliteStats = ref.watch(sqliteStatsProvider);
    final currentStorage = ref.watch(currentStorageTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Comparison'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current storage indicator
            _buildCurrentStorageCard(currentStorage),
            
            const SizedBox(height: 24),
            
            // Storage selector
            _buildStorageSelector(),
            
            const SizedBox(height: 24),
            
            // Performance comparison
            _buildPerformanceComparison(hiveStats, sqliteStats),
            
            const SizedBox(height: 24),
            
            // Features comparison
            _buildFeaturesComparison(),
            
            const SizedBox(height: 24),
            
            // Storage type details
            _buildStorageDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStorageCard(String currentStorage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              currentStorage == 'hive' ? Icons.flash_on : Icons.storage,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Storage Backend',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currentStorage == 'hive' ? 'Hive (NoSQL)' : 'SQLite (SQL)',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Switch Storage Backend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _switchStorage('hive'),
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Use Hive'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _switchStorage('sqlite'),
                    icon: const Icon(Icons.storage),
                    label: const Text('Use SQLite'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '⚠️ Switching will clear all current data',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceComparison(
    AsyncValue<Map<String, dynamic>> hiveStats,
    AsyncValue<Map<String, dynamic>> sqliteStats,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Comparison',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Hive stats
            _buildStatsSection('Hive (NoSQL)', hiveStats, Colors.orange),
            
            const SizedBox(height: 16),
            
            // SQLite stats
            _buildStatsSection('SQLite (SQL)', sqliteStats, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(
    String title,
    AsyncValue<Map<String, dynamic>> stats,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        stats.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
          data: (data) => Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildStatChip('Notes', '${data['total_notes'] ?? 0}'),
              _buildStatChip('Categories', '${data['total_categories'] ?? 0}'),
              _buildStatChip('Tags', '${data['total_tags'] ?? 0}'),
              if (data['storage_type'] != null)
                _buildStatChip('Type', '${data['storage_type']}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      labelStyle: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _buildFeaturesComparison() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Features Comparison',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildComparisonTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    final features = [
      ['Feature', 'Hive', 'SQLite'],
      ['Performance', 'Excellent', 'Very Good'],
      ['Query Power', 'Basic', 'Full SQL'],
      ['Relationships', 'Manual', 'Native'],
      ['Type Safety', 'Strong', 'Good'],
      ['Storage Size', 'Compact', 'Larger'],
      ['Full-text Search', 'Manual', 'Built-in'],
      ['Transactions', 'Basic', 'Advanced'],
      ['Cross-platform', 'Yes', 'Yes'],
      ['Learning Curve', 'Easy', 'Moderate'],
    ];

    return Table(
      border: TableBorder.all(color: Theme.of(context).dividerColor),
      children: features.map((row) {
        final isHeader = row == features.first;
        return TableRow(
          decoration: isHeader
              ? BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant)
              : null,
          children: row.map((cell) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                cell,
                style: isHeader
                    ? Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                    : Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildStorageDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Storage Implementation Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildStorageDetail(
              'Hive NoSQL Database',
              'Fast, lightweight, type-safe key-value storage optimized for Flutter.',
              [
                '• Pure Dart implementation',
                '• Lazy loading with efficient memory usage',
                '• Type adapters for custom objects',
                '• Automatic encryption support',
                '• Excellent for simple to moderate data structures',
              ],
              Colors.orange,
            ),
            
            const SizedBox(height: 16),
            
            _buildStorageDetail(
              'SQLite Relational Database',
              'Full-featured SQL database with ACID compliance and complex query support.',
              [
                '• Full SQL query capabilities',
                '• Foreign key constraints and triggers',
                '• Full-text search (FTS) support',
                '• ACID transactions',
                '• Excellent for complex data relationships',
              ],
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageDetail(
    String title,
    String description,
    List<String> features,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                feature,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            )),
      ],
    );
  }

  void _switchStorage(String storageType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch Storage Backend'),
        content: Text(
          'Are you sure you want to switch to ${storageType.toUpperCase()}? '
          'This will clear all current data and cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(currentStorageTypeProvider.notifier).switchStorage(storageType);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Switched to ${storageType.toUpperCase()}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Switch'),
          ),
        ],
      ),
    );
  }
}