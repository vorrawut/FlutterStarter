/// Validation mixin for form input validation
/// 
/// This file provides reusable validation patterns and error handling
/// for form inputs and user data validation.
library;

import 'package:flutter/material.dart';

/// Validation result data class
@immutable
class ValidationResult {
  /// Creates a validation result
  const ValidationResult({
    required this.isValid,
    this.errorMessage,
  });

  /// Whether the validation passed
  final bool isValid;

  /// Error message if validation failed
  final String? errorMessage;

  /// Create a successful validation result
  factory ValidationResult.success() {
    return const ValidationResult(isValid: true);
  }

  /// Create a failed validation result
  factory ValidationResult.error(String message) {
    return ValidationResult(isValid: false, errorMessage: message);
  }

  @override
  String toString() {
    return 'ValidationResult(isValid: $isValid, error: $errorMessage)';
  }
}

/// Validation rule function type
typedef ValidationRule = ValidationResult Function(String value);

/// Mixin for input validation patterns
/// 
/// Provides reusable validation rules and form validation patterns
/// for consistent user input validation across the application.
mixin ValidationMixin {
  
  /// Map to store field validation states
  final Map<String, ValidationResult> _validationStates = {};

  /// Map to store field error messages
  final Map<String, String?> _fieldErrors = {};

  /// Whether validation should show errors immediately
  bool get showErrorsImmediately => false;

  /// Whether to validate on every change
  bool get validateOnChange => true;

  /// Get validation state for a field
  ValidationResult getValidationState(String fieldName) {
    return _validationStates[fieldName] ?? ValidationResult.success();
  }

  /// Get error message for a field
  String? getFieldError(String fieldName) {
    return _fieldErrors[fieldName];
  }

  /// Check if a field has errors
  bool hasFieldError(String fieldName) {
    return _fieldErrors[fieldName] != null;
  }

  /// Check if any field has errors
  bool get hasAnyErrors => _fieldErrors.values.any((error) => error != null);

  /// Get all field errors
  Map<String, String> get allErrors {
    return Map.fromEntries(
      _fieldErrors.entries.where((entry) => entry.value != null)
          .map((entry) => MapEntry(entry.key, entry.value!)),
    );
  }

  /// Validate a field with given rules
  ValidationResult validateField(String fieldName, String value, List<ValidationRule> rules) {
    for (final rule in rules) {
      final result = rule(value);
      if (!result.isValid) {
        _validationStates[fieldName] = result;
        _fieldErrors[fieldName] = result.errorMessage;
        return result;
      }
    }

    // All rules passed
    final successResult = ValidationResult.success();
    _validationStates[fieldName] = successResult;
    _fieldErrors[fieldName] = null;
    return successResult;
  }

  /// Validate multiple fields
  Map<String, ValidationResult> validateFields(Map<String, ValidationFieldConfig> fields) {
    final results = <String, ValidationResult>{};

    for (final entry in fields.entries) {
      final fieldName = entry.key;
      final config = entry.value;
      results[fieldName] = validateField(fieldName, config.value, config.rules);
    }

    return results;
  }

  /// Check if all fields are valid
  bool validateAllFields(Map<String, ValidationFieldConfig> fields) {
    final results = validateFields(fields);
    return results.values.every((result) => result.isValid);
  }

  /// Clear validation state for a field
  void clearFieldValidation(String fieldName) {
    _validationStates.remove(fieldName);
    _fieldErrors.remove(fieldName);
  }

  /// Clear all validation states
  void clearAllValidation() {
    _validationStates.clear();
    _fieldErrors.clear();
  }

  /// Set custom error for a field
  void setFieldError(String fieldName, String error) {
    _validationStates[fieldName] = ValidationResult.error(error);
    _fieldErrors[fieldName] = error;
  }

  /// Clear error for a field
  void clearFieldError(String fieldName) {
    _validationStates[fieldName] = ValidationResult.success();
    _fieldErrors[fieldName] = null;
  }

  // Common validation rules

  /// Required field validation
  static ValidationRule required([String? message]) {
    return (String value) {
      if (value.trim().isEmpty) {
        return ValidationResult.error(message ?? 'This field is required');
      }
      return ValidationResult.success();
    };
  }

  /// Minimum length validation
  static ValidationRule minLength(int length, [String? message]) {
    return (String value) {
      if (value.length < length) {
        return ValidationResult.error(
          message ?? 'Must be at least $length characters long',
        );
      }
      return ValidationResult.success();
    };
  }

  /// Maximum length validation
  static ValidationRule maxLength(int length, [String? message]) {
    return (String value) {
      if (value.length > length) {
        return ValidationResult.error(
          message ?? 'Must be no more than $length characters long',
        );
      }
      return ValidationResult.success();
    };
  }

  /// Email validation
  static ValidationRule email([String? message]) {
    return (String value) {
      if (value.isEmpty) return ValidationResult.success();
      
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return ValidationResult.error(message ?? 'Please enter a valid email address');
      }
      return ValidationResult.success();
    };
  }

  /// Phone number validation
  static ValidationRule phoneNumber([String? message]) {
    return (String value) {
      if (value.isEmpty) return ValidationResult.success();
      
      // Remove common phone number formatting
      final cleanNumber = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
      
      if (cleanNumber.length < 10 || cleanNumber.length > 15) {
        return ValidationResult.error(message ?? 'Please enter a valid phone number');
      }
      
      if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) {
        return ValidationResult.error(message ?? 'Phone number can only contain digits');
      }
      
      return ValidationResult.success();
    };
  }

  /// URL validation
  static ValidationRule url([String? message]) {
    return (String value) {
      if (value.isEmpty) return ValidationResult.success();
      
      try {
        final uri = Uri.parse(value);
        if (!uri.hasScheme || (!uri.scheme.startsWith('http') && !uri.scheme.startsWith('https'))) {
          return ValidationResult.error(message ?? 'Please enter a valid URL');
        }
      } catch (e) {
        return ValidationResult.error(message ?? 'Please enter a valid URL');
      }
      
      return ValidationResult.success();
    };
  }

  /// Numeric validation
  static ValidationRule numeric([String? message]) {
    return (String value) {
      if (value.isEmpty) return ValidationResult.success();
      
      if (double.tryParse(value) == null) {
        return ValidationResult.error(message ?? 'Please enter a valid number');
      }
      return ValidationResult.success();
    };
  }

  /// Integer validation
  static ValidationRule integer([String? message]) {
    return (String value) {
      if (value.isEmpty) return ValidationResult.success();
      
      if (int.tryParse(value) == null) {
        return ValidationResult.error(message ?? 'Please enter a valid integer');
      }
      return ValidationResult.success();
    };
  }

  /// Positive number validation
  static ValidationRule positiveNumber([String? message]) {
    return (String value) {
      if (value.isEmpty) return ValidationResult.success();
      
      final number = double.tryParse(value);
      if (number == null || number <= 0) {
        return ValidationResult.error(message ?? 'Please enter a positive number');
      }
      return ValidationResult.success();
    };
  }

  /// Date validation (ISO format)
  static ValidationRule date([String? message]) {
    return (String value) {
      if (value.isEmpty) return ValidationResult.success();
      
      try {
        DateTime.parse(value);
      } catch (e) {
        return ValidationResult.error(message ?? 'Please enter a valid date');
      }
      
      return ValidationResult.success();
    };
  }

  /// Future date validation
  static ValidationRule futureDate([String? message]) {
    return (String value) {
      if (value.isEmpty) return ValidationResult.success();
      
      try {
        final date = DateTime.parse(value);
        if (date.isBefore(DateTime.now())) {
          return ValidationResult.error(message ?? 'Date must be in the future');
        }
      } catch (e) {
        return ValidationResult.error(message ?? 'Please enter a valid date');
      }
      
      return ValidationResult.success();
    };
  }

  /// Past date validation
  static ValidationRule pastDate([String? message]) {
    return (String value) {
      if (value.isEmpty) return ValidationResult.success();
      
      try {
        final date = DateTime.parse(value);
        if (date.isAfter(DateTime.now())) {
          return ValidationResult.error(message ?? 'Date must be in the past');
        }
      } catch (e) {
        return ValidationResult.error(message ?? 'Please enter a valid date');
      }
      
      return ValidationResult.success();
    };
  }

  /// Custom pattern validation
  static ValidationRule pattern(RegExp pattern, [String? message]) {
    return (String value) {
      if (value.isEmpty) return ValidationResult.success();
      
      if (!pattern.hasMatch(value)) {
        return ValidationResult.error(message ?? 'Please enter a valid value');
      }
      return ValidationResult.success();
    };
  }

  /// Match field validation (for password confirmation)
  static ValidationRule matchesField(String otherValue, [String? message]) {
    return (String value) {
      if (value != otherValue) {
        return ValidationResult.error(message ?? 'Values do not match');
      }
      return ValidationResult.success();
    };
  }

  /// One of values validation
  static ValidationRule oneOf(List<String> validValues, [String? message]) {
    return (String value) {
      if (value.isEmpty) return ValidationResult.success();
      
      if (!validValues.contains(value)) {
        return ValidationResult.error(
          message ?? 'Please select one of: ${validValues.join(', ')}',
        );
      }
      return ValidationResult.success();
    };
  }

  /// Custom validation rule
  static ValidationRule custom(bool Function(String) validator, String errorMessage) {
    return (String value) {
      if (validator(value)) {
        return ValidationResult.success();
      }
      return ValidationResult.error(errorMessage);
    };
  }

  /// Combine multiple validation rules
  static ValidationRule combine(List<ValidationRule> rules) {
    return (String value) {
      for (final rule in rules) {
        final result = rule(value);
        if (!result.isValid) {
          return result;
        }
      }
      return ValidationResult.success();
    };
  }
}

