import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'screens/auth/reset_password/reset_password_screen.dart';
import 'screens/register_profile/register_screen.dart';

void main() {
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),

      home: const ResetPasswordScreen(),

      routes: {
        '/register': (context) => const registerScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
      },
    );
  }
}