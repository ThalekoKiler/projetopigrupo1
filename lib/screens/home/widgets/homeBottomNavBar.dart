import "package:flutter/material.dart";
class HomeBottomNavBar extends StatelessWidget {
  final Color primaryColor;
  const HomeBottomNavBar({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.home, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.edit_calendar, color: Colors.white70), onPressed: () {}),
          IconButton(icon: const Icon(Icons.psychology, color: Colors.white70), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person, color: Colors.white70), onPressed: () {}),
        ],
      ),
    );
  }
}