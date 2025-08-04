# 🧪 Lesson 22: Unit & Widget Testing - Concepts

## 🎯 **Learning Objectives**

By the end of this lesson, you will master:
- **Unit Testing Excellence** - Comprehensive testing of business logic, models, and services
- **Widget Testing Mastery** - Complete UI component testing with user interaction simulation
- **Firebase Testing Strategies** - Testing Firebase services with mocks and emulators
- **State Management Testing** - Testing Provider, Riverpod, Bloc patterns with complex scenarios
- **Async Testing Proficiency** - Testing streams, futures, and real-time operations
- **Test-Driven Development** - TDD principles and practices for Flutter development
- **Code Coverage Excellence** - Achieving >90% test coverage with meaningful tests
- **Performance Testing** - Testing app performance, memory usage, and optimization validation
- **Integration Testing Foundations** - Preparing for comprehensive integration testing strategies

## 🚀 **Testing Philosophy and Best Practices**

### **Why Testing Matters in Production Flutter Apps**

Professional Flutter development requires comprehensive testing to ensure:

```dart
// The Testing Pyramid for Flutter Applications
class FlutterTestingPyramid {
  static const testingLevels = {
    'Unit Tests (70%)': {
      'Purpose': 'Test individual functions, methods, and classes',
      'Speed': 'Very Fast (<1ms per test)',
      'Scope': 'Isolated business logic and data models',
      'Tools': 'test package, mockito, bloc_test',
      'Examples': [
        'Model serialization/deserialization',
        'Business logic calculations', 
        'Repository methods',
        'Use case implementations',
        'Utility functions'
      ],
    },
    
    'Widget Tests (20%)': {
      'Purpose': 'Test UI components and user interactions',
      'Speed': 'Fast (<100ms per test)',
      'Scope': 'Individual widgets and widget trees',
      'Tools': 'flutter_test, widget testing framework',
      'Examples': [
        'Widget rendering and layout',
        'User tap and scroll interactions',
        'Form validation and input',
        'State changes and updates',
        'Navigation and routing'
      ],
    },
    
    'Integration Tests (10%)': {
      'Purpose': 'Test complete user flows and app behavior',
      'Speed': 'Slow (seconds per test)',
      'Scope': 'Full app functionality end-to-end',
      'Tools': 'integration_test, patrol, golden tests',
      'Examples': [
        'Complete user registration flow',
        'Chat message sending and receiving',
        'Social feed interactions',
        'Push notification handling',
        'Offline functionality'
      ],
    },
  };

  // Quality Gates and Metrics
  static const qualityStandards = [
    'Code Coverage >90% with meaningful tests',
    'All critical paths covered with unit tests',
    'UI components tested with widget tests',
    'Performance benchmarks validated',
    'Edge cases and error scenarios covered',
    'Async operations properly tested',
    'Mock services for external dependencies',
    'Consistent test structure and naming',
  ];
}
```

### **Testing Strategy for Complex Flutter Applications**

```dart
// Comprehensive Testing Strategy
class ProductionTestingStrategy {
  // Test Organization Principles
  static const organizationPrinciples = [
    'AAA Pattern - Arrange, Act, Assert for clear test structure',
    'One Assertion per Test - Focus on single behavior validation',
    'Descriptive Names - Tests as living documentation',
    'Fast and Reliable - Tests run quickly and consistently',
    'Independent Tests - No dependencies between test cases',
    'Realistic Data - Use production-like test data',
    'Edge Case Coverage - Test boundary conditions and errors',
    'Performance Awareness - Monitor test execution time',
  ];

  // Test Categories by Application Layer
  static const testingByLayer = {
    'Domain Layer Testing': [
      'Entity validation and business rules',
      'Use case logic and error handling', 
      'Repository interface contracts',
      'Value object immutability and equality',
    ],
    
    'Data Layer Testing': [
      'Model serialization/deserialization',
      'Repository implementations with mocks',
      'Network service error handling',
      'Local storage operations',
      'Cache management and invalidation',
    ],
    
    'Presentation Layer Testing': [
      'State management provider testing',
      'Widget interaction and behavior',
      'Navigation and routing logic',
      'Form validation and user input',
      'Loading states and error handling',
    ],
    
    'Core Layer Testing': [
      'Utility function correctness',
      'Service configuration and setup',
      'Error handling and logging',
      'Performance monitoring helpers',
    ],
  };
}
```

## 🧪 **Unit Testing Deep Dive**

### **Testing Business Logic and Models**

