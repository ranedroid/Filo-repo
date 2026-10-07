import 'package:flutter/foundation.dart';
import 'models.dart';

/// State management for the Filo onboarding flow.
/// Adheres to the state machine outlined in HANDOFF.md:
/// Intro -> Login -> Role -> Profile -> Welcome -> Dashboard.
class OnboardingController extends ChangeNotifier {
  OnboardingStep _currentStep = OnboardingStep.intro;
  int _introSlideIndex = 0;
  bool _isLoading = false;

  UserProfile _userProfile = const UserProfile(
    id: 'user_preview_01',
    displayName: '',
    email: '',
  );

  OnboardingStep get currentStep => _currentStep;
  int get introSlideIndex => _introSlideIndex;
  bool get isLoading => _isLoading;
  UserProfile get userProfile => _userProfile;

  void setIntroSlideIndex(int index) {
    if (_introSlideIndex != index) {
      _introSlideIndex = index;
      notifyListeners();
    }
  }

  void nextIntroSlide() {
    if (_introSlideIndex < 2) {
      _introSlideIndex++;
      notifyListeners();
    } else {
      goToLogin();
    }
  }

  void skipIntro() {
    goToLogin();
  }

  void goToIntro() {
    _currentStep = OnboardingStep.intro;
    _introSlideIndex = 0;
    notifyListeners();
  }

  void goToLogin() {
    _currentStep = OnboardingStep.login;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    // Simulating quick authentic Google sign-in response
    await Future.delayed(const Duration(milliseconds: 600));

    _userProfile = _userProfile.copyWith(
      displayName: _userProfile.displayName.isEmpty ? 'Alex Mercer' : _userProfile.displayName,
      email: _userProfile.email.isEmpty ? 'alex.mercer@gmail.com' : _userProfile.email,
    );

    _isLoading = false;

    // Check if role has already been set
    if (_userProfile.role == null) {
      _currentStep = OnboardingStep.roleSelect;
    } else if (!_userProfile.isComplete) {
      _currentStep = OnboardingStep.profileSetup;
    } else {
      _currentStep = OnboardingStep.completed;
    }

    notifyListeners();
  }

  void selectRole(UserRole role) {
    _userProfile = _userProfile.copyWith(role: role);
    notifyListeners();
  }

  void confirmRole() {
    if (_userProfile.role != null) {
      _currentStep = OnboardingStep.profileSetup;
      notifyListeners();
    }
  }

  void updateProfileData({
    required String displayName,
    required String school,
    required String bio,
    required int avatarIndex,
  }) {
    _userProfile = _userProfile.copyWith(
      displayName: displayName,
      school: school,
      bio: bio,
      avatarIndex: avatarIndex,
      isComplete: true,
    );
    notifyListeners();
  }

  Future<void> saveProfile({
    required String displayName,
    required String school,
    required String bio,
    required int avatarIndex,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    updateProfileData(
      displayName: displayName,
      school: school,
      bio: bio,
      avatarIndex: avatarIndex,
    );

    _isLoading = false;
    _currentStep = OnboardingStep.welcome;
    notifyListeners();
  }

  void finishOnboarding() {
    _currentStep = OnboardingStep.completed;
    notifyListeners();
  }

  void reset() {
    _currentStep = OnboardingStep.intro;
    _introSlideIndex = 0;
    _isLoading = false;
    _userProfile = const UserProfile(
      id: 'user_preview_01',
      displayName: '',
      email: '',
    );
    notifyListeners();
  }
}
