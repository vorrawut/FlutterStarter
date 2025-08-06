import 'package:equatable/equatable.dart';

class NewsSource extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? url;
  final String? category;
  final String? language;
  final String? country;

  const NewsSource({
    required this.id,
    required this.name,
    required this.description,
    this.url,
    this.category,
    this.language,
    this.country,
  });

  NewsSource copyWith({
    String? id,
    String? name,
    String? description,
    String? url,
    String? category,
    String? language,
    String? country,
  }) {
    return NewsSource(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      category: category ?? this.category,
      language: language ?? this.language,
      country: country ?? this.country,
    );
  }

  String get displayName {
    return name.isNotEmpty ? name : 'Unknown Source';
  }

  String get categoryDisplayName {
    if (category == null || category!.isEmpty) {
      return 'General';
    }
    // Capitalize first letter
    return category![0].toUpperCase() + category!.substring(1).toLowerCase();
  }

  bool get hasWebsite => url != null && url!.isNotEmpty;

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

  @override
  String toString() {
    return 'NewsSource(id: $id, name: $name, category: $category)';
  }
}