import 'package:flutter/material.dart';

/// Demo User Model
/// 
/// Demonstrates:
/// - Data modeling (Lesson 4)
/// - Immutable objects with copyWith pattern
/// - Enum usage for user types
/// - JSON serialization concepts

enum UserRole {
  student('student', 'Student', Icons.school, Color(0xFF3B82F6)),
  developer('developer', 'Developer', Icons.code, Color(0xFF10B981)),
  instructor('instructor', 'Instructor', Icons.person_outline, Color(0xFF8B5CF6));

  const UserRole(this.id, this.displayName, this.icon, this.color);

  final String id;
  final String displayName;
  final IconData icon;
  final Color color;
}

/// Demo user data model for bypassing authentication
class DemoUser {
  const DemoUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.avatar,
    required this.joinDate,
    this.points = 0,
    this.streak = 0,
    this.completedQuizzes = 0,
    this.joinedGroups = 0,
    this.bio = '',
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final String avatar;
  final DateTime joinDate;
  final int points;
  final int streak;
  final int completedQuizzes;
  final int joinedGroups;
  final String bio;

  /// Full name getter
  String get fullName => '$firstName $lastName';

  /// Display name with role
  String get displayNameWithRole => '$fullName (${role.displayName})';

  /// Copy with method for immutable updates
  DemoUser copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    String? avatar,
    DateTime? joinDate,
    int? points,
    int? streak,
    int? completedQuizzes,
    int? joinedGroups,
    String? bio,
  }) {
    return DemoUser(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      joinDate: joinDate ?? this.joinDate,
      points: points ?? this.points,
      streak: streak ?? this.streak,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      joinedGroups: joinedGroups ?? this.joinedGroups,
      bio: bio ?? this.bio,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.id,
      'avatar': avatar,
      'joinDate': joinDate.toIso8601String(),
      'points': points,
      'streak': streak,
      'completedQuizzes': completedQuizzes,
      'joinedGroups': joinedGroups,
      'bio': bio,
    };
  }

  /// Create from JSON
  factory DemoUser.fromJson(Map<String, dynamic> json) {
    return DemoUser(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: UserRole.values.firstWhere(
        (role) => role.id == json['role'],
        orElse: () => UserRole.student,
      ),
      avatar: json['avatar'] as String,
      joinDate: DateTime.parse(json['joinDate'] as String),
      points: json['points'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
      completedQuizzes: json['completedQuizzes'] as int? ?? 0,
      joinedGroups: json['joinedGroups'] as int? ?? 0,
      bio: json['bio'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DemoUser &&
        other.id == id &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.role == role &&
        other.avatar == avatar &&
        other.joinDate == joinDate &&
        other.points == points &&
        other.streak == streak &&
        other.completedQuizzes == completedQuizzes &&
        other.joinedGroups == joinedGroups &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      firstName,
      lastName,
      role,
      avatar,
      joinDate,
      points,
      streak,
      completedQuizzes,
      joinedGroups,
      bio,
    );
  }

  @override
  String toString() {
    return 'DemoUser(id: $id, fullName: $fullName, role: ${role.displayName})';
  }
}

/// Pre-defined demo users for different roles
class DemoUsers {
  static final student = DemoUser(
    id: 'demo_student_001',
    email: 'student@fluttersocial.dev',
    firstName: 'Alex',
    lastName: 'Student',
    role: UserRole.student,
    avatar: '👨‍🎓',
    joinDate: DateTime.now().subtract(const Duration(days: 30)),
    points: 1250,
    streak: 7,
    completedQuizzes: 15,
    joinedGroups: 3,
    bio: 'Passionate Flutter learner, excited to build amazing mobile apps!',
  );

  static final developer = DemoUser(
    id: 'demo_developer_001',
    email: 'dev@fluttersocial.dev',
    firstName: 'Taylor',
    lastName: 'Developer',
    role: UserRole.developer,
    avatar: '👩‍💻',
    joinDate: DateTime.now().subtract(const Duration(days: 180)),
    points: 3500,
    streak: 25,
    completedQuizzes: 45,
    joinedGroups: 8,
    bio: 'Senior Flutter Developer with 5+ years experience. Love helping others learn!',
  );

  static final instructor = DemoUser(
    id: 'demo_instructor_001',
    email: 'instructor@fluttersocial.dev',
    firstName: 'Morgan',
    lastName: 'Instructor',
    role: UserRole.instructor,
    avatar: '👨‍🏫',
    joinDate: DateTime.now().subtract(const Duration(days: 365)),
    points: 7500,
    streak: 50,
    completedQuizzes: 100,
    joinedGroups: 15,
    bio: 'Flutter instructor and course creator. Building the next generation of Flutter developers!',
  );

  /// Get all demo users
  static List<DemoUser> get allUsers => [student, developer, instructor];

  /// Get user by role
  static DemoUser? getUserByRole(UserRole role) {
    switch (role) {
      case UserRole.student:
        return student;
      case UserRole.developer:
        return developer;
      case UserRole.instructor:
        return instructor;
    }
  }
}
