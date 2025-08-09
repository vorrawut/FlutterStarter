import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/demo_user.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/router/app_router.dart';

/// Enhanced Login Page with Demo Features
///
/// Demonstrates:
/// - Authentication UI patterns with bypass functionality
/// - Beautiful animations and micro-interactions
/// - Form validation and error handling
/// - Responsive design implementation
/// - State management integration with Riverpod
/// - Material 3 design components
class EnhancedLoginPage extends ConsumerStatefulWidget {
  const EnhancedLoginPage({
    super.key,
    this.redirectPath,
  });

  final String? redirectPath;

  @override
  ConsumerState<EnhancedLoginPage> createState() => _EnhancedLoginPageState();
}

class _EnhancedLoginPageState extends ConsumerState<EnhancedLoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _showDemoOptions = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  Future<void> _handleDemoLogin(UserRole role) async {
    await ref.read(authProvider.notifier).loginDemo(role);
  }

  void _navigateToSignup() {
    context.push('/auth/signup');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(isLoadingProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        final destination = widget.redirectPath ?? AppRoutes.home;
        context.go(destination);
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.secondary.withValues(alpha: 0.05),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 60),
                        
                        // App Logo/Title
                        _buildHeader(theme),
                        
                        const SizedBox(height: 60),
                        
                        // Login Form
                        _buildLoginForm(theme, isLoading),
                        
                        const SizedBox(height: 32),
                        
                        // Demo Login Section
                        _buildDemoSection(theme, isLoading),
                        
                        const SizedBox(height: 32),
                        
                        // Sign up link
                        _buildSignupLink(theme),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.flutter_dash,
            size: 50,
            color: theme.colorScheme.onPrimary,
          ),
        )
            .animate(delay: 300.ms)
            .scale(begin: const Offset(0.8, 0.8))
            .fadeIn(),
        
        const SizedBox(height: 24),
        
        Text(
          'Welcome Back!',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        )
            .animate(delay: 500.ms)
            .fadeIn()
            .slideY(begin: 20),
        
        const SizedBox(height: 8),
        
        Text(
          'Sign in to continue your Flutter journey',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        )
            .animate(delay: 700.ms)
            .fadeIn()
            .slideY(begin: 20),
      ],
    );
  }

  Widget _buildLoginForm(ThemeData theme, bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          )
              .animate(delay: 900.ms)
              .fadeIn()
              .slideX(begin: -20),
          
          const SizedBox(height: 20),
          
          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          )
              .animate(delay: 1100.ms)
              .fadeIn()
              .slideX(begin: 20),
          
          const SizedBox(height: 32),
          
          // Login Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          )
              .animate(delay: 1300.ms)
              .fadeIn()
              .slideY(begin: 20),
          
          const SizedBox(height: 16),
          
          // Forgot Password
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Forgot password feature not implemented in demo'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
              .animate(delay: 1500.ms)
              .fadeIn(),
        ],
      ),
    );
  }

  Widget _buildDemoSection(ThemeData theme, bool isLoading) {
    return Column(
      children: [
        // Divider with "OR"
        Row(
          children: [
            Expanded(child: Divider(color: theme.dividerColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: theme.dividerColor)),
          ],
        )
            .animate(delay: 1700.ms)
            .fadeIn(),
        
        const SizedBox(height: 24),
        
        // Demo Login Toggle
        TextButton.icon(
          onPressed: isLoading
              ? null
              : () {
                  setState(() {
                    _showDemoOptions = !_showDemoOptions;
                  });
                },
          icon: Icon(
            _showDemoOptions ? Icons.expand_less : Icons.expand_more,
          ),
          label: const Text('Demo Login Options'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        )
            .animate(delay: 1900.ms)
            .fadeIn()
            .scale(),
        
        // Demo Login Buttons
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _showDemoOptions ? null : 0,
          child: _showDemoOptions
              ? Column(
                  children: [
                    const SizedBox(height: 16),
                    ...UserRole.values.map(
                      (role) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildDemoLoginButton(theme, role, isLoading),
                      ),
                    ),
                  ],
                )
              : null,
        ),
      ],
    );
  }

  Widget _buildDemoLoginButton(ThemeData theme, UserRole role, bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : () => _handleDemoLogin(role),
        icon: Icon(role.icon, color: role.color),
        label: Text('Login as ${role.displayName}'),
        style: OutlinedButton.styleFrom(
          foregroundColor: role.color,
          side: BorderSide(color: role.color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 2100 + (UserRole.values.indexOf(role) * 200)))
        .fadeIn()
        .slideX(begin: -20);
  }

  Widget _buildSignupLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        TextButton(
          onPressed: _navigateToSignup,
          child: Text(
            'Create Account',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    )
        .animate(delay: 2500.ms)
        .fadeIn()
        .slideY(begin: 20);
  }
}
