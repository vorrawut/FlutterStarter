# Pokédex List Workshop

## Overview
In this workshop you build a practical Pokémon list screen that pulls the first 151 Pokémon from the public PokéAPI and renders each name alongside its sprite.

## Learning Objectives
- Practice wiring the `http` package into a Flutter project.
- Decode JSON payloads into lightweight Dart objects.
- Use `FutureBuilder` and `ListView.builder` to render asynchronous data safely.
- Derive additional fields (sprite URLs) from API data.

## Prerequisites
- Flutter SDK installed and working `flutter run` setup.
- A starter app scaffold (for example this module's FlutterStarter repo).
- Network access to `https://pokeapi.co`.

## 1. Inspect the API
The PokéAPI endpoint you will use is `https://pokeapi.co/api/v2/pokemon?limit=151`. A sample response contains the array you need in the `results` field:

```json
{
  "count": 1302,
  "next": "https://pokeapi.co/api/v2/pokemon?offset=3&limit=3",
  "previous": null,
  "results": [
    { "name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/" }
  ]
}
```

Each Pokémon only provides a name and a detail URL. The sprite image can be built from the Pokémon id: `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/<id>.png`.

## 2. Add Dependencies
Open `pubspec.yaml` and add the `http` package (or confirm it is already listed):

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
```

Run `flutter pub get` once the dependency is added.

## 3. Create the Screen
Create `lib/pokemon_list_screen.dart` and scaffold a stateful widget. Use the following implementation as a starting point:

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late Future<List<_Pokemon>> _pokemonFuture;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _fetchPokemon();
  }

  Future<List<_Pokemon>> _fetchPokemon() async {
    final uri = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Failed to load Pokémon');

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final results = body['results'] as List<dynamic>;

    return results.map((entry) {
      final name = entry['name'] as String;
      final url = entry['url'] as String;
      final id = int.parse(url.split('/').where((segment) => segment.isNotEmpty).last);
      return _Pokemon(
        name: name,
        imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
      );
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: FutureBuilder<List<_Pokemon>>(
        future: _pokemonFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final pokemon = snapshot.data!;
          return ListView.builder(
            itemCount: pokemon.length,
            itemBuilder: (context, index) {
              final poke = pokemon[index];
              return ListTile(
                leading: Image.network(poke.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                title: Text(poke.name),
              );
            },
          );
        },
      ),
    );
  }
}

class _Pokemon {
  const _Pokemon({required this.name, required this.imageUrl});

  final String name;
  final String imageUrl;
}
```

## 4. Wire the Screen Into the App
In your `MaterialApp`, set the home (or a named route) to `PokemonListScreen` and run the app:

```dart
return MaterialApp(
  title: 'Pokédex',
  theme: ThemeData(useMaterial3: true),
  home: const PokemonListScreen(),
);
```

## 5. Validate and Polish
- Confirm the list shows 151 entries with sprites.
- Add loading and error states that feel appropriate for your app design.
- Consider caching using `CachedNetworkImage` or similar for smoother scrolling.

## Stretch Ideas
- Navigate to a detail page using the Pokémon id extracted from the URL.
- Support pull-to-refresh with `RefreshIndicator`.
- Add search or filtering across the loaded list.
- Add tests that mock `http.Client` to validate JSON parsing logic.
