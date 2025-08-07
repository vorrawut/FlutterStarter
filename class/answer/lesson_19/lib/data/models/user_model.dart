import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../core/constants/firebase_constants.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String displayName,
    String? photoURL,
    @Default('') String bio,
    String? website,
    String? location,
    @Default([]) List<String> interests,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @Default(0) int postsCount,
    @Default(true) bool isPublic,
    @Default(true) bool isActive,
    @Default(false) bool isVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSeenAt,
    Map<String, dynamic>? settings,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      id: snapshot.id,
      email: data[FirebaseConstants.userEmailField] ?? '',
      displayName: data[FirebaseConstants.userDisplayNameField] ?? 
                   FirebaseConstants.defaultUserDisplayName,
      photoURL: data[FirebaseConstants.userPhotoURLField],
      bio: data[FirebaseConstants.userBioField] ?? 
           FirebaseConstants.defaultUserBio,
      website: data[FirebaseConstants.userWebsiteField],
      location: data[FirebaseConstants.userLocationField],
      interests: List<String>.from(data[FirebaseConstants.userInterestsField] ?? []),
      followersCount: data[FirebaseConstants.userFollowersCountField] ?? 0,
      followingCount: data[FirebaseConstants.userFollowingCountField] ?? 0,
      postsCount: data[FirebaseConstants.userPostsCountField] ?? 0,
      isPublic: data[FirebaseConstants.userIsPublicField] ?? 
                FirebaseConstants.defaultIsPublicProfile,
      isActive: data[FirebaseConstants.userIsActiveField] ?? true,
      isVerified: data[FirebaseConstants.userIsVerifiedField] ?? false,
      createdAt: (data[FirebaseConstants.userCreatedAtField] as Timestamp).toDate(),
      updatedAt: (data[FirebaseConstants.userUpdatedAtField] as Timestamp).toDate(),
      lastSeenAt: data[FirebaseConstants.userLastSeenAtField] != null 
          ? (data[FirebaseConstants.userLastSeenAtField] as Timestamp).toDate()
          : null,
      settings: data[FirebaseConstants.userSettingsField],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirebaseConstants.userEmailField: email,
      FirebaseConstants.userDisplayNameField: displayName,
      FirebaseConstants.userPhotoURLField: photoURL,
      FirebaseConstants.userBioField: bio,
      FirebaseConstants.userWebsiteField: website,
      FirebaseConstants.userLocationField: location,
      FirebaseConstants.userInterestsField: interests,
      FirebaseConstants.userFollowersCountField: followersCount,
      FirebaseConstants.userFollowingCountField: followingCount,
      FirebaseConstants.userPostsCountField: postsCount,
      FirebaseConstants.userIsPublicField: isPublic,
      FirebaseConstants.userIsActiveField: isActive,
      FirebaseConstants.userIsVerifiedField: isVerified,
      FirebaseConstants.userCreatedAtField: Timestamp.fromDate(createdAt),
      FirebaseConstants.userUpdatedAtField: Timestamp.fromDate(updatedAt),
      FirebaseConstants.userLastSeenAtField: lastSeenAt != null 
          ? Timestamp.fromDate(lastSeenAt!)
          : null,
      FirebaseConstants.userSettingsField: settings,
    };
  }

  factory UserModel.fromFirebaseUser(auth.User firebaseUser) {
    final now = DateTime.now();
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? 
                   FirebaseConstants.defaultUserDisplayName,
      photoURL: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? now,
      updatedAt: now,
      lastSeenAt: now,
      settings: _defaultSettings(),
    );
  }

  static Map<String, dynamic> _defaultSettings() {
    return {
      FirebaseConstants.settingsNotificationsEnabled: true,
      FirebaseConstants.settingsEmailNotifications: true,
      FirebaseConstants.settingsPushNotifications: true,
      FirebaseConstants.settingsPrivateAccount: false,
      FirebaseConstants.settingsShowEmail: false,
      FirebaseConstants.settingsShowLastSeen: true,
      FirebaseConstants.settingsThemeMode: 'system',
      FirebaseConstants.settingsLanguage: 'en',
    };
  }
}

