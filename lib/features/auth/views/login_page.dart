import 'package:flutter/material.dart';
import 'package:pi_projeto/app/routes/app_routes.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:pi_projeto/core/espaco.dart';
import 'package:pi_projeto/features/auth/viewmodels/login_viewmodel.dart';
import 'package:pi_projeto/features/auth/widgets/custom_input_label.dart';
import 'package:pi_projeto/features/auth/widgets/inputpassword.dart';
import 'package:pi_projeto/features/auth/widgets/subtittlebutton.dart';
import 'package:pi_projeto/features/auth/widgets/subtitulos_cadastro.dart';
import 'package:pi_projeto/features/auth/widgets/botao.dart';
import 'package:pi_projeto/features/auth/widgets/tittlecontainer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LoginViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.CorPrincipal,
          appBar: AppBar(
            backgroundColor: AppColors.CorPrincipal,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Header do Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icon.png',
                      width: 27,
                      height: 27,
                    ),
                    Espaco.w04,
                    const Text(
                      'Dra. Thais Tardelli',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Espaco.h24,

                // Card de Login
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: viewModel.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Tittlecontainer(text: 'Login'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Não tem uma conta? ',
                              style: TextStyle(fontSize: 12),
                            ),
                            Subtittlebutton(
                              text: 'Cadastre-se',
                              onPressed: () => Navigator.pushNamed(
                                context,
                                AppRoutes.register,
                              ),
                            ),
                          ],
                        ),
                        Espaco.h16,

                        const SubtitulosCadastro(texto: 'E-mail'),
                        CustomInputLabel(
                          text: 'Digite seu email aqui...',
                          controller: viewModel.emailController,
                          validator: viewModel.emailValidator,
                        ),

                        Espaco.h16,

                        const SubtitulosCadastro(texto: 'Senha'),
                        Inputpassword(
                          text: 'Digite sua senha aqui...',
                          controller: viewModel.passwordController,
                          validator: viewModel.passwordValidator,
                          obscureText: viewModel.obscurePassword,
                          onPressedIcon: viewModel.togglePasswordVisibility,
                        ),

                        Espaco.h08,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SubtitulosCadastro(texto: 'Manter conectado'),
                            Subtittlebutton(
                              text: 'Esqueceu a senha?',
                              onPressed: () {},
                            ),
                          ],
                        ),

                        Espaco.h24,

                        // --- BOTÃO DE ENTRAR (Ajustado para receber a rota) ---
                        Botao(
                          backgroundColor: AppColors.CorPrincipal,
                          texto: viewModel.isLoading ? 'Aguarde...' : 'Entrar',
                          corDaFonte: Colors.white,
                          onPressed: viewModel.isLoading
                              ? null
                              : () {
                                  viewModel.onLoginPressed(
                                    onSuccess: (rota) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        rota, // Entra na Home correta (Admin ou Paciente)
                                      );
                                    },
                                    onError: (erro) => _showErrorSnackBar(erro),
                                  );
                                },
                        ),

                        Espaco.h16,
                        const Center(
                          child: Text(
                            'ou',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Espaco.h16,

                        // --- BOTÃO GOOGLE (Ajustado para receber a rota) ---
                        Botao(
                          backgroundColor: Colors.white,
                          texto: 'Continuar com Google',
                          corDaFonte: Colors.black,
                          icone: Image.asset(
                            'assets/images/google.png',
                            height: 20,
                          ),
                          onPressed: viewModel.isLoading
                              ? null
                              : () {
                                  viewModel.onGoogleLoginPressed(
                                    onSuccess: (rota) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        rota, // Entra na Home correta via Google
                                      );
                                    },
                                    onError: (erro) => _showErrorSnackBar(erro),
                                  );
                                },
                        ),
                      ],
                    ),
                  ),
                ),
                Espaco.h24,
              ],
            ),
          ),
        );
      },
    );
  }
}
