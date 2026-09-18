import 'package:flutter/material.dart';
import 'package:movieapp/modules/auth/screens/login_screen.dart';
import 'package:movieapp/modules/auth/screens/register.dart';

  import '../../presentation/Home_screen/home_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import 'app_route_name.dart';

class AppRoute {
  static Route<dynamic>? onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case AppRouteName.loginScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case AppRouteName.register:
        return MaterialPageRoute(
          builder: (context) => const Register(),
        );
      case AppRouteName.homePage:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        ); case AppRouteName.onboardingScreen:
        return MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ); case AppRouteName.splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
    }
  }
}