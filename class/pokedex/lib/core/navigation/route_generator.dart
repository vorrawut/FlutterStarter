import 'package:flutter/material.dart';
import 'package:pokedex/core/constants/routes.dart';
import 'package:pokedex/features/list/splash_screen.dart';
import 'package:pokedex/features/login/login_screen.dart';
import 'package:pokedex/features/splash/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _createRoute(const SplashScreen());

      case Routes.login:
        return _createRoute(const LoginScreen());

      case Routes.pokemonList:
        return _createRoute(const ListScreen());

      case Routes.pokemonDetail:
        return _createRoute(const LoginScreen());

      default:
        return _createRoute(LoginScreen());
    }
  }

  static PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
