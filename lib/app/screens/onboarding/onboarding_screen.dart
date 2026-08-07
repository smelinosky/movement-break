import 'package:flutter/material.dart';

import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  static const int _totalPages = 3;

  final List<_OnboardingContent> _pages = const [
    _OnboardingContent(
      title: 'When was the last time you moved?',
      body:
          'Long periods of sitting can leave you feeling tired, stiff, and unfocused. '
          'Movement Break helps you build healthy movement habits with quick, simple movement breaks throughout your day.',
      buttonText: 'Continue',
    ),
    _OnboardingContent(
      title: 'How it works',
      body:
          'Movement Break reminds you when it is time to move. '
          'Tap the reminder, complete a short movement, and get back to your day.',
      buttonText: 'Continue',
    ),
    _OnboardingContent(
      title: 'What you’ll get',
      body:
          'Short movement breaks designed to help you move more consistently, '
          'feel less stiff, and build a healthier daily movement habit.',
      buttonText: 'Let’s Get Started',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_currentPage < _totalPages - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Setup wizard is coming next.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final page = _pages[index];

          return OnboardingPage(
            title: page.title,
            body: page.body,
            currentPage: index,
            totalPages: _totalPages,
            buttonText: page.buttonText,
            onContinue: _continue,
          );
        },
      ),
    );
  }
}

class _OnboardingContent {
  const _OnboardingContent({
    required this.title,
    required this.body,
    required this.buttonText,
  });

  final String title;
  final String body;
  final String buttonText;
}
