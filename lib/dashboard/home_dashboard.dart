import 'package:flutter/material.dart';
import '../onboarding/design.dart';
import '../onboarding/models.dart';
import '../onboarding/onboarding_controller.dart';

/// Duolingo-styled Dashboard displaying gamified headers, streaks, and tactile cards.
class HomeDashboardScreen extends StatelessWidget {
  final OnboardingController controller;

  const HomeDashboardScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final profile = controller.userProfile;
    final isInstructor = profile.role == UserRole.instructor;

    return Scaffold(
      backgroundColor: DuoColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                // Duolingo-style Gamified Top App Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: DuoColors.borderGrey, width: 2)),
                  ),
                  child: Row(
                    children: [
                      // Brand Logo Chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: DuoColors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'FILO',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Streak Counter (Fire)
                      Row(
                        children: const [
                          Icon(Icons.local_fire_department_rounded, color: DuoColors.coral, size: 24),
                          SizedBox(width: 4),
                          Text(
                            '1',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: DuoColors.coral,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // Gems Counter (Diamonds)
                      Row(
                        children: const [
                          Icon(Icons.diamond_rounded, color: DuoColors.blue, size: 22),
                          SizedBox(width: 4),
                          Text(
                            '50',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: DuoColors.blue,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Replay Onboarding Button
                      GestureDetector(
                        onTap: controller.reset,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: DuoColors.greenSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: DuoColors.green, width: 1.5),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.replay_rounded, size: 16, color: DuoColors.greenDark),
                              SizedBox(width: 4),
                              Text(
                                'REPLAY',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                  color: DuoColors.greenDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Dashboard Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting speech bubble
                        DuoSpeechBubble(
                          title: 'Welcome, ${profile.displayName}!',
                          text: isInstructor
                              ? 'Your teaching headquarters is ready. Create a class to begin!'
                              : 'Keep your streak going! Join your class with your instructor’s code.',
                        ),

                        const SizedBox(height: 24),

                        // Daily Quest / Goal Banner
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: DuoColors.yellowLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: DuoColors.yellowDark, width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: DuoColors.yellow,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.star_rounded, color: Colors.white, size: 30),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'FIRST MILESTONE',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                        color: DuoColors.yellowDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isInstructor
                                          ? 'Create your first classroom'
                                          : 'Join your first classroom',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: DuoColors.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, color: DuoColors.yellowDark, size: 28),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Section Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isInstructor ? 'YOUR CLASSES' : 'ENROLLED CLASSES',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                                color: DuoColors.textMuted,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: DuoColors.borderGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                '0 ACTIVE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                  color: DuoColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Empty State 3D Card
                        DuoCard(
                          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: isInstructor ? DuoColors.tealSurface : DuoColors.greenSurface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isInstructor ? Icons.class_outlined : Icons.menu_book_rounded,
                                  size: 38,
                                  color: isInstructor ? DuoColors.teal : DuoColors.green,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                isInstructor ? 'No classes yet' : 'No classes joined yet',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: DuoColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isInstructor
                                    ? 'Tap below to set up your first subject and section.'
                                    : 'Enter the 6-character code from your instructor to get started.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: DuoColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Fixed Bottom Action Bar
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: DuoColors.borderGrey, width: 2)),
                  ),
                  child: DuoButton(
                    label: isInstructor ? 'Create a class' : 'Join a class',
                    variant: DuoButtonVariant.primary,
                    icon: Icon(
                      isInstructor ? Icons.add_rounded : Icons.login_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: DuoColors.greenDark,
                          content: Text(
                            isInstructor
                                ? 'Create class form will open here!'
                                : 'Join class dialog will open here!',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
