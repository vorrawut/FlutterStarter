import 'package:connectpro_ultimate_testing/data/models/chat_models.dart';
import 'package:connectpro_ultimate_testing/data/models/social_models.dart';
import 'package:connectpro_ultimate_testing/data/models/user_models.dart';
import 'package:connectpro_ultimate_testing/data/models/notification_models.dart';

/// Test fixtures providing consistent test data across the application
class TestFixtures {
  
  /// Creates a test user model
  static UserModel createUser({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    String? bio,
    bool isVerified = false,
    bool isActive = true,
    DateTime? createdAt,
  }) {
    final now = createdAt ?? DateTime.now();
    return UserModel(
      id: id ?? 'user_${now.millisecondsSinceEpoch}',
      email: email ?? 'user${now.millisecondsSinceEpoch}@test.com',
      displayName: displayName ?? 'Test User ${now.millisecondsSinceEpoch}',
      photoURL: photoURL,
      bio: bio ?? 'Test bio for user',
      website: null,
      location: null,
      interests: ['testing', 'flutter', 'mobile'],
      followersCount: 0,
      followingCount: 0,
      postsCount: 0,
      isPublic: true,
      isActive: isActive,
      isVerified: isVerified,
      createdAt: now,
      updatedAt: now,
      lastSeenAt: now,
      settings: const {},
    );
  }

  /// Creates a test message model
  static MessageModel createMessage({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    MessageStatus? status,
    List<MediaAttachment>? attachments,
    Map<String, MessageReaction>? reactions,
    List<String>? readBy,
    bool isDeleted = false,
    bool isEncrypted = false,
  }) {
    final now = timestamp ?? DateTime.now();
    return MessageModel(
      id: id ?? 'msg_${now.millisecondsSinceEpoch}',
      chatId: chatId ?? 'chat_test',
      senderId: senderId ?? 'user_test',
      content: content ?? 'Test message content',
      type: type ?? MessageType.text,
      timestamp: now,
      attachments: attachments ?? [],
      metadata: const {},
      reactions: reactions ?? {},
      readBy: readBy ?? [],
      editHistory: [],
      isDeleted: isDeleted,
      isEncrypted: isEncrypted,
      status: status ?? MessageStatus.sent,
    );
  }

  /// Creates a test message with image attachment
  static MessageModel createImageMessage({
    String? id,
    String? chatId,
    String? senderId,
    String? imageUrl,
    DateTime? timestamp,
  }) {
    return createMessage(
      id: id,
      chatId: chatId,
      senderId: senderId,
      content: 'Shared an image',
      type: MessageType.image,
      timestamp: timestamp,
      attachments: [
        MediaAttachment(
          id: 'attachment_${DateTime.now().millisecondsSinceEpoch}',
          url: imageUrl ?? 'https://test.com/image.jpg',
          fileName: 'test_image.jpg',
          mimeType: 'image/jpeg',
          sizeBytes: 1024000,
          uploadedAt: timestamp ?? DateTime.now(),
        ),
      ],
    );
  }

  /// Creates a test message with reactions
  static MessageModel createMessageWithReactions({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    Map<String, String>? userReactions,
  }) {
    final reactions = <String, MessageReaction>{};
    userReactions?.forEach((userId, emoji) {
      reactions[userId] = MessageReaction(
        emoji: emoji,
        userId: userId,
        timestamp: DateTime.now(),
      );
    });

    return createMessage(
      id: id,
      chatId: chatId,
      senderId: senderId,
      content: content,
      reactions: reactions,
    );
  }

  /// Creates a test chat model
  static ChatModel createChat({
    String? id,
    String? name,
    List<String>? participantIds,
    ChatType? type,
    DateTime? createdAt,
    LastMessage? lastMessage,
  }) {
    final now = createdAt ?? DateTime.now();
    final defaultParticipants = participantIds ?? ['user1', 'user2'];
    
    return ChatModel(
      id: id ?? 'chat_${now.millisecondsSinceEpoch}',
      name: name ?? (type == ChatType.direct ? '' : 'Test Chat'),
      participantIds: defaultParticipants,
      participants: {
        for (int i = 0; i < defaultParticipants.length; i++)
          defaultParticipants[i]: ChatParticipant(
            userId: defaultParticipants[i],
            displayName: 'User ${i + 1}',
            role: i == 0 ? ChatRole.owner : ChatRole.member,
            joinedAt: now,
            isActive: true,
          ),
      },
      type: type ?? ChatType.group,
      lastMessage: lastMessage,
      unreadCounts: {for (final id in defaultParticipants) id: 0},
      lastSeenTimestamps: {},
      isActive: true,
      settings: {},
      createdAt: now,
      updatedAt: now,
      createdBy: defaultParticipants.first,
    );
  }

