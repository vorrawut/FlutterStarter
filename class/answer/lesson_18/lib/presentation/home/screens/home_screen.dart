import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/article.dart';
import '../../providers/news_providers.dart';
import '../../widgets/article_card.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/category_tabs.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/error_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final List<String> _categories = [
    'general',
    'business',
    'technology',
    'health',
    'science',
    'sports',
    'entertainment',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more articles when reaching the bottom
      ref.read(newsNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildSliverAppBar(theme, innerBoxIsScrolled),
            _buildSliverPersistentHeader(),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _categories.map((category) {
            return _buildNewsTab(category);
          }).toList(),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme, bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: innerBoxIsScrolled ? 4 : 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'NewsHub Ultimate',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withOpacity(0.1),
                theme.colorScheme.secondary.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _showSearchDelegate(context),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'bookmarks',
              child: Row(
                children: [
                  Icon(Icons.bookmark),
                  SizedBox(width: 8),
                  Text('Bookmarks'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 8),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'cache',
              child: Row(
                children: [
                  Icon(Icons.storage),
                  SizedBox(width: 8),
                  Text('Cache Stats'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSliverPersistentHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CategoryTabsPersistentHeaderDelegate(
        tabController: _tabController,
        categories: _categories,
      ),
    );
  }

  Widget _buildNewsTab(String category) {
    return Consumer(
      builder: (context, ref, child) {
        final articlesAsync = ref.watch(articlesByCategoryProvider(category));
        
        return articlesAsync.when(
          loading: () => const LoadingShimmer(),
          error: (error, stack) => NewsErrorWidget(
            error: error.toString(),
            onRetry: () => ref.invalidate(articlesByCategoryProvider(category)),
          ),
          data: (articles) => _buildArticlesList(articles, category),
        );
      },
    );
  }

  Widget _buildArticlesList(List<Article> articles, String category) {
    if (articles.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(articlesByCategoryProvider(category));
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: articles.length + 1, // +1 for loading indicator
        itemBuilder: (context, index) {
          if (index == articles.length) {
            return _buildLoadMoreIndicator();
          }
          
          final article = articles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ArticleCard(
              article: article,
              onTap: () => _openArticle(article),
              onBookmarkTap: () => _toggleBookmark(article),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No articles available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull to refresh or check your connection',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Consumer(
      builder: (context, ref, child) {
        final isLoading = ref.watch(newsNotifierProvider).isLoadingMore;
        
        if (isLoading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _scrollToTop(),
      child: const Icon(Icons.keyboard_arrow_up),
    );
  }

  void _showSearchDelegate(BuildContext context) {
    showSearch(
      context: context,
      delegate: NewsSearchDelegate(ref),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'bookmarks':
        _showBookmarks();
        break;
      case 'settings':
        _showSettings();
        break;
      case 'cache':
        _showCacheStats();
        break;
    }
  }

  void _showBookmarks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BookmarksScreen(),
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const SettingsBottomSheet(),
    );
  }

  void _showCacheStats() async {
    final stats = await ref.read(newsRepositoryProvider).getCacheStats();
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cache Statistics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hive Storage: ${stats['hive']} articles'),
              Text('SQLite Storage: ${stats['sqlite']} articles'),
              Text('Total: ${stats['total']} articles'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(newsRepositoryProvider).clearCache();
                Navigator.pop(context);
                ref.invalidate(topHeadlinesProvider);
              },
              child: const Text('Clear Cache'),
            ),
          ],
        ),
      );
    }
  }

  void _openArticle(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }

  void _toggleBookmark(Article article) {
    ref.read(newsRepositoryProvider).toggleBookmark(article.id);
    // Refresh the current view to update bookmark status
    final currentCategory = _categories[_tabController.index];
    ref.invalidate(articlesByCategoryProvider(currentCategory));
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

// Persistent header delegate for category tabs
class _CategoryTabsPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<String> categories;

  _CategoryTabsPersistentHeaderDelegate({
    required this.tabController,
    required this.categories,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: theme.colorScheme.primary,
        tabs: categories.map((category) {
          return Tab(
            text: category.toUpperCase(),
          );
        }).toList(),
      ),
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

// Placeholder screens that would be implemented
class NewsSearchDelegate extends SearchDelegate {
  final WidgetRef ref;

  NewsSearchDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return const SizedBox.shrink();
    
    return Consumer(
      builder: (context, ref, child) {
        final searchResults = ref.watch(searchResultsProvider(query));
        
        return searchResults.when(
          loading: () => const LoadingShimmer(),
          error: (error, stack) => NewsErrorWidget(
            error: error.toString(),
            onRetry: () => ref.invalidate(searchResultsProvider(query)),
          ),
          data: (articles) => ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ArticleCard(
                article: article,
                onTap: () => close(context, article),
                onBookmarkTap: () => ref.read(newsRepositoryProvider)
                    .toggleBookmark(article.id),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // In a real app, this would show search suggestions
    return const Center(
      child: Text('Type to search articles...'),
    );
  }
}

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final bookmarksAsync = ref.watch(bookmarkedArticlesProvider);
          
          return bookmarksAsync.when(
            loading: () => const LoadingShimmer(),
            error: (error, stack) => NewsErrorWidget(
              error: error.toString(),
              onRetry: () => ref.invalidate(bookmarkedArticlesProvider),
            ),
            data: (articles) {
              if (articles.isEmpty) {
                return const Center(
                  child: Text('No bookmarked articles'),
                );
              }
              
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return ArticleCard(
                    article: article,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailScreen(article: article),
                      ),
                    ),
                    onBookmarkTap: () {
                      ref.read(newsRepositoryProvider).toggleBookmark(article.id);
                      ref.invalidate(bookmarkedArticlesProvider);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SettingsBottomSheet extends ConsumerWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          
          ListTile(
            title: const Text('Storage Backend'),
            subtitle: const Text('Choose preferred storage system'),
            trailing: DropdownButton<String>(
              value: 'hybrid',
              onChanged: (value) {
                if (value != null) {
                  ref.read(newsRepositoryProvider).switchStorageBackend(value);
                }
              },
              items: const [
                DropdownMenuItem(value: 'hybrid', child: Text('Hybrid')),
                DropdownMenuItem(value: 'hive', child: Text('Hive')),
                DropdownMenuItem(value: 'sqlite', child: Text('SQLite')),
              ],
            ),
          ),
          
          ListTile(
            title: const Text('Sync Data'),
            subtitle: const Text('Refresh cached articles'),
            trailing: IconButton(
              icon: const Icon(Icons.sync),
              onPressed: () async {
                await ref.read(newsRepositoryProvider).syncData();
                ref.invalidate(topHeadlinesProvider);
              },
            ),
          ),
          
          ListTile(
            title: const Text('Clear Cache'),
            subtitle: const Text('Remove all cached articles'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await ref.read(newsRepositoryProvider).clearCache();
                ref.invalidate(topHeadlinesProvider);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        actions: [
          IconButton(
            icon: Icon(
              article.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () {
              // Handle bookmark toggle
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.urlToImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (article.description != null) ...[
              Text(
                article.description!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (article.content != null) ...[
              Text(
                article.content!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
