# 🔥 Workshop

## 🎯 **What We're Building**

Create **SocialHub Pro** - a comprehensive social platform that demonstrates Firebase Auth + Firestore mastery, including:
- **🔐 Multi-Provider Authentication** - Email/password, Google, Apple, phone verification
- **👥 Real-Time User Profiles** - Live profile updates with Firestore synchronization
- **📱 Social Features** - Posts, comments, likes, following system with real-time updates
- **🔒 Advanced Security** - Comprehensive Firestore security rules and data validation
- **🏗️ Clean Architecture** - Repository pattern with Firebase service integration
- **🧪 Testing Excellence** - Firebase emulator testing and comprehensive mocks

## ✅ **Expected Outcome**

A production-ready social platform demonstrating:
- 🔐 **Authentication Mastery** - Multiple sign-in methods with security best practices
- 👥 **Real-Time Social Features** - Live posts, comments, and user interactions
- 🔒 **Security Excellence** - Comprehensive data protection and access control
- 🏗️ **Clean Architecture** - Professional Firebase integration with repository pattern
- ⚡ **Performance Optimization** - Efficient real-time queries and offline support
- 🧪 **Testing Excellence** - Complete testing strategy with emulator integration

## 🏗️ **Project Architecture**

We'll build a social platform showcasing Firebase Auth + Firestore integration:

```
socialhub_pro/
├── lib/
│   ├── core/                          # 🔧 Core infrastructure
│   │   ├── firebase/                  # Firebase configuration
│   │   │   ├── firebase_config.dart   # Firebase initialization and setup
│   │   │   ├── auth_service.dart      # Authentication service wrapper
│   │   │   └── firestore_service.dart # Firestore service wrapper
│   │   ├── errors/                    # Error handling
│   │   │   ├── auth_exceptions.dart   # Authentication exceptions
│   │   │   ├── firestore_exceptions.dart # Firestore exceptions
│   │   │   └── error_handler.dart     # Global error handling
│   │   ├── constants/                 # Constants and configuration
│   │   │   ├── firebase_constants.dart # Firebase collection names
│   │   │   └── app_constants.dart     # Application constants
│   │   └── utils/                     # Utilities and helpers
│   │       ├── validators.dart        # Input validation utilities
│   │       └── formatters.dart        # Data formatting utilities
│   ├── data/                          # 💾 Data layer
│   │   ├── models/                    # Data models
│   │   │   ├── user_model.dart        # User with Firestore mapping
│   │   │   ├── post_model.dart        # Post with real-time features
│   │   │   ├── comment_model.dart     # Comment with threading
│   │   │   ├── like_model.dart        # Like/reaction system
│   │   │   └── follow_model.dart      # Following/follower relationships
│   │   ├── datasources/               # Data source implementations
│   │   │   ├── remote/                # Firebase data sources
│   │   │   │   ├── auth_remote_datasource.dart    # Authentication operations
│   │   │   │   ├── user_remote_datasource.dart    # User profile operations
│   │   │   │   ├── post_remote_datasource.dart    # Post CRUD operations
│   │   │   │   └── social_remote_datasource.dart  # Social features (follow, like)
│   │   │   └── local/                 # Local caching data sources
│   │   │       ├── user_local_datasource.dart     # User profile caching
│   │   │       └── post_local_datasource.dart     # Post caching
│   │   ├── repositories/              # Repository implementations
│   │   │   ├── auth_repository_impl.dart          # Authentication repository
│   │   │   ├── user_repository_impl.dart          # User management repository
│   │   │   ├── post_repository_impl.dart          # Post management repository
│   │   │   └── social_repository_impl.dart        # Social features repository
│   │   └── services/                  # Firebase services
│   │       ├── firebase_auth_service.dart         # Enhanced auth service
│   │       ├── firestore_service.dart             # Enhanced Firestore service
│   │       └── real_time_service.dart             # Real-time update service
│   ├── domain/                        # 🎯 Business logic
│   │   ├── entities/                  # Domain entities
│   │   │   ├── user.dart              # Core user entity
│   │   │   ├── post.dart              # Core post entity
│   │   │   ├── comment.dart           # Core comment entity
│   │   │   └── social_interaction.dart # Social interaction entity
│   │   ├── repositories/              # Repository interfaces
│   │   │   ├── auth_repository.dart   # Authentication interface
│   │   │   ├── user_repository.dart   # User management interface
│   │   │   ├── post_repository.dart   # Post management interface
│   │   │   └── social_repository.dart # Social features interface
│   │   └── usecases/                  # Business use cases
│   │       ├── auth_usecases.dart     # Authentication use cases
│   │       ├── user_usecases.dart     # User management use cases
│   │       ├── post_usecases.dart     # Post management use cases
│   │       └── social_usecases.dart   # Social interaction use cases
│   └── presentation/                  # 🎨 UI layer
│       ├── pages/                     # App screens
│       │   ├── auth/                  # Authentication screens
│       │   │   ├── sign_in_screen.dart # Sign-in with multiple providers
│       │   │   ├── sign_up_screen.dart # Registration flow
│       │   │   └── phone_auth_screen.dart # Phone verification
│       │   ├── profile/               # User profile screens
│       │   │   ├── profile_screen.dart # User profile display
│       │   │   └── edit_profile_screen.dart # Profile editing
│       │   ├── feed/                  # Social feed screens
│       │   │   ├── home_feed_screen.dart # Main social feed
│       │   │   └── post_detail_screen.dart # Post details with comments
│       │   └── social/                # Social features screens
│       │       ├── followers_screen.dart # Followers/following lists
│       │       └── user_search_screen.dart # User discovery
│       ├── widgets/                   # Reusable widgets
│       │   ├── auth_widgets.dart      # Authentication UI components
│       │   ├── post_widgets.dart      # Post display components
│       │   ├── user_widgets.dart      # User profile components
│       │   └── real_time_widgets.dart # Real-time update widgets
│       └── providers/                 # State management (Riverpod)
│           ├── auth_provider.dart     # Authentication state
│           ├── user_provider.dart     # User profile state
│           ├── post_provider.dart     # Post management state
│           └── social_provider.dart   # Social interaction state
├── test/                              # 🧪 Comprehensive testing
│   ├── unit/                          # Unit tests
│   │   ├── repositories/              # Repository tests
│   │   ├── usecases/                  # Use case tests
│   │   ├── datasources/               # Data source tests
│   │   └── mocks/                     # Mock implementations
│   ├── integration/                   # Integration tests
│   │   ├── firebase_auth_test.dart    # Authentication integration
│   │   ├── firestore_test.dart        # Firestore integration
│   │   └── real_time_test.dart        # Real-time features testing
│   └── widget/                        # Widget tests
├── firebase/                          # 🔥 Firebase configuration
│   ├── firestore.rules                # Security rules
│   ├── firestore.indexes.json         # Index configuration
│   └── firebase.json                  # Firebase project config
└── assets/                            # 🎨 App assets
```

