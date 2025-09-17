import 'package:flutter/material.dart';
import 'features/login/login.dart';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Pokemon-themed color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC107), // Pokemon yellow
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        // Custom font for Pokemon feel
        fontFamily: 'Inter',
      ),
      home: const LoginScreen(),
    );
  }
}
