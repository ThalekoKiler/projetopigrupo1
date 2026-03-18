import 'package:flutter/material.dart';
import 'package:pi_projeto/theme/app_colors.dart';
import 'package:pi_projeto/screens/loginPage/widgets/global/espaco.dart';
import 'package:pi_projeto/screens/loginPage/widgets/login/subtitulos_cadastro.dart';
import 'package:pi_projeto/screens/loginPage/widgets/login/botao.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.CorPrincipal,
      appBar: AppBar(backgroundColor: AppColors.CorPrincipal),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dr. Thais Tardelli',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          Espaco.h16,

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Não tem uma conta? ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Text(
                      'cadastrar-se',
                      style: TextStyle(
                        color: const Color(0xFFB76E79),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                Espaco.h16,

                SubtitulosCadastro(texto: 'Login'),

                const SizedBox(height: 1),

                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Digite seu email aqui',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Espaco.h16,

                SubtitulosCadastro(texto: 'senha'),

                const SizedBox(height: 1),

                TextField(
                  decoration: InputDecoration(
                    hintText: 'Digite sua senha aqui',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                Espaco.h16,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SubtitulosCadastro(texto: 'Manter conectado'),

                    Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB76E79),
                      ),
                    ),
                  ],
                ),

                Espaco.h24,

                Botao(
                  backgroundColor: AppColors.CorPrincipal,
                  texto: 'Entrar',
                  corDaFonte: AppColors.CorBranco,
                  onPressed: () {},
                ),

                Espaco.h24,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'or',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                Espaco.h24,

                Botao(
                  backgroundColor: AppColors.CorBranco,
                  texto: 'Continuar com Google',
                  corDaFonte: AppColors.TextoPrincipal,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
