import 'package:equatable/equatable.dart';

/// Business card style enumeration
enum BusinessCardStyle {
  modern('Modern', 'Gradient design with contemporary styling'),
  elegant('Elegant', 'Clean professional design with minimal styling'),
  creative('Creative', 'Artistic design with bold colors and patterns'),
  minimal('Minimal', 'Simple typography-focused design');

  const BusinessCardStyle(this.displayName, this.description);

  final String displayName;
  final String description;
}

/// Business card entity representing a professional contact card
class BusinessCard extends Equatable {
  final String id;
  final String name;
  final String title;
  final String company;
  final String email;
  final String phone;
  final String website;
  final BusinessCardStyle style;

  const BusinessCard({
    required this.id,
    required this.name,
    required this.title,
    required this.company,
    required this.email,
    required this.phone,
    required this.website,
    required this.style,
  });

  /// Create a copy of this business card with optional field updates
  BusinessCard copyWith({
    String? id,
    String? name,
    String? title,
    String? company,
    String? email,
    String? phone,
    String? website,
    BusinessCardStyle? style,
  }) {
    return BusinessCard(
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

  /// Validate business card data
  bool get isValid {
    return name.isNotEmpty &&
           title.isNotEmpty &&
           company.isNotEmpty &&
           _isValidEmail(email) &&
           _isValidPhone(phone) &&
           _isValidWebsite(website);
  }

  /// Get initials from name for avatar display
  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.isEmpty) return '';
    if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
    return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
  }

  /// Get formatted display name
  String get displayName => name;

  /// Get short company name (first word if multiple)
  String get shortCompany {
    final companyParts = company.split(' ');
    return companyParts.isNotEmpty ? companyParts[0] : company;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        title,
        company,
        email,
        phone,
        website,
        style,
      ];

  @override
  String toString() {
    return 'BusinessCard(id: $id, name: $name, title: $title, company: $company)';
  }

  // Private validation methods
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    return phoneRegex.hasMatch(phone) && phone.length >= 10;
  }

  bool _isValidWebsite(String website) {
    // Simple domain validation
    return website.isNotEmpty && 
           (website.contains('.') || website.startsWith('http'));
  }
}

/// Factory class for creating business card entities
class BusinessCardFactory {
  /// Create a business card with generated ID
  static BusinessCard create({
    required String name,
    required String title,
    required String company,
    required String email,
    required String phone,
    required String website,
    required BusinessCardStyle style,
  }) {
    return BusinessCard(
      id: _generateId(),
      name: name,
      title: title,
      company: company,
      email: email,
      phone: phone,
      website: website,
      style: style,
    );
  }

  /// Create a sample business card for testing/demo purposes
  static BusinessCard createSample({
    String? name,
    BusinessCardStyle? style,
  }) {
    return BusinessCard(
      id: _generateId(),
      name: name ?? 'John Doe',
      title: 'Software Developer',
      company: 'Tech Company Inc.',
      email: 'john@techcompany.com',
      phone: '+1 (555) 123-4567',
      website: 'johndoe.dev',
      style: style ?? BusinessCardStyle.modern,
    );
  }

  /// Generate a unique ID for business cards
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}