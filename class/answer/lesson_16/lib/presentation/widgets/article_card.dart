import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/news_article.dart';
import '../providers/news_providers.dart';

class ArticleCard extends ConsumerStatefulWidget {
  final NewsArticle article;
  final bool showImage;
  final bool showFullContent;
  final bool isCompact;
  final VoidCallback? onTap;

  const ArticleCard({
    super.key,
    required this.article,
    this.showImage = true,
    this.showFullContent = true,
    this.isCompact = false,
    this.onTap,
  });

  @override
  ConsumerState<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends ConsumerState<ArticleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBookmarked = ref.watch(bookmarkedArticlesProvider
        .select((bookmarks) => bookmarks.any((a) => a.id == widget.article.id)));
    final isRead = ref.watch(readArticlesProvider
        .select((readSet) => readSet.contains(widget.article.id)));

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            elevation: widget.isCompact ? 1 : 2,
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () {
                _markAsRead();
                if (widget.onTap != null) {
                  widget.onTap!();
                } else {
                  _showArticleDetails();
                }
              },
              onTapDown: (_) => _animationController.forward(),
              onTapUp: (_) => _animationController.reverse(),
              onTapCancel: () => _animationController.reverse(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: widget.isCompact
                    ? _buildCompactLayout(isBookmarked, isRead)
                    : _buildFullLayout(isBookmarked, isRead),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullLayout(bool isBookmarked, bool isRead) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with source and actions
        _buildHeader(isBookmarked, isRead),
        
        const SizedBox(height: 12),
        
        // Image (if enabled and available)
        if (widget.showImage && widget.article.hasImage) ...[
          _buildImage(),
          const SizedBox(height: 12),
        ],
        
        // Title
        _buildTitle(),
        
        const SizedBox(height: 8),
        
        // Description/Content
        if (widget.showFullContent) ...[
          _buildContent(),
          const SizedBox(height: 12),
        ],
        
        // Footer with metadata
        _buildFooter(),
      ],
    );
  }

  Widget _buildCompactLayout(bool isBookmarked, bool isRead) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image (if enabled and available)
        if (widget.showImage && widget.article.hasImage) ...[
          _buildCompactImage(),
          const SizedBox(width: 12),
        ],
        
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildCompactHeader(isBookmarked, isRead),
              
              const SizedBox(height: 4),
              
              // Title
              _buildTitle(),
              
              const SizedBox(height: 4),
              
              // Footer
              _buildFooter(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isBookmarked, bool isRead) {
    return Row(
      children: [
        // Source and category
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article.displayAuthor,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (widget.article.category != 'General')
                Text(
                  widget.article.category.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        
        // Actions
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Read indicator
            if (isRead)
              Icon(
                Icons.visibility,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            
            const SizedBox(width: 4),
            
            // Bookmark button
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
              onPressed: _toggleBookmark,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactHeader(bool isBookmarked, bool isRead) {
    return Row(
      children: [
        // Source
        Expanded(
          child: Text(
            widget.article.displayAuthor,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // Indicators
        if (isRead)
          Icon(
            Icons.visibility,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        
        const SizedBox(width: 4),
        
        // Bookmark button
        InkWell(
          onTap: _toggleBookmark,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          imageUrl: widget.article.imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Icon(
              Icons.image_not_supported,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 80,
        height: 80,
        child: CachedNetworkImage(
          imageUrl: widget.article.imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Icon(
              Icons.image_not_supported,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.article.title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      maxLines: widget.isCompact ? 2 : 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContent() {
    final content = widget.article.shortDescription.isNotEmpty
        ? widget.article.shortDescription
        : widget.article.shortContent;
    
    if (content.isEmpty) return const SizedBox.shrink();
    
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Time ago
        Icon(
          Icons.access_time,
          size: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          widget.article.timeAgo,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        
        const Spacer(),
        
        // Share button
        InkWell(
          onTap: _shareArticle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.share,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  void _toggleBookmark() {
    ref.read(bookmarkedArticlesProvider.notifier).toggleBookmark(widget.article);
  }

  void _markAsRead() {
    ref.read(readArticlesProvider.notifier).markAsRead(widget.article.id);
  }

  void _shareArticle() {
    // In a real app, this would use the share plugin
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality not implemented in demo'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showArticleDetails() {
    // In a real app, this would navigate to a detailed article view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Article details not implemented in demo'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}