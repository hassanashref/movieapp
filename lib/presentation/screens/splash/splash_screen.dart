import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    Timer(const Duration(seconds:  2), () {
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
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          
          
              Expanded(child: Center(child: Image.asset("assets/images/movie_logo.png"))),
          
               Image.asset("assets/images/img_1.png",height: 76.h,width: 180.w,),
              SizedBox(),
          
              Text(
                'Supervised by Mohamed Helal',
                style:  TextStyle(fontSize: 16.r,fontWeight:FontWeight.w400,color: AppColors.textSecondary
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