/// Configuration for field validation
@immutable
class ValidationFieldConfig {
  /// Creates a validation field configuration
  const ValidationFieldConfig({
    required this.value,
    required this.rules,
    this.validateOnChange = true,
  });

  /// Current field value
  final String value;

  /// Validation rules to apply
  final List<ValidationRule> rules;

  /// Whether to validate on every change
  final bool validateOnChange;
}

/// Enhanced text form field with built-in validation
class ValidatedTextFormField extends StatefulWidget {
  /// Creates a validated text form field
  const ValidatedTextFormField({
    super.key,
    required this.fieldName,
    required this.validationRules,
    this.controller,
    this.decoration,
    this.onChanged,
    this.onValidationChanged,
    this.validateOnChange = true,
    this.showErrorsImmediately = false,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.enabled = true,
  });

  /// Unique field name for validation tracking
  final String fieldName;

  /// Validation rules to apply
  final List<ValidationRule> validationRules;

  /// Text editing controller
  final TextEditingController? controller;

  /// Input decoration
  final InputDecoration? decoration;

  /// Called when text changes
  final void Function(String)? onChanged;

  /// Called when validation state changes
  final void Function(String fieldName, ValidationResult result)? onValidationChanged;

  /// Whether to validate on every change
  final bool validateOnChange;

