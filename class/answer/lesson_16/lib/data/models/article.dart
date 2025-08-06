import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'source.dart';

part 'article.g.dart';

@JsonSerializable()
class Article extends Equatable {
  final Source? source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  @JsonKey(name: 'urlToImage')
  final String? imageUrl;
  @JsonKey(name: 'publishedAt')
  final DateTime publishedAt;
  final String? content;

  // Local fields (not from API)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isBookmarked;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isRead;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DateTime? readAt;

  const Article({
    this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    this.content,
    this.isBookmarked = false,
    this.isRead = false,
    this.readAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  Article copyWith({
    Source? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? imageUrl,
    DateTime? publishedAt,
    String? content,
    bool? isBookmarked,
    bool? isRead,
    DateTime? readAt,
  }) {
    return Article(
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }

  Article markAsRead() {
    return copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );
  }

  Article toggleBookmark() {
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
    if (description == null || description!.isEmpty) {
      return '';
    }
    if (description!.length <= 150) {
      return description!;
    }
    return '${description!.substring(0, 147)}...';
  }

  String get shortContent {
    if (content == null || content!.isEmpty) {
      return shortDescription;
    }
    if (content!.length <= 200) {
      return content!;
    }
    return '${content!.substring(0, 197)}...';
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
        source,
        author,
        title,
        description,
        url,
        imageUrl,
        publishedAt,
        content,
        isBookmarked,
        isRead,
        readAt,
      ];

  @override
  String toString() {
    return 'Article(title: $title, author: $displayAuthor, publishedAt: $publishedAt)';
  }
}