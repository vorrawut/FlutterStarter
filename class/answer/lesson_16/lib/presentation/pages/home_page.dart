import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_providers.dart';
import '../widgets/article_card.dart';
import '../widgets/section_header.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_shimmer.dart';
import '../../domain/entities/news_article.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeNews = ref.watch(homeNewsProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NewsFlow Pro'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Country selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (country) {
              ref.read(selectedCountryProvider.notifier).state = country;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'us',
                child: ListTile(
                  leading: Text('🇺🇸'),
                  title: Text('United States'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'gb',
                child: ListTile(
                  leading: Text('🇬🇧'),
                  title: Text('United Kingdom'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'ca',
                child: ListTile(
                  leading: Text('🇨🇦'),
                  title: Text('Canada'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'au',
                child: ListTile(
                  leading: Text('🇦🇺'),
                  title: Text('Australia'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'de',
                child: ListTile(
                  leading: Text('🇩🇪'),
                  title: Text('Germany'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(homeNewsProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(homeNewsProvider);
        },
        child: homeNews.when(
          loading: () => const LoadingShimmerList(),
          error: (error, stack) => CustomErrorWidget(
            error: error,
            onRetry: () => ref.invalidate(homeNewsProvider),
          ),
          data: (newsData) => _buildContent(newsData),
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, List<NewsArticle>> newsData) {
    final headlines = newsData['headlines'] ?? [];
    final trending = newsData['trending'] ?? [];
    final recent = newsData['recent'] ?? [];

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Performance info
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.network_wifi,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Advanced Networking with Dio & Retrofit',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Cached • Optimized',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Top Headlines section
        if (headlines.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Top Headlines',
              subtitle: '${headlines.length} articles',
              onSeeAll: () => _navigateToCategory('headlines'),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: headlines.take(5).length,
                itemBuilder: (context, index) {
                  final article = headlines[index];
                  return Container(
                    width: 300,
                    margin: const EdgeInsets.only(right: 16),
                    child: ArticleCard(
                      article: article,
                      showImage: true,
                      showFullContent: false,
                    ),
                  );
                },
              ),
            ),
          ),
        ],

        // Trending section
        if (trending.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Trending Now',
              subtitle: '${trending.length} articles',
              onSeeAll: () => _navigateToCategory('trending'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final article = trending[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ArticleCard(
                    article: article,
                    showImage: true,
                    showFullContent: false,
                    isCompact: true,
                  ),
                );
              },
              childCount: trending.take(3).length,
            ),
          ),
        ],

        // Recent section
        if (recent.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Latest News',
              subtitle: '${recent.length} articles',
              onSeeAll: () => _navigateToCategory('recent'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final article = recent[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ArticleCard(
                    article: article,
                    showImage: false,
                    showFullContent: false,
                    isCompact: true,
                  ),
                );
              },
              childCount: recent.take(5).length,
            ),
          ),
        ],

        // Empty state
        if (headlines.isEmpty && trending.isEmpty && recent.isEmpty)
          const SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.newspaper, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No news available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Check your internet connection and try again',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 32),
        ),
      ],
    );
  }

  void _navigateToCategory(String category) {
    // In a real app, this would navigate to a category-specific page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigate to $category category'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}