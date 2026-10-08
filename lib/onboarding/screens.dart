import 'package:flutter/material.dart';
import 'design.dart';
import 'filo_frame.dart';
import 'models.dart';
import 'onboarding_controller.dart';
import 'placeholders.dart';

// ==========================================
// 1. INTRO SCREEN (Duolingo-Style)
// ==========================================
class IntroScreen extends StatefulWidget {
  final OnboardingController controller;

  const IntroScreen({super.key, required this.controller});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late final PageController _pageController;

  static const List<Map<String, String>> _slides = [
    {
      'title': 'Learning, together.',
      'subtitle':
          'Connect, learn, and grow in classrooms tailored for both students and instructors.',
    },
    {
      'title': 'Small steps. Big wins.',
      'subtitle':
          'Track your lessons, submit assignments, and celebrate everyday learning milestones.',
    },
    {
      'title': 'Stay curious.',
      'subtitle':
          'Explore engaging course materials, quizzes, and instant feedback on any device.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.controller.introSlideIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final currentSlide = widget.controller.introSlideIndex;
        final isLastSlide = currentSlide == _slides.length - 1;
        final double progress = (currentSlide + 1) / (_slides.length + 2); // 0.2 to 0.6

        return FiloFrame(
          progress: progress,
          trailingHeader: GestureDetector(
            onTap: widget.controller.skipIntro,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'SKIP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                  color: DuoColors.textMuted,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 420,
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    widget.controller.setIntroSlideIndex(index);
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DuoIntroBadge(slideIndex: index),
                        const SizedBox(height: 20),
                        DuoSpeechBubble(
                          title: slide['title'],
                          text: slide['subtitle']!,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Segmented Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (index) {
                  final isActive = index == currentSlide;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isActive ? DuoColors.green : DuoColors.borderGrey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
            ],
          ),
          footer: DuoButton(
            label: isLastSlide ? 'Get started' : 'Continue',
            variant: DuoButtonVariant.primary,
            onPressed: () {
              if (isLastSlide) {
                widget.controller.goToLogin();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                );
              }
            },
          ),
        );
      },
    );
  }
}

// ==========================================
// 2. LOGIN SCREEN (Duolingo-Style)
// ==========================================
class LoginScreen extends StatelessWidget {
  final OnboardingController controller;

  const LoginScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final errorMsg = controller.errorMessage;

        return FiloFrame(
          progress: 0.5,
          onBack: controller.goToIntro,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const DuoLoginBadge(),
              const SizedBox(height: 24),
              const DuoSpeechBubble(
                title: 'Hello, curious mind!',
                text:
                    'Sign in with your Google account to get started with your classes.',
              ),
              const SizedBox(height: 24),

              // Feature highlight badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: DuoColors.blueLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: DuoColors.blueDark.withValues(alpha: 0.3),
                      width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.bolt_rounded, color: DuoColors.blueDark, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'INSTANT SIGN-IN • NO PASSWORDS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: DuoColors.blueDark,
                      ),
                    ),
                  ],
                ),
              ),

              // Error message
              if (errorMsg != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: DuoColors.coral.withValues(alpha: 0.4),
                        width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: DuoColors.coralDark, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          errorMsg,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: DuoColors.coralDark,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.clearError,
                        child: const Icon(Icons.close_rounded,
                            color: DuoColors.textMuted, size: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          footer: DuoButton(
            label: 'Continue with Google',
            variant: DuoButtonVariant.teal,
            isLoading: controller.isLoading,
            icon: Container(
              width: 30,
              height: 30,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.g_mobiledata_rounded,
                color: DuoColors.teal,
                size: 22,
              ),
            ),
            onPressed: controller.isLoading ? null : controller.signInWithGoogle,
          ),
        );
      },
    );
  }
}

// ==========================================
// 3. ROLE SELECTION SCREEN (Duolingo-Style)
// ==========================================
class RoleSelectionScreen extends StatelessWidget {
  final OnboardingController controller;

  const RoleSelectionScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final selectedRole = controller.userProfile.role;

        return FiloFrame(
          progress: 0.7,
          onBack: controller.goToLogin,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const DuoSpeechBubble(
                title: "What's your role?",
                text: 'Choose how you will be using Filo. You can join or manage classes right away.',
              ),
              const SizedBox(height: 28),

              // Student Card (3D DuoCard)
              DuoCard(
                isSelected: selectedRole == UserRole.student,
                onTap: () => controller.selectRole(UserRole.student),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: selectedRole == UserRole.student
                            ? DuoColors.green
                            : DuoColors.greenSurface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.backpack_rounded,
                        color: selectedRole == UserRole.student
                            ? Colors.white
                            : DuoColors.greenDark,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Learn',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: DuoColors.textDark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: DuoColors.greenLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'STUDENT',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                    color: DuoColors.greenDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Join classes, review lessons, and test your skills with quizzes.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: DuoColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Checkmark radio indicator
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: selectedRole == UserRole.student
                            ? DuoColors.green
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedRole == UserRole.student
                              ? DuoColors.greenDark
                              : DuoColors.borderDark,
                          width: 2.5,
                        ),
                      ),
                      child: selectedRole == UserRole.student
                          ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Instructor Card (3D DuoCard)
              DuoCard(
                isSelected: selectedRole == UserRole.instructor,
                onTap: () => controller.selectRole(UserRole.instructor),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: selectedRole == UserRole.instructor
                            ? DuoColors.teal
                            : DuoColors.tealSurface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.co_present_rounded,
                        color: selectedRole == UserRole.instructor
                            ? Colors.white
                            : DuoColors.tealDark,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Teach',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: DuoColors.textDark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: DuoColors.tealLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'INSTRUCTOR',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                    color: DuoColors.tealDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Create classes, share files, and craft AI-powered quizzes.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: DuoColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: selectedRole == UserRole.instructor
                            ? DuoColors.teal
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedRole == UserRole.instructor
                              ? DuoColors.tealDark
                              : DuoColors.borderDark,
                          width: 2.5,
                        ),
                      ),
                      child: selectedRole == UserRole.instructor
                          ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          footer: DuoButton(
            label: 'Continue',
            variant: DuoButtonVariant.primary,
            onPressed: selectedRole == null ? null : controller.confirmRole,
          ),
        );
      },
    );
  }
}

