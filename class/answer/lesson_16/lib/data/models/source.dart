import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'source.g.dart';

@JsonSerializable()
class Source extends Equatable {
  final String? id;
  final String name;
  final String? description;
  final String? url;
  final String? category;
  final String? language;
  final String? country;

  const Source({
    this.id,
    required this.name,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
  });

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
  Map<String, dynamic> toJson() => _$SourceToJson(this);

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

  String get languageDisplayName {
    if (language == null || language!.isEmpty) {
      return 'Unknown';
    }
    
    // Common language codes to names mapping
    const languageMap = {
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian',
      'pt': 'Portuguese',
      'ru': 'Russian',
      'ja': 'Japanese',
      'ko': 'Korean',
      'zh': 'Chinese',
      'ar': 'Arabic',
      'hi': 'Hindi',
      'th': 'Thai',
      'vi': 'Vietnamese',
      'nl': 'Dutch',
      'sv': 'Swedish',
      'no': 'Norwegian',
      'da': 'Danish',
      'fi': 'Finnish',
      'pl': 'Polish',
      'cs': 'Czech',
      'hu': 'Hungarian',
      'ro': 'Romanian',
      'bg': 'Bulgarian',
      'hr': 'Croatian',
      'sk': 'Slovak',
      'sl': 'Slovenian',
      'et': 'Estonian',
      'lv': 'Latvian',
      'lt': 'Lithuanian',
    };

    return languageMap[language!.toLowerCase()] ?? language!.toUpperCase();
  }

  String get countryDisplayName {
    if (country == null || country!.isEmpty) {
      return 'Unknown';
    }
    
    // Common country codes to names mapping
    const countryMap = {
      'us': 'United States',
      'gb': 'United Kingdom',
      'ca': 'Canada',
      'au': 'Australia',
      'de': 'Germany',
      'fr': 'France',
      'it': 'Italy',
      'es': 'Spain',
      'pt': 'Portugal',
      'nl': 'Netherlands',
      'be': 'Belgium',
      'ch': 'Switzerland',
      'at': 'Austria',
      'dk': 'Denmark',
      'se': 'Sweden',
      'no': 'Norway',
      'fi': 'Finland',
      'pl': 'Poland',
      'cz': 'Czech Republic',
      'sk': 'Slovakia',
      'hu': 'Hungary',
      'ro': 'Romania',
      'bg': 'Bulgaria',
      'hr': 'Croatia',
      'si': 'Slovenia',
      'ee': 'Estonia',
      'lv': 'Latvia',
      'lt': 'Lithuania',
      'jp': 'Japan',
      'kr': 'South Korea',
      'cn': 'China',
      'in': 'India',
      'th': 'Thailand',
      'vn': 'Vietnam',
      'my': 'Malaysia',
      'sg': 'Singapore',
      'ph': 'Philippines',
      'id': 'Indonesia',
      'ru': 'Russia',
      'br': 'Brazil',
      'mx': 'Mexico',
      'ar': 'Argentina',
      'cl': 'Chile',
      'co': 'Colombia',
      'pe': 'Peru',
      'za': 'South Africa',
      'eg': 'Egypt',
      'sa': 'Saudi Arabia',
      'ae': 'United Arab Emirates',
      'il': 'Israel',
      'tr': 'Turkey',
      'ua': 'Ukraine',
      'ie': 'Ireland',
      'nz': 'New Zealand',
    };

    return countryMap[country!.toLowerCase()] ?? country!.toUpperCase();
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
    return 'Source(id: $id, name: $name, category: $category)';
  }
}