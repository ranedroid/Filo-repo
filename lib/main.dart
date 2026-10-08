import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dashboard/home_dashboard.dart';
import 'onboarding/design.dart';
import 'onboarding/models.dart';
import 'onboarding/onboarding_controller.dart';
import 'onboarding/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization notice: $e');
  }
  runApp(const FiloApp());
}

class FiloApp extends StatelessWidget {
  const FiloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: DuoColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: DuoColors.green,
          primary: DuoColors.green,
          secondary: DuoColors.teal,
          surface: DuoColors.background,
        ),
      ),
      home: const FiloRootFlow(),
    );
  }
}

class FiloRootFlow extends StatefulWidget {
  const FiloRootFlow({super.key});

  @override
  State<FiloRootFlow> createState() => _FiloRootFlowState();
}

class _FiloRootFlowState extends State<FiloRootFlow> {
  final OnboardingController _controller = OnboardingController();

  @override
  void initState() {
    super.initState();
    _controller.tryRestoreSession();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Container(
          color: DuoColors.background,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 340),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            child: _buildCurrentScreen(),
          ),
        );
      },
    );
  }

  Widget _buildCurrentScreen() {
    switch (_controller.currentStep) {
      case OnboardingStep.intro:
        return IntroScreen(
          key: const ValueKey('intro_step'),
          controller: _controller,
        );
      case OnboardingStep.login:
        return LoginScreen(
          key: const ValueKey('login_step'),
          controller: _controller,
        );
      case OnboardingStep.roleSelect:
        return RoleSelectionScreen(
          key: const ValueKey('role_step'),
          controller: _controller,
        );
      case OnboardingStep.profileSetup:
        return ProfileSetupScreen(
          key: const ValueKey('profile_step'),
          controller: _controller,
        );
      case OnboardingStep.welcome:
        return WelcomeScreen(
          key: const ValueKey('welcome_step'),
          controller: _controller,
        );
      case OnboardingStep.completed:
        return HomeDashboardScreen(
          key: const ValueKey('dashboard_step'),
          controller: _controller,
        );
    }
  }
}