```dart
// test/unit/models/message_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectpro_ultimate/data/models/chat_models.dart';

void main() {
  group('MessageModel', () {
    late MessageModel testMessage;
    
    setUp(() {
      testMessage = MessageModel(
        id: 'test-message-id',
        chatId: 'test-chat-id',
        senderId: 'test-sender-id',
        content: 'Test message content',
        type: MessageType.text,
        timestamp: DateTime(2024, 1, 15, 10, 30),
        attachments: [],
        metadata: {},
        reactions: {},
        readBy: [],
        editHistory: [],
        isDeleted: false,
        isEncrypted: false,
        status: MessageStatus.sent,
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
      });

      test('should have correct default values', () {
        expect(testMessage.attachments, isEmpty);
        expect(testMessage.reactions, isEmpty);
        expect(testMessage.readBy, isEmpty);
        expect(testMessage.editHistory, isEmpty);
        expect(testMessage.isDeleted, isFalse);
        expect(testMessage.isEncrypted, isFalse);
      });
    });

    group('Helper Methods', () {
      test('hasAttachments should return false for text message', () {
        expect(testMessage.hasAttachments, isFalse);
      });

      test('hasAttachments should return true when attachments exist', () {
        final messageWithAttachments = testMessage.copyWith(
          attachments: [
            MediaAttachment(
              id: 'attachment-1',
              url: 'https://example.com/image.jpg',
              fileName: 'image.jpg',
              mimeType: 'image/jpeg',
              sizeBytes: 1024,
              uploadedAt: DateTime.now(),
            ),
          ],
        );
        
        expect(messageWithAttachments.hasAttachments, isTrue);
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
      });

      test('messageAge should calculate correct duration', () {
        final now = DateTime.now();
        final oneHourAgo = now.subtract(Duration(hours: 1));
        final recentMessage = testMessage.copyWith(timestamp: oneHourAgo);
        
        expect(recentMessage.messageAge.inHours, equals(1));
      });
    });

    group('Firestore Serialization', () {
      test('should convert to Firestore format correctly', () {
        final firestoreData = testMessage.toFirestore();
        
        expect(firestoreData['chatId'], equals('test-chat-id'));
        expect(firestoreData['senderId'], equals('test-sender-id'));
        expect(firestoreData['content'], equals('Test message content'));
        expect(firestoreData['type'], equals('MessageType.text'));
        expect(firestoreData['timestamp'], isA<Timestamp>());
        expect(firestoreData['status'], equals('MessageStatus.sent'));
      });

      test('should create from Firestore snapshot correctly', () {
        // Create mock Firestore document
        final mockData = {
          'chatId': 'test-chat-id',
          'senderId': 'test-sender-id',
          'content': 'Test message content',
          'type': 'MessageType.text',
          'timestamp': Timestamp.fromDate(DateTime(2024, 1, 15, 10, 30)),
          'attachments': [],
          'metadata': {},
          'reactions': {},
          'readBy': [],
          'editHistory': [],
          'isDeleted': false,
          'isEncrypted': false,
          'status': 'MessageStatus.sent',
        };

        // Note: In real tests, you'd use a proper mock DocumentSnapshot
        // For this example, we're showing the data structure validation
        expect(mockData['chatId'], equals('test-chat-id'));
        expect(mockData['content'], equals('Test message content'));
      });
    });

    group('Reaction Management', () {
      test('getUsersWhoReacted should return empty list for no reactions', () {
        final users = testMessage.getUsersWhoReacted('👍');
        expect(users, isEmpty);
      });

      test('getUsersWhoReacted should return correct users for emoji', () {
        final messageWithReactions = testMessage.copyWith(
          reactions: {
            'user1': MessageReaction(
              emoji: '👍',
              userId: 'user1',
              timestamp: DateTime.now(),
            ),
            'user2': MessageReaction(
              emoji: '❤️',
              userId: 'user2',
              timestamp: DateTime.now(),
            ),
            'user3': MessageReaction(
              emoji: '👍',
              userId: 'user3',
              timestamp: DateTime.now(),
            ),
          },
        );

        final thumbsUpUsers = messageWithReactions.getUsersWhoReacted('👍');
        expect(thumbsUpUsers, hasLength(2));
        expect(thumbsUpUsers, containsAll(['user1', 'user3']));
      });

      test('reactionCounts should calculate correct counts', () {
        final messageWithReactions = testMessage.copyWith(
          reactions: {
            'user1': MessageReaction(
              emoji: '👍',
              userId: 'user1',
              timestamp: DateTime.now(),
            ),
            'user2': MessageReaction(
              emoji: '👍',
              userId: 'user2',
              timestamp: DateTime.now(),
            ),
            'user3': MessageReaction(
              emoji: '❤️',
              userId: 'user3',
              timestamp: DateTime.now(),
            ),
          },
        );

        final counts = messageWithReactions.reactionCounts;
        expect(counts['👍'], equals(2));
        expect(counts['❤️'], equals(1));
      });
    });

    group('Edge Cases and Validation', () {
      test('should handle empty content gracefully', () {
        final emptyMessage = testMessage.copyWith(content: '');
        expect(emptyMessage.content, equals(''));
        expect(emptyMessage.hasAttachments, isFalse);
      });

      test('should handle very long content', () {
        final longContent = 'A' * 10000;
        final longMessage = testMessage.copyWith(content: longContent);
        expect(longMessage.content.length, equals(10000));
      });

      test('should handle special characters in content', () {
        final specialContent = '🎉 Hello! @user #hashtag https://example.com 中文 العربية';
        final specialMessage = testMessage.copyWith(content: specialContent);
        expect(specialMessage.content, equals(specialContent));
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
  });
}
```

