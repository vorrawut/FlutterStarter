import '../../domain/entities/business_card.dart';

/// Data model for business card that extends the domain entity
/// Provides serialization/deserialization capabilities for data persistence
class BusinessCardModel extends BusinessCard {
  const BusinessCardModel({
    required super.id,
    required super.name,
    required super.title,
    required super.company,
    required super.email,
    required super.phone,
    required super.website,
    required super.style,
  });

  /// Create BusinessCardModel from domain entity
  factory BusinessCardModel.fromEntity(BusinessCard entity) {
    return BusinessCardModel(
      id: entity.id,
      name: entity.name,
      title: entity.title,
      company: entity.company,
      email: entity.email,
      phone: entity.phone,
      website: entity.website,
      style: entity.style,
    );
  }

  /// Convert to domain entity
  BusinessCard toEntity() {
    return BusinessCard(
      id: id,
      name: name,
      title: title,
      company: company,
      email: email,
      phone: phone,
      website: website,
      style: style,
    );
  }

  /// Create BusinessCardModel from JSON map
  factory BusinessCardModel.fromJson(Map<String, dynamic> json) {
    return BusinessCardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
      style: BusinessCardStyle.values.firstWhere(
        (style) => style.name == json['style'],
        orElse: () => BusinessCardStyle.modern,
      ),
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'company': company,
      'email': email,
      'phone': phone,
      'website': website,
      'style': style.name,
    };
  }

  /// Create a copy with updated fields
  @override
  BusinessCardModel copyWith({
    String? id,
    String? name,
    String? title,
    String? company,
    String? email,
    String? phone,
    String? website,
    BusinessCardStyle? style,
  }) {
    return BusinessCardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      company: company ?? this.company,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      style: style ?? this.style,
    );
  }

  @override
  String toString() {
    return 'BusinessCardModel(id: $id, name: $name, title: $title, company: $company)';
  }

  /// Equality comparison for testing and data integrity
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BusinessCardModel &&
        other.id == id &&
        other.name == name &&
        other.title == title &&
        other.company == company &&
        other.email == email &&
        other.phone == phone &&
        other.website == website &&
        other.style == style;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      title,
      company,
      email,
      phone,
      website,
      style,
    );
  }
}

/// Collection of sample business card data for demo purposes
class BusinessCardSampleData {
  static const List<Map<String, dynamic>> sampleData = [
    {
      'id': 'bc_001',
      'name': 'Sarah Chen',
      'title': 'Senior Flutter Developer',
      'company': 'TechCorp Inc.',
      'email': 'sarah@techcorp.com',
      'phone': '+1 (555) 123-4567',
      'website': 'sarahchen.dev',
      'style': 'modern',
    },
    {
      'id': 'bc_002',
      'name': 'Marcus Johnson',
      'title': 'UX/UI Designer',
      'company': 'Design Studio',
      'email': 'marcus@design.io',
      'phone': '+1 (555) 987-6543',
      'website': 'marcusdesign.com',
      'style': 'elegant',
    },
    {
      'id': 'bc_003',
      'name': 'Elena Rodriguez',
      'title': 'Product Manager',
      'company': 'Innovation Labs',
      'email': 'elena@innovlabs.com',
      'phone': '+1 (555) 456-7890',
      'website': 'elenapm.pro',
      'style': 'creative',
    },
    {
      'id': 'bc_004',
      'name': 'David Kim',
      'title': 'Software Architect',
      'company': 'StartupX',
      'email': 'david@startupx.io',
      'phone': '+1 (555) 321-0987',
      'website': 'davidkim.tech',
      'style': 'minimal',
    },
    {
      'id': 'bc_005',
      'name': 'Lisa Thompson',
      'title': 'DevOps Engineer',
      'company': 'CloudTech Solutions',
      'email': 'lisa@cloudtech.com',
      'phone': '+1 (555) 654-3210',
      'website': 'lisadevops.com',
      'style': 'modern',
    },
    {
      'id': 'bc_006',
      'name': 'James Wilson',
      'title': 'Frontend Developer',
      'company': 'WebCraft Agency',
      'email': 'james@webcraft.co',
      'phone': '+1 (555) 789-4561',
      'website': 'jameswilson.dev',
      'style': 'elegant',
    },
  ];

  /// Get sample business card models
  static List<BusinessCardModel> getSampleCards() {
    return sampleData
        .map((data) => BusinessCardModel.fromJson(data))
        .toList();
  }

  /// Get sample cards by style
  static List<BusinessCardModel> getSampleCardsByStyle(BusinessCardStyle style) {
    return getSampleCards()
        .where((card) => card.style == style)
        .toList();
  }

  /// Get grouped sample cards
  static Map<BusinessCardStyle, List<BusinessCardModel>> getGroupedSampleCards() {
    final cards = getSampleCards();
    final Map<BusinessCardStyle, List<BusinessCardModel>> grouped = {};

    for (final card in cards) {
      grouped.putIfAbsent(card.style, () => []).add(card);
    }

    return grouped;
  }
}