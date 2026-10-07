enum UserRole {
  student,
  instructor,
}

enum OnboardingStep {
  intro,
  login,
  roleSelect,
  profileSetup,
  welcome,
  completed,
}

class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final UserRole? role;
  final String school;
  final String bio;
  final int avatarIndex; // -1: Google photo, 0-3: illustrated avatars
  final bool isComplete;

  const UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    this.role,
    this.school = '',
    this.bio = '',
    this.avatarIndex = 0,
    this.isComplete = false,
  });

  UserProfile copyWith({
    String? id,
    String? displayName,
    String? email,
    UserRole? role,
    String? school,
    String? bio,
    int? avatarIndex,
    bool? isComplete,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      role: role ?? this.role,
      school: school ?? this.school,
      bio: bio ?? this.bio,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  String get roleTitle {
    switch (role) {
      case UserRole.instructor:
        return 'Instructor';
      case UserRole.student:
        return 'Student';
      case null:
        return 'Learner';
    }
  }
}
