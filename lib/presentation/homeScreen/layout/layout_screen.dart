import 'package:flutter/material.dart';
import 'package:movieapp/presentation/homeScreen/home_screen.dart';
import 'package:movieapp/presentation/homeScreen/layout/braws_screen.dart';
import 'package:movieapp/presentation/homeScreen/layout/prof_screen.dart';
import 'package:movieapp/presentation/homeScreen/layout/search_screen.dart';
import 'package:movieapp/presentation/homeScreen/layout/widgets/custom_nav_item.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});
  static const String routeName = '/layoutScreen';

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    SearchScreen(),
    BrawsScreen(),
    ProfScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff17191A),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xff242626),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomNavItem(
                icon: Icons.home_rounded,
                isSelected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              CustomNavItem(
                icon: Icons.search_rounded,
                isSelected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              CustomNavItem(
                icon: Icons.movie_outlined,
                isSelected: _selectedIndex == 2,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              CustomNavItem(
                icon: Icons.person_outline_rounded,
                isSelected: _selectedIndex == 3,
                onTap: () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
