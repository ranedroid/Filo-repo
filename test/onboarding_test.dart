import 'package:flutter_test/flutter_test.dart';
import 'package:filo_app/onboarding/models.dart';
import 'package:filo_app/onboarding/onboarding_controller.dart';

void main() {
  group('UserProfile model tests', () {
    test('serializes to and from Map accurately', () {
      const original = UserProfile(
        id: 'usr_123',
        displayName: 'Sam Teacher',
        email: 'sam@school.edu',
        role: UserRole.instructor,
        school: 'Tech High',
        bio: 'CS Teacher',
        avatarIndex: 2,
        isComplete: true,
      );

      final map = original.toMap();
      final fromMap = UserProfile.fromMap(map, documentId: 'usr_123');

      expect(fromMap.id, 'usr_123');
      expect(fromMap.displayName, 'Sam Teacher');
      expect(fromMap.email, 'sam@school.edu');
      expect(fromMap.role, UserRole.instructor);
      expect(fromMap.school, 'Tech High');
      expect(fromMap.bio, 'CS Teacher');
      expect(fromMap.avatarIndex, 2);
      expect(fromMap.isComplete, true);
    });
  });

  group('OnboardingController flow tests', () {
    test('initial state begins at intro step', () {
      final controller = OnboardingController();
      expect(controller.currentStep, OnboardingStep.intro);
      expect(controller.introSlideIndex, 0);
    });

    test('step progression and role assignment', () {
      final controller = OnboardingController();

      controller.goToLogin();
      expect(controller.currentStep, OnboardingStep.login);

      controller.selectRole(UserRole.student);
      expect(controller.userProfile.role, UserRole.student);

      controller.confirmRole();
      expect(controller.currentStep, OnboardingStep.profileSetup);

      controller.updateProfileData(
        displayName: 'Jordan Learner',
        school: 'Central High',
        bio: 'Ready to study',
        avatarIndex: 1,
      );

      expect(controller.userProfile.displayName, 'Jordan Learner');
      expect(controller.userProfile.school, 'Central High');
      expect(controller.userProfile.isComplete, true);
    });
  });
}
