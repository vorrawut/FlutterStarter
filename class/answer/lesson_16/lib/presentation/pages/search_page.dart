import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_providers.dart';
import '../widgets/article_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_shimmer.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    ref.read(searchQueryProvider.notifier).state = query;
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchArticlesProvider({
      'query': searchQuery,
      'language': 'en',
      'sortBy': 'publishedAt',
      'pageSize': 20,
    }));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search News'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for news...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textInputAction: TextInputAction.search,
            ),
          ),

          // Results
          Expanded(
            child: searchQuery.isEmpty
                ? _buildEmptyState()
                : searchResults.when(
                    loading: () => const LoadingShimmerList(),
                    error: (error, stack) => CustomErrorWidget(
                      error: error,
                      onRetry: () => ref.invalidate(searchArticlesProvider),
                    ),
                    data: (articles) => _buildResults(articles),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Search for News',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            'Enter keywords to find relevant articles',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(List articles) {
    if (articles.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Results Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Try different keywords or check your spelling',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ArticleCard(
            article: article,
            showImage: true,
            showFullContent: true,
            isCompact: false,
          ),
        );
      },
    );
  }
}

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedArticles = ref.watch(bookmarkedArticlesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (bookmarkedArticles.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showClearAllDialog(context, ref),
            ),
        ],
      ),
      body: bookmarkedArticles.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No Bookmarks Yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bookmark articles to read them later',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = bookmarkedArticles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ArticleCard(
                    article: article,
                    showImage: true,
                    showFullContent: true,
                    isCompact: false,
                  ),
                );
              },
            ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Bookmarks'),
        content: const Text('Are you sure you want to remove all bookmarks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Clear all bookmarks
              final notifier = ref.read(bookmarkedArticlesProvider.notifier);
              notifier.state = [];
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class SourcesPage extends ConsumerWidget {
  const SourcesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sources = ref.watch(newsSourcesProvider({}));

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Sources'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: sources.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => CustomErrorWidget(
          error: error,
          onRetry: () => ref.invalidate(newsSourcesProvider),
        ),
        data: (sourcesList) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sourcesList.length,
          itemBuilder: (context, index) {
            final source = sourcesList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(source.displayName),
                subtitle: Text(source.description),
                trailing: Text(source.categoryDisplayName),
                onTap: () {
                  // Navigate to source articles
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Show articles from ${source.name}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}