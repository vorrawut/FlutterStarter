import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectpro_ultimate_testing/data/models/chat_models.dart';
import '../../fixtures/test_fixtures.dart';

void main() {
  group('MessageModel', () {
    late MessageModel testMessage;
    
    setUp(() {
      testMessage = TestFixtures.createMessage(
        id: 'test-message-id',
        chatId: 'test-chat-id',
        senderId: 'test-sender-id',
        content: 'Test message content',
        timestamp: DateTime(2024, 1, 15, 10, 30),
      );
    });

    group('Constructor and Properties', () {
      test('should create MessageModel with required properties', () {
        expect(testMessage.id, equals('test-message-id'));
        expect(testMessage.chatId, equals('test-chat-id'));
        expect(testMessage.senderId, equals('test-sender-id'));
        expect(testMessage.content, equals('Test message content'));
        expect(testMessage.type, equals(MessageType.text));
        expect(testMessage.status, equals(MessageStatus.sent));
        expect(testMessage.timestamp, equals(DateTime(2024, 1, 15, 10, 30)));
      });

      test('should have correct default values', () {
        expect(testMessage.attachments, isEmpty);
        expect(testMessage.reactions, isEmpty);
        expect(testMessage.readBy, isEmpty);
        expect(testMessage.editHistory, isEmpty);
        expect(testMessage.isDeleted, isFalse);
        expect(testMessage.isEncrypted, isFalse);
        expect(testMessage.metadata, isEmpty);
      });

      test('should handle null and empty values gracefully', () {
        final messageWithNulls = TestFixtures.createMessage(
          content: '',
          reactions: {},
        );
        
        expect(messageWithNulls.content, equals(''));
        expect(messageWithNulls.reactions, isEmpty);
        expect(messageWithNulls.hasAttachments, isFalse);
      });
    });

    group('Helper Methods', () {
      test('hasAttachments should return false for text message', () {
        expect(testMessage.hasAttachments, isFalse);
      });

      test('hasAttachments should return true when attachments exist', () {
        final messageWithAttachments = TestFixtures.createImageMessage(
          id: 'image-message',
          imageUrl: 'https://example.com/image.jpg',
        );
        
        expect(messageWithAttachments.hasAttachments, isTrue);
        expect(messageWithAttachments.attachments.length, equals(1));
        expect(messageWithAttachments.type, equals(MessageType.image));
      });

      test('isEdited should return false for unedited message', () {
        expect(testMessage.isEdited, isFalse);
      });

      test('isEdited should return true when edit history exists', () {
        final editedMessage = testMessage.copyWith(
          editHistory: [
            MessageEdit(
              previousContent: 'Original content',
              editedAt: DateTime.now(),
              editedBy: 'test-sender-id',
            ),
          ],
        );
        
        expect(editedMessage.isEdited, isTrue);
        expect(editedMessage.editHistory.length, equals(1));
      });

      test('messageAge should calculate correct duration', () {
        final now = DateTime.now();
        final oneHourAgo = now.subtract(const Duration(hours: 1));
        final recentMessage = testMessage.copyWith(timestamp: oneHourAgo);
        
        final age = recentMessage.messageAge;
        expect(age.inHours, equals(1));
        expect(age.inMinutes, equals(60));
      });

      test('isFromCurrentUser should return correct value', () {
        expect(testMessage.isFromCurrentUser('test-sender-id'), isTrue);
        expect(testMessage.isFromCurrentUser('other-user-id'), isFalse);
        expect(testMessage.isFromCurrentUser(''), isFalse);
      });

      test('formattedTimestamp should return correct format', () {
        final message = testMessage.copyWith(
          timestamp: DateTime(2024, 1, 15, 14, 30), // 2:30 PM
        );
        
        expect(message.formattedTimestamp, equals('14:30'));
      });
    });

    group('Serialization', () {
      test('should convert to JSON correctly', () {
        final json = testMessage.toJson();
        
        expect(json['id'], equals('test-message-id'));
        expect(json['chatId'], equals('test-chat-id'));
        expect(json['senderId'], equals('test-sender-id'));
        expect(json['content'], equals('Test message content'));
        expect(json['type'], equals('text'));
        expect(json['status'], equals('sent'));
        expect(json['isDeleted'], equals(false));
        expect(json['isEncrypted'], equals(false));
      });

      test('should create from JSON correctly', () {
        final json = {
          'id': 'json-message-id',
          'chatId': 'json-chat-id',
          'senderId': 'json-sender-id',
          'content': 'JSON message content',
          'type': 'text',
          'timestamp': '2024-01-15T10:30:00.000Z',
          'attachments': [],
          'metadata': {},
          'reactions': {},
          'readBy': [],
          'editHistory': [],
          'isDeleted': false,
          'isEncrypted': false,
          'status': 'sent',
        };

        final message = MessageModel.fromJson(json);
        
        expect(message.id, equals('json-message-id'));
        expect(message.chatId, equals('json-chat-id'));
        expect(message.senderId, equals('json-sender-id'));
        expect(message.content, equals('JSON message content'));
        expect(message.type, equals(MessageType.text));
      });

      test('should handle malformed JSON gracefully', () {
        final malformedJson = {
          'id': 'test-id',
          'chatId': 'test-chat',
          'senderId': 'test-sender',
          'content': 'test',
          'type': 'invalid_type', // Invalid enum value
          'timestamp': 'invalid_date', // Invalid date
        };

        expect(
          () => MessageModel.fromJson(malformedJson),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('Firestore Integration', () {
      test('should convert to Firestore format correctly', () {
        final firestoreData = testMessage.toFirestore();
        
        expect(firestoreData['chatId'], equals('test-chat-id'));
        expect(firestoreData['senderId'], equals('test-sender-id'));
        expect(firestoreData['content'], equals('Test message content'));
        expect(firestoreData['type'], equals('text'));
        expect(firestoreData['timestamp'], isA<Timestamp>());
        expect(firestoreData['status'], equals('sent'));
        expect(firestoreData['attachments'], isA<List>());
        expect(firestoreData['reactions'], isA<Map>());
      });

      test('should create from Firestore snapshot correctly', () {
        final firestoreData = {
          'chatId': 'firestore-chat-id',
          'senderId': 'firestore-sender-id',
          'content': 'Firestore message content',
          'type': 'text',
          'timestamp': Timestamp.fromDate(DateTime(2024, 1, 15, 10, 30)),
          'attachments': [],
          'metadata': {},
          'reactions': {},
          'readBy': [],
          'editHistory': [],
          'isDeleted': false,
          'isEncrypted': false,
          'status': 'sent',
        };

        final message = MessageModel.fromFirestore('firestore-id', firestoreData);
        
        expect(message.id, equals('firestore-id'));
        expect(message.chatId, equals('firestore-chat-id'));
        expect(message.content, equals('Firestore message content'));
        expect(message.timestamp, equals(DateTime(2024, 1, 15, 10, 30)));
      });
    });

    group('Reaction Management', () {
      test('getUsersWhoReacted should return empty list for no reactions', () {
        final users = testMessage.getUsersWhoReacted('👍');
        expect(users, isEmpty);
      });

      test('getUsersWhoReacted should return correct users for emoji', () {
        final messageWithReactions = TestFixtures.createMessageWithReactions(
          userReactions: {
            'user1': '👍',
            'user2': '❤️',
            'user3': '👍',
          },
        );

        final thumbsUpUsers = messageWithReactions.getUsersWhoReacted('👍');
        expect(thumbsUpUsers, hasLength(2));
        expect(thumbsUpUsers, containsAll(['user1', 'user3']));

        final heartUsers = messageWithReactions.getUsersWhoReacted('❤️');
        expect(heartUsers, hasLength(1));
        expect(heartUsers, contains('user2'));
      });

      test('reactionCounts should calculate correct counts', () {
        final messageWithReactions = TestFixtures.createMessageWithReactions(
          userReactions: {
            'user1': '👍',
            'user2': '👍',
            'user3': '❤️',
            'user4': '😂',
            'user5': '👍',
          },
        );

        final counts = messageWithReactions.reactionCounts;
        expect(counts['👍'], equals(3));
        expect(counts['❤️'], equals(1));
        expect(counts['😂'], equals(1));
        expect(counts.length, equals(3));
      });

      test('hasReactionFromUser should return correct value', () {
        final messageWithReactions = TestFixtures.createMessageWithReactions(
          userReactions: {
            'user1': '👍',
            'user2': '❤️',
          },
        );

        expect(messageWithReactions.hasReactionFromUser('user1'), isTrue);
        expect(messageWithReactions.hasReactionFromUser('user2'), isTrue);
        expect(messageWithReactions.hasReactionFromUser('user3'), isFalse);
      });

      test('getUserReaction should return correct emoji', () {
        final messageWithReactions = TestFixtures.createMessageWithReactions(
          userReactions: {
            'user1': '👍',
            'user2': '❤️',
          },
        );

        expect(messageWithReactions.getUserReaction('user1'), equals('👍'));
        expect(messageWithReactions.getUserReaction('user2'), equals('❤️'));
        expect(messageWithReactions.getUserReaction('user3'), isNull);
      });
    });

    group('Edge Cases and Validation', () {
      test('should handle empty content gracefully', () {
        final emptyMessage = testMessage.copyWith(content: '');
        expect(emptyMessage.content, equals(''));
        expect(emptyMessage.hasAttachments, isFalse);
        expect(emptyMessage.isEdited, isFalse);
      });

      test('should handle very long content', () {
        final longContent = 'A' * 10000;
        final longMessage = testMessage.copyWith(content: longContent);
        expect(longMessage.content.length, equals(10000));
        expect(longMessage.content, equals(longContent));
      });

      test('should handle special characters in content', () {
        final specialContent = '🎉 Hello! @user #hashtag https://example.com 中文 العربية';
        final specialMessage = testMessage.copyWith(content: specialContent);
        expect(specialMessage.content, equals(specialContent));
      });

      test('should handle emoji-only content', () {
        final emojiMessage = testMessage.copyWith(content: '🎉🎊🎈');
        expect(emojiMessage.content, equals('🎉🎊🎈'));
      });

      test('should handle null safety correctly', () {
        final message = TestFixtures.createMessage();
        
        expect(message.attachments, isNotNull);
        expect(message.reactions, isNotNull);
        expect(message.readBy, isNotNull);
        expect(message.editHistory, isNotNull);
        expect(message.metadata, isNotNull);
      });

      test('should maintain immutability with copyWith', () {
        final originalMessage = testMessage;
        final copiedMessage = originalMessage.copyWith(content: 'Modified content');
        
        expect(originalMessage.content, equals('Test message content'));
        expect(copiedMessage.content, equals('Modified content'));
        expect(originalMessage.id, equals(copiedMessage.id));
      });
    });

    group('Message Status and State', () {
      test('should handle different message statuses', () {
        final statuses = [
          MessageStatus.sending,
          MessageStatus.sent,
          MessageStatus.delivered,
          MessageStatus.read,
          MessageStatus.failed,
        ];

        for (final status in statuses) {
          final message = testMessage.copyWith(status: status);
          expect(message.status, equals(status));
        }
      });

      test('should handle read receipts correctly', () {
        final messageWithReads = testMessage.copyWith(
          readBy: ['user1', 'user2', 'user3'],
          status: MessageStatus.read,
        );

        expect(messageWithReads.readBy.length, equals(3));
        expect(messageWithReads.isReadBy('user1'), isTrue);
        expect(messageWithReads.isReadBy('user4'), isFalse);
        expect(messageWithReads.status, equals(MessageStatus.read));
      });

      test('should handle deletion state correctly', () {
        final deletedMessage = testMessage.copyWith(
          isDeleted: true,
          content: 'This message was deleted',
        );

        expect(deletedMessage.isDeleted, isTrue);
        expect(deletedMessage.content, equals('This message was deleted'));
      });
    });
  });

  group('MessageEdit', () {
    test('should create MessageEdit with correct properties', () {
      final edit = MessageEdit(
        previousContent: 'Original content',
        editedAt: DateTime(2024, 1, 15, 11, 0),
        editedBy: 'test-user-id',
      );

      expect(edit.previousContent, equals('Original content'));
      expect(edit.editedBy, equals('test-user-id'));
      expect(edit.editedAt, equals(DateTime(2024, 1, 15, 11, 0)));
    });

    test('should serialize to JSON correctly', () {
      final edit = MessageEdit(
        previousContent: 'Original content',
        editedAt: DateTime(2024, 1, 15, 11, 0),
        editedBy: 'test-user-id',
      );

      final json = edit.toJson();
      expect(json['previousContent'], equals('Original content'));
      expect(json['editedBy'], equals('test-user-id'));
      expect(json['editedAt'], isA<String>());
    });

    test('should create from JSON correctly', () {
      final json = {
        'previousContent': 'JSON original content',
        'editedAt': '2024-01-15T11:00:00.000Z',
        'editedBy': 'json-user-id',
      };

      final edit = MessageEdit.fromJson(json);
      expect(edit.previousContent, equals('JSON original content'));
      expect(edit.editedBy, equals('json-user-id'));
    });
  });

  group('MessageReaction', () {
    test('should create MessageReaction with correct properties', () {
      final reaction = MessageReaction(
        emoji: '👍',
        userId: 'test-user-id',
        timestamp: DateTime(2024, 1, 15, 10, 45),
      );

      expect(reaction.emoji, equals('👍'));
      expect(reaction.userId, equals('test-user-id'));
      expect(reaction.timestamp, equals(DateTime(2024, 1, 15, 10, 45)));
    });

    test('should handle various emoji types', () {
      final emojis = ['👍', '❤️', '😂', '😮', '😢', '😡', '🎉', '🔥'];
      
      for (final emoji in emojis) {
        final reaction = MessageReaction(
          emoji: emoji,
          userId: 'test-user-id',
          timestamp: DateTime.now(),
        );
        
        expect(reaction.emoji, equals(emoji));
      }
    });

    test('should serialize to JSON correctly', () {
      final reaction = MessageReaction(
        emoji: '❤️',
        userId: 'test-user-id',
        timestamp: DateTime(2024, 1, 15, 10, 45),
      );

      final json = reaction.toJson();
      expect(json['emoji'], equals('❤️'));
      expect(json['userId'], equals('test-user-id'));
      expect(json['timestamp'], isA<String>());
    });

    test('should create from JSON correctly', () {
      final json = {
        'emoji': '🎉',
        'userId': 'json-user-id',
        'timestamp': '2024-01-15T10:45:00.000Z',
      };

      final reaction = MessageReaction.fromJson(json);
      expect(reaction.emoji, equals('🎉'));
      expect(reaction.userId, equals('json-user-id'));
    });
  });

  group('MediaAttachment', () {
    test('should create MediaAttachment with correct properties', () {
      final attachment = TestFixtures.createMediaAttachment(
        id: 'test-attachment',
        url: 'https://example.com/image.jpg',
        fileName: 'test_image.jpg',
        mimeType: 'image/jpeg',
        sizeBytes: 1024000,
      );

      expect(attachment.id, equals('test-attachment'));
      expect(attachment.url, equals('https://example.com/image.jpg'));
      expect(attachment.fileName, equals('test_image.jpg'));
      expect(attachment.mimeType, equals('image/jpeg'));
      expect(attachment.sizeBytes, equals(1024000));
    });

    test('should identify file types correctly', () {
      final imageAttachment = TestFixtures.createMediaAttachment(
        mimeType: 'image/jpeg',
      );
      final videoAttachment = TestFixtures.createMediaAttachment(
        mimeType: 'video/mp4',
      );
      final documentAttachment = TestFixtures.createMediaAttachment(
        mimeType: 'application/pdf',
      );

      expect(imageAttachment.isImage, isTrue);
      expect(imageAttachment.isVideo, isFalse);
      expect(imageAttachment.isDocument, isFalse);

      expect(videoAttachment.isImage, isFalse);
      expect(videoAttachment.isVideo, isTrue);
      expect(videoAttachment.isDocument, isFalse);

      expect(documentAttachment.isImage, isFalse);
      expect(documentAttachment.isVideo, isFalse);
      expect(documentAttachment.isDocument, isTrue);
    });

    test('should format file size correctly', () {
      final smallFile = TestFixtures.createMediaAttachment(sizeBytes: 1024);
      final mediumFile = TestFixtures.createMediaAttachment(sizeBytes: 1024 * 1024);
      final largeFile = TestFixtures.createMediaAttachment(sizeBytes: 1024 * 1024 * 10);

      expect(smallFile.formattedSize, equals('1.0 KB'));
      expect(mediumFile.formattedSize, equals('1.0 MB'));
      expect(largeFile.formattedSize, equals('10.0 MB'));
    });
  });
}
