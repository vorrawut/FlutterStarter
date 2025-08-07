class FirebaseConstants {
  // Collection names
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String commentsCollection = 'comments';
  static const String likesCollection = 'likes';
  static const String followsCollection = 'follows';
  static const String notificationsCollection = 'notifications';
  static const String analyticsCollection = 'analytics';
  static const String reportsCollection = 'reports';
  
  // Subcollection names
  static const String userPostsSubcollection = 'posts';
  static const String userFollowersSubcollection = 'followers';
  static const String userFollowingSubcollection = 'following';
  static const String postCommentsSubcollection = 'comments';
  static const String postLikesSubcollection = 'likes';
  static const String userNotificationsSubcollection = 'notifications';
  
  // Document field names
  // User fields
  static const String userIdField = 'id';
  static const String userEmailField = 'email';
  static const String userDisplayNameField = 'displayName';
  static const String userPhotoURLField = 'photoURL';
  static const String userBioField = 'bio';
  static const String userWebsiteField = 'website';
  static const String userLocationField = 'location';
  static const String userInterestsField = 'interests';
  static const String userFollowersCountField = 'followersCount';
  static const String userFollowingCountField = 'followingCount';
  static const String userPostsCountField = 'postsCount';
  static const String userIsPublicField = 'isPublic';
  static const String userIsActiveField = 'isActive';
  static const String userIsVerifiedField = 'isVerified';
  static const String userCreatedAtField = 'createdAt';
  static const String userUpdatedAtField = 'updatedAt';
  static const String userLastSeenAtField = 'lastSeenAt';
  static const String userSettingsField = 'settings';
  
  // Post fields
  static const String postIdField = 'id';
  static const String postAuthorIdField = 'authorId';
  static const String postContentField = 'content';
  static const String postImageUrlsField = 'imageUrls';
  static const String postHashtagsField = 'hashtags';
  static const String postMentionsField = 'mentions';
  static const String postLikesCountField = 'likesCount';
  static const String postCommentsCountField = 'commentsCount';
  static const String postSharesCountField = 'sharesCount';
  static const String postVisibilityField = 'visibility';
  static const String postIsPinnedField = 'isPinned';
  static const String postAllowCommentsField = 'allowComments';
  static const String postAllowSharesField = 'allowShares';
  static const String postCreatedAtField = 'createdAt';
  static const String postUpdatedAtField = 'updatedAt';
  static const String postLocationField = 'location';
  static const String postMetadataField = 'metadata';
  
  // Comment fields
  static const String commentIdField = 'id';
  static const String commentPostIdField = 'postId';
  static const String commentAuthorIdField = 'authorId';
  static const String commentContentField = 'content';
  static const String commentLikesCountField = 'likesCount';
  static const String commentRepliesCountField = 'repliesCount';
  static const String commentParentCommentIdField = 'parentCommentId';
  static const String commentCreatedAtField = 'createdAt';
  static const String commentUpdatedAtField = 'updatedAt';
  static const String commentIsEditedField = 'isEdited';
  static const String commentIsDeletedField = 'isDeleted';
  
  // Like fields
  static const String likeIdField = 'id';
  static const String likeUserIdField = 'userId';
  static const String likeTargetIdField = 'targetId';
  static const String likeTargetTypeField = 'targetType';
  static const String likeCreatedAtField = 'createdAt';
  
  // Follow fields
  static const String followIdField = 'id';
  static const String followFollowerIdField = 'followerId';
  static const String followFollowingIdField = 'followingId';
  static const String followCreatedAtField = 'createdAt';
  static const String followIsActiveField = 'isActive';
  
  // Post visibility options
  static const String visibilityPublic = 'public';
  static const String visibilityFollowers = 'followers';
  static const String visibilityPrivate = 'private';
  
  // Like target types
  static const String likeTargetTypePost = 'post';
  static const String likeTargetTypeComment = 'comment';
  
  // User settings keys
  static const String settingsNotificationsEnabled = 'notificationsEnabled';
  static const String settingsEmailNotifications = 'emailNotifications';
  static const String settingsPushNotifications = 'pushNotifications';
  static const String settingsPrivateAccount = 'privateAccount';
  static const String settingsShowEmail = 'showEmail';
  static const String settingsShowLastSeen = 'showLastSeen';
  static const String settingsThemeMode = 'themeMode';
  static const String settingsLanguage = 'language';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int defaultCommentsPageSize = 10;
  static const int maxPageSize = 100;
  
  // Limits
  static const int maxPostContentLength = 2000;
  static const int maxCommentContentLength = 500;
  static const int maxBioLength = 160;
  static const int maxDisplayNameLength = 50;
  static const int maxHashtagsPerPost = 10;
  static const int maxMentionsPerPost = 10;
  static const int maxImagesPerPost = 4;
  
  // Cache durations
  static const Duration userProfileCacheDuration = Duration(minutes: 15);
  static const Duration postsCacheDuration = Duration(minutes: 5);
  static const Duration followersCacheDuration = Duration(minutes: 30);
  
  // Error messages
  static const String errorUserNotFound = 'User not found';
  static const String errorPostNotFound = 'Post not found';
  static const String errorCommentNotFound = 'Comment not found';
  static const String errorUnauthorized = 'Unauthorized access';
  static const String errorInvalidData = 'Invalid data provided';
  static const String errorNetworkUnavailable = 'Network unavailable';
  static const String errorServerError = 'Server error occurred';
  static const String errorRateLimited = 'Too many requests';
  
  // Analytics events
  static const String eventPostCreated = 'post_created';
  static const String eventPostLiked = 'post_liked';
  static const String eventPostShared = 'post_shared';
  static const String eventCommentCreated = 'comment_created';
  static const String eventUserFollowed = 'user_followed';
  static const String eventUserUnfollowed = 'user_unfollowed';
  static const String eventProfileViewed = 'profile_viewed';
  static const String eventSearchPerformed = 'search_performed';
  static const String eventFeedViewed = 'feed_viewed';
  
  // Storage paths
  static const String userProfileImagePath = 'users/{userId}/profile_images';
  static const String postImagePath = 'posts/{postId}/images';
  static const String tempImagePath = 'temp/{userId}';
  
  // Default values
  static const String defaultUserDisplayName = 'User';
  static const String defaultUserBio = '';
  static const String defaultPostVisibility = visibilityPublic;
  static const bool defaultAllowComments = true;
  static const bool defaultAllowShares = true;
  static const bool defaultIsPublicProfile = true;
  
  // Security rules helpers
  static const String securityRuleOwnerCheck = 'request.auth.uid == resource.data.authorId';
  static const String securityRuleAuthenticatedCheck = 'request.auth != null';
  static const String securityRuleEmailVerifiedCheck = 'request.auth.token.email_verified == true';
}
