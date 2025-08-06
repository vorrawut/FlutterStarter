import 'package:flutter/material.dart';

enum ProjectComplexity { simple, moderate, complex, enterprise }
enum TeamExperience { beginner, intermediate, advanced, expert }
enum StateScope { local, shared, global, multiApp }
enum PerformanceRequirement { standard, optimized, critical }

class PatternSelectorWidget extends StatefulWidget {
  const PatternSelectorWidget({super.key});

  @override
  State<PatternSelectorWidget> createState() => _PatternSelectorWidgetState();
}

class _PatternSelectorWidgetState extends State<PatternSelectorWidget> {
  ProjectComplexity _complexity = ProjectComplexity.moderate;
  TeamExperience _experience = TeamExperience.intermediate;
  StateScope _scope = StateScope.shared;
  PerformanceRequirement _performance = PerformanceRequirement.standard;
  bool _needsTesting = true;
  bool _needsScalability = false;
  bool _hasAsyncOperations = false;
  bool _requiresTypesSafety = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Pattern Selector'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildQuestionnaire(),
            const SizedBox(height: 24),
            _buildRecommendation(),
            const SizedBox(height: 24),
            _buildComparisonChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Assessment',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Answer the following questions to get a personalized state management pattern recommendation.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionnaire() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assessment Questions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildDropdownQuestion(
              'Project Complexity',
              _complexity,
              ProjectComplexity.values,
              (value) => setState(() => _complexity = value!),
              (complexity) => complexity.name.toUpperCase(),
            ),
            
            _buildDropdownQuestion(
              'Team Experience',
              _experience,
              TeamExperience.values,
              (value) => setState(() => _experience = value!),
              (experience) => experience.name.toUpperCase(),
            ),
            
            _buildDropdownQuestion(
              'State Scope',
              _scope,
              StateScope.values,
              (value) => setState(() => _scope = value!),
              (scope) => scope.name.toUpperCase(),
            ),
            
            _buildDropdownQuestion(
              'Performance Requirements',
              _performance,
              PerformanceRequirement.values,
              (value) => setState(() => _performance = value!),
              (performance) => performance.name.toUpperCase(),
            ),
            
            _buildSwitchQuestion(
              'Testing Required',
              'Does your project require comprehensive testing?',
              _needsTesting,
              (value) => setState(() => _needsTesting = value),
            ),
            
            _buildSwitchQuestion(
              'Future Scalability',
              'Will the app scale to enterprise level?',
              _needsScalability,
              (value) => setState(() => _needsScalability = value),
            ),
            
            _buildSwitchQuestion(
              'Async Operations',
              'Does your app have complex async operations?',
              _hasAsyncOperations,
              (value) => setState(() => _hasAsyncOperations = value),
            ),
            
            _buildSwitchQuestion(
              'Type Safety',
              'Is compile-time type safety important?',
              _requiresTypesSafety,
              (value) => setState(() => _requiresTypesSafety = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownQuestion<T>(
    String title,
    T value,
    List<T> options,
    Function(T?) onChanged,
    String Function(T) formatter,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<T>(
            value: value,
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(formatter(option)),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchQuestion(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SwitchListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(description),
        value: value,
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildRecommendation() {
    final recommendation = _calculateRecommendation();
    
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recommendation',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Recommended Pattern: ${recommendation['pattern']}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recommendation['reasoning'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            if (recommendation['alternatives'] != null) ...[
              const SizedBox(height: 12),
              Text(
                'Alternative Options:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                recommendation['alternatives'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pattern Comparison Matrix',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
    final criteria = [
      'Learning Curve',
      'Performance',
      'Testability',
      'Scalability',
      'Type Safety',
      'Async Support',
    ];

    final patterns = ['setState', 'Provider', 'Riverpod', 'Bloc'];
    
    // Scoring matrix (1-5 scale)
    final scores = {
      'setState': [5, 5, 2, 1, 3, 2],
      'Provider': [4, 4, 4, 3, 3, 3],
      'Riverpod': [3, 4, 5, 4, 5, 5],
      'Bloc': [2, 3, 5, 5, 4, 4],
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          const DataColumn(label: Text('Criteria')),
          ...patterns.map((pattern) => DataColumn(label: Text(pattern))),
        ],
        rows: List.generate(criteria.length, (index) {
          return DataRow(
            cells: [
              DataCell(Text(criteria[index])),
              ...patterns.map((pattern) {
                final score = scores[pattern]![index];
                return DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < score ? Icons.star : Icons.star_border,
                          size: 16,
                          color: starIndex < score ? Colors.amber : Colors.grey,
                        );
                      }),
                    ],
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  Map<String, String> _calculateRecommendation() {
    int setStateScore = 0;
    int providerScore = 0;
    int riverpodScore = 0;
    int blocScore = 0;

    // Complexity scoring
    switch (_complexity) {
      case ProjectComplexity.simple:
        setStateScore += 3;
        providerScore += 2;
        riverpodScore += 1;
        blocScore += 0;
        break;
      case ProjectComplexity.moderate:
        setStateScore += 1;
        providerScore += 3;
        riverpodScore += 2;
        blocScore += 1;
        break;
      case ProjectComplexity.complex:
        setStateScore += 0;
        providerScore += 1;
        riverpodScore += 3;
        blocScore += 2;
        break;
      case ProjectComplexity.enterprise:
        setStateScore += 0;
        providerScore += 0;
        riverpodScore += 2;
        blocScore += 3;
        break;
    }

    // Team experience scoring
    switch (_experience) {
      case TeamExperience.beginner:
        setStateScore += 3;
        providerScore += 2;
        riverpodScore += 1;
        blocScore += 0;
        break;
      case TeamExperience.intermediate:
        setStateScore += 2;
        providerScore += 3;
        riverpodScore += 2;
        blocScore += 1;
        break;
      case TeamExperience.advanced:
        setStateScore += 1;
        providerScore += 2;
        riverpodScore += 3;
        blocScore += 2;
        break;
      case TeamExperience.expert:
        setStateScore += 0;
        providerScore += 1;
        riverpodScore += 3;
        blocScore += 3;
        break;
    }

    // State scope scoring
    switch (_scope) {
      case StateScope.local:
        setStateScore += 3;
        providerScore += 1;
        riverpodScore += 1;
        blocScore += 0;
        break;
      case StateScope.shared:
        setStateScore += 0;
        providerScore += 3;
        riverpodScore += 2;
        blocScore += 1;
        break;
      case StateScope.global:
        setStateScore += 0;
        providerScore += 1;
        riverpodScore += 3;
        blocScore += 2;
        break;
      case StateScope.multiApp:
        setStateScore += 0;
        providerScore += 0;
        riverpodScore += 2;
        blocScore += 3;
        break;
    }

    // Additional criteria
    if (_needsTesting) {
      riverpodScore += 2;
      blocScore += 2;
      providerScore += 1;
    }

    if (_needsScalability) {
      riverpodScore += 2;
      blocScore += 2;
    }

    if (_hasAsyncOperations) {
      riverpodScore += 2;
      blocScore += 2;
      providerScore += 1;
    }

    if (_requiresTypesSafety) {
      riverpodScore += 3;
      blocScore += 1;
    }

    // Find the highest score
    final scores = {
      'setState': setStateScore,
      'Provider': providerScore,
      'Riverpod': riverpodScore,
      'Bloc': blocScore,
    };

    final maxScore = scores.values.reduce((a, b) => a > b ? a : b);
    final recommendedPattern = scores.entries
        .firstWhere((entry) => entry.value == maxScore)
        .key;

    final alternatives = scores.entries
        .where((entry) => entry.value >= maxScore - 1 && entry.key != recommendedPattern)
        .map((entry) => entry.key)
        .join(', ');

    return {
      'pattern': recommendedPattern,
      'reasoning': _getReasoningForPattern(recommendedPattern),
      'alternatives': alternatives.isNotEmpty ? alternatives : null,
    };
  }

  String _getReasoningForPattern(String pattern) {
    switch (pattern) {
      case 'setState':
        return 'setState is ideal for your project due to its simplicity and direct approach. Perfect for local state management with minimal complexity.';
      case 'Provider':
        return 'Provider is recommended for its balance of simplicity and power. Great for shared state with moderate complexity and good team adoption.';
      case 'Riverpod':
        return 'Riverpod 2.0 is ideal for your needs, offering type safety, excellent async support, and superior testing capabilities while maintaining good performance.';
      case 'Bloc':
        return 'Bloc pattern is recommended for complex enterprise applications requiring strict business logic separation and comprehensive testing strategies.';
      default:
        return 'Based on your requirements, this pattern offers the best balance of features and complexity.';
    }
  }
}