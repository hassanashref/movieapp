import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context)
            .pushReplacementNamed(OnboardingScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: r.w(90),
                      height: r.w(90),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.primary,
                        size: r.w(48),
                      ),
                    ),
                    SizedBox(height: r.h(10)),
                    Text(
                      'Route',
                      style: TextStyle(
                        fontSize: r.sp(32),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: r.h(24)),
              child: Text(
                'Supervised by Mohamed Helal',
                style: TextStyle(
                  fontSize: r.sp(12),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}