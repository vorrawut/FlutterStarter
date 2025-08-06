import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/weather/weather_bloc.dart';
import '../../blocs/weather/weather_event.dart';
import '../../blocs/weather/weather_state.dart';

class WeatherSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final Function(String) onCitySelected;

  const WeatherSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onCitySelected,
  });

  @override
  State<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends State<WeatherSearchBar> {
  bool _showResults = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: 'Search for a city...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      widget.controller.clear();
                      setState(() {
                        _showResults = false;
                      });
                      context.read<WeatherBloc>().add(const WeatherSearchRequested(''));
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (query) {
            setState(() {
              _showResults = query.isNotEmpty;
            });
            
            if (query.isNotEmpty) {
              context.read<WeatherBloc>().add(WeatherSearchRequested(query));
            }
          },
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              widget.onSearch(query);
              setState(() {
                _showResults = false;
              });
            }
          },
        ),
        
        if (_showResults) _buildSearchResults(),
      ],
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state.isSearching) {
          return Card(
            margin: const EdgeInsets.only(top: 8),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Searching...'),
                ],
              ),
            ),
          );
        }

        if (state.searchResults.isEmpty && widget.controller.text.isNotEmpty) {
          return Card(
            margin: const EdgeInsets.only(top: 8),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No cities found'),
            ),
          );
        }

        if (state.searchResults.isNotEmpty) {
          return Card(
            margin: const EdgeInsets.only(top: 8),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.searchResults.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final city = state.searchResults[index];
                return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(city),
                  onTap: () {
                    widget.onCitySelected(city);
                    widget.controller.clear();
                    setState(() {
                      _showResults = false;
                    });
                  },
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}