import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:pi_projeto/app/routes/app_routes.dart";
import 'package:url_launcher/url_launcher.dart';

class QuickAccessGrid extends StatelessWidget {
  final Color primaryColor;
  const QuickAccessGrid({super.key, required this.primaryColor});

  Future<void> _chamarEmergencia(BuildContext context) async {
    final Uri launchUri = Uri(scheme: 'tel', path: '+5519981376210');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Chamada de Emergência"),
        content: const Text("Deseja ligar para o consultório agora?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () async {
              Navigator.pop(context);
              if (await canLaunchUrl(launchUri)) {
                await launchUrl(launchUri);
              }
            },
            child: const Text("Ligar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuickAccessItem(
          icon: Icons.edit_calendar,
          label: 'nova\nconsulta',
          color: primaryColor,
          onTap: () => Navigator.pushNamed(context, AppRoutes.agenda),
        ),
        QuickAccessItem(
          icon: Icons.folder_open,
          label: 'Meus\nExames',
          color: primaryColor,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.exames,
              arguments: {
                'pacienteUid': FirebaseAuth.instance.currentUser!.uid,
                'roleUsuarioLogado': 'paciente',
              },
            );
          },
        ),
        QuickAccessItem(
          icon: Icons.badge_outlined,
          label: 'Carteirinha',
          color: primaryColor,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.carteirinha);
          },
        ),
        QuickAccessItem(
          icon: Icons.phone_in_talk,
          label: 'Emergência',
          color: primaryColor,
          onTap: () => _chamarEmergencia(context),
        ),
      ],
    );
  }
}

class QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickAccessItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 75,
        height: 90,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
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
                fontSize: 10,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
