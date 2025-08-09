import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? content;
  final String? urlToImage;
  final String? url;
  final DateTime publishedAt;
  final Source? source;
  final bool isBookmarked;
  final List<String> categories;
  final int readTimeMinutes;
  final DateTime? cachedAt;

  const Article({
    required this.id,
    required this.title,
    this.description,
    this.content,
    this.urlToImage,
    this.url,
    required this.publishedAt,
    this.source,
    this.isBookmarked = false,
    this.categories = const [],
    this.readTimeMinutes = 5,
    this.cachedAt,
  });

  Article copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? urlToImage,
    String? url,
    DateTime? publishedAt,
    Source? source,
    bool? isBookmarked,
    List<String>? categories,
    int? readTimeMinutes,
    DateTime? cachedAt,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      urlToImage: urlToImage ?? this.urlToImage,
      url: url ?? this.url,
      publishedAt: publishedAt ?? this.publishedAt,
      source: source ?? this.source,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      categories: categories ?? this.categories,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'urlToImage': urlToImage,
      'url': url,
      'publishedAt': publishedAt.toIso8601String(),
      'source': source?.toJson(),
      'isBookmarked': isBookmarked,
      'categories': categories,
      'readTimeMinutes': readTimeMinutes,
      'cachedAt': cachedAt?.toIso8601String(),
    };
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      content: json['content'] as String?,
      urlToImage: json['urlToImage'] as String?,
      url: json['url'] as String?,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      source: json['source'] != null 
          ? Source.fromJson(json['source'] as Map<String, dynamic>)
          : null,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      categories: List<String>.from(json['categories'] as List? ?? []),
      readTimeMinutes: json['readTimeMinutes'] as int? ?? 5,
      cachedAt: json['cachedAt'] != null 
          ? DateTime.parse(json['cachedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        urlToImage,
        url,
        publishedAt,
        source,
        isBookmarked,
        categories,
        readTimeMinutes,
        cachedAt,
      ];
}

class Source extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? url;
  final String? category;
  final String? language;
  final String? country;

  const Source({
    required this.id,
    required this.name,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
  });

  Source copyWith({
    String? id,
    String? name,
    String? description,
    String? url,
    String? category,
    String? language,
    String? country,
  }) {
    return Source(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      category: category ?? this.category,
      language: language ?? this.language,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'category': category,
      'language': language,
      'country': country,
    };
  }

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      url: json['url'] as String?,
      category: json['category'] as String?,
      language: json['language'] as String?,
      country: json['country'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        url,
        category,
        language,
        country,
      ];
}
