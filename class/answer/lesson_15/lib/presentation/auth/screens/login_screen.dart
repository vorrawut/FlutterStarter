import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bloc/auth_bloc.dart';
import '../widgets/login_form.dart';
import '../../theme/providers/theme_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> 
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _showRegistration = false;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _showRegistration = !_showRegistration;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeSettings = ref.watch(themeSettingsProvider).valueOrNull;
    
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    
                    // App Logo and Title
                    _buildHeader(theme),
                    
                    const SizedBox(height: 60),
                    
                    // Login/Register Form
                    Card(
                      elevation: themeSettings?.reduceAnimations == true ? 2 : 8,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildModeToggle(theme),
                            
                            const SizedBox(height: 24),
                            
                            LoginForm(
                              isRegistrationMode: _showRegistration,
                              onModeToggle: _toggleMode,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick actions
                    _buildQuickActions(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Icon(
          Icons.security_rounded,
          size: 80,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'AuthFlow Pro',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Secure Authentication & Theme Management',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModeToggle(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: _showRegistration ? _toggleMode : null,
            child: Text(
              'Sign In',
              style: TextStyle(
                color: !_showRegistration
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: !_showRegistration 
                    ? FontWeight.bold 
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
        Container(
          width: 1,
          height: 24,
          color: theme.colorScheme.outline,
        ),
        Expanded(
          child: TextButton(
            onPressed: !_showRegistration ? _toggleMode : null,
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: _showRegistration
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: _showRegistration 
                    ? FontWeight.bold 
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () {
            context.read<AuthBloc>().add(AuthBiometricRequested());
          },
          icon: const Icon(Icons.fingerprint),
          label: const Text('Sign in with Biometrics'),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // Navigate to theme settings
                _showThemeSettings(context);
              },
              child: const Text('Theme Settings'),
            ),
            const Text(' • '),
            TextButton(
              onPressed: () {
                // Show demo credentials
                _showDemoCredentials(context);
              },
              child: const Text('Demo Credentials'),
            ),
          ],
        ),
      ],
    );
  }

  void _showThemeSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ThemeSettingsSheet(),
    );
  }

  void _showDemoCredentials(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Demo Credentials'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: demo@authflow.pro'),
            Text('Password: demo123'),
            SizedBox(height: 16),
            Text(
              'Use these credentials to test the authentication system.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ThemeSettingsSheet extends ConsumerWidget {
  const ThemeSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeSettingsProvider).valueOrNull;
    final themeNotifier = ref.read(themeSettingsProvider.notifier);
    
    if (themeSettings == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Theme Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          
          // Theme mode
          ListTile(
            title: const Text('Theme Mode'),
            trailing: DropdownButton<ThemeMode>(
              value: themeSettings.themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  themeNotifier.updateThemeMode(mode);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                ),
              ],
            ),
          ),
          
          // Color scheme
          ListTile(
            title: const Text('Color Scheme'),
            trailing: DropdownButton<String>(
              value: themeSettings.colorScheme,
              onChanged: (scheme) {
                if (scheme != null) {
                  themeNotifier.updateColorScheme(scheme);
                }
              },
              items: const [
                DropdownMenuItem(value: 'material', child: Text('Blue')),
                DropdownMenuItem(value: 'green', child: Text('Green')),
                DropdownMenuItem(value: 'purple', child: Text('Purple')),
                DropdownMenuItem(value: 'orange', child: Text('Orange')),
                DropdownMenuItem(value: 'red', child: Text('Red')),
              ],
            ),
          ),
          
          // High contrast
          SwitchListTile(
            title: const Text('High Contrast'),
            value: themeSettings.highContrast,
            onChanged: (_) => themeNotifier.toggleHighContrast(),
          ),
          
          // Dynamic colors
          SwitchListTile(
            title: const Text('Dynamic Colors'),
            subtitle: const Text('Use system color palette'),
            value: themeSettings.dynamicColors,
            onChanged: (_) => themeNotifier.toggleDynamicColors(),
          ),
          
          // Text scale
          ListTile(
            title: const Text('Text Scale'),
            subtitle: Slider(
              value: themeSettings.textScaleFactor,
              min: 0.8,
              max: 1.4,
              divisions: 6,
              label: '${(themeSettings.textScaleFactor * 100).round()}%',
              onChanged: (value) {
                themeNotifier.updateTextScaleFactor(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
