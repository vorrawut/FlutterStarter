// lib/core/store_optimization/store_listing_manager.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';

/// Comprehensive store listing and optimization management
/// Handles app store optimization, metadata management, and analytics
class StoreListingManager {
  static final StoreListingManager _instance = StoreListingManager._internal();
  factory StoreListingManager() => _instance;
  StoreListingManager._internal();

  static const String _prefsKey = 'store_listing_config';
  late SharedPreferences _prefs;
  late PackageInfo _packageInfo;
  
  bool _isInitialized = false;
  StoreListingConfig? _currentConfig;

  /// Initialize the store listing manager
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _prefs = await SharedPreferences.getInstance();
      _packageInfo = await PackageInfo.fromPlatform();
      await _loadConfiguration();
      _isInitialized = true;
      
      debugPrint('✅ Store Listing Manager initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize Store Listing Manager: $e');
    }
  }

  /// Load store listing configuration
  Future<void> _loadConfiguration() async {
    try {
      final configJson = _prefs.getString(_prefsKey);
      if (configJson != null) {
        final configMap = jsonDecode(configJson) as Map<String, dynamic>;
        _currentConfig = StoreListingConfig.fromJson(configMap);
      } else {
        _currentConfig = _getDefaultConfiguration();
        await _saveConfiguration();
      }
    } catch (e) {
      debugPrint('Error loading store configuration: $e');
      _currentConfig = _getDefaultConfiguration();
    }
  }

  /// Save store listing configuration
  Future<void> _saveConfiguration() async {
    if (_currentConfig != null) {
      final configJson = jsonEncode(_currentConfig!.toJson());
      await _prefs.setString(_prefsKey, configJson);
    }
  }

  /// Get default store listing configuration
  StoreListingConfig _getDefaultConfiguration() {
    return StoreListingConfig(
      appName: 'ConnectPro Ultimate',
      shortDescription: 'Advanced social networking with real-time features',
      fullDescription: _getDefaultFullDescription(),
      keywords: _getDefaultKeywords(),
      category: StoreCategory.social,
      contentRating: ContentRating.teen,
      targetAudience: TargetAudience.youngAdults,
      supportedLanguages: ['en', 'es', 'fr', 'de', 'ja', 'zh'],
      screenshots: _getDefaultScreenshots(),
      featureGraphic: 'assets/store/feature_graphic.png',
      appIcon: 'assets/images/app_icon.png',
      privacyPolicyUrl: 'https://connectpro.app/privacy',
      termsOfServiceUrl: 'https://connectpro.app/terms',
      supportUrl: 'https://connectpro.app/support',
      marketingUrl: 'https://connectpro.app',
      pricing: PricingModel.free,
      inAppPurchases: true,
      advertisements: false,
      releaseNotes: _getDefaultReleaseNotes(),
      lastUpdated: DateTime.now(),
    );
  }

  /// Get current store listing configuration
  StoreListingConfig? get currentConfig => _currentConfig;

  /// Update store listing configuration
  Future<void> updateConfiguration(StoreListingConfig config) async {
    _currentConfig = config;
    await _saveConfiguration();
    debugPrint('Store listing configuration updated');
  }

  /// Generate store listing for Google Play Store
  GooglePlayStoreListing generateGooglePlayListing() {
    if (_currentConfig == null) {
      throw Exception('Store configuration not initialized');
    }

    return GooglePlayStoreListing(
      title: _currentConfig!.appName,
      shortDescription: _currentConfig!.shortDescription,
      fullDescription: _formatFullDescriptionForGooglePlay(),
      keywords: _currentConfig!.keywords.join(', '),
      category: _mapCategoryToGooglePlay(_currentConfig!.category),
      contentRating: _mapContentRatingToGooglePlay(_currentConfig!.contentRating),
      targetAudience: _mapTargetAudienceToGooglePlay(_currentConfig!.targetAudience),
      screenshots: _currentConfig!.screenshots,
      featureGraphic: _currentConfig!.featureGraphic,
      appIcon: _currentConfig!.appIcon,
      privacyPolicyUrl: _currentConfig!.privacyPolicyUrl,
      inAppProducts: _currentConfig!.inAppPurchases,
      containsAds: _currentConfig!.advertisements,
      releaseNotes: _currentConfig!.releaseNotes,
      versionName: _packageInfo.version,
      versionCode: _packageInfo.buildNumber,
    );
  }

  /// Generate store listing for Apple App Store
  AppStoreListing generateAppStoreListing() {
    if (_currentConfig == null) {
      throw Exception('Store configuration not initialized');
    }

    return AppStoreListing(
      name: _currentConfig!.appName,
      subtitle: _getAppStoreSubtitle(),
      description: _formatFullDescriptionForAppStore(),
      keywords: _currentConfig!.keywords.take(100).join(','), // App Store limit
      category: _mapCategoryToAppStore(_currentConfig!.category),
      contentRating: _mapContentRatingToAppStore(_currentConfig!.contentRating),
      screenshots: _currentConfig!.screenshots,
      appIcon: _currentConfig!.appIcon,
      privacyPolicyUrl: _currentConfig!.privacyPolicyUrl,
      supportUrl: _currentConfig!.supportUrl,
      marketingUrl: _currentConfig!.marketingUrl,
      releaseNotes: _currentConfig!.releaseNotes,
      version: _packageInfo.version,
      buildNumber: _packageInfo.buildNumber,
      inAppPurchases: _currentConfig!.inAppPurchases,
    );
  }

  /// Optimize listing for search keywords
  Future<void> optimizeForKeywords(List<String> targetKeywords) async {
    if (_currentConfig == null) return;

    // Analyze current keyword density
    final keywordAnalysis = _analyzeKeywordDensity(targetKeywords);
    
    // Optimize description and keywords
    final optimizedKeywords = _optimizeKeywords(targetKeywords, keywordAnalysis);
    final optimizedDescription = _optimizeDescription(targetKeywords);

    // Update configuration
    final updatedConfig = _currentConfig!.copyWith(
      keywords: optimizedKeywords,
      fullDescription: optimizedDescription,
      lastUpdated: DateTime.now(),
    );

    await updateConfiguration(updatedConfig);
    debugPrint('Store listing optimized for keywords: ${targetKeywords.join(', ')}');
  }

  /// Analyze keyword density in current listing
  Map<String, double> _analyzeKeywordDensity(List<String> keywords) {
    final analysis = <String, double>{};
    final fullText = '${_currentConfig!.appName} ${_currentConfig!.shortDescription} ${_currentConfig!.fullDescription}'.toLowerCase();
    final words = fullText.split(RegExp(r'\W+'));
    final totalWords = words.length;

    for (final keyword in keywords) {
      final keywordLower = keyword.toLowerCase();
      final count = words.where((word) => word.contains(keywordLower)).length;
      analysis[keyword] = count / totalWords;
    }

    return analysis;
  }

  /// Optimize keywords for app store algorithms
  List<String> _optimizeKeywords(List<String> targetKeywords, Map<String, double> currentDensity) {
    final optimizedKeywords = <String>[];
    
    // Add high-priority keywords first
    optimizedKeywords.addAll(targetKeywords.take(10));
    
    // Add related keywords for better discoverability
    optimizedKeywords.addAll([
      'social network',
      'chat messaging',
      'real-time communication',
      'video calls',
      'group chat',
      'social media',
      'instant messaging',
      'community',
      'friends',
      'networking',
    ]);

    // Remove duplicates and limit to platform constraints
    return optimizedKeywords.toSet().take(50).toList();
  }

  /// Optimize description for search algorithms
  String _optimizeDescription(List<String> keywords) {
    return '''
🚀 ConnectPro Ultimate - Advanced Social Networking

ConnectPro Ultimate is the premier social networking platform designed for modern communication and community building. Experience seamless real-time messaging, video calls, and social interactions in a beautifully designed interface.

✨ KEY FEATURES:
• Real-time Chat & Messaging - Instant communication with friends and groups
• Video & Voice Calls - Crystal-clear calls with advanced features
• Social Feed - Share moments and discover content from your network
• Group Communities - Create and join communities around your interests
• Privacy & Security - End-to-end encryption and advanced privacy controls
• Cross-Platform Sync - Seamless experience across all your devices

🌟 PREMIUM SOCIAL EXPERIENCE:
• Advanced chat features with rich media support
• Smart notifications and message organization
• Customizable themes and personalization options
• Professional networking tools and features
• Enhanced privacy settings and security options

💡 PERFECT FOR:
• Social networking enthusiasts
• Professional communicators
• Community builders and organizers
• Privacy-conscious users
• Modern messaging enthusiasts

🔒 PRIVACY & SECURITY:
ConnectPro Ultimate prioritizes your privacy with end-to-end encryption, secure data handling, and transparent privacy policies. Your data is protected with industry-leading security measures.

📱 SEAMLESS EXPERIENCE:
Enjoy a smooth, intuitive interface designed for modern users. Our app provides excellent performance, beautiful animations, and accessibility features for all users.

Download ConnectPro Ultimate today and experience the future of social networking and communication!

Keywords: ${keywords.take(10).join(', ')}
''';
  }

  /// Format description for Google Play Store
  String _formatFullDescriptionForGooglePlay() {
    // Google Play allows up to 4000 characters
    final description = _currentConfig!.fullDescription;
    return description.length > 4000 ? description.substring(0, 4000) : description;
  }

  /// Format description for Apple App Store
  String _formatFullDescriptionForAppStore() {
    // App Store allows up to 4000 characters
    final description = _currentConfig!.fullDescription;
    return description.length > 4000 ? description.substring(0, 4000) : description;
  }

  /// Get App Store subtitle
  String _getAppStoreSubtitle() {
    return 'Real-time Social Networking';
  }

  /// Map category to Google Play Store format
  String _mapCategoryToGooglePlay(StoreCategory category) {
    switch (category) {
      case StoreCategory.social:
        return 'SOCIAL';
      case StoreCategory.communication:
        return 'COMMUNICATION';
      case StoreCategory.productivity:
        return 'PRODUCTIVITY';
      case StoreCategory.lifestyle:
        return 'LIFESTYLE';
      case StoreCategory.entertainment:
        return 'ENTERTAINMENT';
      case StoreCategory.business:
        return 'BUSINESS';
    }
  }

  /// Map category to Apple App Store format
  String _mapCategoryToAppStore(StoreCategory category) {
    switch (category) {
      case StoreCategory.social:
        return 'Social Networking';
      case StoreCategory.communication:
        return 'Social Networking';
      case StoreCategory.productivity:
        return 'Productivity';
      case StoreCategory.lifestyle:
        return 'Lifestyle';
      case StoreCategory.entertainment:
        return 'Entertainment';
      case StoreCategory.business:
        return 'Business';
    }
  }

  /// Map content rating to Google Play Store format
  String _mapContentRatingToGooglePlay(ContentRating rating) {
    switch (rating) {
      case ContentRating.everyone:
        return 'Everyone';
      case ContentRating.everyone10Plus:
        return 'Everyone 10+';
      case ContentRating.teen:
        return 'Teen';
      case ContentRating.mature:
        return 'Mature 17+';
    }
  }

  /// Map content rating to Apple App Store format
  String _mapContentRatingToAppStore(ContentRating rating) {
    switch (rating) {
      case ContentRating.everyone:
        return '4+';
      case ContentRating.everyone10Plus:
        return '9+';
      case ContentRating.teen:
        return '12+';
      case ContentRating.mature:
        return '17+';
    }
  }

  /// Map target audience to Google Play Store format
  String _mapTargetAudienceToGooglePlay(TargetAudience audience) {
    switch (audience) {
      case TargetAudience.children:
        return 'Ages 5-11';
      case TargetAudience.teens:
        return 'Ages 13-17';
      case TargetAudience.youngAdults:
        return 'Ages 18-24';
      case TargetAudience.adults:
        return 'Ages 25-64';
      case TargetAudience.seniors:
        return 'Ages 65+';
    }
  }

  /// Get default keywords
  List<String> _getDefaultKeywords() {
    return [
      'social networking',
      'chat',
      'messaging',
      'video calls',
      'real-time',
      'communication',
      'social media',
      'friends',
      'community',
      'instant messaging',
      'group chat',
      'video conference',
      'social app',
      'networking',
      'connect',
    ];
  }

  /// Get default screenshots
  List<String> _getDefaultScreenshots() {
    return [
      'assets/screenshots/chat_screen.png',
      'assets/screenshots/social_feed.png',
      'assets/screenshots/video_call.png',
      'assets/screenshots/profile_screen.png',
      'assets/screenshots/groups_screen.png',
    ];
  }

  /// Get default full description
  String _getDefaultFullDescription() {
    return '''
🚀 ConnectPro Ultimate - The Future of Social Networking

Experience the next generation of social networking with ConnectPro Ultimate. Our cutting-edge platform combines real-time messaging, video calling, and social feed features in a beautifully designed, user-friendly interface.

✨ POWERFUL FEATURES:
• Real-time Chat & Messaging with rich media support
• High-quality Video & Voice Calls with advanced features
• Dynamic Social Feed with intelligent content discovery
• Secure Group Communities and private conversations
• End-to-end Encryption for maximum privacy and security
• Cross-platform Synchronization across all devices
• Smart Notifications with customizable preferences
• Beautiful Themes and personalization options

🌟 ADVANCED CAPABILITIES:
• Professional networking tools for business users
• Advanced search and discovery features
• Rich media sharing with photos, videos, and documents
• Location sharing and check-in features
• Integration with calendar and productivity apps
• Offline message support and sync when connected
• Advanced privacy controls and blocking features
• Analytics and insights for content creators

💼 PERFECT FOR:
• Social networking enthusiasts seeking premium features
• Business professionals requiring secure communication
• Community organizers and group administrators
• Content creators and influencers
• Privacy-conscious users demanding security
• International users with multi-language support

🔒 PRIVACY & SECURITY FIRST:
Your privacy is our priority. ConnectPro Ultimate features industry-leading encryption, secure data handling, transparent privacy policies, and gives you complete control over your data and privacy settings.

🌍 GLOBAL CONNECTIVITY:
Connect with people worldwide through our robust, scalable platform. Enjoy seamless communication regardless of location, with optimized performance for all network conditions.

📱 SEAMLESS USER EXPERIENCE:
Our intuitive interface is designed for users of all ages and technical backgrounds. Enjoy smooth animations, accessibility features, and consistent performance across iOS and Android platforms.

Download ConnectPro Ultimate today and join millions of users experiencing the future of social networking and real-time communication!
''';
  }

  /// Get default release notes
  String _getDefaultReleaseNotes() {
    return '''
🚀 What's New in ConnectPro Ultimate

✨ New Features:
• Enhanced video calling with improved quality
• Advanced message search and filtering
• New themes and customization options
• Improved group management features

🔧 Improvements:
• Faster app startup and performance
• Better notification handling
• Enhanced security and privacy features
• UI/UX improvements throughout the app

🐛 Bug Fixes:
• Resolved occasional connection issues
• Fixed message synchronization problems
• Improved stability and reliability
• Various minor bug fixes and optimizations

We're constantly working to improve your ConnectPro Ultimate experience. Thank you for your feedback and continued support!
''';
  }
}

