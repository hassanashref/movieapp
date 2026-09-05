import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../utils/responsive.dart';
import 'widgets/onboarding_page.dart';
import 'onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _back() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finish() {
    // TODO: Navigator.pushReplacementNamed(LoginScreen.routeName)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Onboarding finished!')),
    );
  }

  Widget _buildButtons(Responsive r) {
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == onboardingList.length - 1;

    if (isFirst) {
      return _PrimaryButton(text: 'Explore Now', onPressed: _next, r: r);
    }

    return Column(
      children: [
        _PrimaryButton(
          text: isLast ? 'Finish' : 'Next',
          onPressed: isLast ? _finish : _next,
          r: r,
        ),
        SizedBox(height: r.h(10)),
        _OutlinedButtonWidget(text: 'Back', onPressed: _back, r: r),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingList.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return OnboardingPage(
            data: onboardingList[index],
            bottomButtons: _buildButtons(r),
          );
        },
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Responsive r;

  const _PrimaryButton({
    required this.text,
    required this.onPressed,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: r.h(50),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.w(8)),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: r.sp(15),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _OutlinedButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Responsive r;

  const _OutlinedButtonWidget({
    required this.text,
    required this.onPressed,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: r.h(50),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.w(8)),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: r.sp(15),
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}