### **Testing Services and Repositories**

```dart
// test/unit/services/chat_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectpro_ultimate/data/services/realtime_chat_service.dart';
import 'package:connectpro_ultimate/data/models/chat_models.dart';

// Generate mocks
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

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockChatsCollection = MockCollectionReference();
      mockChatDocument = MockDocumentReference();
      mockMessagesCollection = MockCollectionReference();
      mockMessageDocument = MockDocumentReference();

      // Setup basic mocks
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test-user-id');
      when(mockFirestore.collection('chats')).thenReturn(mockChatsCollection);
      when(mockChatsCollection.doc(any)).thenReturn(mockChatDocument);
      when(mockChatDocument.collection('messages')).thenReturn(mockMessagesCollection);
      when(mockMessagesCollection.doc()).thenReturn(mockMessageDocument);
      when(mockMessageDocument.id).thenReturn('test-message-id');
    });

    group('sendMessage', () {
      test('should send message successfully', () async {
        // Arrange
        when(mockMessageDocument.set(any)).thenAnswer((_) async => {});
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionFunction = invocation.positionalArguments[0];
          final mockTransaction = MockTransaction();
          return await transactionFunction(mockTransaction);
        });

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
      });

      test('should handle send message failure', () async {
        // Arrange
        when(mockFirestore.runTransaction(any))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => RealtimeChatService.sendMessage(
            chatId: 'test-chat-id',
            content: 'Test message',
            type: MessageType.text,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should include attachments when provided', () async {
        // Arrange
        final attachments = [
          MediaAttachment(
            id: 'attachment-1',
            url: 'https://example.com/image.jpg',
            fileName: 'image.jpg',
            mimeType: 'image/jpeg',
            sizeBytes: 1024,
            uploadedAt: DateTime.now(),
          ),
        ];

        when(mockMessageDocument.set(any)).thenAnswer((_) async => {});
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionFunction = invocation.positionalArguments[0];
          final mockTransaction = MockTransaction();
          return await transactionFunction(mockTransaction);
        });

        // Act
        final result = await RealtimeChatService.sendMessage(
          chatId: 'test-chat-id',
          content: 'Test message with attachment',
          type: MessageType.image,
          attachments: attachments,
        );

        // Assert
        expect(result.hasAttachments, isTrue);
        expect(result.attachments.length, equals(1));
        expect(result.type, equals(MessageType.image));
      });
    });

    group('markMessagesAsRead', () {
      test('should mark multiple messages as read', () async {
        // Arrange
        final messageIds = ['msg1', 'msg2', 'msg3'];
        final mockBatch = MockWriteBatch();
        
        when(mockFirestore.batch()).thenReturn(mockBatch);
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
    });

    group('Edge Cases and Error Handling', () {
      test('should handle null user gracefully', () async {
        // Arrange
        when(mockAuth.currentUser).thenReturn(null);

        // Act & Assert
        expect(
          () => RealtimeChatService.sendMessage(
            chatId: 'test-chat-id',
            content: 'Test message',
            type: MessageType.text,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle empty message content', () async {
        // Arrange
        when(mockMessageDocument.set(any)).thenAnswer((_) async => {});
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionFunction = invocation.positionalArguments[0];
          final mockTransaction = MockTransaction();
          return await transactionFunction(mockTransaction);
        });

        // Act
        final result = await RealtimeChatService.sendMessage(
          chatId: 'test-chat-id',
          content: '',
          type: MessageType.text,
        );

        // Assert
        expect(result.content, equals(''));
      });

      test('should handle very long message content', () async {
        // Arrange
        final longContent = 'A' * 10000;
        when(mockMessageDocument.set(any)).thenAnswer((_) async => {});
        when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
          final transactionFunction = invocation.positionalArguments[0];
          final mockTransaction = MockTransaction();
          return await transactionFunction(mockTransaction);
        });

        // Act
        final result = await RealtimeChatService.sendMessage(
          chatId: 'test-chat-id',
          content: longContent,
          type: MessageType.text,
        );

        // Assert
        expect(result.content.length, equals(10000));
      });
    });
  });
}
```

### **Testing Use Cases and Business Logic**

