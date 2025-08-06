/// Task form widget with validation and state management
/// 
/// This file demonstrates StatefulWidget form patterns with comprehensive
/// validation, state management, and user input handling.
library;

import 'package:flutter/material.dart';
import '../../core/models/task.dart';
import '../mixins/lifecycle_mixin.dart';
import '../mixins/validation_mixin.dart';

/// Task form widget for creating and editing tasks
/// 
/// Demonstrates comprehensive form state management with validation,
/// error handling, and proper StatefulWidget lifecycle patterns.
class TaskForm extends StatefulWidget {
  /// Creates a task form widget
  const TaskForm({
    super.key,
    this.initialTask,
    required this.onSubmit,
    this.onCancel,
    this.title = 'Create Task',
    this.submitLabel = 'Create Task',
    this.cancelLabel = 'Cancel',
  });

  /// Initial task data for editing (null for creation)
  final Task? initialTask;

  /// Called when form is submitted with valid data
  final void Function(Task task) onSubmit;

  /// Called when form is cancelled
  final VoidCallback? onCancel;

  /// Form title
  final String title;

  /// Submit button label
  final String submitLabel;

  /// Cancel button label
  final String cancelLabel;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm>
    with LifecycleMixin<TaskForm>, ValidationMixin {

  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Text editing controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _estimatedHoursController;
  late TextEditingController _actualHoursController;
  late TextEditingController _dueDateController;
  late TextEditingController _newTagController;

  /// Form state
  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskStatus _selectedStatus = TaskStatus.pending;
  DateTime? _selectedDueDate;
  List<String> _selectedTags = [];
  bool _isSubmitting = false;
  String? _submitError;

  /// Focus nodes for form navigation
  late FocusNode _titleFocusNode;
  late FocusNode _descriptionFocusNode;
  late FocusNode _estimatedHoursFocusNode;
  late FocusNode _actualHoursFocusNode;
  late FocusNode _newTagFocusNode;

  @override
  String get widgetName => 'TaskForm';

  @override
  bool get enableLifecycleLogging => true;

  @override
  bool get enableSetStateMonitoring => true;

  @override
  bool get showErrorsImmediately => false;

  @override
  bool get validateOnChange => true;

  @override
  void onInitStateCallback() {
    _initializeControllers();
    _initializeFocusNodes();
    _loadInitialData();
  }

  @override
  void onDisposeCallback() {
    _disposeControllers();
    _disposeFocusNodes();
  }

  /// Initialize text editing controllers
  void _initializeControllers() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _estimatedHoursController = TextEditingController();
    _actualHoursController = TextEditingController();
    _dueDateController = TextEditingController();
    _newTagController = TextEditingController();
  }

  /// Initialize focus nodes
  void _initializeFocusNodes() {
    _titleFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _estimatedHoursFocusNode = FocusNode();
    _actualHoursFocusNode = FocusNode();
    _newTagFocusNode = FocusNode();
  }

