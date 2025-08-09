import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import '../../core/di/service_locator.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/screens/login_screen.dart';
import '../home/screens/home_screen.dart';
import '../theme/providers/theme_providers.dart';
import '../settings/providers/user_settings_provider.dart';

class AuthFlowProApp extends ConsumerWidget {
  const AuthFlowProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightTheme = ref.watch(currentThemeDataProvider);
    final darkTheme = ref.watch(darkThemeDataProvider);
    final themeMode = ref.watch(themeModeProvider);

    return BlocProvider(
      create: (context) => AuthBloc(
        loginUseCase: getIt(),
        logoutUseCase: getIt(),
        registerUseCase: getIt(),
        biometricService: getIt(),
        securityService: getIt(),
        analyticsService: getIt(),
      ),
      child: MaterialApp(
        title: 'AuthFlow Pro',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthAuthenticated) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
