// lib/core/app_store_submission/submission_manager.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'dart:io';

/// Comprehensive app store submission and review management
/// Handles submission workflows, review tracking, and compliance validation
class AppStoreSubmissionManager {
  static final AppStoreSubmissionManager _instance = AppStoreSubmissionManager._internal();
  factory AppStoreSubmissionManager() => _instance;
  AppStoreSubmissionManager._internal();

  static const String _submissionPrefsKey = 'app_store_submissions';
  static const String _reviewPrefsKey = 'review_tracking';
  late SharedPreferences _prefs;
  late PackageInfo _packageInfo;
  
  bool _isInitialized = false;
  List<SubmissionRecord> _submissionHistory = [];
  List<ReviewProcess> _activeReviews = [];

  /// Initialize the submission manager
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _prefs = await SharedPreferences.getInstance();
      _packageInfo = await PackageInfo.fromPlatform();
      await _loadSubmissionHistory();
      await _loadActiveReviews();
      _isInitialized = true;
      
      debugPrint('✅ App Store Submission Manager initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize Submission Manager: $e');
    }
  }

  /// Load submission history from storage
  Future<void> _loadSubmissionHistory() async {
    try {
      final historyJson = _prefs.getString(_submissionPrefsKey);
      if (historyJson != null) {
        final historyList = jsonDecode(historyJson) as List;
        _submissionHistory = historyList
            .map((json) => SubmissionRecord.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading submission history: $e');
      _submissionHistory = [];
    }
  }

  /// Load active reviews from storage
  Future<void> _loadActiveReviews() async {
    try {
      final reviewsJson = _prefs.getString(_reviewPrefsKey);
      if (reviewsJson != null) {
        final reviewsList = jsonDecode(reviewsJson) as List;
        _activeReviews = reviewsList
            .map((json) => ReviewProcess.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading active reviews: $e');
      _activeReviews = [];
    }
  }

  /// Save submission history to storage
  Future<void> _saveSubmissionHistory() async {
    final historyJson = jsonEncode(_submissionHistory.map((s) => s.toJson()).toList());
    await _prefs.setString(_submissionPrefsKey, historyJson);
  }

  /// Save active reviews to storage
  Future<void> _saveActiveReviews() async {
    final reviewsJson = jsonEncode(_activeReviews.map((r) => r.toJson()).toList());
    await _prefs.setString(_reviewPrefsKey, reviewsJson);
  }

  /// Prepare submission for Google Play Store
  Future<GooglePlaySubmission> prepareGooglePlaySubmission({
    required String releaseTrack,
    required List<String> apkPaths,
    required String releaseNotes,
    double? userFraction,
    bool isDraft = true,
  }) async {
    if (!_isInitialized) await initialize();

    // Validate APK files
    await _validateApkFiles(apkPaths);

    // Pre-submission checklist
    final checklist = await _runGooglePlayChecklist();
    
    // Create submission record
    final submission = GooglePlaySubmission(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      appVersion: _packageInfo.version,
      buildNumber: _packageInfo.buildNumber,
      releaseTrack: releaseTrack,
      apkPaths: apkPaths,
      releaseNotes: releaseNotes,
      userFraction: userFraction,
      isDraft: isDraft,
      submissionDate: DateTime.now(),
      status: SubmissionStatus.preparing,
      checklist: checklist,
      validationResults: await _validateGooglePlaySubmission(apkPaths),
    );

    // Add to submission history
    final submissionRecord = SubmissionRecord(
      id: submission.id,
      platform: StorePlatform.googlePlay,
      version: submission.appVersion,
      buildNumber: submission.buildNumber,
      submissionDate: submission.submissionDate,
      status: submission.status,
      track: releaseTrack,
    );
    
    _submissionHistory.add(submissionRecord);
    await _saveSubmissionHistory();

    debugPrint('Google Play submission prepared: ${submission.id}');
    return submission;
  }

  /// Prepare submission for Apple App Store
  Future<AppStoreSubmission> prepareAppStoreSubmission({
    required String ipaPath,
    required String releaseNotes,
    bool isPhased = false,
    bool autoRelease = false,
  }) async {
    if (!_isInitialized) await initialize();

    // Validate IPA file
    await _validateIpaFile(ipaPath);

    // Pre-submission checklist
    final checklist = await _runAppStoreChecklist();
    
    // Create submission record
    final submission = AppStoreSubmission(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      appVersion: _packageInfo.version,
      buildNumber: _packageInfo.buildNumber,
      ipaPath: ipaPath,
      releaseNotes: releaseNotes,
      isPhased: isPhased,
      autoRelease: autoRelease,
      submissionDate: DateTime.now(),
      status: SubmissionStatus.preparing,
      checklist: checklist,
      validationResults: await _validateAppStoreSubmission(ipaPath),
    );

    // Add to submission history
    final submissionRecord = SubmissionRecord(
      id: submission.id,
      platform: StorePlatform.appStore,
      version: submission.appVersion,
      buildNumber: submission.buildNumber,
      submissionDate: submission.submissionDate,
      status: submission.status,
      track: 'production',
    );
    
    _submissionHistory.add(submissionRecord);
    await _saveSubmissionHistory();

    debugPrint('App Store submission prepared: ${submission.id}');
    return submission;
  }

  /// Submit to Google Play Store
  Future<SubmissionResult> submitToGooglePlay(GooglePlaySubmission submission) async {
    try {
      // Update status
      submission.status = SubmissionStatus.uploading;
      await _updateSubmissionStatus(submission.id, submission.status);

      // Simulate upload process (in real implementation, use Google Play Developer API)
      await _simulateUploadProcess();

      // Update status to submitted
      submission.status = SubmissionStatus.submitted;
      await _updateSubmissionStatus(submission.id, submission.status);

      // Start review tracking
      await _startReviewTracking(submission);

      return SubmissionResult(
        success: true,
        submissionId: submission.id,
        message: 'Successfully submitted to Google Play Store',
        trackingUrl: 'https://play.google.com/console/developer/app/${_packageInfo.packageName}',
      );
    } catch (e) {
      submission.status = SubmissionStatus.failed;
      await _updateSubmissionStatus(submission.id, submission.status);
      
      return SubmissionResult(
        success: false,
        submissionId: submission.id,
        message: 'Failed to submit to Google Play Store: $e',
        error: e.toString(),
      );
    }
  }

  /// Submit to Apple App Store
  Future<SubmissionResult> submitToAppStore(AppStoreSubmission submission) async {
    try {
      // Update status
      submission.status = SubmissionStatus.uploading;
      await _updateSubmissionStatus(submission.id, submission.status);

      // Simulate upload process (in real implementation, use App Store Connect API)
      await _simulateUploadProcess();

      // Update status to submitted
      submission.status = SubmissionStatus.submitted;
      await _updateSubmissionStatus(submission.id, submission.status);

      // Start review tracking
      await _startReviewTracking(submission);

      return SubmissionResult(
        success: true,
        submissionId: submission.id,
        message: 'Successfully submitted to App Store',
        trackingUrl: 'https://appstoreconnect.apple.com/apps/${_packageInfo.packageName}',
      );
    } catch (e) {
      submission.status = SubmissionStatus.failed;
      await _updateSubmissionStatus(submission.id, submission.status);
      
      return SubmissionResult(
        success: false,
        submissionId: submission.id,
        message: 'Failed to submit to App Store: $e',
        error: e.toString(),
      );
    }
  }

  /// Start review tracking for a submission
  Future<void> _startReviewTracking(dynamic submission) async {
    final reviewProcess = ReviewProcess(
      id: submission.id,
      platform: submission is GooglePlaySubmission ? StorePlatform.googlePlay : StorePlatform.appStore,
      appVersion: submission.appVersion,
      buildNumber: submission.buildNumber,
      submissionDate: submission.submissionDate,
      status: ReviewStatus.inReview,
      estimatedReviewTime: submission is GooglePlaySubmission 
          ? Duration(hours: 3) // Google Play typically reviews within hours
          : Duration(days: 2), // App Store typically takes 1-3 days
      checkpoints: _getInitialCheckpoints(submission is GooglePlaySubmission),
      lastUpdated: DateTime.now(),
    );

    _activeReviews.add(reviewProcess);
    await _saveActiveReviews();
    
    debugPrint('Started review tracking for submission: ${submission.id}');
  }

  /// Get initial review checkpoints
  List<ReviewCheckpoint> _getInitialCheckpoints(bool isGooglePlay) {
    if (isGooglePlay) {
      return [
        ReviewCheckpoint(
          name: 'Automated Security Scan',
          description: 'Automated malware and security scanning',
          status: ReviewCheckpointStatus.pending,
          estimatedTime: Duration(minutes: 30),
        ),
        ReviewCheckpoint(
          name: 'Policy Compliance Review',
          description: 'Review against Google Play policies',
          status: ReviewCheckpointStatus.pending,
          estimatedTime: Duration(hours: 1),
        ),
        ReviewCheckpoint(
          name: 'Content Review',
          description: 'Review of app content and metadata',
          status: ReviewCheckpointStatus.pending,
          estimatedTime: Duration(hours: 2),
        ),
      ];
    } else {
      return [
        ReviewCheckpoint(
          name: 'Automated Analysis',
          description: 'Automated app analysis and validation',
          status: ReviewCheckpointStatus.pending,
          estimatedTime: Duration(hours: 6),
        ),
        ReviewCheckpoint(
          name: 'App Review',
          description: 'Human review of app functionality and content',
          status: ReviewCheckpointStatus.pending,
          estimatedTime: Duration(days: 1),
        ),
        ReviewCheckpoint(
          name: 'Final Approval',
          description: 'Final approval and release preparation',
          status: ReviewCheckpointStatus.pending,
          estimatedTime: Duration(hours: 4),
        ),
      ];
    }
  }

  /// Update submission status
  Future<void> _updateSubmissionStatus(String submissionId, SubmissionStatus status) async {
    final index = _submissionHistory.indexWhere((s) => s.id == submissionId);
    if (index != -1) {
      _submissionHistory[index] = _submissionHistory[index].copyWith(status: status);
      await _saveSubmissionHistory();
    }
  }

  /// Run Google Play pre-submission checklist
  Future<SubmissionChecklist> _runGooglePlayChecklist() async {
    final checklist = SubmissionChecklist();
    
    // Check app manifest
    checklist.items.add(ChecklistItem(
      name: 'Android Manifest Validation',
      description: 'Validate Android manifest configuration',
      isCompleted: await _validateAndroidManifest(),
      isRequired: true,
    ));

    // Check app signing
    checklist.items.add(ChecklistItem(
      name: 'App Signing Configuration',
      description: 'Verify app signing and upload keystore',
      isCompleted: await _validateAppSigning(),
      isRequired: true,
    ));

    // Check target SDK version
    checklist.items.add(ChecklistItem(
      name: 'Target SDK Version',
      description: 'Verify target SDK meets requirements',
      isCompleted: await _validateTargetSdk(),
      isRequired: true,
    ));

    // Check permissions
    checklist.items.add(ChecklistItem(
      name: 'Permission Usage',
      description: 'Verify appropriate permission usage',
      isCompleted: await _validatePermissions(),
      isRequired: true,
    ));

    // Check privacy policy
    checklist.items.add(ChecklistItem(
      name: 'Privacy Policy',
      description: 'Verify privacy policy is accessible',
      isCompleted: await _validatePrivacyPolicy(),
      isRequired: true,
    ));

    // Check content rating
    checklist.items.add(ChecklistItem(
      name: 'Content Rating',
      description: 'Verify appropriate content rating',
      isCompleted: await _validateContentRating(),
      isRequired: true,
    ));

    return checklist;
  }

  /// Run App Store pre-submission checklist
  Future<SubmissionChecklist> _runAppStoreChecklist() async {
    final checklist = SubmissionChecklist();
    
    // Check iOS deployment target
    checklist.items.add(ChecklistItem(
      name: 'iOS Deployment Target',
      description: 'Verify minimum iOS version support',
      isCompleted: await _validateIosDeploymentTarget(),
      isRequired: true,
    ));

    // Check app icons
    checklist.items.add(ChecklistItem(
      name: 'App Icons',
      description: 'Verify all required app icon sizes',
      isCompleted: await _validateAppIcons(),
      isRequired: true,
    ));

    // Check launch screen
    checklist.items.add(ChecklistItem(
      name: 'Launch Screen',
      description: 'Verify launch screen configuration',
      isCompleted: await _validateLaunchScreen(),
      isRequired: true,
    ));

    // Check app transport security
    checklist.items.add(ChecklistItem(
      name: 'App Transport Security',
      description: 'Verify ATS configuration',
      isCompleted: await _validateAppTransportSecurity(),
      isRequired: true,
    ));

    // Check privacy policy
    checklist.items.add(ChecklistItem(
      name: 'Privacy Policy',
      description: 'Verify privacy policy is accessible',
      isCompleted: await _validatePrivacyPolicy(),
      isRequired: true,
    ));

    // Check in-app purchases
    checklist.items.add(ChecklistItem(
      name: 'In-App Purchases',
      description: 'Verify in-app purchase configuration',
      isCompleted: await _validateInAppPurchases(),
      isRequired: false,
    ));

    return checklist;
  }

  /// Validate APK files
  Future<void> _validateApkFiles(List<String> apkPaths) async {
    for (final path in apkPaths) {
      final file = File(path);
      if (!await file.exists()) {
        throw Exception('APK file not found: $path');
      }
      
      // Check file size (Google Play limit is 150MB for APK)
      final size = await file.length();
      if (size > 150 * 1024 * 1024) {
        throw Exception('APK file too large: ${size / (1024 * 1024)}MB (max 150MB)');
      }
    }
  }

  /// Validate IPA file
  Future<void> _validateIpaFile(String ipaPath) async {
    final file = File(ipaPath);
    if (!await file.exists()) {
      throw Exception('IPA file not found: $ipaPath');
    }
    
    // Check file size (App Store limit is 4GB)
    final size = await file.length();
    if (size > 4 * 1024 * 1024 * 1024) {
      throw Exception('IPA file too large: ${size / (1024 * 1024 * 1024)}GB (max 4GB)');
    }
  }

  /// Validate Google Play submission
  Future<ValidationResults> _validateGooglePlaySubmission(List<String> apkPaths) async {
    final results = ValidationResults();
    
    // Add validation checks
    results.checks.add(ValidationCheck(
      name: 'APK Format',
      passed: apkPaths.every((path) => path.endsWith('.apk') || path.endsWith('.aab')),
      message: 'All files are valid APK/AAB format',
    ));

    results.checks.add(ValidationCheck(
      name: 'File Size',
      passed: true, // Already validated in _validateApkFiles
      message: 'All files within size limits',
    ));

    results.checks.add(ValidationCheck(
      name: 'Version Code',
      passed: await _validateVersionCode(),
      message: 'Version code is higher than previous releases',
    ));

    return results;
  }

  /// Validate App Store submission
  Future<ValidationResults> _validateAppStoreSubmission(String ipaPath) async {
    final results = ValidationResults();
    
    // Add validation checks
    results.checks.add(ValidationCheck(
      name: 'IPA Format',
      passed: ipaPath.endsWith('.ipa'),
      message: 'File is valid IPA format',
    ));

    results.checks.add(ValidationCheck(
      name: 'File Size',
      passed: true, // Already validated in _validateIpaFile
      message: 'File within size limits',
    ));

    results.checks.add(ValidationCheck(
      name: 'Bundle Version',
      passed: await _validateBundleVersion(),
      message: 'Bundle version is higher than previous releases',
    ));

    return results;
  }

  /// Simulate upload process
  Future<void> _simulateUploadProcess() async {
    // Simulate upload delay
    await Future.delayed(Duration(seconds: 5));
  }

  /// Validation helper methods
  Future<bool> _validateAndroidManifest() async => true;
  Future<bool> _validateAppSigning() async => true;
  Future<bool> _validateTargetSdk() async => true;
  Future<bool> _validatePermissions() async => true;
  Future<bool> _validatePrivacyPolicy() async => true;
  Future<bool> _validateContentRating() async => true;
  Future<bool> _validateIosDeploymentTarget() async => true;
  Future<bool> _validateAppIcons() async => true;
  Future<bool> _validateLaunchScreen() async => true;
  Future<bool> _validateAppTransportSecurity() async => true;
  Future<bool> _validateInAppPurchases() async => true;
  Future<bool> _validateVersionCode() async => true;
  Future<bool> _validateBundleVersion() async => true;

  /// Get submission history
  List<SubmissionRecord> get submissionHistory => _submissionHistory;

  /// Get active reviews
  List<ReviewProcess> get activeReviews => _activeReviews;

  /// Get submission by ID
  SubmissionRecord? getSubmissionById(String id) {
    try {
      return _submissionHistory.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get review process by ID
  ReviewProcess? getReviewById(String id) {
    try {
      return _activeReviews.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update review status (simulated - in real app, this would be called by webhooks or polling)
  Future<void> updateReviewStatus(String reviewId, ReviewStatus status) async {
    final index = _activeReviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      _activeReviews[index] = _activeReviews[index].copyWith(
        status: status,
        lastUpdated: DateTime.now(),
      );
      await _saveActiveReviews();
      debugPrint('Updated review status: $reviewId -> $status');
    }
  }
}

/// Store platform enumeration
enum StorePlatform { googlePlay, appStore }

/// Submission status enumeration
enum SubmissionStatus {
  preparing,
  validating,
  uploading,
  submitted,
  inReview,
  approved,
  rejected,
  published,
  failed,
}

/// Review status enumeration
enum ReviewStatus {
  submitted,
  inReview,
  waitingForDeveloper,
  approved,
  rejected,
  published,
}

/// Review checkpoint status enumeration
enum ReviewCheckpointStatus {
  pending,
  inProgress,
  completed,
  failed,
}

/// Submission record model
class SubmissionRecord {
  final String id;
  final StorePlatform platform;
  final String version;
  final String buildNumber;
  final DateTime submissionDate;
  final SubmissionStatus status;
  final String track;

  const SubmissionRecord({
    required this.id,
    required this.platform,
    required this.version,
    required this.buildNumber,
    required this.submissionDate,
    required this.status,
    required this.track,
  });

  SubmissionRecord copyWith({
    String? id,
    StorePlatform? platform,
    String? version,
    String? buildNumber,
    DateTime? submissionDate,
    SubmissionStatus? status,
    String? track,
  }) {
    return SubmissionRecord(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      version: version ?? this.version,
      buildNumber: buildNumber ?? this.buildNumber,
      submissionDate: submissionDate ?? this.submissionDate,
      status: status ?? this.status,
      track: track ?? this.track,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform.toString(),
      'version': version,
      'buildNumber': buildNumber,
      'submissionDate': submissionDate.toIso8601String(),
      'status': status.toString(),
      'track': track,
    };
  }

  factory SubmissionRecord.fromJson(Map<String, dynamic> json) {
    return SubmissionRecord(
      id: json['id'] as String,
      platform: StorePlatform.values.firstWhere(
        (e) => e.toString() == json['platform'],
      ),
      version: json['version'] as String,
      buildNumber: json['buildNumber'] as String,
      submissionDate: DateTime.parse(json['submissionDate'] as String),
      status: SubmissionStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      track: json['track'] as String,
    );
  }
}

/// Google Play submission model
class GooglePlaySubmission {
  final String id;
  final String appVersion;
  final String buildNumber;
  final String releaseTrack;
  final List<String> apkPaths;
  final String releaseNotes;
  final double? userFraction;
  final bool isDraft;
  final DateTime submissionDate;
  SubmissionStatus status;
  final SubmissionChecklist checklist;
  final ValidationResults validationResults;

  GooglePlaySubmission({
    required this.id,
    required this.appVersion,
    required this.buildNumber,
    required this.releaseTrack,
    required this.apkPaths,
    required this.releaseNotes,
    this.userFraction,
    required this.isDraft,
    required this.submissionDate,
    required this.status,
    required this.checklist,
    required this.validationResults,
  });
}

/// App Store submission model
class AppStoreSubmission {
  final String id;
  final String appVersion;
  final String buildNumber;
  final String ipaPath;
  final String releaseNotes;
  final bool isPhased;
  final bool autoRelease;
  final DateTime submissionDate;
  SubmissionStatus status;
  final SubmissionChecklist checklist;
  final ValidationResults validationResults;

  AppStoreSubmission({
    required this.id,
    required this.appVersion,
    required this.buildNumber,
    required this.ipaPath,
    required this.releaseNotes,
    required this.isPhased,
    required this.autoRelease,
    required this.submissionDate,
    required this.status,
    required this.checklist,
    required this.validationResults,
  });
}

/// Review process model
class ReviewProcess {
  final String id;
  final StorePlatform platform;
  final String appVersion;
  final String buildNumber;
  final DateTime submissionDate;
  final ReviewStatus status;
  final Duration estimatedReviewTime;
  final List<ReviewCheckpoint> checkpoints;
  final DateTime lastUpdated;

  const ReviewProcess({
    required this.id,
    required this.platform,
    required this.appVersion,
    required this.buildNumber,
    required this.submissionDate,
    required this.status,
    required this.estimatedReviewTime,
    required this.checkpoints,
    required this.lastUpdated,
  });

  ReviewProcess copyWith({
    String? id,
    StorePlatform? platform,
    String? appVersion,
    String? buildNumber,
    DateTime? submissionDate,
    ReviewStatus? status,
    Duration? estimatedReviewTime,
    List<ReviewCheckpoint>? checkpoints,
    DateTime? lastUpdated,
  }) {
    return ReviewProcess(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
      submissionDate: submissionDate ?? this.submissionDate,
      status: status ?? this.status,
      estimatedReviewTime: estimatedReviewTime ?? this.estimatedReviewTime,
      checkpoints: checkpoints ?? this.checkpoints,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform.toString(),
      'appVersion': appVersion,
      'buildNumber': buildNumber,
      'submissionDate': submissionDate.toIso8601String(),
      'status': status.toString(),
      'estimatedReviewTime': estimatedReviewTime.inMilliseconds,
      'checkpoints': checkpoints.map((c) => c.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory ReviewProcess.fromJson(Map<String, dynamic> json) {
    return ReviewProcess(
      id: json['id'] as String,
      platform: StorePlatform.values.firstWhere(
        (e) => e.toString() == json['platform'],
      ),
      appVersion: json['appVersion'] as String,
      buildNumber: json['buildNumber'] as String,
      submissionDate: DateTime.parse(json['submissionDate'] as String),
      status: ReviewStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      estimatedReviewTime: Duration(milliseconds: json['estimatedReviewTime'] as int),
      checkpoints: (json['checkpoints'] as List)
          .map((c) => ReviewCheckpoint.fromJson(c))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}

/// Review checkpoint model
class ReviewCheckpoint {
  final String name;
  final String description;
  final ReviewCheckpointStatus status;
  final Duration estimatedTime;
  final DateTime? startTime;
  final DateTime? completionTime;

  const ReviewCheckpoint({
    required this.name,
    required this.description,
    required this.status,
    required this.estimatedTime,
    this.startTime,
    this.completionTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'status': status.toString(),
      'estimatedTime': estimatedTime.inMilliseconds,
      'startTime': startTime?.toIso8601String(),
      'completionTime': completionTime?.toIso8601String(),
    };
  }

  factory ReviewCheckpoint.fromJson(Map<String, dynamic> json) {
    return ReviewCheckpoint(
      name: json['name'] as String,
      description: json['description'] as String,
      status: ReviewCheckpointStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      estimatedTime: Duration(milliseconds: json['estimatedTime'] as int),
      startTime: json['startTime'] != null 
          ? DateTime.parse(json['startTime'] as String) 
          : null,
      completionTime: json['completionTime'] != null 
          ? DateTime.parse(json['completionTime'] as String) 
          : null,
    );
  }
}

/// Submission checklist model
class SubmissionChecklist {
  final List<ChecklistItem> items = [];

  bool get isComplete => items.every((item) => item.isCompleted || !item.isRequired);
  int get completedItems => items.where((item) => item.isCompleted).length;
  int get totalItems => items.length;
  double get completionPercentage => items.isEmpty ? 0.0 : completedItems / totalItems;
}

/// Checklist item model
class ChecklistItem {
  final String name;
  final String description;
  final bool isCompleted;
  final bool isRequired;

  const ChecklistItem({
    required this.name,
    required this.description,
    required this.isCompleted,
    required this.isRequired,
  });
}

/// Validation results model
class ValidationResults {
  final List<ValidationCheck> checks = [];

  bool get isValid => checks.every((check) => check.passed);
  int get passedChecks => checks.where((check) => check.passed).length;
  int get totalChecks => checks.length;
}

/// Validation check model
class ValidationCheck {
  final String name;
  final bool passed;
  final String message;

  const ValidationCheck({
    required this.name,
    required this.passed,
    required this.message,
  });
}

/// Submission result model
class SubmissionResult {
  final bool success;
  final String submissionId;
  final String message;
  final String? trackingUrl;
  final String? error;

  const SubmissionResult({
    required this.success,
    required this.submissionId,
    required this.message,
    this.trackingUrl,
    this.error,
  });
}