// ==========================================
// 4. PROFILE SETUP SCREEN (Duolingo-Style)
// ==========================================
class ProfileSetupScreen extends StatefulWidget {
  final OnboardingController controller;

  const ProfileSetupScreen({super.key, required this.controller});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _schoolController;
  late final TextEditingController _bioController;
  int _avatarIndex = 0;

  @override
  void initState() {
    super.initState();
    final profile = widget.controller.userProfile;
    _nameController = TextEditingController(text: profile.displayName);
    _schoolController = TextEditingController(text: profile.school);
    _bioController = TextEditingController(text: profile.bio);
    _avatarIndex = profile.avatarIndex;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.controller.saveProfile(
        displayName: _nameController.text.trim(),
        school: _schoolController.text.trim(),
        bio: _bioController.text.trim(),
        avatarIndex: _avatarIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.controller.userProfile;

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return FiloFrame(
          progress: 0.85,
          onBack: () => widget.controller.selectRole(widget.controller.userProfile.role ?? UserRole.student),
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const DuoSpeechBubble(
                  title: 'Create your profile!',
                  text: 'Pick an avatar and confirm your name for your class community.',
                ),
                const SizedBox(height: 24),

                // Chunky Avatar Picker
                DuoAvatarPicker(
                  selectedIndex: _avatarIndex,
                  onSelected: (idx) {
                    setState(() {
                      _avatarIndex = idx;
                    });
                  },
                ),
                const SizedBox(height: 28),

                // Display Name Input (Chunky 3D Input)
                const Text(
                  'DISPLAY NAME',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: DuoColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: DuoColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: DuoColors.borderGrey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: DuoColors.borderGrey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: DuoColors.green, width: 2.5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Email Address (Read-only badge)
                const Text(
                  'EMAIL ADDRESS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: DuoColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: DuoColors.borderGrey, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email_outlined, size: 20, color: DuoColors.textMuted),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          profile.email,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: DuoColors.textMuted,
                          ),
                        ),
                      ),
                      const Icon(Icons.lock_rounded, size: 18, color: DuoColors.textMuted),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // School / Organization (Optional)
                const Text(
                  'SCHOOL / ORGANIZATION (OPTIONAL)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: DuoColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _schoolController,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: DuoColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'e.g. University of Science',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: DuoColors.borderGrey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: DuoColors.borderGrey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: DuoColors.green, width: 2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Bio (Optional)
                const Text(
                  'SHORT BIO (OPTIONAL)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: DuoColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bioController,
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: DuoColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'A sentence about yourself...',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: DuoColors.borderGrey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: DuoColors.borderGrey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: DuoColors.green, width: 2.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          footer: DuoButton(
            label: 'Save and continue',
            variant: DuoButtonVariant.primary,
            isLoading: widget.controller.isLoading,
            onPressed: _submit,
          ),
        );
      },
    );
  }
}

// ==========================================
// 5. WELCOME SCREEN (Duolingo-Style)
// ==========================================
class WelcomeScreen extends StatelessWidget {
  final OnboardingController controller;

  const WelcomeScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final profile = controller.userProfile;

        return FiloFrame(
          progress: 1.0, // 100% full progress!
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const DuoWelcomeBadge(),
              const SizedBox(height: 20),
              DuoSpeechBubble(
                title: "You're all set!",
                text: "Welcome to Filo, ${profile.displayName}! Your journey starts today.",
              ),
              const SizedBox(height: 24),

              // Achievement Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: DuoColors.borderGrey, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: DuoColors.greenLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            profile.role == UserRole.instructor
                                ? Icons.co_present_rounded
                                : Icons.backpack_rounded,
                            color: DuoColors.greenDark,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.roleTitle.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                  color: DuoColors.textDark,
                                ),
                              ),
                              Text(
                                profile.school.isNotEmpty ? profile.school : 'Filo Learning Hub',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: DuoColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: DuoColors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'READY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (profile.bio.isNotEmpty) ...[
                      const Divider(height: 24, color: DuoColors.borderGrey),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '"${profile.bio}"',
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: DuoColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          footer: DuoButton(
            label: "Let's go!",
            variant: DuoButtonVariant.primary,
            onPressed: controller.finishOnboarding,
          ),
        );
      },
    );
  }
}
