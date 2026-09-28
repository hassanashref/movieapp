import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../homeScreen/home_screen.dart';
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
      if (!mounted) return;

      // final user = FirebaseAuth.instance.currentUser;
      // if (user != null) {
      //   Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      // } else {
      //   Navigator.of(context).pushReplacementNamed(OnboardingScreen.routeName);
      // }

      Navigator.of(context).pushReplacementNamed(OnboardingScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset("assets/images/movie_logo.png"),
                ),
              ),
              Image.asset(
                "assets/images/img_1.png",
                height: 76.h,
                width: 180.w,
              ),
              const SizedBox(height: 10),
              Text(
                'Supervised by Mohamed Helal',
                style: TextStyle(
                  fontSize: 16.r,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