## 👨‍💻 **Step-by-Step Implementation**

### **Step 1: Firebase Project Setup & Configuration** ⏱️ *30 minutes*

Set up Firebase project with all required services:

```yaml
# pubspec.yaml
name: socialhub_pro
description: Social platform with Firebase Auth + Firestore

dependencies:
  flutter:
    sdk: flutter
  
  # Firebase Core
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8
  
  # Authentication Providers
  google_sign_in: ^6.1.6
  sign_in_with_apple: ^5.0.0
  
  # State Management
  flutter_riverpod: ^2.4.5
  
  # UI Components
  cached_network_image: ^3.3.0
  image_picker: ^1.0.4
  animations: ^2.0.7
  
  # Utilities
  uuid: ^4.1.0
  intl: ^0.18.1
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  equatable: ^2.0.5
  
  # Validation
  form_field_validator: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.6
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  
  # Testing
  mocktail: ^1.0.0
  integration_test:
    sdk: flutter
  fake_cloud_firestore: ^2.4.1+1
  firebase_auth_mocks: ^0.13.0
  
  # Linting
  flutter_lints: ^3.0.1
```

### **Step 2: Firebase Configuration & Services** ⏱️ *40 minutes*

Create comprehensive Firebase service infrastructure:

```dart
// lib/core/firebase/firebase_config.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Configure services
    await _configureFirebaseServices();
    
    // Setup error tracking
    await _setupErrorTracking();
    
    // Configure emulators for development
    await _configureEmulators();
  }
  
  static Future<void> _configureFirebaseServices() async {
    // Enable Firestore offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    
    // Configure Auth settings
    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: false,
      userAccessGroup: null,
    );
    
    // Enable Analytics
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }
  
  static Future<void> _setupErrorTracking() async {
    // Enable Crashlytics
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    
    // Catch Flutter framework errors
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    
    // Catch async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  
  static Future<void> _configureEmulators() async {
    // Only use emulators in debug mode
    if (kDebugMode) {
      try {
        // Connect to Firestore emulator
        FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
        
        // Connect to Auth emulator
        await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
        
        print('🔧 Connected to Firebase emulators');
      } catch (e) {
        print('⚠️ Failed to connect to emulators: $e');
      }
    }
  }
  
  // Firebase service getters
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAnalytics get analytics => FirebaseAnalytics.instance;
  static FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;
}

// lib/core/firebase/auth_service.dart
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Authentication state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Current user
  static User? get currentUser => _auth.currentUser;
  
  // Authentication status
  static bool get isAuthenticated => _auth.currentUser != null;
  
  // Email/Password Authentication
  static Future<UserCredential> signInWithEmailPassword(
    String email, 
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await FirebaseConfig.analytics.logLogin();
      return credential;
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw _handleAuthException(e);
    }
  }
  
  static Future<UserCredential> createUserWithEmailPassword(
    String email, 
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await FirebaseConfig.analytics.logSignUp(signUpMethod: 'email');
      return credential;
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw _handleAuthException(e);
    }
  }
  
  // Google Sign-In
  static Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw AuthException('Google sign-in cancelled');
      
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = await _auth.signInWithCredential(credential);
      await FirebaseConfig.analytics.logLogin(loginMethod: 'google');
      
      return userCredential;
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Google sign-in failed: ${e.toString()}');
    }
  }
  
  // Apple Sign-In
  static Future<UserCredential> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      
      final userCredential = await _auth.signInWithCredential(oauthCredential);
      await FirebaseConfig.analytics.logLogin(loginMethod: 'apple');
      
      return userCredential;
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Apple sign-in failed: ${e.toString()}');
    }
  }
  
  // Phone Authentication
  static Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Phone verification failed: ${e.toString()}');
    }
  }
  
  static Future<UserCredential> signInWithPhoneCredential(
    PhoneAuthCredential credential,
  ) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      await FirebaseConfig.analytics.logLogin(loginMethod: 'phone');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw _handleAuthException(e);
    }
  }
  
  // Sign Out
  static Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        GoogleSignIn().signOut(),
      ]);
      
      await FirebaseConfig.analytics.logEvent(name: 'sign_out');
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }
  
  // Password Reset
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw _handleAuthException(e);
    }
  }
  
  // Email Verification
  static Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Failed to send verification email: ${e.toString()}');
    }
  }
  
  // Error Handling
  static AuthException _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException('No account found with this email address.');
      case 'wrong-password':
        return AuthException('Incorrect password.');
      case 'email-already-in-use':
        return AuthException('An account already exists with this email.');
      case 'weak-password':
        return AuthException('Password is too weak.');
      case 'invalid-email':
        return AuthException('Email address is invalid.');
      case 'user-disabled':
        return AuthException('This account has been disabled.');
      case 'too-many-requests':
        return AuthException('Too many requests. Please try again later.');
      case 'operation-not-allowed':
        return AuthException('This sign-in method is not allowed.');
      case 'requires-recent-login':
        return AuthException('Please sign in again to complete this action.');
      default:
        return AuthException('Authentication failed: ${e.message}');
    }
  }
}

// lib/core/firebase/firestore_service.dart
class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection names
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String commentsCollection = 'comments';
  static const String likesCollection = 'likes';
  static const String followsCollection = 'follows';
  
  // Collection references
  static CollectionReference get users => 
      _firestore.collection(usersCollection);
  static CollectionReference get posts => 
      _firestore.collection(postsCollection);
  static CollectionReference get comments => 
      _firestore.collection(commentsCollection);
  static CollectionReference get likes => 
      _firestore.collection(likesCollection);
  static CollectionReference get follows => 
      _firestore.collection(followsCollection);
  
  // Typed collection references
  static CollectionReference<UserModel> get usersTyped => 
      users.withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromFirestore(snapshot),
        toFirestore: (user, _) => user.toFirestore(),
      );
  
  static CollectionReference<PostModel> get postsTyped => 
      posts.withConverter<PostModel>(
        fromFirestore: (snapshot, _) => PostModel.fromFirestore(snapshot),
        toFirestore: (post, _) => post.toFirestore(),
      );
  
  // Document references
  static DocumentReference userDoc(String userId) => users.doc(userId);
  static DocumentReference postDoc(String postId) => posts.doc(postId);
  
  // Subcollection references
  static CollectionReference userPosts(String userId) => 
      userDoc(userId).collection('posts');
  
  static CollectionReference userFollowers(String userId) => 
      userDoc(userId).collection('followers');
  
  static CollectionReference userFollowing(String userId) => 
      userDoc(userId).collection('following');
  
  static CollectionReference postComments(String postId) => 
      postDoc(postId).collection('comments');
  
  static CollectionReference postLikes(String postId) => 
      postDoc(postId).collection('likes');
  
  // Advanced query builders
  static Query buildUserFeedQuery(
    String userId, {
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) {
    Query query = posts
        .where('visibility', isEqualTo: 'public')
        .orderBy('createdAt', descending: true);
    
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    
    return query.limit(limit);
  }
  
  static Query buildUserPostsQuery(
    String userId, {
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) {
    Query query = posts
        .where('authorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);
    
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    
    return query.limit(limit);
  }
  
  // Batch operations
  static Future<void> batchWrite(List<BatchOperation> operations) async {
    try {
      final batch = _firestore.batch();
      
      for (final operation in operations) {
        switch (operation.type) {
          case BatchOperationType.set:
            batch.set(operation.reference, operation.data!);
            break;
          case BatchOperationType.update:
            batch.update(operation.reference, operation.data!);
            break;
          case BatchOperationType.delete:
            batch.delete(operation.reference);
            break;
        }
      }
      
      await batch.commit();
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw FirestoreException('Batch operation failed: ${e.toString()}');
    }
  }
  
  // Transaction operations
  static Future<T> runTransaction<T>(
    Future<T> Function(Transaction) updateFunction,
  ) async {
    try {
      return await _firestore.runTransaction(updateFunction);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw FirestoreException('Transaction failed: ${e.toString()}');
    }
  }
}
```

