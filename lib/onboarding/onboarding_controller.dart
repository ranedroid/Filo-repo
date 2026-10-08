import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../services/user_repository.dart';
import 'models.dart';

/// State management for the Filo onboarding flow.
/// State machine: Intro -> Login -> RoleSelect -> ProfileSetup -> Welcome -> Dashboard.
///
/// Firebase handles authentication (Google Sign-In) and persists
/// lightweight user profile documents in Cloud Firestore.
class OnboardingController extends ChangeNotifier {
  final AuthService _authService;
  final UserRepository _userRepository;

  OnboardingStep _currentStep = OnboardingStep.intro;
  int _introSlideIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile _userProfile = const UserProfile(
    id: 'user_preview_01',
    displayName: '',
    email: '',
  );

  OnboardingController({
    AuthService? authService,
    UserRepository? userRepository,
  })  : _authService = authService ?? AuthService(),
        _userRepository = userRepository ?? UserRepository();

  OnboardingStep get currentStep => _currentStep;
  int get introSlideIndex => _introSlideIndex;
  bool get isLoading => _isLoading;
  UserProfile get userProfile => _userProfile;

  /// Non-null when the last sign-in attempt failed.
  String? get errorMessage => _errorMessage;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

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

  void skipIntro() => goToLogin();

  void goToIntro() {
    _currentStep = OnboardingStep.intro;
    _introSlideIndex = 0;
    notifyListeners();
  }

  void goToLogin() {
    _currentStep = OnboardingStep.login;
    _errorMessage = null;
    notifyListeners();
  }

  /// Attempt to restore existing logged-in session from Firebase and Firestore.
  /// Returns true if a complete profile was restored and app can skip onboarding.
  Future<bool> tryRestoreSession() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final profile = await _userRepository.getUserProfile(user.uid);
        if (profile != null && profile.isComplete) {
          _userProfile = profile;
          _currentStep = OnboardingStep.completed;
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      debugPrint('tryRestoreSession notice: $e');
    }
    return false;
  }

  /// Authenticate with Google via Firebase Auth, then read or create the
  /// user's profile document in Cloud Firestore.
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authService.signInWithGoogle();

      if (credential == null) {
        // User dismissed the account picker — stay on login screen
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (credential.user != null) {
        final user = credential.user!;
        final uid = user.uid;

        // Check if user document already exists in Firestore
        final existingProfile = await _userRepository.getUserProfile(uid);

        if (existingProfile != null && existingProfile.isComplete) {
          // Returning user with completed profile -> jump straight to dashboard
          _userProfile = existingProfile;
          _isLoading = false;
          _currentStep = OnboardingStep.completed;
          notifyListeners();
          return;
        }

        // New user or incomplete profile — carry over Google identity info
        _userProfile = (existingProfile ?? _userProfile).copyWith(
          id: uid,
          displayName: user.displayName?.isNotEmpty == true
              ? user.displayName
              : _userProfile.displayName,
          email: user.email ?? _userProfile.email,
          photoUrl: user.photoURL,
        );
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint('signInWithGoogle unexpected error: $e');
      _errorMessage = 'Something went wrong. Please try again.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = false;

    // Navigate based on profile completeness
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

    updateProfileData(
      displayName: displayName,
      school: school,
      bio: bio,
      avatarIndex: avatarIndex,
    );

    try {
      await _userRepository.saveUserProfile(_userProfile);
    } catch (e) {
      debugPrint('saveProfile Firestore notice: $e');
    }

    _isLoading = false;
    _currentStep = OnboardingStep.welcome;
    notifyListeners();
  }

  void finishOnboarding() {
    _currentStep = OnboardingStep.completed;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    reset();
  }

  void reset() {
    _currentStep = OnboardingStep.intro;
    _introSlideIndex = 0;
    _isLoading = false;
    _errorMessage = null;
    _userProfile = const UserProfile(
      id: 'user_preview_01',
      displayName: '',
      email: '',
    );
    notifyListeners();
  }
}
