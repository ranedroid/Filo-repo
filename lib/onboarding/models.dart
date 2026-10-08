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
  final String? photoUrl;
  final bool isComplete;

  const UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    this.role,
    this.school = '',
    this.bio = '',
    this.avatarIndex = 0,
    this.photoUrl,
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
    String? photoUrl,
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
      photoUrl: photoUrl ?? this.photoUrl,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'role': role?.name,
      'school': school,
      'bio': bio,
      'avatarIndex': avatarIndex,
      'photoUrl': photoUrl,
      'isComplete': isComplete,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, {String? documentId}) {
    UserRole? parsedRole;
    final roleString = map['role'] as String?;
    if (roleString == 'instructor') {
      parsedRole = UserRole.instructor;
    } else if (roleString == 'student') {
      parsedRole = UserRole.student;
    }

    return UserProfile(
      id: documentId ?? (map['id'] as String? ?? ''),
      displayName: map['displayName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: parsedRole,
      school: map['school'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      avatarIndex: (map['avatarIndex'] as num?)?.toInt() ?? 0,
      photoUrl: map['photoUrl'] as String?,
      isComplete: map['isComplete'] as bool? ?? false,
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
