import 'package:flutter/material.dart';

class ProfScreen extends StatelessWidget {
  const ProfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff17191A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline_rounded,
              color: Color(0xffffd400),
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              'Profile Screen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
