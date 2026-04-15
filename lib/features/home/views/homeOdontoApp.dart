import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:pi_projeto/features/home/viewmodels/home_viewmodel.dart';
import 'package:pi_projeto/features/home/widgets/sectionTitle.dart';
import 'package:pi_projeto/features/home/widgets/homeHeader.dart';
import 'package:pi_projeto/features/home/widgets/aiBanner.dart';
import 'package:pi_projeto/features/home/widgets/quickAccessGrid.dart';
import 'package:pi_projeto/features/home/widgets/appointmentCard.dart';
import 'package:pi_projeto/features/home/widgets/newsCarousel.dart';
import 'package:pi_projeto/features/home/widgets/homeBottomNavBar.dart';
import 'package:pi_projeto/app/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const Color primaryColor = Color(0xFFB86B77);
  static const Color bgColor = Color(0xFFF4F6F9);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel();
    viewModel.carregarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (builderContext, _) {
        return Scaffold(
          backgroundColor: HomePage.bgColor,

          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: HomePage.primaryColor),
                  accountName: Text(viewModel.nomeUsuario),
                  accountEmail: Text(
                    FirebaseAuth.instance.currentUser?.email ?? "",
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: HomePage.primaryColor,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Editar Perfil'),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.editProfile);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  title: const Text(
                    'Sair',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    await viewModel.deslogar();

                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.login,
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(
                      primaryColor: HomePage.primaryColor,
                      userName: viewModel.nomeUsuario,
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Próximo Agendamento'),
                    const SizedBox(height: 12),
                    const AppointmentCard(),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Destaque IA'),
                    const SizedBox(height: 12),
                    const AIBanner(),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Acesso Rápido'),
                    const SizedBox(height: 12),
                    QuickAccessGrid(primaryColor: HomePage.primaryColor),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Notícias e Dicas'),
                    const SizedBox(height: 12),
                    const NewsCarousel(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: HomeBottomNavBar(
            primaryColor: HomePage.primaryColor,
          ),
        );
      },
    );
  }
}
