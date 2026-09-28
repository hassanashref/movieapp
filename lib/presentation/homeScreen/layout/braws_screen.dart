import 'package:flutter/material.dart';

class BrawsScreen extends StatelessWidget {
  const BrawsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff17191A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              color: Color(0xffffd400),
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              'Browse Screen',
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
