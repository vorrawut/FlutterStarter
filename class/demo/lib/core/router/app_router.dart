import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_detail_page.dart';
import '../../features/groups/presentation/pages/groups_page.dart';
import '../../features/groups/presentation/pages/group_detail_page.dart';
import '../../features/quiz/presentation/pages/quiz_list_page.dart';
import '../../features/quiz/presentation/pages/quiz_detail_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../shared/widgets/main_navigation_wrapper.dart';
import '../../shared/widgets/splash_screen.dart';
import '../../shared/widgets/onboarding_screen.dart';
import '../../shared/widgets/error_screen.dart';

/// Application Router Configuration
/// 
/// Demonstrates:
/// - GoRouter implementation (Lesson 6: Navigation & Routing)
/// - Route guards and authentication
/// - Nested navigation patterns
/// - Deep linking support
/// - Type-safe navigation
/// - Route transition animations
/// - Error handling for navigation

/// Router Provider for Riverpod Integration
final appRouterProvider = Provider<GoRouter>((ref) {
  // Watch authentication state for route guards
  final isAuthenticated = ref.watch(authStateProvider);
  final hasCompletedOnboarding = ref.watch(onboardingStateProvider);
  
  print('Router: isAuthenticated=$isAuthenticated, hasCompletedOnboarding=$hasCompletedOnboarding');
  
  return GoRouter(
    // Global navigation configuration
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    
    // Route redirect logic
    redirect: (context, state) {
      final location = state.matchedLocation;
      
      // Skip redirect for splash screen
      if (location == AppRoutes.splash) return null;
      
      // Handle onboarding flow first (highest priority)
      if (!hasCompletedOnboarding) {
        // Allow onboarding page
        if (location == AppRoutes.onboarding) return null;
        // Redirect everything else to onboarding
        return AppRoutes.onboarding;
      }
      
      // Handle authentication flow (after onboarding is complete)
      if (!isAuthenticated) {
        // Allow access to auth pages
        if (location.startsWith('/auth')) return null;
        
        // Redirect to login for protected routes
        return AppRoutes.login;
      }
      
      // Redirect authenticated users away from auth pages
      if (isAuthenticated && location.startsWith('/auth')) {
        return AppRoutes.home;
      }
      
      return null; // No redirect needed
    },
    
    // Error handling
    errorBuilder: (context, state) => ErrorScreen(
      error: state.error.toString(),
      onRetry: () => context.go(AppRoutes.home),
    ),
    
    // Route definitions
    routes: [
      // ========================================
      // App Initialization Routes
      // ========================================
      
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // ========================================
      // Authentication Routes
      // ========================================
      
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) {
          final redirectPath = state.uri.queryParameters['redirect'];
          return LoginPage(redirectPath: redirectPath);
        },
        routes: [
          GoRoute(
            path: 'register',
            name: 'register',
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: 'forgot-password',
            name: 'forgot-password',
            builder: (context, state) => const ForgotPasswordPage(),
          ),
        ],
      ),
      
      // ========================================
      // Main Application Shell
      // ========================================
      
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationWrapper(child: child);
        },
        routes: [
          // Home Tab
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
            routes: [
              // Post details can be accessed from home
              GoRoute(
                path: 'post/:postId',
                name: 'post-detail',
                builder: (context, state) {
                  final postId = state.pathParameters['postId']!;
                  return PostDetailPage(postId: postId);
                },
              ),
            ],
          ),
          
          // Groups Tab
          GoRoute(
            path: AppRoutes.groups,
            name: 'groups',
            builder: (context, state) => const GroupsPage(),
            routes: [
              GoRoute(
                path: ':groupId',
                name: 'group-detail',
                builder: (context, state) {
                  final groupId = state.pathParameters['groupId']!;
                  return GroupDetailPage(groupId: groupId);
                },
                routes: [
                  // Group chat within group details
                  GoRoute(
                    path: 'chat',
                    name: 'group-chat',
                    builder: (context, state) {
                      final groupId = state.pathParameters['groupId']!;
                      return ChatDetailPage(
                        chatId: 'group_$groupId',
                        isGroupChat: true,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          
          // Chat Tab
          GoRoute(
            path: AppRoutes.chat,
            name: 'chat',
            builder: (context, state) => const ChatListPage(),
            routes: [
              GoRoute(
                path: ':chatId',
                name: 'chat-detail',
                builder: (context, state) {
                  final chatId = state.pathParameters['chatId']!;
                  final isGroupChat = state.uri.queryParameters['group'] == 'true';
                  return ChatDetailPage(
                    chatId: chatId,
                    isGroupChat: isGroupChat,
                  );
                },
              ),
            ],
          ),
          
          // Quiz Tab
          GoRoute(
            path: AppRoutes.quiz,
            name: 'quiz',
            builder: (context, state) => const QuizListPage(),
            routes: [
              GoRoute(
                path: ':quizId',
                name: 'quiz-detail',
                builder: (context, state) {
                  final quizId = state.pathParameters['quizId']!;
                  return QuizDetailPage(quizId: quizId);
                },
                routes: [
                  GoRoute(
                    path: 'take',
                    name: 'quiz-take',
                    builder: (context, state) {
                      final quizId = state.pathParameters['quizId']!;
                      return QuizTakePage(quizId: quizId);
                    },
                  ),
                  GoRoute(
                    path: 'results/:attemptId',
                    name: 'quiz-results',
                    builder: (context, state) {
                      final quizId = state.pathParameters['quizId']!;
                      final attemptId = state.pathParameters['attemptId']!;
                      return QuizResultsPage(
                        quizId: quizId,
                        attemptId: attemptId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          
          // Profile Tab
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'profile-edit',
                builder: (context, state) => const ProfileEditPage(),
              ),
              GoRoute(
                path: 'achievements',
                name: 'achievements',
                builder: (context, state) => const AchievementsPage(),
              ),
              GoRoute(
                path: 'followers',
                name: 'followers',
                builder: (context, state) => const FollowersPage(),
              ),
              GoRoute(
                path: 'following',
                name: 'following',
                builder: (context, state) => const FollowingPage(),
              ),
            ],
          ),
        ],
      ),
      
      // ========================================
      // Settings and Additional Routes
      // ========================================
      
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path: 'notifications',
            name: 'notification-settings',
            builder: (context, state) => const NotificationSettingsPage(),
          ),
          GoRoute(
            path: 'privacy',
            name: 'privacy-settings',
            builder: (context, state) => const PrivacySettingsPage(),
          ),
          GoRoute(
            path: 'about',
            name: 'about',
            builder: (context, state) => const AboutPage(),
          ),
        ],
      ),
      
      // ========================================
      // User Profile Routes (Public)
      // ========================================
      
      GoRoute(
        path: '/user/:userId',
        name: 'user-profile',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return UserProfilePage(userId: userId);
        },
      ),
    ],
  );
});

/// Route Constants
/// 
/// Demonstrates:
/// - Type-safe route definitions
/// - Centralized route management
/// - Easy route refactoring
class AppRoutes {
  AppRoutes._(); // Private constructor
  
  // App initialization
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/login/register';
  static const String forgotPassword = '/auth/login/forgot-password';
  
  // Main navigation
  static const String home = '/home';
  static const String groups = '/groups';
  static const String chat = '/chat';
  static const String quiz = '/quiz';
  static const String profile = '/profile';
  
  // Settings
  static const String settings = '/settings';
  static const String notificationSettings = '/settings/notifications';
  static const String privacySettings = '/settings/privacy';
  static const String about = '/settings/about';
}

/// Navigation Helper Extension
/// 
/// Demonstrates:
/// - Extension methods for navigation
/// - Type-safe navigation helpers
/// - Improved developer experience
extension AppNavigation on BuildContext {
  /// Navigate to login page
  void goToLogin({String? redirectPath}) {
    final uri = redirectPath != null 
        ? Uri(path: AppRoutes.login, queryParameters: {'redirect': redirectPath})
        : Uri(path: AppRoutes.login);
    go(uri.toString());
  }
  
  /// Navigate to user profile
  void goToUserProfile(String userId) {
    go('/user/$userId');
  }
  
  /// Navigate to chat
  void goToChat(String chatId, {bool isGroupChat = false}) {
    final uri = Uri(
      path: '${AppRoutes.chat}/$chatId',
      queryParameters: isGroupChat ? {'group': 'true'} : null,
    );
    go(uri.toString());
  }
  
  /// Navigate to quiz
  void goToQuiz(String quizId) {
    go('${AppRoutes.quiz}/$quizId');
  }
  
  /// Navigate to group
  void goToGroup(String groupId) {
    go('${AppRoutes.groups}/$groupId');
  }
  
  /// Navigate back or to home if no previous route
  void goBackOrHome() {
    if (canPop()) {
      pop();
    } else {
      go(AppRoutes.home);
    }
  }
}

/// Authentication State Provider (Placeholder)
/// 
/// Demonstrates:
/// - State management integration with routing
/// - Authentication-aware navigation
/// - Reactive route guards
final authStateProvider = StateProvider<bool>((ref) => false);

/// Onboarding State Provider (Placeholder)
final onboardingStateProvider = StateProvider<bool>((ref) => false);

/// Placeholder Pages (Will be implemented in their respective features)
class PostDetailPage extends StatelessWidget {
  final String postId;
  
  const PostDetailPage({super.key, required this.postId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post $postId')),
      body: Center(child: Text('Post Detail: $postId')),
    );
  }
}

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Profile Edit Page')),
    );
  }
}

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: const Center(child: Text('Achievements Page')),
    );
  }
}

class FollowersPage extends StatelessWidget {
  const FollowersPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Followers')),
      body: const Center(child: Text('Followers Page')),
    );
  }
}

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Following')),
      body: const Center(child: Text('Following Page')),
    );
  }
}

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notification Settings')),
    );
  }
}

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: const Center(child: Text('Privacy Settings')),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('About Page')),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  final String userId;
  
  const UserProfilePage({super.key, required this.userId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User $userId')),
      body: Center(child: Text('User Profile: $userId')),
    );
  }
}

class QuizTakePage extends StatelessWidget {
  final String quizId;
  
  const QuizTakePage({super.key, required this.quizId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take Quiz $quizId')),
      body: Center(child: Text('Taking Quiz: $quizId')),
    );
  }
}

class QuizResultsPage extends StatelessWidget {
  final String quizId;
  final String attemptId;
  
  const QuizResultsPage({
    super.key, 
    required this.quizId, 
    required this.attemptId,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Results')),
      body: Center(
        child: Text('Quiz: $quizId, Attempt: $attemptId'),
      ),
    );
  }
}
