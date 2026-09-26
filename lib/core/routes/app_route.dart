import 'package:flutter/material.dart';
import 'package:movieapp/core/routes/app_route_name.dart';
import 'package:movieapp/modules/auth/screens/forget_Password.dart';
import 'package:movieapp/modules/auth/screens/login_screen.dart';
import 'package:movieapp/modules/auth/screens/register.dart';
import 'package:movieapp/presentation/homeScreen/home_screen.dart';
import 'package:movieapp/presentation/homeScreen/layout/layout_screen.dart';
import 'package:movieapp/presentation/onboarding/onboarding_screen.dart';
import 'package:movieapp/presentation/screens/splash/splash_screen.dart';

class AppRoute {
  static Route<dynamic>? onGenerateRoute(RouteSettings setting) {
    ;
    switch (setting.name) {
      case AppRouteName.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case AppRouteName.register:
        return MaterialPageRoute(builder: (context) => const Register());
      case AppRouteName.forgetpassword:
        return MaterialPageRoute(builder: (context) => const ForgetPassword());
      case AppRouteName.onboardingScreen:
        return MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        );
      case AppRouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case AppRouteName.homeScreen2:
       case HomePage.routeName:
        return MaterialPageRoute(builder: (context) => const LayoutScreen());

      default:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
    }
  }
}