```dart
// test/unit/domain/usecases/send_message_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:connectpro_ultimate/domain/usecases/chat_usecases.dart';
import 'package:connectpro_ultimate/domain/repositories/chat_repository.dart';
import 'package:connectpro_ultimate/domain/entities/chat_entities.dart';
import 'package:connectpro_ultimate/core/error/failures.dart';
import 'package:connectpro_ultimate/core/utils/result.dart';

@GenerateMocks([ChatRepository])
import 'send_message_usecase_test.mocks.dart';

void main() {
  group('SendMessageUseCase', () {
    late SendMessageUseCase useCase;
    late MockChatRepository mockRepository;

    setUp(() {
      mockRepository = MockChatRepository();
      useCase = SendMessageUseCase(mockRepository);
    });

    group('execute', () {
      test('should send message successfully', () async {
        // Arrange
        final params = SendMessageParams(
          chatId: 'test-chat-id',
          content: 'Test message',
          type: MessageType.text,
        );

        final expectedMessage = Message(
          id: 'test-message-id',
          chatId: 'test-chat-id',
          senderId: 'test-sender-id',
          content: 'Test message',
          type: MessageType.text,
          timestamp: DateTime.now(),
        );

        when(mockRepository.sendMessage(any))
            .thenAnswer((_) async => Result.success(expectedMessage));

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data?.content, equals('Test message'));
        verify(mockRepository.sendMessage(any)).called(1);
      });

      test('should return failure when repository fails', () async {
        // Arrange
        final params = SendMessageParams(
          chatId: 'test-chat-id',
          content: 'Test message',
          type: MessageType.text,
        );

        when(mockRepository.sendMessage(any))
            .thenAnswer((_) async => Result.failure(NetworkFailure('Connection error')));

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, isA<NetworkFailure>());
        verify(mockRepository.sendMessage(any)).called(1);
      });

      test('should validate message content before sending', () async {
        // Arrange
        final params = SendMessageParams(
          chatId: 'test-chat-id',
          content: '', // Empty content
          type: MessageType.text,
        );

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, isA<ValidationFailure>());
        verifyNever(mockRepository.sendMessage(any));
      });

      test('should validate chat ID before sending', () async {
        // Arrange
        final params = SendMessageParams(
          chatId: '', // Empty chat ID
          content: 'Test message',
          type: MessageType.text,
        );

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, isA<ValidationFailure>());
        verifyNever(mockRepository.sendMessage(any));
      });

      test('should handle very long messages', () async {
        // Arrange
        final longContent = 'A' * 10000;
        final params = SendMessageParams(
          chatId: 'test-chat-id',
          content: longContent,
          type: MessageType.text,
        );

        final expectedMessage = Message(
          id: 'test-message-id',
          chatId: 'test-chat-id',
          senderId: 'test-sender-id',
          content: longContent,
          type: MessageType.text,
          timestamp: DateTime.now(),
        );

        when(mockRepository.sendMessage(any))
            .thenAnswer((_) async => Result.success(expectedMessage));

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data?.content.length, equals(10000));
      });
    });

    group('Input Validation', () {
      test('should reject null chat ID', () async {
        // Arrange
        final params = SendMessageParams(
          chatId: null, // Null chat ID
          content: 'Test message',
          type: MessageType.text,
        );

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, isA<ValidationFailure>());
      });

      test('should reject messages with only whitespace', () async {
        // Arrange
        final params = SendMessageParams(
          chatId: 'test-chat-id',
          content: '   \n\t   ', // Only whitespace
          type: MessageType.text,
        );

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.error, isA<ValidationFailure>());
      });

      test('should accept valid special characters', () async {
        // Arrange
        final specialContent = '🎉 Hello! @user #hashtag https://example.com';
        final params = SendMessageParams(
          chatId: 'test-chat-id',
          content: specialContent,
          type: MessageType.text,
        );

        final expectedMessage = Message(
          id: 'test-message-id',
          chatId: 'test-chat-id',
          senderId: 'test-sender-id',
          content: specialContent,
          type: MessageType.text,
          timestamp: DateTime.now(),
        );

        when(mockRepository.sendMessage(any))
            .thenAnswer((_) async => Result.success(expectedMessage));

        // Act
        final result = await useCase.execute(params);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data?.content, equals(specialContent));
      });
    });
  });
}
```

## 🎨 **Widget Testing Excellence**

### **Testing UI Components and User Interactions**

