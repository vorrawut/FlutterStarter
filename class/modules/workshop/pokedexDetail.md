# Pokedex: Detail Screen Workshop
Let's continue from List Screen

## ** Step 1: Make item in list clickable** 

1.1 looking for widget we want to enhance from ListScreen.dart
```dart
ListTile(
    leading: Image.network(poke.imageUrl,
        width: 56, height: 56, fit: BoxFit.cover),
    title: Text(poke.name),
);
```
here it is


1.2 add "onTap" to navigate to Detail screen with parameter ID**

add new route in RouteGenerator
```dart
case Routes.pokemonDetail:
    return _createRoute(DetailScreen(id: settings.arguments as int));
```

add onTap to list items in ListScreen
```dart
ListTile(
    leading: Image.network(poke.imageUrl,
        width: 56, height: 56, fit: BoxFit.cover),
    title: Text(poke.name),
    onTap: () { // add this function
        Navigator.pushNamed(context, Routes.pokemonDetail,
            arguments: poke.id);
    },
);
```


## ** Step 2: Create Pokemon Detail Page**

2.1 create DetailScreen.dart and initial stateful widget
```dart
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```

2.2 receive ID from previous page
```dart
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.id});
  final int id; // add this line

  @override
  State<DetailScreen> createState() => _DetailScreenState();
```


2.3 call pokemon API by received ID

import libs
```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
```

prepare model
```dart
class PokemonDetail {
  const PokemonDetail({
    required this.name,
    required this.imageUrl,
    required this.weight,
    required this.height,
  });

  final String name;
  final String imageUrl;
  final int weight;
  final int height;
}
```

fetch and map data
```dart
Future<PokemonDetail> _fetchPokemonDetail() async {
    final uri = Uri.parse('https://pokeapi.co/api/v2/pokemon/$widget.id');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Failed to load Pokémon');
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return PokemonDetail(
      name: body['name'] as String,
      imageUrl: body['imageUrl'] as String,
      weight: body['weight'] as int,
      height: body['height'] as int,
    );
}
```


2.4 implement widgets
```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: FutureBuilder<PokemonDetail>(
        future: pokemonDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final pokemon = snapshot.data!;
          return Column(
            children: [
              Image.network(pokemon.imageUrl),
              Text(pokemon.name),
              Text(pokemon.weight.toString()),
              Text(pokemon.height.toString()),
            ],
          );
        },
      ),
    );
  }
```

---

# Full Code
## DetailScreen.dart
```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonDetail {
  const PokemonDetail({
    required this.name,
    required this.imageUrl,
    required this.weight,
    required this.height,
  });

  final String name;
  final String imageUrl;
  final int weight;
  final int height;
}

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.id});
  final int id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<PokemonDetail> pokemonDetail;

  @override
  void initState() {
    super.initState();
    pokemonDetail = _fetchPokemonDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<PokemonDetail> _fetchPokemonDetail() async {
    final uri = Uri.parse('https://pokeapi.co/api/v2/pokemon/$widget.id');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Failed to load Pokémon');
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return PokemonDetail(
      name: body['name'] as String,
      imageUrl: body['imageUrl'] as String,
      weight: body['weight'] as int,
      height: body['height'] as int,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: FutureBuilder<PokemonDetail>(
        future: pokemonDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final pokemon = snapshot.data!;
          return Column(
            children: [
              Image.network(pokemon.imageUrl),
              Text(pokemon.name),
              Text(pokemon.weight.toString()),
              Text(pokemon.height.toString()),
            ],
          );
        },
      ),
    );
  }
}

```