  /// Creates a test direct chat
  static ChatModel createDirectChat({
    String? id,
    List<String>? participantIds,
    DateTime? createdAt,
  }) {
    return createChat(
      id: id,
      participantIds: participantIds ?? ['user1', 'user2'],
      type: ChatType.direct,
      name: '',
      createdAt: createdAt,
    );
  }

  /// Creates a test group chat
  static ChatModel createGroupChat({
    String? id,
    String? name,
    List<String>? participantIds,
    DateTime? createdAt,
  }) {
    return createChat(
      id: id,
      name: name ?? 'Test Group',
      participantIds: participantIds ?? ['user1', 'user2', 'user3'],
      type: ChatType.group,
      createdAt: createdAt,
    );
  }

  /// Creates a test post model
  static PostModel createPost({
    String? id,
    String? authorId,
    String? content,
    List<String>? hashtags,
    List<String>? mentions,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    PostVisibility? visibility,
    PostStatus? status,
  }) {
    final now = createdAt ?? DateTime.now();
    return PostModel(
      id: id ?? 'post_${now.millisecondsSinceEpoch}',
      authorId: authorId ?? 'author_test',
      content: content ?? 'Test post content with #test and @user',
      hashtags: hashtags ?? ['test'],
      mentions: mentions ?? ['user'],
      likesCount: likesCount ?? 0,
      commentsCount: commentsCount ?? 0,
      sharesCount: 0,
      viewsCount: 0,
      visibility: visibility ?? PostVisibility.public,
      attachments: [],
      metadata: const {},
      createdAt: now,
      updatedAt: now,
      editHistory: [],
      isDeleted: false,
      status: status ?? PostStatus.published,
    );
  }