  /// Load initial data if editing
  void _loadInitialData() {
    final task = widget.initialTask;
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _selectedPriority = task.priority;
      _selectedStatus = task.status;
      _selectedDueDate = task.dueDate;
      _selectedTags = List.from(task.tags);

      if (task.estimatedHours != null) {
        _estimatedHoursController.text = task.estimatedHours.toString();
      }

      if (task.actualHours != null) {
        _actualHoursController.text = task.actualHours.toString();
      }

      if (task.dueDate != null) {
        _dueDateController.text = _formatDateForInput(task.dueDate!);
      }
    }
  }

  /// Dispose controllers
  void _disposeControllers() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedHoursController.dispose();
    _actualHoursController.dispose();
    _dueDateController.dispose();
    _newTagController.dispose();
  }

  /// Dispose focus nodes
  void _disposeFocusNodes() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _estimatedHoursFocusNode.dispose();
    _actualHoursFocusNode.dispose();
    _newTagFocusNode.dispose();
  }

  /// Validate the entire form
  bool _validateForm() {
    // Clear previous errors
    clearAllValidation();

    final fields = {
      'title': ValidationFieldConfig(
        value: _titleController.text,
        rules: TaskValidationRules.title,
      ),
      'description': ValidationFieldConfig(
        value: _descriptionController.text,
        rules: TaskValidationRules.description,
      ),
      'estimatedHours': ValidationFieldConfig(
        value: _estimatedHoursController.text,
        rules: TaskValidationRules.estimatedHours,
      ),
      'actualHours': ValidationFieldConfig(
        value: _actualHoursController.text,
        rules: TaskValidationRules.actualHours,
      ),
      'dueDate': ValidationFieldConfig(
        value: _dueDateController.text,
        rules: TaskValidationRules.dueDate,
      ),
    };

    final isValid = validateAllFields(fields);
    
    // Additional business logic validation
    if (isValid) {
      _validateBusinessRules();
    }

    return !hasAnyErrors;
  }

  /// Validate business rules
  void _validateBusinessRules() {
    // Check if actual hours exceed estimated hours significantly
    final estimatedText = _estimatedHoursController.text;
    final actualText = _actualHoursController.text;
    
    if (estimatedText.isNotEmpty && actualText.isNotEmpty) {
      final estimated = double.tryParse(estimatedText);
      final actual = double.tryParse(actualText);
      
      if (estimated != null && actual != null && actual > estimated * 2) {
        setFieldError(
          'actualHours',
          'Actual hours are significantly higher than estimated. Please review.',
        );
      }
    }

    // Check if completed task has actual hours
    if (_selectedStatus == TaskStatus.completed && actualText.isEmpty) {
      setFieldError(
        'actualHours',
        'Completed tasks should have actual hours recorded.',
      );
    }
  }

  /// Submit the form
  Future<void> _submitForm() async {
    if (_isSubmitting) return;

    safeSetState(() {
      _isSubmitting = true;
      _submitError = null;
    }, 'Submit form - start');

    try {
      // Validate form
      if (!_validateForm()) {
        safeSetState(() {
          _isSubmitting = false;
        }, 'Submit form - validation failed');
        return;
      }

      // Create task object
      final task = _createTaskFromForm();

      // Validate the task business logic
      final validation = task.validate();
      if (!validation.isValid) {
        safeSetState(() {
          _submitError = validation.errorMessage;
          _isSubmitting = false;
        }, 'Submit form - task validation failed');
        return;
      }

      // Submit the task
      widget.onSubmit(task);

      // Don't reset isSubmitting here - let parent handle success/failure

    } catch (error) {
      safeSetState(() {
        _submitError = 'Failed to submit task: $error';
        _isSubmitting = false;
      }, 'Submit form - error');
    }
  }

  /// Create task from form data
  Task _createTaskFromForm() {
    final estimatedHours = _estimatedHoursController.text.isNotEmpty
        ? double.tryParse(_estimatedHoursController.text)
        : null;

    final actualHours = _actualHoursController.text.isNotEmpty
        ? double.tryParse(_actualHoursController.text)
        : null;

    if (widget.initialTask != null) {
      // Update existing task
      return widget.initialTask!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        status: _selectedStatus,
        dueDate: _selectedDueDate,
        tags: _selectedTags,
        estimatedHours: estimatedHours,
        actualHours: actualHours,
        completedAt: _selectedStatus == TaskStatus.completed && widget.initialTask!.completedAt == null
            ? DateTime.now()
            : widget.initialTask!.completedAt,
      );
    } else {
      // Create new task
      return Task.create(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        dueDate: _selectedDueDate,
        tags: _selectedTags,
        estimatedHours: estimatedHours,
      ).copyWith(
        status: _selectedStatus,
        actualHours: actualHours,
        completedAt: _selectedStatus == TaskStatus.completed ? DateTime.now() : null,
      );
    }
  }

  /// Handle due date selection
  Future<void> _selectDueDate() async {
    final initialDate = _selectedDueDate ?? DateTime.now().add(const Duration(days: 1));
    
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      safeSetState(() {
        _selectedDueDate = date;
        _dueDateController.text = _formatDateForInput(date);
      }, 'Select due date');
    }
  }

  /// Clear due date
  void _clearDueDate() {
    safeSetState(() {
      _selectedDueDate = null;
      _dueDateController.clear();
    }, 'Clear due date');
  }

  /// Add a new tag
  void _addTag() {
    final tagText = _newTagController.text.trim();
    if (tagText.isEmpty) return;

    // Validate tag
    final validation = validateField('newTag', tagText, TaskValidationRules.tag);
    if (!validation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validation.errorMessage!)),
      );
      return;
    }

    if (!_selectedTags.contains(tagText)) {
      safeSetState(() {
        _selectedTags.add(tagText);
        _newTagController.clear();
      }, 'Add tag: $tagText');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tag already exists')),
      );
    }
  }

  /// Remove a tag
  void _removeTag(String tag) {
    safeSetState(() {
      _selectedTags.remove(tag);
    }, 'Remove tag: $tag');
  }

  /// Format date for input display
  String _formatDateForInput(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }

  @override
  Widget buildWidget(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.onCancel != null)
            TextButton(
              onPressed: _isSubmitting ? null : widget.onCancel,
              child: Text(widget.cancelLabel),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Submit error display
              if (_submitError != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _submitError!,
                    style: TextStyle(color: theme.colorScheme.onErrorContainer),
                  ),
                ),
              ],

              // Basic Information Section
              _buildSectionHeader(theme, 'Basic Information'),
              const SizedBox(height: 16),
              
              _buildTitleField(),
              const SizedBox(height: 16),
              
              _buildDescriptionField(),
              const SizedBox(height: 24),

              // Priority and Status Section
              _buildSectionHeader(theme, 'Priority & Status'),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: _buildPrioritySelector(theme)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatusSelector(theme)),
                ],
              ),
              const SizedBox(height: 24),

              // Time Tracking Section
              _buildSectionHeader(theme, 'Time Tracking'),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: _buildEstimatedHoursField()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildActualHoursField()),
                ],
              ),
              const SizedBox(height: 24),

              // Due Date Section
              _buildSectionHeader(theme, 'Due Date'),
              const SizedBox(height: 16),
              
              _buildDueDateField(theme),
              const SizedBox(height: 24),

              // Tags Section
              _buildSectionHeader(theme, 'Tags'),
              const SizedBox(height: 16),
              
              _buildTagsSection(theme),
              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build section header
  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
    );
  }

  /// Build title field
  Widget _buildTitleField() {
    return ValidatedTextFormField(
      fieldName: 'title',
      controller: _titleController,
      focusNode: _titleFocusNode,
      decoration: const InputDecoration(
        labelText: 'Task Title *',
        hintText: 'Enter a descriptive title for your task',
        border: OutlineInputBorder(),
      ),
      validationRules: TaskValidationRules.title,
      onChanged: (value) {
        // Real-time validation feedback
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        _descriptionFocusNode.requestFocus();
      },
    );
  }

  /// Build description field
  Widget _buildDescriptionField() {
    return ValidatedTextFormField(
      fieldName: 'description',
      controller: _descriptionController,
      focusNode: _descriptionFocusNode,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Provide additional details about the task',
        border: OutlineInputBorder(),
      ),
      validationRules: TaskValidationRules.description,
      maxLines: 3,
    );
  }

  /// Build priority selector
  Widget _buildPrioritySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TaskPriority>(
          value: _selectedPriority,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: TaskPriority.values.map((priority) {
            return DropdownMenuItem(
              value: priority,
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: TaskPriority.getColor(priority),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(priority.label),
                ],
              ),
            );
          }).toList(),
          onChanged: (priority) {
            if (priority != null) {
              safeSetState(() {
                _selectedPriority = priority;
              }, 'Select priority: ${priority.label}');
            }
          },
        ),
      ],
    );
  }

  /// Build status selector
  Widget _buildStatusSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TaskStatus>(
          value: _selectedStatus,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: TaskStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status.label),
            );
          }).toList(),
          onChanged: (status) {
            if (status != null) {
              safeSetState(() {
                _selectedStatus = status;
              }, 'Select status: ${status.label}');
            }
          },
        ),
      ],
    );
  }

  /// Build estimated hours field
  Widget _buildEstimatedHoursField() {
    return ValidatedTextFormField(
      fieldName: 'estimatedHours',
      controller: _estimatedHoursController,
      focusNode: _estimatedHoursFocusNode,
      decoration: const InputDecoration(
        labelText: 'Estimated Hours',
        hintText: '0.0',
        border: OutlineInputBorder(),
        suffixText: 'hrs',
      ),
      validationRules: TaskValidationRules.estimatedHours,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  /// Build actual hours field
  Widget _buildActualHoursField() {
    return ValidatedTextFormField(
      fieldName: 'actualHours',
      controller: _actualHoursController,
      focusNode: _actualHoursFocusNode,
      decoration: const InputDecoration(
        labelText: 'Actual Hours',
        hintText: '0.0',
        border: OutlineInputBorder(),
        suffixText: 'hrs',
      ),
      validationRules: TaskValidationRules.actualHours,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  /// Build due date field
  Widget _buildDueDateField(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _dueDateController,
            decoration: const InputDecoration(
              labelText: 'Due Date',
              hintText: 'Select due date',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: _selectDueDate,
          ),
        ),
        if (_selectedDueDate != null) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: _clearDueDate,
            icon: const Icon(Icons.clear),
            tooltip: 'Clear due date',
          ),
        ],
      ],
    );
  }

  /// Build tags section
  Widget _buildTagsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add tag input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _newTagController,
                focusNode: _newTagFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Add Tag',
                  hintText: 'Enter tag name',
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _addTag,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        
        // Display current tags
        if (_selectedTags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedTags.map((tag) {
              return Chip(
                label: Text(tag),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeTag(tag),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isSubmitting ? null : widget.onCancel,
            child: Text(widget.cancelLabel),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitForm,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.submitLabel),
          ),
        ),
      ],
    );
  }
}