/// Store listing configuration model
class StoreListingConfig {
  final String appName;
  final String shortDescription;
  final String fullDescription;
  final List<String> keywords;
  final StoreCategory category;
  final ContentRating contentRating;
  final TargetAudience targetAudience;
  final List<String> supportedLanguages;
  final List<String> screenshots;
  final String featureGraphic;
  final String appIcon;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String supportUrl;
  final String marketingUrl;
  final PricingModel pricing;
  final bool inAppPurchases;
  final bool advertisements;
  final String releaseNotes;
  final DateTime lastUpdated;

  const StoreListingConfig({
    required this.appName,
    required this.shortDescription,
    required this.fullDescription,
    required this.keywords,
    required this.category,
    required this.contentRating,
    required this.targetAudience,
    required this.supportedLanguages,
    required this.screenshots,
    required this.featureGraphic,
    required this.appIcon,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.supportUrl,
    required this.marketingUrl,
    required this.pricing,
    required this.inAppPurchases,
    required this.advertisements,
    required this.releaseNotes,
    required this.lastUpdated,
  });

  StoreListingConfig copyWith({
    String? appName,
    String? shortDescription,
    String? fullDescription,
    List<String>? keywords,
    StoreCategory? category,
    ContentRating? contentRating,
    TargetAudience? targetAudience,
    List<String>? supportedLanguages,
    List<String>? screenshots,
    String? featureGraphic,
    String? appIcon,
    String? privacyPolicyUrl,
    String? termsOfServiceUrl,
    String? supportUrl,
    String? marketingUrl,
    PricingModel? pricing,
    bool? inAppPurchases,
    bool? advertisements,
    String? releaseNotes,
    DateTime? lastUpdated,
  }) {
    return StoreListingConfig(
      appName: appName ?? this.appName,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      keywords: keywords ?? this.keywords,
      category: category ?? this.category,
      contentRating: contentRating ?? this.contentRating,
      targetAudience: targetAudience ?? this.targetAudience,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      screenshots: screenshots ?? this.screenshots,
      featureGraphic: featureGraphic ?? this.featureGraphic,
      appIcon: appIcon ?? this.appIcon,
      privacyPolicyUrl: privacyPolicyUrl ?? this.privacyPolicyUrl,
      termsOfServiceUrl: termsOfServiceUrl ?? this.termsOfServiceUrl,
      supportUrl: supportUrl ?? this.supportUrl,
      marketingUrl: marketingUrl ?? this.marketingUrl,
      pricing: pricing ?? this.pricing,
      inAppPurchases: inAppPurchases ?? this.inAppPurchases,
      advertisements: advertisements ?? this.advertisements,
      releaseNotes: releaseNotes ?? this.releaseNotes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'keywords': keywords,
      'category': category.toString(),
      'contentRating': contentRating.toString(),
      'targetAudience': targetAudience.toString(),
      'supportedLanguages': supportedLanguages,
      'screenshots': screenshots,
      'featureGraphic': featureGraphic,
      'appIcon': appIcon,
      'privacyPolicyUrl': privacyPolicyUrl,
      'termsOfServiceUrl': termsOfServiceUrl,
      'supportUrl': supportUrl,
      'marketingUrl': marketingUrl,
      'pricing': pricing.toString(),
      'inAppPurchases': inAppPurchases,
      'advertisements': advertisements,
      'releaseNotes': releaseNotes,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory StoreListingConfig.fromJson(Map<String, dynamic> json) {
    return StoreListingConfig(
      appName: json['appName'] as String,
      shortDescription: json['shortDescription'] as String,
      fullDescription: json['fullDescription'] as String,
      keywords: List<String>.from(json['keywords']),
      category: _parseStoreCategory(json['category'] as String),
      contentRating: _parseContentRating(json['contentRating'] as String),
      targetAudience: _parseTargetAudience(json['targetAudience'] as String),
      supportedLanguages: List<String>.from(json['supportedLanguages']),
      screenshots: List<String>.from(json['screenshots']),
      featureGraphic: json['featureGraphic'] as String,
      appIcon: json['appIcon'] as String,
      privacyPolicyUrl: json['privacyPolicyUrl'] as String,
      termsOfServiceUrl: json['termsOfServiceUrl'] as String,
      supportUrl: json['supportUrl'] as String,
      marketingUrl: json['marketingUrl'] as String,
      pricing: _parsePricingModel(json['pricing'] as String),
      inAppPurchases: json['inAppPurchases'] as bool,
      advertisements: json['advertisements'] as bool,
      releaseNotes: json['releaseNotes'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  static StoreCategory _parseStoreCategory(String value) {
    return StoreCategory.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => StoreCategory.social,
    );
  }

  static ContentRating _parseContentRating(String value) {
    return ContentRating.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => ContentRating.teen,
    );
  }

  static TargetAudience _parseTargetAudience(String value) {
    return TargetAudience.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => TargetAudience.youngAdults,
    );
  }

  static PricingModel _parsePricingModel(String value) {
    return PricingModel.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => PricingModel.free,
    );
  }
}

/// Google Play Store listing model
class GooglePlayStoreListing {
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String keywords;
  final String category;
  final String contentRating;
  final String targetAudience;
  final List<String> screenshots;
  final String featureGraphic;
  final String appIcon;
  final String privacyPolicyUrl;
  final bool inAppProducts;
  final bool containsAds;
  final String releaseNotes;
  final String versionName;
  final String versionCode;

