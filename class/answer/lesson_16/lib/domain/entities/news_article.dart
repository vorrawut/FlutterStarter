import 'package:equatable/equatable.dart';
import 'news_source.dart';

class NewsArticle extends Equatable {
  final String id;
  final String title;
  final String description;
  final String content;
  final String url;
  final String? imageUrl;
  final DateTime publishedAt;
  final String? author;
  final NewsSource? source;
  final bool isBookmarked;
  final bool isRead;
  final DateTime? readAt;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    this.author,
    this.source,
    this.isBookmarked = false,
    this.isRead = false,
    this.readAt,
  });

  NewsArticle copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? url,
    String? imageUrl,
    DateTime? publishedAt,
    String? author,
    NewsSource? source,
    bool? isBookmarked,
    bool? isRead,
    DateTime? readAt,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      author: author ?? this.author,
      source: source ?? this.source,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }

  NewsArticle markAsRead() {
    return copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );
  }

  NewsArticle toggleBookmark() {
    return copyWith(
      isBookmarked: !isBookmarked,
    );
  }

  String get displayAuthor {
    if (author != null && author!.isNotEmpty) {
      return author!;
    }
    if (source?.name != null && source!.name.isNotEmpty) {
      return source!.name;
    }
    return 'Unknown';
  }

  String get shortDescription {
    if (description.isEmpty) {
      return '';
    }
    if (description.length <= 150) {
      return description;
    }
    return '${description.substring(0, 147)}...';
  }

  String get shortContent {
    if (content.isEmpty) {
      return shortDescription;
    }
    if (content.length <= 200) {
      return content;
    }
    return '${content.substring(0, 197)}...';
  }

  Duration get timeSincePublished {
    return DateTime.now().difference(publishedAt);
  }

  String get timeAgo {
    final duration = timeSincePublished;
    
    if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  bool get isRecent {
    final duration = timeSincePublished;
    return duration.inHours < 24;
  }

  String get category {
    if (source?.category != null && source!.category!.isNotEmpty) {
      return source!.category!;
    }
    return 'General';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        url,
        imageUrl,
        publishedAt,
        author,
        source,
        isBookmarked,
        isRead,
        readAt,
      ];

  @override
  String toString() {
    return 'NewsArticle(id: $id, title: $title, author: $displayAuthor)';
  }
}