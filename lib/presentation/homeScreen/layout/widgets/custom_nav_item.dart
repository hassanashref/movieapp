import 'package:flutter/material.dart';

class CustomNavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomNavItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          size: 26,
          color: isSelected ? const Color(0xffffd400) : Colors.white60,
        ),
      ),
    );
  }
}