### **Step 3: Data Models with Firestore Integration** ⏱️ *45 minutes*

Create comprehensive data models for the social platform:

```dart
// lib/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String displayName,
    String? photoURL,
    String? bio,
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
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'],
      bio: data['bio'],
      website: data['website'],
      location: data['location'],
      interests: List<String>.from(data['interests'] ?? []),
      followersCount: data['followersCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
      postsCount: data['postsCount'] ?? 0,
      isPublic: data['isPublic'] ?? true,
      isActive: data['isActive'] ?? true,
      isVerified: data['isVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastSeenAt: data['lastSeenAt'] != null 
          ? (data['lastSeenAt'] as Timestamp).toDate()
          : null,
      settings: data['settings'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'bio': bio,
      'website': website,
      'location': location,
      'interests': interests,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
      'isPublic': isPublic,
      'isActive': isActive,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastSeenAt': lastSeenAt != null 
          ? Timestamp.fromDate(lastSeenAt!)
          : null,
      'settings': settings,
    };
  }

  factory UserModel.fromFirebaseUser(User firebaseUser) {
    final now = DateTime.now();
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoURL: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? now,
      updatedAt: now,
      lastSeenAt: now,
    );
  }
}

// lib/data/models/post_model.dart
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
    @Default('public') String visibility, // public, followers, private
    @Default(false) bool isPinned,
    @Default(true) bool allowComments,
    @Default(true) bool allowShares,
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
      authorId: data['authorId'] ?? '',
      content: data['content'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      hashtags: List<String>.from(data['hashtags'] ?? []),
      mentions: List<String>.from(data['mentions'] ?? []),
      likesCount: data['likesCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      sharesCount: data['sharesCount'] ?? 0,
      visibility: data['visibility'] ?? 'public',
      isPinned: data['isPinned'] ?? false,
      allowComments: data['allowComments'] ?? true,
      allowShares: data['allowShares'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      location: data['location'],
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'content': content,
      'imageUrls': imageUrls,
      'hashtags': hashtags,
      'mentions': mentions,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'visibility': visibility,
      'isPinned': isPinned,
      'allowComments': allowComments,
      'allowShares': allowShares,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'location': location,
      'metadata': metadata,
    };
  }

  // Extract hashtags from content
  List<String> extractHashtags() {
    final regex = RegExp(r'#\w+');
    return regex.allMatches(content)
        .map((match) => match.group(0)!)
        .toList();
  }

  // Extract mentions from content
  List<String> extractMentions() {
    final regex = RegExp(r'@\w+');
    return regex.allMatches(content)
        .map((match) => match.group(0)!.substring(1)) // Remove @
        .toList();
  }
}

// lib/data/models/comment_model.dart
@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String postId,
    required String authorId,
    required String content,
    @Default(0) int likesCount,
    @Default(0) int repliesCount,
    String? parentCommentId, // For threaded comments
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isEdited,
    @Default(false) bool isDeleted,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) => 
      _$CommentModelFromJson(json);

  factory CommentModel.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CommentModel(
      id: snapshot.id,
      postId: data['postId'] ?? '',
      authorId: data['authorId'] ?? '',
      content: data['content'] ?? '',
      likesCount: data['likesCount'] ?? 0,
      repliesCount: data['repliesCount'] ?? 0,
      parentCommentId: data['parentCommentId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isEdited: data['isEdited'] ?? false,
      isDeleted: data['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'authorId': authorId,
      'content': content,
      'likesCount': likesCount,
      'repliesCount': repliesCount,
      'parentCommentId': parentCommentId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isEdited': isEdited,
      'isDeleted': isDeleted,
    };
  }
}

// lib/data/models/like_model.dart
@freezed
class LikeModel with _$LikeModel {
  const factory LikeModel({
    required String id,
    required String userId,
    required String targetId, // postId or commentId
    required String targetType, // 'post' or 'comment'
    required DateTime createdAt,
  }) = _LikeModel;

  factory LikeModel.fromJson(Map<String, dynamic> json) => 
      _$LikeModelFromJson(json);

  factory LikeModel.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return LikeModel(
      id: snapshot.id,
      userId: data['userId'] ?? '',
      targetId: data['targetId'] ?? '',
      targetType: data['targetType'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'targetId': targetId,
      'targetType': targetType,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

// lib/data/models/follow_model.dart
@freezed
class FollowModel with _$FollowModel {
  const factory FollowModel({
    required String id,
    required String followerId,
    required String followingId,
    required DateTime createdAt,
    @Default(true) bool isActive,
  }) = _FollowModel;

  factory FollowModel.fromJson(Map<String, dynamic> json) => 
      _$FollowModelFromJson(json);

  factory FollowModel.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return FollowModel(
      id: snapshot.id,
      followerId: data['followerId'] ?? '',
      followingId: data['followingId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'followerId': followerId,
      'followingId': followingId,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }
}
```

