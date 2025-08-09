import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  final bool isRegistrationMode;
  final VoidCallback? onModeToggle;
  
  const LoginForm({
    super.key,
    this.isRegistrationMode = false,
    this.onModeToggle,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Local UI state managed with setState
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _rememberMe = false;
  bool _acceptTerms = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isFormValid = false;
  
  // Animation controllers for local UI feedback
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _pulseAnimation;
  
  // Input validation state
  String? _emailError;
  String? _passwordError;
  String? _firstNameError;
  String? _lastNameError;
  String? _confirmPasswordError;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animations for local UI feedback
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_pulseController);
    
    // Listen to text changes for real-time validation
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _firstNameController.addListener(_validateFirstName);
    _lastNameController.addListener(_validateLastName);
    _confirmPasswordController.addListener(_validateConfirmPassword);
    
    // Demo credentials for testing
    _emailController.text = 'demo@authflow.pro';
    _passwordController.text = 'demo123';
    _validateEmail();
    _validatePassword();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pulseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Real-time validation with setState
  void _validateEmail() {
    setState(() {
      final email = _emailController.text.trim();
      if (email.isEmpty) {
        _emailError = null;
        _isEmailValid = false;
      } else if (!_isValidEmail(email)) {
        _emailError = 'Please enter a valid email address';
        _isEmailValid = false;
      } else {
        _emailError = null;
        _isEmailValid = true;
      }
      _updateFormValidity();
    });
  }

  void _validatePassword() {
    setState(() {
      final password = _passwordController.text;
      if (password.isEmpty) {
        _passwordError = null;
        _isPasswordValid = false;
      } else if (password.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
        _isPasswordValid = false;
      } else {
        _passwordError = null;
        _isPasswordValid = true;
      }
      _updateFormValidity();
      
      // Re-validate confirm password if in registration mode
      if (widget.isRegistrationMode) {
        _validateConfirmPassword();
      }
    });
  }

  void _validateFirstName() {
    setState(() {
      final firstName = _firstNameController.text.trim();
      if (widget.isRegistrationMode && firstName.isEmpty) {
        _firstNameError = 'First name is required';
      } else if (firstName.isNotEmpty && firstName.length < 2) {
        _firstNameError = 'First name must be at least 2 characters';
      } else {
        _firstNameError = null;
      }
      _updateFormValidity();
    });
  }

  void _validateLastName() {
    setState(() {
      final lastName = _lastNameController.text.trim();
      if (widget.isRegistrationMode && lastName.isEmpty) {
        _lastNameError = 'Last name is required';
      } else if (lastName.isNotEmpty && lastName.length < 2) {
        _lastNameError = 'Last name must be at least 2 characters';
      } else {
        _lastNameError = null;
      }
      _updateFormValidity();
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      final confirmPassword = _confirmPasswordController.text;
      final password = _passwordController.text;
      
      if (widget.isRegistrationMode) {
        if (confirmPassword.isEmpty) {
          _confirmPasswordError = 'Please confirm your password';
        } else if (confirmPassword != password) {
          _confirmPasswordError = 'Passwords do not match';
        } else {
          _confirmPasswordError = null;
        }
      } else {
        _confirmPasswordError = null;
      }
      _updateFormValidity();
    });
  }

  void _updateFormValidity() {
    if (widget.isRegistrationMode) {
      _isFormValid = _isEmailValid &&
          _isPasswordValid &&
          _firstNameError == null &&
          _lastNameError == null &&
          _confirmPasswordError == null &&
          _firstNameController.text.trim().isNotEmpty &&
          _lastNameController.text.trim().isNotEmpty &&
          _acceptTerms;
    } else {
      _isFormValid = _isEmailValid && _isPasswordValid;
    }
  }

  // Local UI state toggles with setState
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  void _toggleAcceptTerms(bool? value) {
    setState(() {
      _acceptTerms = value ?? false;
      _updateFormValidity();
    });
  }

  // Animation triggers for user feedback
  void _triggerErrorAnimation() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  void _triggerSuccessAnimation() {
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _triggerErrorAnimation();
        } else if (state is AuthAuthenticated) {
          _triggerSuccessAnimation();
        }
      },
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: child,
          );
        },
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Registration-specific fields
              if (widget.isRegistrationMode) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        errorText: _firstNameError,
                        prefixIcon: Icons.person,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        errorText: _lastNameError,
                        prefixIcon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              
              // Email field with real-time validation
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                errorText: _emailError,
                prefixIcon: Icons.email,
                suffixIcon: _isEmailValid ? Icons.check : null,
                suffixIconColor: theme.colorScheme.primary,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              
              const SizedBox(height: 16),
              
              // Password field with visibility toggle
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                errorText: _passwordError,
                prefixIcon: Icons.lock,
                suffixIcon: _isPasswordValid ? Icons.check : null,
                suffixIconColor: theme.colorScheme.primary,
                obscureText: !_isPasswordVisible,
                textInputAction: widget.isRegistrationMode 
                    ? TextInputAction.next 
                    : TextInputAction.done,
                trailingWidget: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              
              // Confirm password for registration
              if (widget.isRegistrationMode) ...[
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  errorText: _confirmPasswordError,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: _confirmPasswordError == null && 
                             _confirmPasswordController.text.isNotEmpty ? Icons.check : null,
                  suffixIconColor: theme.colorScheme.primary,
                  obscureText: !_isConfirmPasswordVisible,
                  textInputAction: TextInputAction.done,
                  trailingWidget: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Options
              Row(
                children: [
                  if (!widget.isRegistrationMode) ...[
                    Checkbox(
                      value: _rememberMe,
                      onChanged: _toggleRememberMe,
                    ),
                    const Expanded(
                      child: Text('Remember me'),
                    ),
                  ] else ...[
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: _toggleAcceptTerms,
                    ),
                    const Expanded(
                      child: Text('I accept the Terms and Conditions'),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Submit button with loading state
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  
                  return AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: child,
                      );
                    },
                    child: ElevatedButton(
                      onPressed: _isFormValid && !isLoading ? _handleSubmit : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              widget.isRegistrationMode ? 'Create Account' : 'Sign In',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  );
                },
              ),
              
              if (!widget.isRegistrationMode) ...[
                const SizedBox(height: 16),
                
                // Forgot password
                TextButton(
                  onPressed: _handleForgotPassword,
                  child: const Text('Forgot Password?'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? errorText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Color? suffixIconColor,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    Widget? trailingWidget,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (suffixIcon != null)
              Icon(suffixIcon, color: suffixIconColor),
            if (trailingWidget != null) trailingWidget,
          ],
        ),
        border: const OutlineInputBorder(),
        filled: true,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: (_) {
        if (textInputAction == TextInputAction.done && _isFormValid) {
          _handleSubmit();
        }
      },
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.isRegistrationMode) {
        context.read<AuthBloc>().add(
          AuthRegistrationRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            rememberMe: _rememberMe,
          ),
        );
      }
    }
  }

  void _handleForgotPassword() {
    if (_emailController.text.trim().isNotEmpty) {
      context.read<AuthBloc>().add(
        AuthPasswordResetRequested(_emailController.text.trim()),
      );
    } else {
      // Show email input dialog
      _showPasswordResetDialog();
    }
  }

  void _showPasswordResetDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.trim().isNotEmpty) {
                context.read<AuthBloc>().add(
                  AuthPasswordResetRequested(emailController.text.trim()),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Send Reset Email'),
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
