import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:uas_project/models/onboarding_data_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Track Your Mood',
      description:
          'Monitor your emotional well-being daily with our intuitive mood tracker',
      lottieAsset: 'assets/animation/mood_tracker.json',
      backgroundColor: Color(0xFF6B9080),
    ),
    OnboardingData(
      title: 'Mental Wellness',
      description:
          'Access psychology tests and personalized mental health insights',
      lottieAsset: 'assets/animation/bettermind.json',
      backgroundColor: Color(0xFF4A7C7E),
    ),
    OnboardingData(
      title: 'Meditation & Relax',
      description: 'Find peace with guided meditation and relaxation audio',
      lottieAsset: 'assets/animation/meditation.json',
      backgroundColor: Color(0xFF5C8374),
    ),
    OnboardingData(
      title: 'Connect & Share',
      description: 'Join our supportive community and share your journey',
      lottieAsset: 'assets/animation/community.json',
      backgroundColor: Color(0xFF3D6B5E),
    ),
  ];
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),

          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildDot(index),
              ),
            ),
          ),

          Positioned(bottom: 40, left: 40, right: 40, child: _buildButton()),

          if (_currentPage < _pages.length - 1)
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  _pageController.animateToPage(
                    _pages.length - 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: data.backgroundColor,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            Lottie.asset(
              data.lottieAsset,
              width: 280,
              height: 280,
              fit: BoxFit.contain,
            ),

            const Spacer(flex: 1),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                data.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.modernAntiqua(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                data.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.gulzar(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white38,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildButton() {
    final isLastPage = _currentPage == _pages.length - 1;

    return ElevatedButton(
      onPressed: () {
        if (isLastPage) {
          Navigator.pushNamed(context, "/welcomeScreen");
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _pages[_currentPage].backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      child: Text(
        isLastPage ? 'Get Started' : 'Next',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
