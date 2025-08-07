import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/constants/firebase_constants.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String authorId,
    required String content,
    @Default([]) List<String> imageUrls,
    @Default([]) List<String> hashtags,
    @Default([]) List<String> mentions,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(0) int sharesCount,
    @Default(FirebaseConstants.defaultPostVisibility) String visibility,
    @Default(false) bool isPinned,
    @Default(FirebaseConstants.defaultAllowComments) bool allowComments,
    @Default(FirebaseConstants.defaultAllowShares) bool allowShares,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? location,
    Map<String, dynamic>? metadata,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => 
      _$PostModelFromJson(json);

  factory PostModel.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return PostModel(
      id: snapshot.id,
      authorId: data[FirebaseConstants.postAuthorIdField] ?? '',
      content: data[FirebaseConstants.postContentField] ?? '',
      imageUrls: List<String>.from(data[FirebaseConstants.postImageUrlsField] ?? []),
      hashtags: List<String>.from(data[FirebaseConstants.postHashtagsField] ?? []),
      mentions: List<String>.from(data[FirebaseConstants.postMentionsField] ?? []),
      likesCount: data[FirebaseConstants.postLikesCountField] ?? 0,
      commentsCount: data[FirebaseConstants.postCommentsCountField] ?? 0,
      sharesCount: data[FirebaseConstants.postSharesCountField] ?? 0,
      visibility: data[FirebaseConstants.postVisibilityField] ?? 
                  FirebaseConstants.defaultPostVisibility,
      isPinned: data[FirebaseConstants.postIsPinnedField] ?? false,
      allowComments: data[FirebaseConstants.postAllowCommentsField] ?? 
                     FirebaseConstants.defaultAllowComments,
      allowShares: data[FirebaseConstants.postAllowSharesField] ?? 
                   FirebaseConstants.defaultAllowShares,
      createdAt: (data[FirebaseConstants.postCreatedAtField] as Timestamp).toDate(),
      updatedAt: (data[FirebaseConstants.postUpdatedAtField] as Timestamp).toDate(),
      location: data[FirebaseConstants.postLocationField],
      metadata: data[FirebaseConstants.postMetadataField],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirebaseConstants.postAuthorIdField: authorId,
      FirebaseConstants.postContentField: content,
      FirebaseConstants.postImageUrlsField: imageUrls,
      FirebaseConstants.postHashtagsField: hashtags,
      FirebaseConstants.postMentionsField: mentions,
      FirebaseConstants.postLikesCountField: likesCount,
      FirebaseConstants.postCommentsCountField: commentsCount,
      FirebaseConstants.postSharesCountField: sharesCount,
      FirebaseConstants.postVisibilityField: visibility,
      FirebaseConstants.postIsPinnedField: isPinned,
      FirebaseConstants.postAllowCommentsField: allowComments,
      FirebaseConstants.postAllowSharesField: allowShares,
      FirebaseConstants.postCreatedAtField: Timestamp.fromDate(createdAt),
      FirebaseConstants.postUpdatedAtField: Timestamp.fromDate(updatedAt),
      FirebaseConstants.postLocationField: location,
      FirebaseConstants.postMetadataField: metadata,
    };
  }

  factory PostModel.create({
    required String id,
    required String authorId,
    required String content,
    List<String> imageUrls = const [],
    String visibility = FirebaseConstants.defaultPostVisibility,
    String? location,
    Map<String, dynamic>? metadata,
  }) {
    final now = DateTime.now();
    final extractedHashtags = _extractHashtags(content);
    final extractedMentions = _extractMentions(content);
    
    return PostModel(
      id: id,
      authorId: authorId,
      content: content,
      imageUrls: imageUrls,
      hashtags: extractedHashtags,
      mentions: extractedMentions,
      visibility: visibility,
      createdAt: now,
      updatedAt: now,
      location: location,
      metadata: metadata,
    );
  }

  // Extract hashtags from content
  static List<String> _extractHashtags(String content) {
    final regex = RegExp(r'#\w+');
    return regex.allMatches(content)
        .map((match) => match.group(0)!.toLowerCase())
        .toSet() // Remove duplicates
        .take(FirebaseConstants.maxHashtagsPerPost)
        .toList();
  }

  // Extract mentions from content
  static List<String> _extractMentions(String content) {
    final regex = RegExp(r'@\w+');
    return regex.allMatches(content)
        .map((match) => match.group(0)!.substring(1).toLowerCase()) // Remove @
        .toSet() // Remove duplicates
        .take(FirebaseConstants.maxMentionsPerPost)
        .toList();
  }
}

