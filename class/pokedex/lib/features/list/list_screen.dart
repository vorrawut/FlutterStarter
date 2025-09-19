import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/core/constants/routes.dart';

class _Pokemon {
  const _Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String imageUrl;
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<_Pokemon>> _pokemonFuture;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _fetchPokemon();
  }

  @override
  void dispose() {
    super.dispose();
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
      final id =
          int.parse(url.split('/').where((segment) => segment.isNotEmpty).last);
      return _Pokemon(
        id: id,
        name: name,
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
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
                leading: Image.network(poke.imageUrl,
                    width: 56, height: 56, fit: BoxFit.cover),
                title: Text(poke.name),
                onTap: () {
                  Navigator.pushNamed(context, Routes.pokemonDetail,
                      arguments: poke.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