```dart
// test/widget/chat/message_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectpro_ultimate/presentation/widgets/chat/message_widgets.dart';
import 'package:connectpro_ultimate/data/models/chat_models.dart';

void main() {
  group('MessageBubbleWidget', () {
    late MessageModel testMessage;

    setUp(() {
      testMessage = MessageModel(
        id: 'test-message-id',
        chatId: 'test-chat-id',
        senderId: 'test-sender-id',
        content: 'Test message content',
        type: MessageType.text,
        timestamp: DateTime(2024, 1, 15, 10, 30),
        attachments: [],
        metadata: {},
        reactions: {},
        readBy: [],
        editHistory: [],
        isDeleted: false,
        isEncrypted: false,
        status: MessageStatus.sent,
      );
    });

    testWidgets('should display message content correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MessageBubbleWidget(
                message: testMessage,
                isOwnMessage: false,
                showSenderName: true,
              ),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Test message content'), findsOneWidget);
      expect(find.byType(MessageBubbleWidget), findsOneWidget);
    });

    testWidgets('should show different style for own messages', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MessageBubbleWidget(
                message: testMessage,
                isOwnMessage: true,
                showSenderName: false,
              ),
            ),
          ),
        ),
      );

      // Act
      final messageBubble = tester.widget<Container>(
        find.descendant(
          of: find.byType(MessageBubbleWidget),
          matching: find.byType(Container),
        ),
      );

      // Assert
      expect(messageBubble.decoration, isA<BoxDecoration>());
      // Verify alignment and styling for own messages
    });

    testWidgets('should display timestamp correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MessageBubbleWidget(
                message: testMessage,
                isOwnMessage: false,
                showSenderName: true,
              ),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('10:30'), findsOneWidget);
    });

    testWidgets('should handle long messages with proper wrapping', (tester) async {
      // Arrange
      final longMessage = testMessage.copyWith(
        content: 'This is a very long message that should wrap to multiple lines when displayed in the message bubble widget to test the text wrapping functionality.',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300, // Constrained width to force wrapping
                child: MessageBubbleWidget(
                  message: longMessage,
                  isOwnMessage: false,
                  showSenderName: true,
                ),
              ),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.text(longMessage.content), findsOneWidget);
      
      // Verify the widget doesn't overflow
      expect(tester.takeException(), isNull);
    });

    group('Message Reactions', () {
      testWidgets('should display reactions when present', (tester) async {
        // Arrange
        final messageWithReactions = testMessage.copyWith(
          reactions: {
            'user1': MessageReaction(
              emoji: '👍',
              userId: 'user1',
              timestamp: DateTime.now(),
            ),
            'user2': MessageReaction(
              emoji: '❤️',
              userId: 'user2',
              timestamp: DateTime.now(),
            ),
          },
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: MessageBubbleWidget(
                  message: messageWithReactions,
                  isOwnMessage: false,
                  showSenderName: true,
                ),
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('👍'), findsOneWidget);
        expect(find.text('❤️'), findsOneWidget);
        expect(find.byType(ReactionChip), findsNWidgets(2));
      });

      testWidgets('should handle reaction tap', (tester) async {
        // Arrange
        bool reactionTapped = false;
        final messageWithReactions = testMessage.copyWith(
          reactions: {
            'user1': MessageReaction(
              emoji: '👍',
              userId: 'user1',
              timestamp: DateTime.now(),
            ),
          },
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: MessageBubbleWidget(
                  message: messageWithReactions,
                  isOwnMessage: false,
                  showSenderName: true,
                  onReactionTap: (emoji) {
                    reactionTapped = true;
                  },
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(ReactionChip).first);
        await tester.pumpAndSettle();

        // Assert
        expect(reactionTapped, isTrue);
      });
    });

    group('Message Status Indicators', () {
      testWidgets('should show sending status indicator', (tester) async {
        // Arrange
        final sendingMessage = testMessage.copyWith(
          status: MessageStatus.sending,
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: MessageBubbleWidget(
                  message: sendingMessage,
                  isOwnMessage: true,
                  showSenderName: false,
                ),
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.access_time), findsOneWidget);
      });

      testWidgets('should show sent status indicator', (tester) async {
        // Arrange
        final sentMessage = testMessage.copyWith(
          status: MessageStatus.sent,
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: MessageBubbleWidget(
                  message: sentMessage,
                  isOwnMessage: true,
                  showSenderName: false,
                ),
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('should show read status indicator', (tester) async {
        // Arrange
        final readMessage = testMessage.copyWith(
          status: MessageStatus.read,
          readBy: ['other-user-id'],
        );

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: MessageBubbleWidget(
                  message: readMessage,
                  isOwnMessage: true,
                  showSenderName: false,
                ),
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byIcon(Icons.done_all), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper accessibility labels', (tester) async {
        // Arrange
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: MessageBubbleWidget(
                  message: testMessage,
                  isOwnMessage: false,
                  showSenderName: true,
                ),
              ),
            ),
          ),
        );

        // Act & Assert
        expect(
          find.bySemanticsLabel('Message from test-sender-id: Test message content'),
          findsOneWidget,
        );
      });

      testWidgets('should support semantic actions', (tester) async {
        // Arrange
        bool longPressTriggered = false;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: MessageBubbleWidget(
                  message: testMessage,
                  isOwnMessage: true,
                  showSenderName: false,
                  onLongPress: () {
                    longPressTriggered = true;
                  },
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.longPress(find.byType(MessageBubbleWidget));
        await tester.pumpAndSettle();

        // Assert
        expect(longPressTriggered, isTrue);
      });
    });

    group('Performance', () {
      testWidgets('should not rebuild unnecessarily', (tester) async {
        // Arrange
        int buildCount = 0;
        
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    buildCount++;
                    return MessageBubbleWidget(
                      message: testMessage,
                      isOwnMessage: false,
                      showSenderName: true,
                    );
                  },
                ),
              ),
            ),
          ),
        );

        final initialBuildCount = buildCount;

        // Act - Update with same message
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    buildCount++;
                    return MessageBubbleWidget(
                      message: testMessage,
                      isOwnMessage: false,
                      showSenderName: true,
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Assert - Should not rebuild if props haven't changed
        expect(buildCount, equals(initialBuildCount + 1));
      });
    });
  });

  group('MessageListWidget', () {
    testWidgets('should display list of messages', (tester) async {
      // Arrange
      final messages = [
        testMessage,
        testMessage.copyWith(
          id: 'message-2',
          content: 'Second message',
          timestamp: DateTime(2024, 1, 15, 10, 31),
        ),
        testMessage.copyWith(
          id: 'message-3',
          content: 'Third message',
          timestamp: DateTime(2024, 1, 15, 10, 32),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MessageListWidget(
                messages: messages,
                currentUserId: 'test-sender-id',
              ),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(MessageBubbleWidget), findsNWidgets(3));
      expect(find.text('Test message content'), findsOneWidget);
      expect(find.text('Second message'), findsOneWidget);
      expect(find.text('Third message'), findsOneWidget);
    });

    testWidgets('should handle scroll to bottom', (tester) async {
      // Arrange
      final messages = List.generate(50, (index) => 
        testMessage.copyWith(
          id: 'message-$index',
          content: 'Message $index',
          timestamp: DateTime(2024, 1, 15, 10, 30 + index),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MessageListWidget(
                messages: messages,
                currentUserId: 'test-sender-id',
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.drag(
        find.byType(ListView),
        Offset(0, -1000), // Scroll up
      );
      await tester.pumpAndSettle();

      // Verify scroll position changed
      final scrollController = tester.widget<ListView>(
        find.byType(ListView),
      ).controller;
      
      expect(scrollController?.offset, greaterThan(0));
    });
  });
}
```