extension PostModelExtensions on PostModel {
  // Business logic getters
  bool get hasImages => imageUrls.isNotEmpty;
  bool get hasHashtags => hashtags.isNotEmpty;
  bool get hasMentions => mentions.isNotEmpty;
  bool get hasLocation => location != null && location!.isNotEmpty;
  bool get hasLikes => likesCount > 0;
  bool get hasComments => commentsCount > 0;
  bool get hasShares => sharesCount > 0;
  bool get hasEngagement => hasLikes || hasComments || hasShares;
  bool get isPublic => visibility == FirebaseConstants.visibilityPublic;
  bool get isPrivate => visibility == FirebaseConstants.visibilityPrivate;
  bool get isForFollowers => visibility == FirebaseConstants.visibilityFollowers;
  bool get wasEdited => updatedAt.isAfter(createdAt.add(const Duration(minutes: 1)));
  
  // Time calculations
  Duration get timeSinceCreation => DateTime.now().difference(createdAt);
  Duration get timeSinceUpdate => DateTime.now().difference(updatedAt);
  
  // Display helpers
  String get timeAgoText {
    final difference = timeSinceCreation;
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    if (difference.inDays < 30) return '${difference.inDays ~/ 7}w';
    
    return '${difference.inDays ~/ 30}mo';
  }
  
  String get likesDisplayText {
    if (likesCount == 0) return '';
    if (likesCount == 1) return '1 like';
    if (likesCount < 1000) return '$likesCount likes';
    if (likesCount < 1000000) {
      return '${(likesCount / 1000).toStringAsFixed(1)}K likes';
    }
    return '${(likesCount / 1000000).toStringAsFixed(1)}M likes';
  }
  
  String get commentsDisplayText {
    if (commentsCount == 0) return '';
    if (commentsCount == 1) return '1 comment';
    if (commentsCount < 1000) return '$commentsCount comments';
    if (commentsCount < 1000000) {
      return '${(commentsCount / 1000).toStringAsFixed(1)}K comments';
    }
    return '${(commentsCount / 1000000).toStringAsFixed(1)}M comments';
  }
  
  String get sharesDisplayText {
    if (sharesCount == 0) return '';
    if (sharesCount == 1) return '1 share';
    if (sharesCount < 1000) return '$sharesCount shares';
    if (sharesCount < 1000000) {
      return '${(sharesCount / 1000).toStringAsFixed(1)}K shares';
    }
    return '${(sharesCount / 1000000).toStringAsFixed(1)}M shares';
  }
  
  String get visibilityDisplayText {
    switch (visibility) {
      case FirebaseConstants.visibilityPublic:
        return 'Public';
      case FirebaseConstants.visibilityFollowers:
        return 'Followers';
      case FirebaseConstants.visibilityPrivate:
        return 'Private';
      default:
        return 'Unknown';
    }
  }
  
  // Content processing
  String get excerpt {
    if (content.length <= 100) return content;
    return '${content.substring(0, 97)}...';
  }
  
  int get wordCount {
    if (content.trim().isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }
  
  int get characterCount => content.length;
  
  // Engagement metrics
  int get totalEngagement => likesCount + commentsCount + sharesCount;
  
  double get engagementRate {
    if (totalEngagement == 0) return 0.0;
    // This would typically be calculated against reach/impressions
    // For now, we'll use a simple calculation
    return totalEngagement.toDouble();
  }
  
  // Update helpers
  PostModel incrementLikesCount() {
    return copyWith(
      likesCount: likesCount + 1,
      updatedAt: DateTime.now(),
    );
  }
  
  PostModel decrementLikesCount() {
    return copyWith(
      likesCount: likesCount > 0 ? likesCount - 1 : 0,
      updatedAt: DateTime.now(),
    );
  }
  
  PostModel incrementCommentsCount() {
    return copyWith(
      commentsCount: commentsCount + 1,
      updatedAt: DateTime.now(),
    );
  }
  
  PostModel decrementCommentsCount() {
    return copyWith(
      commentsCount: commentsCount > 0 ? commentsCount - 1 : 0,
      updatedAt: DateTime.now(),
    );
  }
  
  PostModel incrementSharesCount() {
    return copyWith(
      sharesCount: sharesCount + 1,
      updatedAt: DateTime.now(),
    );
  }
  
  PostModel pin() {
    return copyWith(
      isPinned: true,
      updatedAt: DateTime.now(),
    );
  }
  
  PostModel unpin() {
    return copyWith(
      isPinned: false,
      updatedAt: DateTime.now(),
    );
  }
  
  PostModel updateContent(String newContent) {
    final extractedHashtags = PostModel._extractHashtags(newContent);
    final extractedMentions = PostModel._extractMentions(newContent);
    
    return copyWith(
      content: newContent,
      hashtags: extractedHashtags,
      mentions: extractedMentions,
      updatedAt: DateTime.now(),
    );
  }
  
  PostModel toggleComments() {
    return copyWith(
      allowComments: !allowComments,
      updatedAt: DateTime.now(),
    );
  }
  
  PostModel toggleShares() {
    return copyWith(
      allowShares: !allowShares,
      updatedAt: DateTime.now(),
    );
  }
  
  PostModel changeVisibility(String newVisibility) {
    return copyWith(
      visibility: newVisibility,
      updatedAt: DateTime.now(),
    );
  }
}
