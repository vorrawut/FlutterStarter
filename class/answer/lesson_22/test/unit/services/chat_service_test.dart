import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectpro_ultimate_testing/data/services/realtime_chat_service.dart';
import 'package:connectpro_ultimate_testing/data/models/chat_models.dart';
import 'package:connectpro_ultimate_testing/core/error/exceptions.dart';
import '../../fixtures/test_fixtures.dart';

// Generate mocks for required classes
@GenerateMocks([
  FirebaseFirestore,
  FirebaseAuth,
  User,
  DocumentReference,
  DocumentSnapshot,
  CollectionReference,
  Query,
  QuerySnapshot,
  QueryDocumentSnapshot,
  Transaction,
  WriteBatch,
])
import 'chat_service_test.mocks.dart';

void main() {
  group('RealtimeChatService', () {
    late MockFirebaseFirestore mockFirestore;
    late MockFirebaseAuth mockAuth;
    late MockUser mockUser;
    late MockCollectionReference mockChatsCollection;
    late MockDocumentReference mockChatDocument;
    late MockCollectionReference mockMessagesCollection;
    late MockDocumentReference mockMessageDocument;
    late MockWriteBatch mockBatch;
    late MockTransaction mockTransaction;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockChatsCollection = MockCollectionReference();
      mockChatDocument = MockDocumentReference();
      mockMessagesCollection = MockCollectionReference();
      mockMessageDocument = MockDocumentReference();
      mockBatch = MockWriteBatch();
      mockTransaction = MockTransaction();

      // Setup basic mocks
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test-user-id');
      when(mockUser.displayName).thenReturn('Test User');
      when(mockFirestore.collection('chats')).thenReturn(mockChatsCollection);
      when(mockChatsCollection.doc(any)).thenReturn(mockChatDocument);
      when(mockChatDocument.collection('messages')).thenReturn(mockMessagesCollection);
      when(mockMessagesCollection.doc()).thenReturn(mockMessageDocument);
      when(mockMessageDocument.id).thenReturn('test-message-id');
      when(mockFirestore.batch()).thenReturn(mockBatch);
    });

    tearDown(() {
      reset(mockFirestore);
      reset(mockAuth);
      reset(mockUser);
    });

    group('sendMessage', () {
      test('should send text message successfully', () async {
        // Arrange
        when(mockMessageDocument.set(any)).thenAnswer((_) async => {});
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionFunction = invocation.positionalArguments[0] as Function;
          return await transactionFunction(mockTransaction);
        });
        when(mockTransaction.update(any, any)).thenAnswer((_) async => {});

        // Act
        final result = await RealtimeChatService.sendMessage(
          chatId: 'test-chat-id',
          content: 'Test message',
          type: MessageType.text,
        );

        // Assert
        expect(result.content, equals('Test message'));
        expect(result.type, equals(MessageType.text));
        expect(result.senderId, equals('test-user-id'));
        expect(result.status, equals(MessageStatus.sent));
        expect(result.chatId, equals('test-chat-id'));
        
        verify(mockMessageDocument.set(any)).called(1);
        verify(mockFirestore.runTransaction(any)).called(1);
      });

      test('should send image message with attachments', () async {
        // Arrange
        final attachment = TestFixtures.createMediaAttachment(
          url: 'https://example.com/image.jpg',
          fileName: 'test.jpg',
          mimeType: 'image/jpeg',
        );

        when(mockMessageDocument.set(any)).thenAnswer((_) async => {});
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionFunction = invocation.positionalArguments[0] as Function;
          return await transactionFunction(mockTransaction);
        });
        when(mockTransaction.update(any, any)).thenAnswer((_) async => {});

        // Act
        final result = await RealtimeChatService.sendMessage(
          chatId: 'test-chat-id',
          content: 'Sent an image',
          type: MessageType.image,
          attachments: [attachment],
        );

        // Assert
        expect(result.type, equals(MessageType.image));
        expect(result.hasAttachments, isTrue);
        expect(result.attachments.length, equals(1));
        expect(result.attachments.first.url, equals('https://example.com/image.jpg'));
      });

      test('should handle send message failure', () async {
        // Arrange
        when(mockFirestore.runTransaction(any))
            .thenThrow(const FirebaseException(
              plugin: 'cloud_firestore',
              code: 'unavailable',
              message: 'Service unavailable',
            ));

        // Act & Assert
        expect(
          () => RealtimeChatService.sendMessage(
            chatId: 'test-chat-id',
            content: 'Test message',
            type: MessageType.text,
          ),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should throw exception when user is not authenticated', () async {
        // Arrange
        when(mockAuth.currentUser).thenReturn(null);

        // Act & Assert
        expect(
          () => RealtimeChatService.sendMessage(
            chatId: 'test-chat-id',
            content: 'Test message',
            type: MessageType.text,
          ),
          throwsA(isA<AuthenticationException>()),
        );
      });

      test('should validate message content', () async {
        // Arrange & Act & Assert
        expect(
          () => RealtimeChatService.sendMessage(
            chatId: 'test-chat-id',
            content: '', // Empty content
            type: MessageType.text,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('should validate chat ID', () async {
        // Arrange & Act & Assert
        expect(
          () => RealtimeChatService.sendMessage(
            chatId: '', // Empty chat ID
            content: 'Test message',
            type: MessageType.text,
          ),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('markMessagesAsRead', () {
      test('should mark multiple messages as read successfully', () async {
        // Arrange
        final messageIds = ['msg1', 'msg2', 'msg3'];
        
        when(mockBatch.update(any, any)).thenAnswer((_) => mockBatch);
        when(mockBatch.commit()).thenAnswer((_) async => []);
        when(mockChatDocument.update(any)).thenAnswer((_) async => {});

        // Act
        await RealtimeChatService.markMessagesAsRead(
          chatId: 'test-chat-id',
          messageIds: messageIds,
        );

        // Assert
        verify(mockBatch.commit()).called(1);
        verify(mockChatDocument.update(any)).called(1);
      });

      test('should handle empty message IDs list', () async {
        // Arrange
        const messageIds = <String>[];

        // Act
        await RealtimeChatService.markMessagesAsRead(
          chatId: 'test-chat-id',
          messageIds: messageIds,
        );

        // Assert - Should not call batch operations for empty list
        verifyNever(mockBatch.commit());
      });

      test('should handle mark as read failure', () async {
        // Arrange
        final messageIds = ['msg1', 'msg2'];
        
        when(mockBatch.update(any, any)).thenAnswer((_) => mockBatch);
        when(mockBatch.commit()).thenThrow(const FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Permission denied',
        ));

        // Act & Assert
        expect(
          () => RealtimeChatService.markMessagesAsRead(
            chatId: 'test-chat-id',
            messageIds: messageIds,
          ),
          throwsA(isA<PermissionException>()),
        );
      });
    });

    group('addReaction', () {
      test('should add reaction to message successfully', () async {
        // Arrange
        when(mockChatDocument.collection('messages'))
            .thenReturn(mockMessagesCollection);
        when(mockMessagesCollection.doc('test-message-id'))
            .thenReturn(mockMessageDocument);
        when(mockMessageDocument.update(any)).thenAnswer((_) async => {});

        // Act
        await RealtimeChatService.addReaction(
          chatId: 'test-chat-id',
          messageId: 'test-message-id',
          emoji: '👍',
        );

        // Assert
        verify(mockMessageDocument.update(any)).called(1);
        
        final capturedUpdate = verify(mockMessageDocument.update(captureAny)).captured.first as Map;
        expect(capturedUpdate.containsKey('reactions.test-user-id'), isTrue);
      });

      test('should handle reaction addition failure', () async {
        // Arrange
        when(mockChatDocument.collection('messages'))
            .thenReturn(mockMessagesCollection);
        when(mockMessagesCollection.doc('test-message-id'))
            .thenReturn(mockMessageDocument);
        when(mockMessageDocument.update(any))
            .thenThrow(const FirebaseException(
              plugin: 'cloud_firestore',
              code: 'not-found',
              message: 'Message not found',
            ));

        // Act & Assert
        expect(
          () => RealtimeChatService.addReaction(
            chatId: 'test-chat-id',
            messageId: 'test-message-id',
            emoji: '👍',
          ),
          throwsA(isA<NotFoundException>()),
        );
      });
    });

    group('removeReaction', () {
      test('should remove reaction from message successfully', () async {
        // Arrange
        when(mockChatDocument.collection('messages'))
            .thenReturn(mockMessagesCollection);
        when(mockMessagesCollection.doc('test-message-id'))
            .thenReturn(mockMessageDocument);
        when(mockMessageDocument.update(any)).thenAnswer((_) async => {});

        // Act
        await RealtimeChatService.removeReaction(
          chatId: 'test-chat-id',
          messageId: 'test-message-id',
        );

        // Assert
        verify(mockMessageDocument.update(any)).called(1);
        
        final capturedUpdate = verify(mockMessageDocument.update(captureAny)).captured.first as Map;
        expect(capturedUpdate.containsKey('reactions.test-user-id'), isTrue);
      });
    });

    group('editMessage', () {
      test('should edit message successfully', () async {
        // Arrange
        const newContent = 'Edited message content';
        
        when(mockChatDocument.collection('messages'))
            .thenReturn(mockMessagesCollection);
        when(mockMessagesCollection.doc('test-message-id'))
            .thenReturn(mockMessageDocument);
        when(mockMessageDocument.update(any)).thenAnswer((_) async => {});

        // Act
        await RealtimeChatService.editMessage(
          chatId: 'test-chat-id',
          messageId: 'test-message-id',
          newContent: newContent,
        );

        // Assert
        verify(mockMessageDocument.update(any)).called(1);
        
        final capturedUpdate = verify(mockMessageDocument.update(captureAny)).captured.first as Map;
        expect(capturedUpdate['content'], equals(newContent));
        expect(capturedUpdate.containsKey('editHistory'), isTrue);
        expect(capturedUpdate.containsKey('updatedAt'), isTrue);
      });

      test('should validate edit content', () async {
        // Act & Assert
        expect(
          () => RealtimeChatService.editMessage(
            chatId: 'test-chat-id',
            messageId: 'test-message-id',
            newContent: '', // Empty content
          ),
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('deleteMessage', () {
      test('should delete message successfully', () async {
        // Arrange
        when(mockChatDocument.collection('messages'))
            .thenReturn(mockMessagesCollection);
        when(mockMessagesCollection.doc('test-message-id'))
            .thenReturn(mockMessageDocument);
        when(mockMessageDocument.update(any)).thenAnswer((_) async => {});

        // Act
        await RealtimeChatService.deleteMessage(
          chatId: 'test-chat-id',
          messageId: 'test-message-id',
        );

        // Assert
        verify(mockMessageDocument.update(any)).called(1);
        
        final capturedUpdate = verify(mockMessageDocument.update(captureAny)).captured.first as Map;
        expect(capturedUpdate['isDeleted'], isTrue);
        expect(capturedUpdate['content'], equals('This message was deleted'));
        expect(capturedUpdate.containsKey('deletedAt'), isTrue);
      });
    });

    group('streamMessages', () {
      test('should create messages stream correctly', () async {
        // Arrange
        final mockQuery = MockQuery();
        final mockQuerySnapshot = MockQuerySnapshot();
        final testMessages = TestFixtures.createMessageList(
          chatId: 'test-chat-id',
          count: 5,
        );
        
        when(mockMessagesCollection.orderBy('timestamp', descending: true))
            .thenReturn(mockQuery);
        when(mockQuery.limit(50)).thenReturn(mockQuery);
        when(mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final stream = RealtimeChatService.streamMessages(
          chatId: 'test-chat-id',
          limit: 50,
        );

        // Assert
        expect(stream, isA<Stream<List<MessageModel>>>());
        
        verify(mockMessagesCollection.orderBy('timestamp', descending: true)).called(1);
        verify(mockQuery.limit(50)).called(1);
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle Firestore permission errors', () async {
        // Arrange
        when(mockFirestore.runTransaction(any))
            .thenThrow(const FirebaseException(
              plugin: 'cloud_firestore',
              code: 'permission-denied',
              message: 'Permission denied',
            ));

        // Act & Assert
        expect(
          () => RealtimeChatService.sendMessage(
            chatId: 'test-chat-id',
            content: 'Test message',
            type: MessageType.text,
          ),
          throwsA(isA<PermissionException>()),
        );
      });

      test('should handle network connectivity issues', () async {
        // Arrange
        when(mockFirestore.runTransaction(any))
            .thenThrow(const FirebaseException(
              plugin: 'cloud_firestore',
              code: 'unavailable',
              message: 'Network unavailable',
            ));

        // Act & Assert
        expect(
          () => RealtimeChatService.sendMessage(
            chatId: 'test-chat-id',
            content: 'Test message',
            type: MessageType.text,
          ),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should handle very long message content', () async {
        // Arrange
        final longContent = 'A' * 10000;
        when(mockMessageDocument.set(any)).thenAnswer((_) async => {});
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionFunction = invocation.positionalArguments[0] as Function;
          return await transactionFunction(mockTransaction);
        });
        when(mockTransaction.update(any, any)).thenAnswer((_) async => {});

        // Act
        final result = await RealtimeChatService.sendMessage(
          chatId: 'test-chat-id',
          content: longContent,
          type: MessageType.text,
        );

        // Assert
        expect(result.content.length, equals(10000));
      });

      test('should handle concurrent message sending', () async {
        // Arrange
        when(mockMessageDocument.set(any)).thenAnswer((_) async => {});
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionFunction = invocation.positionalArguments[0] as Function;
          // Simulate delay
          await Future.delayed(const Duration(milliseconds: 100));
          return await transactionFunction(mockTransaction);
        });
        when(mockTransaction.update(any, any)).thenAnswer((_) async => {});

        // Act
        final futures = List.generate(5, (index) => 
          RealtimeChatService.sendMessage(
            chatId: 'test-chat-id',
            content: 'Concurrent message $index',
            type: MessageType.text,
          ),
        );

        final results = await Future.wait(futures);

        // Assert
        expect(results.length, equals(5));
        for (int i = 0; i < results.length; i++) {
          expect(results[i].content, equals('Concurrent message $i'));
        }
      });
    });
  });
}