## 🧪 **Testing State Management Patterns**

### **Testing Riverpod Providers**

```dart
// test/unit/providers/chat_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:connectpro_ultimate/presentation/providers/chat_providers.dart';
import 'package:connectpro_ultimate/domain/usecases/chat_usecases.dart';
import 'package:connectpro_ultimate/data/models/chat_models.dart';

// Mock the use cases
class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}
class MockGetMessagesUseCase extends Mock implements GetMessagesUseCase {}

void main() {
  group('ChatMessagesProvider', () {
    late ProviderContainer container;
    late MockSendMessageUseCase mockSendMessageUseCase;
    late MockGetMessagesUseCase mockGetMessagesUseCase;

    setUp(() {
      mockSendMessageUseCase = MockSendMessageUseCase();
      mockGetMessagesUseCase = MockGetMessagesUseCase();

      container = ProviderContainer(
        overrides: [
          sendMessageUseCaseProvider.overrideWithValue(mockSendMessageUseCase),
          getMessagesUseCaseProvider.overrideWithValue(mockGetMessagesUseCase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should start with loading state', () {
      // Arrange & Act
      final provider = container.read(chatMessagesProvider('test-chat-id'));

      // Assert
      expect(provider.isLoading, isTrue);
      expect(provider.hasError, isFalse);
      expect(provider.value, isNull);
    });

    test('should load messages successfully', () async {
      // Arrange
      final testMessages = [
        MessageModel(
          id: 'msg-1',
          chatId: 'test-chat-id',
          senderId: 'user-1',
          content: 'Hello',
          type: MessageType.text,
          timestamp: DateTime.now(),
        ),
        MessageModel(
          id: 'msg-2',
          chatId: 'test-chat-id',
          senderId: 'user-2',
          content: 'Hi there',
          type: MessageType.text,
          timestamp: DateTime.now(),
        ),
      ];

      when(mockGetMessagesUseCase.execute(any))
          .thenAnswer((_) async => Result.success(testMessages));

      // Act
      final provider = container.read(chatMessagesProvider('test-chat-id'));
      await container.read(chatMessagesProvider('test-chat-id').future);

      // Assert
      expect(provider.isLoading, isFalse);
      expect(provider.hasError, isFalse);
      expect(provider.value?.length, equals(2));
    });

    test('should handle loading error', () async {
      // Arrange
      when(mockGetMessagesUseCase.execute(any))
          .thenAnswer((_) async => Result.failure(NetworkFailure('Connection error')));

      // Act
      try {
        await container.read(chatMessagesProvider('test-chat-id').future);
      } catch (e) {
        // Expected to throw
      }

      final provider = container.read(chatMessagesProvider('test-chat-id'));

      // Assert
      expect(provider.isLoading, isFalse);
      expect(provider.hasError, isTrue);
    });
  });

  group('ChatNotifierProvider', () {
    late ProviderContainer container;
    late MockSendMessageUseCase mockSendMessageUseCase;

    setUp(() {
      mockSendMessageUseCase = MockSendMessageUseCase();

      container = ProviderContainer(
        overrides: [
          sendMessageUseCaseProvider.overrideWithValue(mockSendMessageUseCase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should send message successfully', () async {
      // Arrange
      final testMessage = MessageModel(
        id: 'new-msg-id',
        chatId: 'test-chat-id',
        senderId: 'current-user-id',
        content: 'New message',
        type: MessageType.text,
        timestamp: DateTime.now(),
      );

      when(mockSendMessageUseCase.execute(any))
          .thenAnswer((_) async => Result.success(testMessage));

      // Act
      final notifier = container.read(chatNotifierProvider('test-chat-id').notifier);
      await notifier.sendMessage('New message', MessageType.text);

      // Assert
      verify(mockSendMessageUseCase.execute(any)).called(1);
      
      final state = container.read(chatNotifierProvider('test-chat-id'));
      expect(state.isLoading, isFalse);
      expect(state.hasError, isFalse);
    });

    test('should handle send message error', () async {
      // Arrange
      when(mockSendMessageUseCase.execute(any))
          .thenAnswer((_) async => Result.failure(NetworkFailure('Send failed')));

      // Act
      final notifier = container.read(chatNotifierProvider('test-chat-id').notifier);
      await notifier.sendMessage('New message', MessageType.text);

      // Assert
      final state = container.read(chatNotifierProvider('test-chat-id'));
      expect(state.hasError, isTrue);
      expect(state.error, isA<NetworkFailure>());
    });

    test('should update typing status', () async {
      // Arrange
      final notifier = container.read(chatNotifierProvider('test-chat-id').notifier);

      // Act
      await notifier.setTypingStatus(true);

      // Assert
      final state = container.read(chatNotifierProvider('test-chat-id'));
      expect(state.value?.isTyping, isTrue);
    });
  });
}
```

