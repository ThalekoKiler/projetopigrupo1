import 'package:flutter/material.dart';
import 'package:pi_projeto/app/routes/app_routes.dart';
import 'package:pi_projeto/features/auth/views/login_page.dart';
import 'package:pi_projeto/features/auth/views/register_page.dart';
import 'package:pi_projeto/features/chat/views/chat_page.dart';
import 'package:pi_projeto/features/home/pages/admin_selecao_paciente_page.dart';
import 'package:pi_projeto/features/home/pages/agenda_page.dart';
import 'package:pi_projeto/features/home/pages/carteirinha_page.dart';
import 'package:pi_projeto/features/home/pages/edit_profile_page.dart';
import 'package:pi_projeto/features/home/views/homeAdmin.dart';
import 'package:pi_projeto/features/home/views/homeOdontoApp.dart';
import 'package:pi_projeto/features/splash/views/splash_page.dart';
import '../../features/home/pages/exames_page.dart';

abstract class AppPages {
  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.login: (_) => const LoginPage(),
    AppRoutes.register: (_) => const RegisterPage(),
    AppRoutes.home: (_) => const HomePage(),
    AppRoutes.splash: (_) => const SplashPage(),
    AppRoutes.agenda: (_) => const AgendaPage(),
    AppRoutes.homeAdmin: (_) => const HomeAdminPage(),
    AppRoutes.editProfile: (_) => const EditProfilePage(),
    AppRoutes.chatIa: (_) => const ChatPage(),
    AppRoutes.carteirinha: (context) {
      final uid = ModalRoute.of(context)?.settings.arguments as String?;
      return CarteirinhaPage(pacienteUidExterno: uid);
    },
    AppRoutes.adminSelecaoPaciente: (_) => const AdminSelecaoPacientePage(),
    AppRoutes.exames: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return ExamesPage(
        pacienteUid: args['pacienteUid'],
        roleUsuarioLogado: args['roleUsuarioLogado'],
      );
    },
  };
}
