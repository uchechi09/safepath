import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'disclaimer_screen.dart';
import 'analyze_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> redGlow;
  late Animation<double> greenGlow;
  late Animation<double> yellowGlow;

  late Animation<Offset> redSlide;
  late Animation<Offset> greenSlide;
  late Animation<Offset> yellowSlide;
  late Animation<Offset> textSlide;
  late Animation<double> logoFade;
  late Animation<Offset> logoSlide;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Sequence: Logo (0.0-0.3) -> Dots (0.3-0.7) -> Text (0.7-1.0)
    logoFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    logoSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
          ),
        );

    // Staggered Dots Animation (0.3 - 0.7)
    greenGlow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeOut),
      ),
    );

    greenSlide = Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.3, 0.5, curve: Curves.easeOutBack),
          ),
        );

    yellowGlow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
      ),
    );

    yellowSlide = Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.4, 0.6, curve: Curves.easeOutBack),
          ),
        );

    redGlow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 0.7, curve: Curves.easeOut),
      ),
    );

    redSlide = Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.5, 0.7, curve: Curves.easeOutBack),
          ),
        );

    // Text Animation (0.7 - 1.0)
    textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    controller.forward();

    // Delay for exactly 4 seconds before navigation
    Timer(const Duration(seconds: 4), () async {
      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
        final hasAcceptedAgreement =
            prefs.getBool('has_accepted_agreement') ?? false;

        Widget nextScreen;
        if (!hasSeenOnboarding) {
          nextScreen = const OnboardingScreen();
        } else if (!hasAcceptedAgreement) {
          nextScreen = const DisclaimerScreen();
        } else {
          nextScreen = const AnalyzeScreen();
        }

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => nextScreen,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget glowLight(
    Color color,
    double glowValue,
    Animation<Offset> slideAnimation,
  ) {
    return SlideTransition(
      position: slideAnimation,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: glowValue),
              blurRadius: 20 * glowValue,
              spreadRadius: 3 * glowValue,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Soft off-white background

      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO WITH ANIMATED DOTS
                Stack(
                  alignment: Alignment.center,
                  children: [
                    FadeTransition(
                      opacity: logoFade,
                      child: SlideTransition(
                        position: logoSlide,
                        child: Image.asset(
                          "assets/images/safepath_logo.png",
                          height: 180,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 75,
                      child: glowLight(
                        const Color(0xFF2ECC71), // Green (Top)
                        greenGlow.value,
                        greenSlide,
                      ),
                    ),
                    Positioned(
                      top: 105,
                      child: glowLight(
                        const Color(0xFFF39C12), // Yellow/Orange (Middle)
                        yellowGlow.value,
                        yellowSlide,
                      ),
                    ),
                    Positioned(
                      top: 135,
                      child: glowLight(
                        const Color(0xFFE74C3C), // Red (Bottom)
                        redGlow.value,
                        redSlide,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                FadeTransition(
                  opacity: controller,
                  child: SlideTransition(
                    position: textSlide,
                    child: const Text(
                      "SafePath LITE",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                FadeTransition(
                  opacity: controller,
                  child: SlideTransition(
                    position: textSlide,
                    child: const Text(
                      "Clarity before Consent",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF636E72),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
