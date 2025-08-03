import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/spacing.dart';

/// Layout analysis bottom sheet for educational purposes
class LayoutAnalysisSheet extends StatefulWidget {
  const LayoutAnalysisSheet({super.key});

  @override
  State<LayoutAnalysisSheet> createState() => _LayoutAnalysisSheetState();
}

class _LayoutAnalysisSheetState extends State<LayoutAnalysisSheet> {
  int _selectedAnalysisType = 0;

  final List<AnalysisType> _analysisTypes = [
    AnalysisType(
      title: 'Clean Architecture',
      icon: Icons.architecture,
      description: 'How this app demonstrates clean architecture principles',
      examples: [
        'Separation of concerns across layers',
        'Domain entities independent of frameworks',
        'Repository pattern for data abstraction',
        'Use cases encapsulate business logic',
        'Dependency inversion with interfaces',
      ],
    ),
    AnalysisType(
      title: 'Constraints',
      icon: Icons.crop_free,
      description: 'How widgets determine their size and position in Flutter',
      examples: [
        'BoxConstraints flow down from parent to child',
        'Children report their size back to parent',
        'Parent assigns final position to children',
        'Tight constraints force exact sizes',
        'Loose constraints allow flexible sizing',
      ],
    ),
    AnalysisType(
      title: 'Responsive Design',
      icon: Icons.devices,
      description: 'Adapting layouts to different screen sizes and orientations',
      examples: [
        'MediaQuery provides screen dimensions',
        'LayoutBuilder gives parent constraints',
        'Breakpoint systems for device categories',
        'Flexible layouts adapt to available space',
        'Responsive utilities simplify adaptation',
      ],
    ),
    AnalysisType(
      title: 'Performance',
      icon: Icons.speed,
      description: 'Optimizing layout performance for smooth experiences',
      examples: [
        'const constructors prevent rebuilds',
        'Widget extraction reduces rebuild scope',
        'Provider pattern for state management',
        'ListView.builder for efficient lists',
        'Proper animation disposal',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusXl),
            ),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(),
              _buildAnalysisTypeSelector(),
              Expanded(
                child: _buildContent(scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.spaceMd),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Architecture Analysis',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          Spacing.verticalSm,
          Text(
            'Deep dive into clean architecture and Flutter layout concepts',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTypeSelector() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spaceXl),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _analysisTypes.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedAnalysisType;
          final analysisType = _analysisTypes[index];

          return GestureDetector(
            onTap: () => setState(() => _selectedAnalysisType = index),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: AppConstants.spaceMd),
              padding: const EdgeInsets.all(AppConstants.spaceMd),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    analysisType.icon,
                    color: isSelected ? Colors.white : Colors.grey[600],
                    size: 28,
                  ),
                  Spacing.verticalXs,
                  Text(
                    analysisType.title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(ScrollController scrollController) {
    final selectedType = _analysisTypes[_selectedAnalysisType];

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(AppConstants.spaceXl),
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.spaceXl),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    selectedType.icon,
                    color: Colors.blue[700],
                    size: 32,
                  ),
                  Spacing.horizontalMd,
                  Expanded(
                    child: Text(
                      selectedType.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.verticalMd,
              Text(
                selectedType.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[800],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        Spacing.vertical2xl,
        const Text(
          'Key Concepts:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Spacing.verticalLg,
        ...selectedType.examples.map((example) => Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spaceMd),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(
                      top: AppConstants.spaceMd,
                      right: AppConstants.spaceMd,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      example,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        if (_selectedAnalysisType == 0) _buildArchitectureDiagram(),
      ],
    );
  }

  Widget _buildArchitectureDiagram() {
    return Container(
      margin: const EdgeInsets.only(top: AppConstants.space2xl),
      padding: const EdgeInsets.all(AppConstants.spaceXl),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏗️ Clean Architecture Layers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.green[900],
            ),
          ),
          Spacing.verticalLg,
          _buildArchitectureLayer(
            'Presentation Layer',
            'UI, Widgets, Controllers',
            Colors.blue,
          ),
          _buildArchitectureLayer(
            'Domain Layer',
            'Entities, Use Cases, Repository Interfaces',
            Colors.green,
          ),
          _buildArchitectureLayer(
            'Data Layer',
            'Repository Implementations, Data Sources, Models',
            Colors.orange,
          ),
          _buildArchitectureLayer(
            'Core Layer',
            'Theme, Constants, Utilities',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildArchitectureLayer(String title, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spaceMd),
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.9),
            ),
          ),
          Spacing.verticalXs,
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Analysis type data class
class AnalysisType {
  final String title;
  final IconData icon;
  final String description;
  final List<String> examples;

  const AnalysisType({
    required this.title,
    required this.icon,
    required this.description,
    required this.examples,
  });
}