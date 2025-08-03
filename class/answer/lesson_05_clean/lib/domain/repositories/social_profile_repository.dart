import '../entities/social_profile.dart';

/// Repository interface for social profile operations
/// Following clean architecture principles, this defines the contract
/// without implementing the actual data operations
abstract class SocialProfileRepository {
  /// Get all social profiles
  Future<List<SocialProfile>> getAllProfiles();

  /// Get a social profile by ID
  Future<SocialProfile?> getProfileById(String id);

  /// Get a social profile by username
  Future<SocialProfile?> getProfileByUsername(String username);

  /// Create a new social profile
  Future<SocialProfile> createProfile(SocialProfile profile);

  /// Update an existing social profile
  Future<SocialProfile> updateProfile(SocialProfile profile);

  /// Delete a social profile by ID
  Future<void> deleteProfile(String id);

  /// Follow a user (update follower count)
  Future<SocialProfile> followUser(String profileId);

  /// Unfollow a user (update follower count)
  Future<SocialProfile> unfollowUser(String profileId);

  /// Search profiles by name or username
  Future<List<SocialProfile>> searchProfiles(String query);

  /// Get trending profiles (by follower count or engagement)
  Future<List<SocialProfile>> getTrendingProfiles({int limit = 10});

  /// Get verified profiles
  Future<List<SocialProfile>> getVerifiedProfiles();

  /// Get profiles by activity level
  Future<List<SocialProfile>> getProfilesByActivityLevel(
    ProfileActivityLevel activityLevel,
  );

  /// Validate profile data
  Future<bool> validateProfile(SocialProfile profile);

  /// Get sample social profiles for demo/testing
  Future<List<SocialProfile>> getSampleProfiles();

  /// Get profile analytics/statistics
  Future<ProfileAnalytics> getProfileAnalytics(String profileId);
}

/// Analytics data for a social profile
class ProfileAnalytics {
  final String profileId;
  final double engagementRate;
  final int dailyGrowth;
  final int weeklyGrowth;
  final int monthlyGrowth;
  final Map<String, int> demographicData;
  final List<String> topHashtags;
  final DateTime lastUpdated;

  const ProfileAnalytics({
    required this.profileId,
    required this.engagementRate,
    required this.dailyGrowth,
    required this.weeklyGrowth,
    required this.monthlyGrowth,
    required this.demographicData,
    required this.topHashtags,
    required this.lastUpdated,
  });

  /// Get growth trend based on daily, weekly, monthly data
  GrowthTrend get growthTrend {
    if (monthlyGrowth > 100) return GrowthTrend.rapid;
    if (monthlyGrowth > 50) return GrowthTrend.strong;
    if (monthlyGrowth > 10) return GrowthTrend.steady;
    if (monthlyGrowth > 0) return GrowthTrend.slow;
    return GrowthTrend.declining;
  }

  /// Get engagement level based on rate
  EngagementLevel get engagementLevel {
    if (engagementRate > 10.0) return EngagementLevel.excellent;
    if (engagementRate > 5.0) return EngagementLevel.good;
    if (engagementRate > 2.0) return EngagementLevel.average;
    if (engagementRate > 0.5) return EngagementLevel.low;
    return EngagementLevel.poor;
  }
}

/// Growth trend enumeration
enum GrowthTrend {
  rapid('Rapid Growth'),
  strong('Strong Growth'),
  steady('Steady Growth'),
  slow('Slow Growth'),
  declining('Declining');

  const GrowthTrend(this.displayName);
  final String displayName;
}

/// Engagement level enumeration
enum EngagementLevel {
  excellent('Excellent'),
  good('Good'),
  average('Average'),
  low('Low'),
  poor('Poor');

  const EngagementLevel(this.displayName);
  final String displayName;
}