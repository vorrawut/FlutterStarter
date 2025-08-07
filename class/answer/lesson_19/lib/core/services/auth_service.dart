import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../firebase/firebase_config.dart';
import '../errors/auth_exceptions.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Authentication state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Current user
  static User? get currentUser => _auth.currentUser;
  
  // Authentication status
  static bool get isAuthenticated => _auth.currentUser != null;
  
  // Email verification status
  static bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;
  
  // Multi-factor authentication status
  static bool get isMFAEnabled => 
      _auth.currentUser?.multiFactor.enrolledFactors.isNotEmpty ?? false;

  /// Email/Password Authentication
  static Future<UserCredential> signInWithEmailPassword(
    String email, 
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Log successful sign-in
      await FirebaseConfig.analytics.logLogin(loginMethod: 'email');
      
      return credential;
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Sign in failed: ${e.toString()}');
    }
  }
  
  static Future<UserCredential> createUserWithEmailPassword(
    String email, 
    String password, {
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name if provided
      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
      }
      
      // Send email verification
      await sendEmailVerification();
      
      // Log successful sign-up
      await FirebaseConfig.analytics.logSignUp(signUpMethod: 'email');
      
      return credential;
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Account creation failed: ${e.toString()}');
    }
  }

  /// Google Sign-In
  static Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Google sign-in was cancelled');
      }
      
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Log successful sign-in
      await FirebaseConfig.analytics.logLogin(loginMethod: 'google');
      
      return userCredential;
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      if (e is AuthException) rethrow;
      throw AuthException('Google sign-in failed: ${e.toString()}');
    }
  }

  /// Apple Sign-In
  static Future<UserCredential> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'your-client-id', // Configure this in production
          redirectUri: Uri.parse('your-redirect-uri'),
        ),
      );
      
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      
      final userCredential = await _auth.signInWithCredential(oauthCredential);
      
      // Update display name if available
      if (appleCredential.givenName != null && 
          appleCredential.familyName != null &&
          userCredential.user != null) {
        final displayName = '${appleCredential.givenName} ${appleCredential.familyName}';
        await userCredential.user!.updateDisplayName(displayName);
      }
      
      // Log successful sign-in
      await FirebaseConfig.analytics.logLogin(loginMethod: 'apple');
      
      return userCredential;
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      if (e is AuthException) rethrow;
      throw AuthException('Apple sign-in failed: ${e.toString()}');
    }
  }

  /// Phone Authentication
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
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timeout
        },
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
      
      // Log successful sign-in
      await FirebaseConfig.analytics.logLogin(loginMethod: 'phone');
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Phone sign-in failed: ${e.toString()}');
    }
  }

  /// Anonymous Authentication
  static Future<UserCredential> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      
      // Log anonymous sign-in
      await FirebaseConfig.analytics.logLogin(loginMethod: 'anonymous');
      
      return credential;
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Anonymous sign-in failed: ${e.toString()}');
    }
  }

  /// Sign Out
  static Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      
      // Log sign-out
      await FirebaseConfig.analytics.logEvent(name: 'sign_out');
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  /// Password Reset
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Password reset failed: ${e.toString()}');
    }
  }

  /// Email Verification
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
  
  static Future<void> reloadUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
      }
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Failed to reload user: ${e.toString()}');
    }
  }

  /// Profile Updates
  static Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
        }
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }
        await user.reload();
      }
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Profile update failed: ${e.toString()}');
    }
  }

  /// Advanced Authentication Features
  
  /// Link Authentication Providers
  static Future<UserCredential> linkWithCredential(
    AuthCredential credential,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return await user.linkWithCredential(credential);
      }
      throw AuthException('No authenticated user to link with');
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      if (e is AuthException) rethrow;
      throw AuthException('Link credential failed: ${e.toString()}');
    }
  }

  /// Unlink Authentication Provider
  static Future<User> unlinkProvider(String providerId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return await user.unlink(providerId);
      }
      throw AuthException('No authenticated user to unlink from');
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      if (e is AuthException) rethrow;
      throw AuthException('Unlink provider failed: ${e.toString()}');
    }
  }

  /// Re-authenticate User
  static Future<UserCredential> reauthenticateUser(
    AuthCredential credential,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return await user.reauthenticateWithCredential(credential);
      }
      throw AuthException('No authenticated user to re-authenticate');
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      if (e is AuthException) rethrow;
      throw AuthException('Re-authentication failed: ${e.toString()}');
    }
  }

  /// Delete User Account
  static Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        
        // Log account deletion
        await FirebaseConfig.analytics.logEvent(name: 'account_deleted');
      }
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Account deletion failed: ${e.toString()}');
    }
  }

  /// Update Password
  static Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Password update failed: ${e.toString()}');
    }
  }

  /// Update Email
  static Future<void> updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(newEmail);
        await sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthExceptions.handleFirebaseAuthException(e);
    } catch (e) {
      await FirebaseConfig.crashlytics.recordError(e, null);
      throw AuthException('Email update failed: ${e.toString()}');
    }
  }

  /// Get User Provider Data
  static List<UserInfo> getProviderData() {
    final user = _auth.currentUser;
    return user?.providerData ?? [];
  }

  /// Check if user has specific provider
  static bool hasProvider(String providerId) {
    final providers = getProviderData();
    return providers.any((provider) => provider.providerId == providerId);
  }

  /// Get primary authentication method
  static String getPrimaryProvider() {
    final providers = getProviderData();
    if (providers.isEmpty) return 'anonymous';
    
    // Priority order: Google, Apple, Phone, Email
    if (providers.any((p) => p.providerId == 'google.com')) return 'google';
    if (providers.any((p) => p.providerId == 'apple.com')) return 'apple';
    if (providers.any((p) => p.providerId == 'phone')) return 'phone';
    if (providers.any((p) => p.providerId == 'password')) return 'email';
    
    return providers.first.providerId;
  }

  /// Check authentication status with detailed info
  static Map<String, dynamic> getAuthStatus() {
    final user = _auth.currentUser;
    
    return {
      'isAuthenticated': isAuthenticated,
      'isEmailVerified': isEmailVerified,
      'isMFAEnabled': isMFAEnabled,
      'isAnonymous': user?.isAnonymous ?? false,
      'uid': user?.uid,
      'email': user?.email,
      'displayName': user?.displayName,
      'photoURL': user?.photoURL,
      'providers': getProviderData().map((p) => p.providerId).toList(),
      'primaryProvider': getPrimaryProvider(),
      'creationTime': user?.metadata.creationTime?.toIso8601String(),
      'lastSignInTime': user?.metadata.lastSignInTime?.toIso8601String(),
    };
  }
}
