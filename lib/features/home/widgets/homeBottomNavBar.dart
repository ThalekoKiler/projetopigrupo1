import "package:flutter/material.dart";
import "../../../app/routes/app_routes.dart";

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
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_calendar, color: Colors.white70),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.agenda);
            },
          ),
          IconButton(
            icon: const Icon(Icons.psychology, color: Colors.white70),
            onPressed: () {
              // Futuramente: Navigator.pushNamed(context, AppRoutes.ia_dicas);
              print("Botão IA clicado");
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white70),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.editProfile);
            },
          ),
        ],
      ),
    );
  }
}