  const GooglePlayStoreListing({
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.keywords,
    required this.category,
    required this.contentRating,
    required this.targetAudience,
    required this.screenshots,
    required this.featureGraphic,
    required this.appIcon,
    required this.privacyPolicyUrl,
    required this.inAppProducts,
    required this.containsAds,
    required this.releaseNotes,
    required this.versionName,
    required this.versionCode,
  });
}

/// Apple App Store listing model
class AppStoreListing {
  final String name;
  final String subtitle;
  final String description;
  final String keywords;
  final String category;
  final String contentRating;
  final List<String> screenshots;
  final String appIcon;
  final String privacyPolicyUrl;
  final String supportUrl;
  final String marketingUrl;
  final String releaseNotes;
  final String version;
  final String buildNumber;
  final bool inAppPurchases;

  const AppStoreListing({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.keywords,
    required this.category,
    required this.contentRating,
    required this.screenshots,
    required this.appIcon,
    required this.privacyPolicyUrl,
    required this.supportUrl,
    required this.marketingUrl,
    required this.releaseNotes,
    required this.version,
    required this.buildNumber,
    required this.inAppPurchases,
  });
}

/// Store category enumeration
enum StoreCategory {
  social,
  communication,
  productivity,
  lifestyle,
  entertainment,
  business,
}

/// Content rating enumeration
enum ContentRating {
  everyone,
  everyone10Plus,
  teen,
  mature,
}

/// Target audience enumeration
enum TargetAudience {
  children,
  teens,
  youngAdults,
  adults,
  seniors,
}

/// Pricing model enumeration
enum PricingModel {
  free,
  paid,
  freemium,
  subscription,
}

