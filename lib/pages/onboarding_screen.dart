import 'package:flutter/material.dart';
import 'onboarding_design.dart';
import 'disclaimer_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      image: 'assets/images/onboarding1.png',
      title: 'Scan risky terms before you accept',
      description:
          'SafePath automatically detects potentially harmful clauses in agreements and policies.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding2.png',
      title: 'We detect hidden clauses in contract',
      description:
          'Our smart detection system flags complex or misleading terms instantly.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding3.png',
      title: 'Get clear explanations instantly',
      description:
          "We help you to understand what you're agreeing to before you tap 'Accept'",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _onboardingData[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              child: Column(
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildIndicator(index),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Bottom Actions
                  if (_currentPage == _onboardingData.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DisclaimerScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OnboardingDesign.primaryBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        _pageController.animateToPage(
                          _onboardingData.length - 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 24 : 12,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive
            ? OnboardingDesign.indicatorActive
            : OnboardingDesign.indicatorInactive,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(data.image, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: OnboardingDesign.titleStyle.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                data.description,
                textAlign: TextAlign.center,
                style: OnboardingDesign.bodyStyle,
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