  /// Whether to show errors immediately
  final bool showErrorsImmediately;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Whether to obscure text (for passwords)
  final bool obscureText;

  /// Maximum number of lines
  final int? maxLines;

  /// Whether the field is enabled
  final bool enabled;

  @override
  State<ValidatedTextFormField> createState() => _ValidatedTextFormFieldState();
}

class _ValidatedTextFormFieldState extends State<ValidatedTextFormField> with ValidationMixin {
  late TextEditingController _controller;
  ValidationResult _validationResult = ValidationResult.success();
  bool _hasBeenTouched = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    
    // Initial validation if there's already text
    if (_controller.text.isNotEmpty) {
      _validateField(_controller.text);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _validateField(String value) {
    final result = validateField(widget.fieldName, value, widget.validationRules);
    
    setState(() {
      _validationResult = result;
    });

    widget.onValidationChanged?.call(widget.fieldName, result);
  }

  void _onChanged(String value) {
    if (widget.validateOnChange) {
      _validateField(value);
    }
    
    if (!_hasBeenTouched) {
      setState(() {
        _hasBeenTouched = true;
      });
    }

    widget.onChanged?.call(value);
  }

  void _onFocusLost() {
    if (!widget.validateOnChange && _hasBeenTouched) {
      _validateField(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowError = (widget.showErrorsImmediately || _hasBeenTouched) && 
                           !_validationResult.isValid;

    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          _onFocusLost();
        }
      },
      child: TextFormField(
        controller: _controller,
        decoration: (widget.decoration ?? const InputDecoration()).copyWith(
          errorText: shouldShowError ? _validationResult.errorMessage : null,
          errorMaxLines: 2,
        ),
        onChanged: _onChanged,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        enabled: widget.enabled,
        validator: (value) {
          final result = validateField(widget.fieldName, value ?? '', widget.validationRules);
          return result.isValid ? null : result.errorMessage;
        },
      ),
    );
  }
}

/// Task-specific validation rules
class TaskValidationRules {
  /// Private constructor
  const TaskValidationRules._();

  /// Task title validation
  static List<ValidationRule> get title => [
    ValidationMixin.required('Task title is required'),
    ValidationMixin.minLength(3, 'Title must be at least 3 characters'),
    ValidationMixin.maxLength(100, 'Title must be less than 100 characters'),
  ];

  /// Task description validation
  static List<ValidationRule> get description => [
    ValidationMixin.maxLength(500, 'Description must be less than 500 characters'),
  ];

  /// Estimated hours validation
  static List<ValidationRule> get estimatedHours => [
    ValidationMixin.positiveNumber('Estimated hours must be a positive number'),
    ValidationMixin.custom(
      (value) => value.isEmpty || (double.tryParse(value) ?? 0) <= 1000,
      'Estimated hours cannot exceed 1000',
    ),
  ];

  /// Actual hours validation
  static List<ValidationRule> get actualHours => [
    ValidationMixin.positiveNumber('Actual hours must be a positive number'),
    ValidationMixin.custom(
      (value) => value.isEmpty || (double.tryParse(value) ?? 0) <= 1000,
      'Actual hours cannot exceed 1000',
    ),
  ];

  /// Due date validation
  static List<ValidationRule> get dueDate => [
    ValidationMixin.date('Please enter a valid date'),
    ValidationMixin.futureDate('Due date must be in the future'),
  ];

  /// Tag validation
  static List<ValidationRule> get tag => [
    ValidationMixin.minLength(2, 'Tag must be at least 2 characters'),
    ValidationMixin.maxLength(20, 'Tag must be less than 20 characters'),
    ValidationMixin.pattern(
      RegExp(r'^[a-zA-Z0-9_-]+$'),
      'Tag can only contain letters, numbers, hyphens, and underscores',
    ),
  ];
}