extension UserModelExtensions on UserModel {
  // Business logic getters
  bool get hasProfileImage => photoURL != null && photoURL!.isNotEmpty;
  bool get hasBio => bio.isNotEmpty;
  bool get hasWebsite => website != null && website!.isNotEmpty;
  bool get hasLocation => location != null && location!.isNotEmpty;
  bool get hasInterests => interests.isNotEmpty;
  bool get hasFollowers => followersCount > 0;
  bool get hasFollowing => followingCount > 0;
  bool get hasPosts => postsCount > 0;
  bool get isOnline => lastSeenAt != null && 
                      DateTime.now().difference(lastSeenAt!).inMinutes < 5;
  
  // Profile completion score (0-100)
  int get profileCompletionScore {
    int score = 0;
    
    // Basic info (50 points)
    if (displayName.isNotEmpty) score += 20;
    if (hasProfileImage) score += 15;
    if (hasBio) score += 15;
    
    // Additional info (30 points)
    if (hasWebsite) score += 10;
    if (hasLocation) score += 10;
    if (hasInterests) score += 10;
    
    // Social activity (20 points)
    if (hasFollowing) score += 10;
    if (hasPosts) score += 10;
    
    return score;
  }
  
  // Time since creation
  Duration get accountAge => DateTime.now().difference(createdAt);
  
  // Time since last activity
  Duration get timeSinceLastSeen => lastSeenAt != null 
      ? DateTime.now().difference(lastSeenAt!)
      : Duration.zero;
  
  // Display helpers
  String get displayLastSeen {
    if (lastSeenAt == null) return 'Never';
    
    final difference = timeSinceLastSeen;
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    if (difference.inDays < 30) return '${difference.inDays ~/ 7}w ago';
    
    return '${difference.inDays ~/ 30}mo ago';
  }
  
  String get followersDisplayText {
    if (followersCount == 0) return 'No followers';
    if (followersCount == 1) return '1 follower';
    if (followersCount < 1000) return '$followersCount followers';
    if (followersCount < 1000000) {
      return '${(followersCount / 1000).toStringAsFixed(1)}K followers';
    }
    return '${(followersCount / 1000000).toStringAsFixed(1)}M followers';
  }
  
  String get followingDisplayText {
    if (followingCount == 0) return 'Not following anyone';
    if (followingCount == 1) return 'Following 1 person';
    if (followingCount < 1000) return 'Following $followingCount';
    if (followingCount < 1000000) {
      return 'Following ${(followingCount / 1000).toStringAsFixed(1)}K';
    }
    return 'Following ${(followingCount / 1000000).toStringAsFixed(1)}M';
  }
  
  String get postsDisplayText {
    if (postsCount == 0) return 'No posts';
    if (postsCount == 1) return '1 post';
    if (postsCount < 1000) return '$postsCount posts';
    if (postsCount < 1000000) {
      return '${(postsCount / 1000).toStringAsFixed(1)}K posts';
    }
    return '${(postsCount / 1000000).toStringAsFixed(1)}M posts';
  }
  
  // Settings helpers
  bool getSettingValue(String key, {bool defaultValue = false}) {
    return settings?[key] ?? defaultValue;
  }
  
  UserModel updateSetting(String key, dynamic value) {
    final newSettings = Map<String, dynamic>.from(settings ?? {});
    newSettings[key] = value;
    return copyWith(
      settings: newSettings,
      updatedAt: DateTime.now(),
    );
  }
  
  // Update helpers
  UserModel updateLastSeen() {
    return copyWith(lastSeenAt: DateTime.now());
  }
  
  UserModel incrementFollowersCount() {
    return copyWith(
      followersCount: followersCount + 1,
      updatedAt: DateTime.now(),
    );
  }
  
  UserModel decrementFollowersCount() {
    return copyWith(
      followersCount: followersCount > 0 ? followersCount - 1 : 0,
      updatedAt: DateTime.now(),
    );
  }
  
  UserModel incrementFollowingCount() {
    return copyWith(
      followingCount: followingCount + 1,
      updatedAt: DateTime.now(),
    );
  }
  
  UserModel decrementFollowingCount() {
    return copyWith(
      followingCount: followingCount > 0 ? followingCount - 1 : 0,
      updatedAt: DateTime.now(),
    );
  }
  
  UserModel incrementPostsCount() {
    return copyWith(
      postsCount: postsCount + 1,
      updatedAt: DateTime.now(),
    );
  }
  
  UserModel decrementPostsCount() {
    return copyWith(
      postsCount: postsCount > 0 ? postsCount - 1 : 0,
      updatedAt: DateTime.now(),
    );
  }
}
