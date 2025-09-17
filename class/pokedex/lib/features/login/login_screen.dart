import 'package:flutter/material.dart';
import 'package:pokedex/core/constants/routes.dart';
import 'package:pokedex/features/login/widgets/login_header.dart';
import 'package:pokedex/features/login/widgets/login_form.dart';
import 'package:pokedex/features/login/widgets/login_bottom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final _confirmPasswordController = TextEditingController();

  bool _isLoginMode = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1B2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoginHeader(),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: LoginForm(
                      isLoginMode: _isLoginMode,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      onLoginSuccess: _handleLoginSuccess,
                      onSignUpSuccess: _handleSignUpSuccess,
                    ),
                  ),
                  const SizedBox(height: 30),
                  LoginBottom(
                    isLoginMode: _isLoginMode,
                    onToggleMode: _toggleMode,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLoginSuccess(String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login: $email'),
        backgroundColor: const Color(0xFFFFC107),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pushReplacementNamed(context, Routes.pokemonList);
  }

  void _handleSignUpSuccess(String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign Up: $email'),
        backgroundColor: const Color(0xFFFFC107),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });

    _animationController.reset();
    _animationController.forward();
  }
}