  /// Creates a test post with media
  static PostModel createPostWithMedia({
    String? id,
    String? authorId,
    String? content,
    List<String>? imageUrls,
  }) {
    final attachments = (imageUrls ?? ['https://test.com/image1.jpg'])
        .asMap()
        .entries
        .map((entry) => MediaAttachment(
              id: 'attachment_${entry.key}',
              url: entry.value,
              fileName: 'image_${entry.key}.jpg',
              mimeType: 'image/jpeg',
              sizeBytes: 1024000,
              uploadedAt: DateTime.now(),
            ))
        .toList();

    return PostModel(
      id: id ?? 'post_media_${DateTime.now().millisecondsSinceEpoch}',
      authorId: authorId ?? 'author_test',
      content: content ?? 'Post with media attachments',
      hashtags: [],
      mentions: [],
      likesCount: 0,
      commentsCount: 0,
      sharesCount: 0,
      viewsCount: 0,
      visibility: PostVisibility.public,
      attachments: attachments,
      metadata: const {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      editHistory: [],
      isDeleted: false,
      status: PostStatus.published,
    );
  }

  /// Creates a test comment model
  static CommentModel createComment({
    String? id,
    String? postId,
    String? authorId,
    String? content,
    String? parentCommentId,
    int? likesCount,
    DateTime? createdAt,
  }) {
    final now = createdAt ?? DateTime.now();
    return CommentModel(
      id: id ?? 'comment_${now.millisecondsSinceEpoch}',
      postId: postId ?? 'post_test',
      authorId: authorId ?? 'author_test',
      content: content ?? 'Test comment content',
      parentCommentId: parentCommentId,
      likesCount: likesCount ?? 0,
      repliesCount: 0,
      createdAt: now,
      updatedAt: now,
      editHistory: [],
      isDeleted: false,
    );
  }

  /// Creates a test notification model
  static NotificationModel createNotification({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    Map<String, dynamic>? data,
    bool isRead = false,
    DateTime? createdAt,
  }) {
    final now = createdAt ?? DateTime.now();
    return NotificationModel(
      id: id ?? 'notification_${now.millisecondsSinceEpoch}',
      userId: userId ?? 'user_test',
      title: title ?? 'Test Notification',
      body: body ?? 'This is a test notification',
      type: type ?? NotificationType.newMessage,
      data: data ?? {},
      isRead: isRead,
      createdAt: now,
      readAt: isRead ? now : null,
    );
  }

  /// Creates a test media attachment
  static MediaAttachment createMediaAttachment({
    String? id,
    String? url,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    DateTime? uploadedAt,
  }) {
    return MediaAttachment(
      id: id ?? 'attachment_${DateTime.now().millisecondsSinceEpoch}',
      url: url ?? 'https://test.com/file.jpg',
      fileName: fileName ?? 'test_file.jpg',
      mimeType: mimeType ?? 'image/jpeg',
      sizeBytes: sizeBytes ?? 1024000,
      uploadedAt: uploadedAt ?? DateTime.now(),
    );
  }

  /// Creates a test message reaction
  static MessageReaction createReaction({
    String? emoji,
    String? userId,
    DateTime? timestamp,
  }) {
    return MessageReaction(
      emoji: emoji ?? '👍',
      userId: userId ?? 'user_test',
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  /// Creates a list of test messages for chat testing
  static List<MessageModel> createMessageList({
    String? chatId,
    int count = 10,
    List<String>? senderIds,
    DateTime? baseTime,
  }) {
    final senders = senderIds ?? ['user1', 'user2'];
    final base = baseTime ?? DateTime.now();
    
    return List.generate(count, (index) {
      final senderId = senders[index % senders.length];
      return createMessage(
        id: 'msg_$index',
        chatId: chatId,
        senderId: senderId,
        content: 'Message $index from $senderId',
        timestamp: base.add(Duration(minutes: index)),
      );
    });
  }

  /// Creates a list of test posts for feed testing
  static List<PostModel> createPostList({
    int count = 20,
    List<String>? authorIds,
    DateTime? baseTime,
  }) {
    final authors = authorIds ?? ['author1', 'author2', 'author3'];
    final base = baseTime ?? DateTime.now();
    
    return List.generate(count, (index) {
      final authorId = authors[index % authors.length];
      return createPost(
        id: 'post_$index',
        authorId: authorId,
        content: 'Post $index from $authorId with #content',
        likesCount: index * 2,
        commentsCount: index,
        createdAt: base.subtract(Duration(hours: index)),
      );
    });
  }

  /// Creates a list of test users
  static List<UserModel> createUserList({
    int count = 10,
    String? namePrefix,
    DateTime? baseTime,
  }) {
    final base = baseTime ?? DateTime.now();
    
    return List.generate(count, (index) {
      return createUser(
        id: 'user_$index',
        email: 'user$index@test.com',
        displayName: '${namePrefix ?? 'User'} $index',
        createdAt: base.subtract(Duration(days: index)),
      );
    });
  }

  /// Creates test notification list
  static List<NotificationModel> createNotificationList({
    String? userId,
    int count = 15,
    DateTime? baseTime,
  }) {
    final base = baseTime ?? DateTime.now();
    final types = NotificationType.values;
    
    return List.generate(count, (index) {
      return createNotification(
        id: 'notification_$index',
        userId: userId,
        title: 'Notification $index',
        body: 'Content for notification $index',
        type: types[index % types.length],
        isRead: index % 3 == 0, // Some read, some unread
        createdAt: base.subtract(Duration(hours: index)),
      );
    });
  }

  /// Creates test data for performance testing
  static List<MessageModel> createLargeMessageList({
    String? chatId,
    int count = 1000,
  }) {
    return createMessageList(
      chatId: chatId,
      count: count,
      senderIds: ['user1', 'user2', 'user3', 'user4', 'user5'],
    );
  }

  /// Creates test data with various message types
  static List<MessageModel> createMixedMessageList({
    String? chatId,
    int count = 50,
  }) {
    final messages = <MessageModel>[];
    final types = MessageType.values;
    
    for (int i = 0; i < count; i++) {
      final type = types[i % types.length];
      final message = type == MessageType.image
          ? createImageMessage(
              id: 'msg_$i',
              chatId: chatId,
              senderId: 'user${i % 3 + 1}',
              timestamp: DateTime.now().subtract(Duration(minutes: i)),
            )
          : createMessage(
              id: 'msg_$i',
              chatId: chatId,
              senderId: 'user${i % 3 + 1}',
              content: 'Message $i of type $type',
              type: type,
              timestamp: DateTime.now().subtract(Duration(minutes: i)),
            );
      messages.add(message);
    }
    
    return messages;
  }
}