## 🔥 **Testing Firebase Integration**

### **Testing with Firebase Emulators**

```dart
// test/integration/firebase_test_helper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

class FirebaseTestHelper {
  static Future<void> setupFirebaseEmulators() async {
    await Firebase.initializeApp();
    
    // Use Firestore emulator
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    
    // Use Auth emulator
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    
    // Clear any existing data
    await clearFirestoreData();
  }

  static Future<void> clearFirestoreData() async {
    final firestore = FirebaseFirestore.instance;
    
    // Delete test collections
    await _deleteCollection(firestore, 'chats');
    await _deleteCollection(firestore, 'users');
    await _deleteCollection(firestore, 'posts');
    await _deleteCollection(firestore, 'notifications');
  }

  static Future<void> _deleteCollection(
    FirebaseFirestore firestore,
    String collectionPath,
  ) async {
    final collection = firestore.collection(collectionPath);
    final snapshot = await collection.get();
    
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  static Future<User> createTestUser({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (displayName != null) {
      await credential.user!.updateDisplayName(displayName);
    }

    return credential.user!;
  }

  static Future<void> signInTestUser({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<DocumentReference> createTestChat({
    required List<String> participantIds,
    String? name,
  }) async {
    final chatData = {
      'participantIds': participantIds,
      'name': name ?? 'Test Chat',
      'type': 'group',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isActive': true,
    };

    return await FirebaseFirestore.instance.collection('chats').add(chatData);
  }

  static Future<DocumentReference> createTestMessage({
    required String chatId,
    required String senderId,
    required String content,
  }) async {
    final messageData = {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'type': 'text',
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'sent',
      'attachments': [],
      'reactions': {},
      'readBy': [],
      'editHistory': [],
      'isDeleted': false,
      'isEncrypted': false,
    };

    return await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);
  }
}

// test/integration/chat_integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:connectpro_ultimate/data/services/realtime_chat_service.dart';
import 'package:connectpro_ultimate/data/models/chat_models.dart';
import 'firebase_test_helper.dart';

void main() {
  group('Chat Integration Tests', () {
    setUpAll(() async {
      await FirebaseTestHelper.setupFirebaseEmulators();
    });

    tearDown(() async {
      await FirebaseTestHelper.clearFirestoreData();
    });

    test('should send and receive messages in real-time', () async {
      // Arrange
      final user1 = await FirebaseTestHelper.createTestUser(
        email: 'user1@test.com',
        password: 'password123',
        displayName: 'User 1',
      );

      final user2 = await FirebaseTestHelper.createTestUser(
        email: 'user2@test.com',
        password: 'password123',
        displayName: 'User 2',
      );

      final chatRef = await FirebaseTestHelper.createTestChat(
        participantIds: [user1.uid, user2.uid],
        name: 'Test Chat',
      );

      // Sign in as user1
      await FirebaseTestHelper.signInTestUser(
        email: 'user1@test.com',
        password: 'password123',
      );

      // Act
      final sentMessage = await RealtimeChatService.sendMessage(
        chatId: chatRef.id,
        content: 'Hello from integration test',
        type: MessageType.text,
      );

      // Assert
      expect(sentMessage.content, equals('Hello from integration test'));
      expect(sentMessage.senderId, equals(user1.uid));
      expect(sentMessage.status, equals(MessageStatus.sent));

      // Verify message exists in Firestore
      final messageDoc = await chatRef
          .collection('messages')
          .doc(sentMessage.id)
          .get();

      expect(messageDoc.exists, isTrue);
      expect(messageDoc.data()!['content'], equals('Hello from integration test'));
    });

    test('should update unread counts correctly', () async {
      // Arrange
      final user1 = await FirebaseTestHelper.createTestUser(
        email: 'user1@test.com',
        password: 'password123',
      );

      final user2 = await FirebaseTestHelper.createTestUser(
        email: 'user2@test.com',
        password: 'password123',
      );

      final chatRef = await FirebaseTestHelper.createTestChat(
        participantIds: [user1.uid, user2.uid],
      );

      // Sign in as user1 and send message
      await FirebaseTestHelper.signInTestUser(
        email: 'user1@test.com',
        password: 'password123',
      );

      await RealtimeChatService.sendMessage(
        chatId: chatRef.id,
        content: 'Test message',
        type: MessageType.text,
      );

      // Act & Assert - Check unread count for user2
      final chatDoc = await chatRef.get();
      final chatData = chatDoc.data() as Map<String, dynamic>;
      final unreadCounts = chatData['unreadCounts'] as Map<String, dynamic>? ?? {};

      expect(unreadCounts[user2.uid], equals(1));
      expect(unreadCounts[user1.uid], anyOf(equals(0), isNull));
    });

    test('should handle message reactions correctly', () async {
      // Arrange
      final user1 = await FirebaseTestHelper.createTestUser(
        email: 'user1@test.com',
        password: 'password123',
      );

      final chatRef = await FirebaseTestHelper.createTestChat(
        participantIds: [user1.uid],
      );

      await FirebaseTestHelper.signInTestUser(
        email: 'user1@test.com',
        password: 'password123',
      );

      final message = await RealtimeChatService.sendMessage(
        chatId: chatRef.id,
        content: 'React to this message',
        type: MessageType.text,
      );

      // Act
      await RealtimeChatService.addReaction(
        chatId: chatRef.id,
        messageId: message.id,
        emoji: '👍',
      );

      // Assert
      final messageDoc = await chatRef
          .collection('messages')
          .doc(message.id)
          .get();

      final messageData = messageDoc.data()!;
      final reactions = messageData['reactions'] as Map<String, dynamic>;

      expect(reactions.containsKey(user1.uid), isTrue);
      expect(reactions[user1.uid]['emoji'], equals('👍'));
    });

    test('should stream messages in real-time', () async {
      // Arrange
      final user1 = await FirebaseTestHelper.createTestUser(
        email: 'user1@test.com',
        password: 'password123',
      );

      final chatRef = await FirebaseTestHelper.createTestChat(
        participantIds: [user1.uid],
      );

      await FirebaseTestHelper.signInTestUser(
        email: 'user1@test.com',
        password: 'password123',
      );

      // Act
      final messagesStream = RealtimeChatService.streamMessages(
        chatId: chatRef.id,
        limit: 50,
      );

      final messagesFuture = messagesStream.first;

      // Send a message while listening
      await RealtimeChatService.sendMessage(
        chatId: chatRef.id,
        content: 'Streaming test message',
        type: MessageType.text,
      );

      // Assert
      final messages = await messagesFuture;
      expect(messages.length, equals(1));
      expect(messages.first.content, equals('Streaming test message'));
    });
  });
}
```

This is the first part of Lesson 22 focusing on Unit Testing fundamentals and Widget Testing. The lesson continues with async testing, performance testing, code coverage, and TDD practices. Would you like me to continue with the remaining parts of the workshop?

**Ready to master comprehensive testing strategies for production Flutter applications! 🧪✨**