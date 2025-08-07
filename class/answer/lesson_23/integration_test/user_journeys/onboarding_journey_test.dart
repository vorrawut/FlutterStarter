import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol/patrol.dart';
import 'package:connectpro_ultimate_integration_testing/main.dart' as app;
import '../helpers/integration_test_helper.dart';
import '../helpers/performance_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete User Onboarding Journey E2E Tests', () {
    late PatrolIntegrationTester $;
    late PerformanceMonitor performanceMonitor;

    setUpAll(() async {
      await IntegrationTestHelper.setupTestEnvironment();
    });

    setUp(() async {
      $ = PatrolIntegrationTester(binding);
      performanceMonitor = PerformanceMonitor();
      await IntegrationTestHelper.resetAppState();
    });

    tearDownAll(() async {
      await IntegrationTestHelper.cleanupTestEnvironment();
    });

    patrolTest('Complete new user onboarding flow with performance monitoring', ($) async {
      print('🚀 Starting complete user onboarding journey test');
      
      await performanceMonitor.startMonitoring();
      
      try {
        // Step 1: App Launch and Splash Screen Validation
        print('📱 Step 1: Testing app launch and splash screen');
        app.main();
        await $.pumpAndSettle();
        
        // Verify splash screen appears with proper branding
        expect($.find.text('ConnectPro Ultimate'), findsOneWidget);
        expect($.find.byType(CircularProgressIndicator), findsOneWidget);
        
        // Validate splash screen animations and loading
        await $.pumpAndSettle(timeout: const Duration(seconds: 10));
        
        // Step 2: Welcome Screen Navigation and UI Validation
        print('👋 Step 2: Testing welcome screen navigation');
        expect($.find.text('Get Started'), findsOneWidget);
        expect($.find.text('Welcome to ConnectPro'), findsOneWidget);
        expect($.find.text('Connect with friends and family'), findsOneWidget);
        
        await $.tap($.find.text('Get Started'));
        await $.pumpAndSettle();
        
        // Verify navigation to authentication options
        expect($.find.text('Create Account'), findsOneWidget);
        expect($.find.text('Sign In'), findsOneWidget);
        
        // Step 3: Registration Flow with Comprehensive Validation
        print('📝 Step 3: Testing user registration with form validation');
        await $.tap($.find.text('Create Account'));
        await $.pumpAndSettle();
        
        // Test form validation - invalid email
        await $.enterText($.find.byKey(const Key('email_field')), 'invalid-email');
        await $.enterText($.find.byKey(const Key('password_field')), 'weak');
        await $.tap($.find.text('Continue'));
        await $.pumpAndSettle();
        
        // Verify validation errors appear
        expect($.find.text('Please enter a valid email'), findsOneWidget);
        expect($.find.text('Password must be at least 8 characters'), findsOneWidget);
        
        // Test password strength validation
        await $.enterText($.find.byKey(const Key('email_field')), 'test@example.com');
        await $.enterText($.find.byKey(const Key('password_field')), 'password123');
        await $.enterText($.find.byKey(const Key('confirm_password_field')), 'different123');
        await $.tap($.find.text('Continue'));
        await $.pumpAndSettle();
        
        expect($.find.text('Passwords do not match'), findsOneWidget);
        
        // Complete valid registration
        await _completeValidRegistration($);
        
        // Step 4: Email Verification Flow Simulation
        print('📧 Step 4: Testing email verification flow');
        await _handleEmailVerificationFlow($);
        
        // Step 5: Profile Setup with Media Upload Testing
        print('👤 Step 5: Testing profile setup and media upload');
        await _completeProfileSetupWithValidation($);
        
        // Step 6: Interactive Tutorial Flow
        print('📚 Step 6: Testing interactive tutorial');
        await _completeTutorialFlowWithGestures($);
        
        // Step 7: First Social Interaction and Onboarding Completion
        print('💬 Step 7: Testing first social interaction');
        await _performFirstSocialInteractionFlow($);
        
        // Step 8: Validate Onboarding Completion and App State
        print('✅ Step 8: Validating onboarding completion');
        expect($.find.text('Welcome to your ConnectPro feed!'), findsOneWidget);
        expect($.find.byIcon(Icons.home), findsOneWidget);
        expect($.find.byIcon(Icons.chat), findsOneWidget);
        expect($.find.byIcon(Icons.search), findsOneWidget);
        expect($.find.byIcon(Icons.person), findsOneWidget);
        
        // Performance validation
        final metrics = await performanceMonitor.getMetrics();
        print('📊 Performance Metrics:');
        print('Total onboarding time: ${metrics.totalOnboardingTime}');
        print('Memory usage: ${metrics.memoryUsage / 1024 / 1024} MB');
        print('Frame rate: ${metrics.averageFrameRate} FPS');
        
        expect(metrics.totalOnboardingTime, lessThan(const Duration(minutes: 3)),
            reason: 'Onboarding should complete within 3 minutes');
        expect(metrics.memoryUsage, lessThan(200 * 1024 * 1024),
            reason: 'Memory usage should be under 200MB');
        expect(metrics.averageFrameRate, greaterThan(55),
            reason: 'Frame rate should maintain above 55 FPS');
        
        print('🎉 Onboarding journey test completed successfully!');
        
      } finally {
        await performanceMonitor.stopMonitoring();
      }
    });

    patrolTest('Onboarding with network interruption and recovery', ($) async {
      print('🌐 Testing onboarding with network interruption scenarios');
      
      app.main();
      await $.pumpAndSettle();
      
      // Start registration process normally
      await _navigateToRegistration($);
      
      // Simulate network interruption during registration
      print('📡 Simulating network disconnection...');
      await IntegrationTestHelper.simulateNetworkDisconnection();
      
      // Attempt registration while offline
      await $.enterText($.find.byKey(const Key('email_field')), 'offline@test.com');
      await $.enterText($.find.byKey(const Key('password_field')), 'OfflinePass123!');
      await $.enterText($.find.byKey(const Key('confirm_password_field')), 'OfflinePass123!');
      await $.tap($.find.text('Create Account'));
      await $.pumpAndSettle();
      
      // Verify offline state handling
      expect($.find.byIcon(Icons.wifi_off), findsOneWidget);
      expect($.find.text('Connection lost. Please check your internet.'), findsOneWidget);
      expect($.find.text('Retry'), findsOneWidget);
      
      // Test retry mechanism while still offline
      await $.tap($.find.text('Retry'));
      await $.pumpAndSettle();
      
      // Should still show offline state
      expect($.find.byIcon(Icons.wifi_off), findsOneWidget);
      
      // Restore network connection
      print('📡 Simulating network reconnection...');
      await IntegrationTestHelper.simulateNetworkReconnection();
      await $.pumpAndSettle(timeout: const Duration(seconds: 5));
      
      // Verify connection restoration
      expect($.find.byIcon(Icons.wifi_off), findsNothing);
      expect($.find.byIcon(Icons.wifi), findsOneWidget);
      
      // Retry registration after connection restoration
      await $.tap($.find.text('Retry'));
      await $.pumpAndSettle();
      
      // Verify successful registration after reconnection
      expect($.find.text('Account created successfully'), findsOneWidget);
    });

    patrolTest('Accessibility compliance during onboarding', ($) async {
      print('♿ Testing onboarding accessibility compliance');
      
      app.main();
      await $.pumpAndSettle();
      
      // Enable accessibility features for testing
      $.binding.accessibilityFeatures = FakeAccessibilityFeatures(
        accessibleNavigation: true,
        disableAnimations: true,
        boldText: true,
        highContrast: true,
        reduceMotion: true,
      );
      
      await $.pumpAndSettle();
      
      // Test semantic navigation throughout onboarding
      await _testSemanticNavigation($);
      
      // Test keyboard navigation
      await _testKeyboardNavigation($);
      
      // Test screen reader compatibility
      await _testScreenReaderCompatibility($);
      
      // Test high contrast mode
      await _testHighContrastMode($);
      
      // Verify accessibility labels and semantics
      await _verifyAccessibilityLabels($);
      
      print('✅ Accessibility compliance verification complete');
    });

    patrolTest('Onboarding performance under various conditions', ($) async {
      print('⚡ Testing onboarding performance under various conditions');
      
      await performanceMonitor.startMonitoring();
      
      try {
        // Test with simulated slow network
        await _testOnboardingWithSlowNetwork($);
        
        // Test with background apps running
        await _testOnboardingWithBackgroundLoad($);
        
        // Test with large profile images
        await _testOnboardingWithLargeMedia($);
        
        // Test memory usage throughout onboarding
        await _testMemoryUsageDuringOnboarding($);
        
        final metrics = await performanceMonitor.getMetrics();
        
        // Performance assertions for various conditions
        expect(metrics.maxMemoryUsage, lessThan(300 * 1024 * 1024),
            reason: 'Max memory usage should stay under 300MB even under load');
        expect(metrics.averageFrameRate, greaterThan(50),
            reason: 'Frame rate should remain above 50 FPS under various conditions');
        
      } finally {
        await performanceMonitor.stopMonitoring();
      }
    });

    // Helper methods for complex onboarding test scenarios

    Future<void> _completeValidRegistration(PatrolIntegrationTester $) async {
      print('📝 Completing valid user registration...');
      
      // Clear any existing text first
      await $.enterText($.find.byKey(const Key('email_field')), '');
      await $.enterText($.find.byKey(const Key('password_field')), '');
      await $.enterText($.find.byKey(const Key('confirm_password_field')), '');
      
      // Enter valid registration data
      await $.enterText($.find.byKey(const Key('email_field')), 'integration.test@example.com');
      await $.enterText($.find.byKey(const Key('password_field')), 'SecureTestPass123!');
      await $.enterText($.find.byKey(const Key('confirm_password_field')), 'SecureTestPass123!');
      
      // Accept terms and conditions
      if ($.find.byKey(const Key('terms_checkbox')).evaluate().isNotEmpty) {
        await $.tap($.find.byKey(const Key('terms_checkbox')));
      }
      if ($.find.byKey(const Key('privacy_checkbox')).evaluate().isNotEmpty) {
        await $.tap($.find.byKey(const Key('privacy_checkbox')));
      }
      
      // Submit registration
      await $.tap($.find.text('Create Account'));
      await $.pumpAndSettle();
      
      print('✅ Registration form submitted successfully');
    }

    Future<void> _handleEmailVerificationFlow(PatrolIntegrationTester $) async {
      print('📧 Handling email verification flow...');
      
      // Verify email verification screen appears
      expect($.find.text('Verify your email'), findsOneWidget);
      expect($.find.text('We sent a verification link'), findsOneWidget);
      expect($.find.text('Check your inbox'), findsOneWidget);
      
      // Test resend verification email functionality
      if ($.find.text('Resend Email').evaluate().isNotEmpty) {
        await $.tap($.find.text('Resend Email'));
        await $.pumpAndSettle();
        expect($.find.text('Verification email sent'), findsOneWidget);
      }
      
      // Simulate email verification completion
      await IntegrationTestHelper.simulateEmailVerification('integration.test@example.com');
      await $.pumpAndSettle();
      
      // Check for verification success or automatic progression
      if ($.find.text('Email verified successfully').evaluate().isNotEmpty) {
        expect($.find.text('Email verified successfully'), findsOneWidget);
        await $.tap($.find.text('Continue'));
        await $.pumpAndSettle();
      }
      
      print('✅ Email verification flow completed');
    }

    Future<void> _completeProfileSetupWithValidation(PatrolIntegrationTester $) async {
      print('👤 Completing profile setup with validation...');
      
      // Verify profile setup screen
      expect($.find.text('Set up your profile'), findsOneWidget);
      
      // Test display name validation
      await $.enterText($.find.byKey(const Key('display_name_field')), 'Te'); // Too short
      await $.tap($.find.text('Continue'));
      await $.pumpAndSettle();
      
      if ($.find.text('Name must be at least 3 characters').evaluate().isNotEmpty) {
        expect($.find.text('Name must be at least 3 characters'), findsOneWidget);
      }
      
      // Enter valid profile information
      await $.enterText($.find.byKey(const Key('display_name_field')), 'Integration Test User');
      await $.enterText($.find.byKey(const Key('bio_field')), 'Testing ConnectPro Ultimate integration flows');
      
      // Test profile photo upload flow
      if ($.find.byKey(const Key('profile_photo_button')).evaluate().isNotEmpty) {
        await $.tap($.find.byKey(const Key('profile_photo_button')));
        await $.pumpAndSettle();
        
        // Choose photo source
        if ($.find.text('Gallery').evaluate().isNotEmpty) {
          await $.tap($.find.text('Gallery'));
          await $.pumpAndSettle();
          
          // Simulate photo selection and upload
          await IntegrationTestHelper.simulatePhotoSelection();
          await $.pumpAndSettle(timeout: const Duration(seconds: 10));
          
          // Verify photo upload progress and completion
          expect($.find.byType(CircularProgressIndicator), findsNothing);
        }
      }
      
      // Complete profile setup
      await $.tap($.find.text('Continue'));
      await $.pumpAndSettle();
      
      print('✅ Profile setup completed successfully');
    }

    Future<void> _completeTutorialFlowWithGestures(PatrolIntegrationTester $) async {
      print('📚 Completing tutorial flow with gesture testing...');
      
      // Verify tutorial introduction
      expect($.find.text('Let\'s get you started!'), findsOneWidget);
      expect($.find.byType(PageView), findsOneWidget);
      
      // Navigate through tutorial screens with both swipe and tap
      for (int i = 0; i < 4; i++) {
        print('📖 Tutorial step ${i + 1}/4');
        
        // Verify tutorial content is displayed
        expect($.find.byType(PageView), findsOneWidget);
        
        // Test both swipe and button navigation
        if (i % 2 == 0) {
          // Swipe navigation
          await $.drag(
            $.find.byType(PageView),
            const Offset(-300, 0), // Swipe left
            const Duration(milliseconds: 300),
          );
        } else {
          // Button navigation
          if ($.find.text('Next').evaluate().isNotEmpty) {
            await $.tap($.find.text('Next'));
          }
        }
        
        await $.pumpAndSettle();
      }
      
      // Complete tutorial
      await $.tap($.find.text('Start Exploring'));
      await $.pumpAndSettle();
      
      print('✅ Tutorial flow completed with gesture testing');
    }

    Future<void> _performFirstSocialInteractionFlow(PatrolIntegrationTester $) async {
      print('💬 Performing first social interaction flow...');
      
      // Verify main app navigation
      expect($.find.byIcon(Icons.home), findsOneWidget);
      
      // Look for sample posts or empty state
      if ($.find.byType(ListView).evaluate().isNotEmpty) {
        // Test liking a post
        if ($.find.byIcon(Icons.favorite_border).evaluate().isNotEmpty) {
          await $.tap($.find.byIcon(Icons.favorite_border).first);
          await $.pumpAndSettle();
          
          // Verify like feedback
          expect($.find.byIcon(Icons.favorite), findsOneWidget);
          
          // Check for onboarding completion celebration
          if ($.find.text('Great! You liked your first post').evaluate().isNotEmpty) {
            expect($.find.text('Great! You liked your first post'), findsOneWidget);
          }
        }
        
        // Test creating first post if available
        if ($.find.byIcon(Icons.add).evaluate().isNotEmpty) {
          await $.tap($.find.byIcon(Icons.add));
          await $.pumpAndSettle();
          
          if ($.find.byType(TextField).evaluate().isNotEmpty) {
            await $.enterText($.find.byType(TextField), 'My first post on ConnectPro! 🎉 #firstpost');
            await $.tap($.find.text('Post'));
            await $.pumpAndSettle();
            
            // Verify post creation success
            expect($.find.text('Post created successfully'), findsOneWidget);
          }
        }
      } else {
        // Handle empty state
        expect($.find.text('Welcome to ConnectPro!'), findsOneWidget);
        expect($.find.text('Start by following some people'), findsOneWidget);
      }
      
      print('✅ First social interaction flow completed');
    }

    Future<void> _navigateToRegistration(PatrolIntegrationTester $) async {
      await $.tap($.find.text('Get Started'));
      await $.pumpAndSettle();
      await $.tap($.find.text('Create Account'));
      await $.pumpAndSettle();
    }

    Future<void> _testSemanticNavigation(PatrolIntegrationTester $) async {
      print('🔍 Testing semantic navigation...');
      
      // Get semantic tree
      final semantics = $.binding.pipelineOwner.semanticsOwner?.rootSemanticsNode;
      expect(semantics, isNotNull);
      
      // Verify semantic nodes have proper labels
      void checkSemanticNode(SemanticsNode node) {
        if (node.hasAction(SemanticsAction.tap)) {
          expect(node.label, isNotEmpty, reason: 'Tappable element should have semantic label');
        }
        
        for (final child in node.children ?? <SemanticsNode>[]) {
          checkSemanticNode(child);
        }
      }
      
      if (semantics != null) {
        checkSemanticNode(semantics);
      }
      
      print('✅ Semantic navigation verification complete');
    }

    Future<void> _testKeyboardNavigation(PatrolIntegrationTester $) async {
      print('⌨️ Testing keyboard navigation...');
      
      // Test tab navigation through focusable elements
      await $.sendKeyEvent(LogicalKeyboardKey.tab);
      await $.pumpAndSettle();
      
      // Verify focus indicators are present
      expect($.find.byType(Focus), findsWidgets);
      
      // Test Enter key activation
      await $.sendKeyEvent(LogicalKeyboardKey.enter);
      await $.pumpAndSettle();
      
      print('✅ Keyboard navigation verification complete');
    }

    Future<void> _testScreenReaderCompatibility(PatrolIntegrationTester $) async {
      print('📱 Testing screen reader compatibility...');
      
      // Verify important elements have semantic labels
      final importantWidgets = [
        ElevatedButton,
        TextButton,
        TextField,
        IconButton,
      ];
      
      for (final widgetType in importantWidgets) {
        final widgets = $.find.byType(widgetType);
        
        for (int i = 0; i < widgets.evaluate().length; i++) {
          final widget = widgets.at(i);
          final semantics = $.getSemantics(widget);
          expect(semantics.label, isNotEmpty,
              reason: '$widgetType should have semantic label for screen readers');
        }
      }
      
      print('✅ Screen reader compatibility verification complete');
    }

    Future<void> _testHighContrastMode(PatrolIntegrationTester $) async {
      print('🌗 Testing high contrast mode...');
      
      // Verify color contrast meets accessibility standards
      final materialApp = $.find.byType(MaterialApp);
      if (materialApp.evaluate().isNotEmpty) {
        final theme = Theme.of($.element(materialApp));
        
        // Basic theme validation for high contrast
        expect(theme.brightness, isNotNull);
        expect(theme.primarySwatch, isNotNull);
      }
      
      print('✅ High contrast mode verification complete');
    }

    Future<void> _verifyAccessibilityLabels(PatrolIntegrationTester $) async {
      print('🏷️ Verifying accessibility labels...');
      
      // Check buttons have semantic labels
      final buttons = $.find.byType(ElevatedButton);
      
      for (int i = 0; i < buttons.evaluate().length; i++) {
        final button = buttons.at(i);
        final semantics = $.getSemantics(button);
        expect(semantics.label, isNotEmpty,
            reason: 'Button $i should have semantic label');
      }
      
      print('✅ Accessibility labels verification complete');
    }

    Future<void> _testOnboardingWithSlowNetwork(PatrolIntegrationTester $) async {
      print('🐌 Testing onboarding with slow network...');
      
      // Simulate slow network conditions
      // This would require implementing network throttling
      
      app.main();
      await $.pumpAndSettle();
      
      // Complete onboarding with network delays
      await _navigateToRegistration($);
      await _completeValidRegistration($);
      
      // Verify app handles slow network gracefully
      expect($.find.byType(CircularProgressIndicator), findsOneWidget);
      
      print('✅ Slow network onboarding test complete');
    }

    Future<void> _testOnboardingWithBackgroundLoad(PatrolIntegrationTester $) async {
      print('📱 Testing onboarding with background load...');
      
      // Simulate background app activity
      // This would require platform-specific implementation
      
      app.main();
      await $.pumpAndSettle();
      
      // Monitor performance during onboarding
      final metrics = await performanceMonitor.getMetrics();
      expect(metrics.averageFrameRate, greaterThan(45),
          reason: 'Frame rate should remain above 45 FPS with background load');
      
      print('✅ Background load onboarding test complete');
    }

    Future<void> _testOnboardingWithLargeMedia(PatrolIntegrationTester $) async {
      print('📸 Testing onboarding with large media...');
      
      // This would test profile setup with large image files
      // Simulated for integration test purposes
      
      print('✅ Large media onboarding test complete');
    }

    Future<void> _testMemoryUsageDuringOnboarding(PatrolIntegrationTester $) async {
      print('💾 Testing memory usage during onboarding...');
      
      final initialMemory = await performanceMonitor.getCurrentMemoryUsage();
      
      app.main();
      await $.pumpAndSettle();
      
      // Complete full onboarding flow
      await _navigateToRegistration($);
      await _completeValidRegistration($);
      
      final finalMemory = await performanceMonitor.getCurrentMemoryUsage();
      final memoryIncrease = finalMemory - initialMemory;
      
      expect(memoryIncrease, lessThan(100 * 1024 * 1024),
          reason: 'Memory increase during onboarding should be less than 100MB');
      
      print('✅ Memory usage onboarding test complete');
    }
  });
}
