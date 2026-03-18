import "package:flutter/material.dart";

class QuickAccessGrid extends StatelessWidget {
  final Color primaryColor;
  const QuickAccessGrid({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuickAccessItem(icon: Icons.edit_calendar, label: 'nova\nconsulta', color: primaryColor),
        QuickAccessItem(icon: Icons.folder_open, label: 'Meus\nExames', color: primaryColor),
        QuickAccessItem(icon: Icons.badge_outlined, label: 'Carteirinha', color: primaryColor),
        QuickAccessItem(icon: Icons.phone_in_talk, label: 'Emergência', color: primaryColor),
      ],
    );
  }
}

class QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const QuickAccessItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, height: 1.1),
          ),
        ],
      ),
    );
  }
}