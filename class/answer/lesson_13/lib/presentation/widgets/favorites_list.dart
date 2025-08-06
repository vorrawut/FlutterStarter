import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/favorites/favorites_cubit.dart';
import '../../cubits/favorites/favorites_state.dart';

class FavoritesList extends StatelessWidget {
  final Function(String) onCitySelected;

  const FavoritesList({
    super.key,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<FavoritesCubit>().clearError();
                  },
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.hasFavorites) ...[
                _buildSectionHeader(context, 'Favorite Cities', Icons.favorite),
                const SizedBox(height: 12),
                _buildFavoritesList(context, state.favorites),
              ],
              
              if (state.hasRecentSearches) ...[
                if (state.hasFavorites) const SizedBox(height: 24),
                _buildSectionHeader(context, 'Recent Searches', Icons.history),
                const SizedBox(height: 12),
                _buildRecentSearchesList(context, state.recentSearches),
              ],
              
              if (!state.hasFavorites && !state.hasRecentSearches) ...[
                _buildEmptyState(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (title.contains('Favorite')) ...[
          IconButton(
            onPressed: () => _showClearFavoritesDialog(context),
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear all favorites',
          ),
        ] else ...[
          IconButton(
            onPressed: () => context.read<FavoritesCubit>().clearRecentSearches(),
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear recent searches',
          ),
        ],
      ],
    );
  }

  Widget _buildFavoritesList(BuildContext context, List<String> favorites) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: favorites.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final city = favorites[index];
        return _buildFavoriteItem(context, city, index);
      },
    );
  }

  Widget _buildFavoriteItem(BuildContext context, String city, int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.location_city,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          city,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showRemoveFavoriteDialog(context, city),
              tooltip: 'Remove from favorites',
            ),
            const Icon(Icons.drag_handle),
          ],
        ),
        onTap: () => onCitySelected(city),
      ),
    );
  }

  Widget _buildRecentSearchesList(BuildContext context, List<String> recentSearches) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentSearches.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final city = recentSearches[index];
        return _buildRecentSearchItem(context, city);
      },
    );
  }

  Widget _buildRecentSearchItem(BuildContext context, String city) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(
            Icons.history,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(city),
        trailing: IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => context.read<FavoritesCubit>().addFavorite(city),
          tooltip: 'Add to favorites',
        ),
        onTap: () => onCitySelected(city),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            Text(
              'No Favorites Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Search for cities and add them to favorites for quick access',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                // Could navigate to search or provide quick add functionality
              },
              icon: const Icon(Icons.search),
              label: const Text('Search Cities'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveFavoriteDialog(BuildContext context, String city) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove Favorite'),
        content: Text('Remove "$city" from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesCubit>().removeFavorite(city);
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showClearFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('This will remove all favorite cities. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesCubit>().clearFavorites();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}