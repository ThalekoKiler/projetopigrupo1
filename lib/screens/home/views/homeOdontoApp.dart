import "package:flutter/material.dart";

import 'package:pi_projeto/screens/home/widgets/sectionTitle.dart';
import 'package:pi_projeto/screens/home/widgets/homeHeader.dart';
import 'package:pi_projeto/screens/home/widgets/aiBanner.dart';
import 'package:pi_projeto/screens/home/widgets/quickAccessGrid.dart';
import 'package:pi_projeto/screens/home/widgets/appointmentCard.dart';
import 'package:pi_projeto/screens/home/widgets/newsCarousel.dart';
import 'package:pi_projeto/screens/home/widgets/homeBottomNavBar.dart';
class HomeOdontoApp extends StatelessWidget {
  const HomeOdontoApp({super.key});

  static const Color primaryColor = Color(0xFFB86B77);
  static const Color bgColor = Color(0xFFF4F6F9);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(primaryColor: primaryColor),
                SizedBox(height: 24),
                SectionTitle(title: 'Próximo Agendamento'),
                SizedBox(height: 12),
                AppointmentCard(),
                SizedBox(height: 24),
                SectionTitle(title: 'Destaque IA'),
                SizedBox(height: 12),
                AIBanner(),
                SizedBox(height: 24),
                SectionTitle(title: 'Acesso Rápido'),
                SizedBox(height: 12),
                QuickAccessGrid(primaryColor: primaryColor),
                SizedBox(height: 24),
                SectionTitle(title: 'Notícias e Dicas'),
                SizedBox(height: 12),
                NewsCarousel(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(primaryColor: primaryColor),
    );
  }
}