*This is part 1 of the workshop. Continue with repository implementation, real-time features, security rules, UI components, and testing...*

## 🚀 **How to Run**

```bash
# Navigate to lesson directory
cd class/workshop/lesson_19

# Install dependencies
flutter pub get

# Generate code for models
flutter packages pub run build_runner build

# Set up Firebase project
# 1. Create new Firebase project at https://console.firebase.google.com
# 2. Enable Authentication (Email/Password, Google, Apple, Phone)
# 3. Enable Firestore Database
# 4. Add your app to Firebase project
# 5. Download configuration files (google-services.json, GoogleService-Info.plist)

# Configure Firebase CLI
firebase login
firebase init

# Start Firebase emulators (for development)
firebase emulators:start

# Run the app
flutter run

# Test the social platform features
# 1. Test multi-provider authentication
# 2. Create and manage user profiles  
# 3. Test real-time posts and comments
# 4. Test following/follower system
# 5. Verify offline functionality
```

## 🎯 **Learning Outcomes**

After completing this workshop, you will have mastered:
- **Firebase Authentication Excellence** - Multi-provider authentication with security best practices
- **Firestore Database Mastery** - Real-time NoSQL database with complex queries and relationships
- **Security Rules Implementation** - Comprehensive data protection and access control
- **Clean Architecture Integration** - Professional Firebase service integration with repository pattern
- **Real-Time Features** - Live data synchronization and social interactions
- **Testing Excellence** - Firebase emulator testing and comprehensive mock strategies

**Ready to build real-time, cloud-powered social applications with Firebase! 🔥✨**