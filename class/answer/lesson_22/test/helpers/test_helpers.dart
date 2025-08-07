import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:connectpro_ultimate_testing/core/constants/app_constants.dart';

/// A collection of helper functions and utilities for testing
class TestHelpers {
  /// Creates a MaterialApp wrapper for widget testing
  static Widget createTestApp({
    required Widget child,
    List<Override>? overrides,
    ThemeData? theme,
    Locale? locale,
    List<NavigatorObserver>? navigatorObservers,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: MaterialApp(
        title: 'Test App',
        theme: theme ?? ThemeData.light(),
        locale: locale,
        navigatorObservers: navigatorObservers ?? [],
        home: child,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  /// Creates a Scaffold wrapper for testing widgets that need a Scaffold
  static Widget createScaffoldWrapper({
    required Widget child,
    AppBar? appBar,
    Widget? floatingActionButton,
    List<Override>? overrides,
  }) {
    return createTestApp(
      overrides: overrides,
      child: Scaffold(
        appBar: appBar,
        body: child,
        floatingActionButton: floatingActionButton,
      ),
    );
  }

  /// Creates a ProviderScope for testing Riverpod providers
  static Widget createProviderTestApp({
    required Widget child,
    required List<Override> overrides,
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: child,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  /// Pumps a widget and waits for all animations to complete
  static Future<void> pumpAndSettle(
    WidgetTester tester,
    Widget widget, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(timeout);
  }

  /// Finds a widget by its key
  static Finder findByKey(String key) {
    return find.byKey(Key(key));
  }

  /// Finds a widget by its text content
  static Finder findByText(String text) {
    return find.text(text);
  }

  /// Finds a widget by its icon
  static Finder findByIcon(IconData icon) {
    return find.byIcon(icon);
  }

  /// Finds a widget by its type
  static Finder findByType<T extends Widget>() {
    return find.byType(T);
  }

  /// Enters text into a TextField
  static Future<void> enterText(
    WidgetTester tester,
    String text, {
    String? fieldKey,
    Type? fieldType,
  }) async {
    final finder = fieldKey != null
        ? findByKey(fieldKey)
        : fieldType != null
            ? find.byType(fieldType)
            : find.byType(TextField);

    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Taps a widget and waits for animations
  static Future<void> tapAndSettle(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.tap(finder);
    await tester.pumpAndSettle(timeout);
  }

  /// Taps a widget by key
  static Future<void> tapByKey(
    WidgetTester tester,
    String key, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tapAndSettle(tester, findByKey(key), timeout: timeout);
  }

  /// Taps a widget by text
  static Future<void> tapByText(
    WidgetTester tester,
    String text, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tapAndSettle(tester, findByText(text), timeout: timeout);
  }

  /// Scrolls until a widget is visible
  static Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder finder,
    Finder scrollable, {
    double delta = 100,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.scrollUntilVisible(
      finder,
      delta,
      scrollable: scrollable,
      timeout: timeout,
    );
    await tester.pumpAndSettle();
  }

  /// Drags a widget to perform scroll or swipe gestures
  static Future<void> drag(
    WidgetTester tester,
    Finder finder,
    Offset offset, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.drag(finder, offset);
    await tester.pumpAndSettle(timeout);
  }

  /// Performs a long press on a widget
  static Future<void> longPress(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.longPress(finder);
    await tester.pumpAndSettle(timeout);
  }

  /// Expects a widget to exist
  static void expectToFind(Finder finder) {
    expect(finder, findsOneWidget);
  }

  /// Expects a widget to not exist
  static void expectNotToFind(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Expects multiple widgets to exist
  static void expectToFindNWidgets(Finder finder, int count) {
    expect(finder, findsNWidgets(count));
  }

  /// Expects at least one widget to exist
  static void expectToFindAtLeastOne(Finder finder) {
    expect(finder, findsAtLeastNWidgets(1));
  }

  /// Expects text to be present
  static void expectText(String text) {
    expectToFind(findByText(text));
  }

  /// Expects text to not be present
  static void expectNoText(String text) {
    expectNotToFind(findByText(text));
  }

  /// Verifies that a widget has specific properties
  static void expectWidgetProperties<T extends Widget>(
    Finder finder,
    void Function(T widget) verifier,
  ) {
    final widget = finder.evaluate().single.widget as T;
    verifier(widget);
  }

  /// Waits for a specific condition to be true
  static Future<void> waitForCondition(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 10),
    Duration interval = const Duration(milliseconds: 100),
  }) async {
    final stopwatch = Stopwatch()..start();
    while (!condition() && stopwatch.elapsed < timeout) {
      await tester.pump(interval);
    }
    stopwatch.stop();
    
    if (!condition()) {
      throw TimeoutException(
        'Condition not met within $timeout',
        timeout,
      );
    }
  }

  /// Waits for a widget to appear
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await waitForCondition(
      tester,
      () => finder.evaluate().isNotEmpty,
      timeout: timeout,
    );
  }

  /// Waits for a widget to disappear
  static Future<void> waitForWidgetToDisappear(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await waitForCondition(
      tester,
      () => finder.evaluate().isEmpty,
      timeout: timeout,
    );
  }

  /// Gets the widget from a finder
  static T getWidget<T extends Widget>(Finder finder) {
    return finder.evaluate().single.widget as T;
  }

  /// Gets the state from a StatefulWidget finder
  static T getState<T extends State>(Finder finder) {
    return tester.state<T>(finder);
  }

  /// Gets the render object from a finder
  static T getRenderObject<T extends RenderObject>(Finder finder) {
    return tester.renderObject<T>(finder);
  }

  /// Captures an exception during widget testing
  static T captureException<T extends Object>(void Function() action) {
    try {
      action();
      throw Exception('Expected exception was not thrown');
    } catch (e) {
      if (e is T) {
        return e;
      }
      rethrow;
    }
  }

  /// Creates a mock verification helper
  static VerificationResult verifyMockCall(Mock mock, Function call) {
    return verify(call);
  }

  /// Creates a mock stub helper
  static PostExpectation whenMockCall(Mock mock, Function call) {
    return when(call);
  }

  /// Generates test data with consistent patterns
  static Map<String, dynamic> generateTestData({
    String? id,
    String? name,
    String? email,
    DateTime? timestamp,
  }) {
    final now = timestamp ?? DateTime.now();
    return {
      'id': id ?? 'test-id-${now.millisecondsSinceEpoch}',
      'name': name ?? 'Test Name',
      'email': email ?? 'test@example.com',
      'timestamp': now.toIso8601String(),
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    };
  }

  /// Creates a test user data structure
  static Map<String, dynamic> createTestUser({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    bool isVerified = false,
  }) {
    return {
      'id': id ?? 'test-user-${DateTime.now().millisecondsSinceEpoch}',
      'email': email ?? 'testuser@example.com',
      'displayName': displayName ?? 'Test User',
      'photoURL': photoUrl,
      'emailVerified': isVerified,
      'isActive': true,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Creates test message data
  static Map<String, dynamic> createTestMessage({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    String type = 'text',
    DateTime? timestamp,
  }) {
    return {
      'id': id ?? 'test-message-${DateTime.now().millisecondsSinceEpoch}',
      'chatId': chatId ?? 'test-chat-id',
      'senderId': senderId ?? 'test-sender-id',
      'content': content ?? 'Test message content',
      'type': type,
      'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
      'status': 'sent',
      'reactions': <String, dynamic>{},
      'readBy': <String>[],
      'isDeleted': false,
      'isEncrypted': false,
    };
  }

  /// Creates test post data
  static Map<String, dynamic> createTestPost({
    String? id,
    String? authorId,
    String? content,
    List<String>? hashtags,
    List<String>? mentions,
    int likesCount = 0,
    int commentsCount = 0,
    DateTime? timestamp,
  }) {
    return {
      'id': id ?? 'test-post-${DateTime.now().millisecondsSinceEpoch}',
      'authorId': authorId ?? 'test-author-id',
      'content': content ?? 'Test post content with #hashtag and @mention',
      'hashtags': hashtags ?? ['hashtag'],
      'mentions': mentions ?? ['mention'],
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': 0,
      'viewsCount': 0,
      'visibility': 'public',
      'createdAt': (timestamp ?? DateTime.now()).toIso8601String(),
      'updatedAt': (timestamp ?? DateTime.now()).toIso8601String(),
      'isDeleted': false,
      'status': 'published',
    };
  }

  /// Validates widget accessibility
  static Future<void> verifyAccessibility(
    WidgetTester tester,
    Widget widget,
  ) async {
    await tester.pumpWidget(widget);
    final handle = tester.ensureSemantics();
    
    // Verify semantic labels exist
    expect(find.bySemanticsLabel(RegExp(r'.+')), findsAtLeastNWidgets(1));
    
    // Cleanup
    handle.dispose();
  }

  /// Performance testing helper
  static Future<void> measureWidgetPerformance(
    WidgetTester tester,
    Widget widget,
    String testName, {
    int iterations = 10,
  }) async {
    final stopwatch = Stopwatch();
    
    for (int i = 0; i < iterations; i++) {
      stopwatch.start();
      await tester.pumpWidget(widget);
      await tester.pump();
      stopwatch.stop();
    }
    
    final averageTime = stopwatch.elapsedMicroseconds / iterations;
    print('$testName: Average render time: ${averageTime}μs');
    
    // Assert reasonable performance
    expect(averageTime, lessThan(16667)); // 60fps threshold
  }
}

/// Exception class for test timeouts
class TimeoutException implements Exception {
  const TimeoutException(this.message, this.timeout);
  
  final String message;
  final Duration timeout;
  
  @override
  String toString() => 'TimeoutException: $message (timeout: $timeout)';
}

/// Test fixture base class for consistent test setup
abstract class TestFixture {
  /// Setup method called before each test
  void setUp() {}
  
  /// Teardown method called after each test
  void tearDown() {}
  
  /// Creates test-specific overrides
  List<Override> createOverrides() => [];
}
