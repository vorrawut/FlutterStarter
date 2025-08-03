import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Social profile entity representing a user's social media profile
class SocialProfile extends Equatable {
  final String id;
  final String name;
  final String username;
  final String bio;
  final int followers;
  final int following;
  final int posts;
  final bool isVerified;
  final Color profileColor;
  final String? avatarUrl;
  final DateTime? joinDate;

  const SocialProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.posts,
    required this.isVerified,
    required this.profileColor,
    this.avatarUrl,
    this.joinDate,
  });

  /// Create a copy of this profile with optional field updates
  SocialProfile copyWith({
    String? id,
    String? name,
    String? username,
    String? bio,
    int? followers,
    int? following,
    int? posts,
    bool? isVerified,
    Color? profileColor,
    String? avatarUrl,
    DateTime? joinDate,
  }) {
    return SocialProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      isVerified: isVerified ?? this.isVerified,
      profileColor: profileColor ?? this.profileColor,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinDate: joinDate ?? this.joinDate,
    );
  }

  /// Update follower count (for follow/unfollow actions)
  SocialProfile updateFollowerCount(int newCount) {
    return copyWith(followers: newCount);
  }

  /// Increment follower count
  SocialProfile incrementFollowers() {
    return copyWith(followers: followers + 1);
  }

  /// Decrement follower count
  SocialProfile decrementFollowers() {
    return copyWith(followers: followers > 0 ? followers - 1 : 0);
  }

  /// Validate profile data
  bool get isValid {
    return name.isNotEmpty &&
           username.isNotEmpty &&
           bio.isNotEmpty &&
           followers >= 0 &&
           following >= 0 &&
           posts >= 0 &&
           _isValidUsername(username);
  }

  /// Get initials from name for avatar display
  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.isEmpty) return '';
    if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
    return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
  }

  /// Get formatted follower count (e.g., 1.2K, 2.5M)
  String get formattedFollowerCount => _formatNumber(followers);

  /// Get formatted following count
  String get formattedFollowingCount => _formatNumber(following);

  /// Get formatted post count
  String get formattedPostCount => _formatNumber(posts);

  /// Get engagement rate estimate based on followers and posts
  double get estimatedEngagementRate {
    if (followers == 0 || posts == 0) return 0.0;
    // Simple engagement rate calculation (this would typically come from real data)
    final avgLikesPerPost = (followers * 0.03).round(); // Assume 3% engagement
    return (avgLikesPerPost / followers) * 100;
  }

  /// Get profile activity level based on posts and join date
  ProfileActivityLevel get activityLevel {
    if (joinDate == null) return ProfileActivityLevel.unknown;
    
    final daysSinceJoined = DateTime.now().difference(joinDate!).inDays;
    if (daysSinceJoined == 0) return ProfileActivityLevel.new_;
    
    final postsPerDay = posts / daysSinceJoined;
    
    if (postsPerDay >= 1.0) return ProfileActivityLevel.veryActive;
    if (postsPerDay >= 0.5) return ProfileActivityLevel.active;
    if (postsPerDay >= 0.1) return ProfileActivityLevel.moderate;
    return ProfileActivityLevel.inactive;
  }

  /// Get bio preview (limited characters)
  String getBioPreview({int maxLength = 100}) {
    if (bio.length <= maxLength) return bio;
    return '${bio.substring(0, maxLength)}...';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        bio,
        followers,
        following,
        posts,
        isVerified,
        profileColor,
        avatarUrl,
        joinDate,
      ];

  @override
  String toString() {
    return 'SocialProfile(id: $id, name: $name, username: $username, followers: $followers)';
  }

  // Private helper methods
  bool _isValidUsername(String username) {
    // Username should start with @ and contain only valid characters
    if (!username.startsWith('@')) return false;
    final usernameRegex = RegExp(r'^@[a-zA-Z0-9_]+$');
    return usernameRegex.hasMatch(username);
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

/// Profile activity level enumeration
enum ProfileActivityLevel {
  new_('New'),
  inactive('Inactive'),
  moderate('Moderate'),
  active('Active'),
  veryActive('Very Active'),
  unknown('Unknown');

  const ProfileActivityLevel(this.displayName);

  final String displayName;
}

/// Factory class for creating social profile entities
class SocialProfileFactory {
  /// Create a social profile with generated ID
  static SocialProfile create({
    required String name,
    required String username,
    required String bio,
    required int followers,
    required int following,
    required int posts,
    required bool isVerified,
    required Color profileColor,
    String? avatarUrl,
    DateTime? joinDate,
  }) {
    return SocialProfile(
      id: _generateId(),
      name: name,
      username: username.startsWith('@') ? username : '@$username',
      bio: bio,
      followers: followers,
      following: following,
      posts: posts,
      isVerified: isVerified,
      profileColor: profileColor,
      avatarUrl: avatarUrl,
      joinDate: joinDate ?? DateTime.now(),
    );
  }

  /// Create a sample social profile for testing/demo purposes
  static SocialProfile createSample({
    String? name,
    String? username,
    Color? profileColor,
  }) {
    return SocialProfile(
      id: _generateId(),
      name: name ?? 'Jane Smith',
      username: username ?? '@janesmith',
      bio: 'Flutter developer passionate about creating beautiful mobile experiences',
      followers: 12500,
      following: 890,
      posts: 156,
      isVerified: true,
      profileColor: profileColor ?? Colors.blue,
      joinDate: DateTime.now().subtract(const Duration(days: 365)),
    );
  }

  /// Create multiple sample profiles for demo
  static List<SocialProfile> createSampleProfiles() {
    return [
      createSample(
        name: 'Alex Rivera',
        username: '@alexcodes',
        profileColor: Colors.blue,
      ),
      createSample(
        name: 'Maya Patel',
        username: '@mayaui',
        profileColor: Colors.pink,
      ),
      createSample(
        name: 'David Kim',
        username: '@davidtech',
        profileColor: Colors.green,
      ),
    ];
  }

  /// Generate a unique ID for social profiles
  static String _generateId() {
    return 'profile_${DateTime.now().millisecondsSinceEpoch}';
  }
}