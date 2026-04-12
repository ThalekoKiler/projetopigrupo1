import 'package:flutter/material.dart';
import 'package:pi_projeto/app/routes/app_routes.dart';
import 'package:pi_projeto/core/espaco.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:pi_projeto/features/auth/widgets/botao.dart';
import 'package:pi_projeto/features/auth/widgets/custom_input_label.dart';
import 'package:pi_projeto/features/auth/widgets/subtittlebutton.dart';
import 'package:pi_projeto/features/auth/widgets/subtitulos_cadastro.dart';
import 'package:pi_projeto/features/auth/widgets/inputpassword.dart';
import 'package:pi_projeto/features/auth/viewmodels/register_viewmodel.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pi_projeto/features/auth/widgets/tittlecontainer.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterViewModel viewModel;

  // Máscara do telefone (11) 99999-9999
  final mascaraTelefone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    viewModel = RegisterViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  // Função para abrir o Calendário
  Future<void> _selecionarData() async {
    FocusScope.of(context).unfocus(); // Fecha o teclado

    DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.CorPrincipal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dataEscolhida != null) {
      String dia = dataEscolhida.day.toString().padLeft(2, '0');
      String mes = dataEscolhida.month.toString().padLeft(2, '0');
      String ano = dataEscolhida.year.toString();
      viewModel.dataController.text = "$dia/$mes/$ano";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.CorPrincipal,
          appBar: AppBar(backgroundColor: AppColors.CorPrincipal, elevation: 0),
          // CORREÇÃO: Trocamos ListView por SingleChildScrollView
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            // CORREÇÃO: "children: []" mudou para "child:" (envolve o Container)
            child: Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                    ),
                    const Tittlecontainer(text: 'Registre-se'),
                    Row(
                      children: [
                        const Text(
                          'Já tem Conta? ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.TextoSecundario,
                          ),
                        ),
                        Subtittlebutton(
                          text: 'Login',
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                        ),
                      ],
                    ),
                    Espaco.h04,

                    // --- NOME ---
                    const SubtitulosCadastro(texto: 'Nome Completo'),
                    Espaco.h04,
                    CustomInputLabel(
                      text: 'Digite seu nome completo...',
                      controller: viewModel.nomeController,
                      validator: viewModel.nomeValidator,
                    ),
                    Espaco.h12,

                    // --- EMAIL ---
                    const SubtitulosCadastro(texto: 'Email'),
                    Espaco.h04,
                    CustomInputLabel(
                      text: 'Digite seu Email...',
                      controller: viewModel.emailController,
                      validator: viewModel.emailValidator,
                    ),
                    Espaco.h12,

                    const SubtitulosCadastro(texto: 'Data de Nascimento'),
                    Espaco.h04,
                    GestureDetector(
                      onTap: _selecionarData,
                      child: AbsorbPointer(
                        child: CustomInputLabel(
                          text: 'DD/MM/AAAA',
                          controller: viewModel.dataController,
                          validator: viewModel.dataValidator,
                          suffixIcon: const Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Espaco.h12,

                    const SubtitulosCadastro(texto: 'Número de Telefone'),
                    Espaco.h04,
                    TextFormField(
                      controller: viewModel.telefoneController,
                      validator: viewModel.telefoneValidator,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [mascaraTelefone],
                      cursorColor: const Color(0xFFB76E79),
                      decoration: InputDecoration(
                        hintText: '(11) 99999-9999',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                viewModel.dddPais, // Puxa o '+55'
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 1,
                                height: 24,
                                color: Colors.grey.shade300,
                              ), // Linha divisória
                            ],
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFB76E79),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    Espaco.h12,

                    // --- SENHA ---
                    const SubtitulosCadastro(texto: 'Definir Senha'),
                    Espaco.h04,
                    Inputpassword(
                      text: 'Digite sua senha...',
                      controller: viewModel.senhaController,
                      validator: viewModel.senhaValidator,
                      obscureText: viewModel.obscurePassword,
                      onPressedIcon: viewModel.togglePasswordVisibility,
                    ),

                    Espaco.h24,

                    // --- BOTÃO ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Botao(
                        backgroundColor: AppColors.CorPrincipal,
                        texto: viewModel.isLoading
                            ? 'Carregando...'
                            : 'Registrar',
                        corDaFonte: AppColors.CorBranco,
                        // Se estiver carregando, passa null (desabilita). Se não, passa a função.
                        onPressed: viewModel.isLoading
                            ? null
                            : () {
                                viewModel.onRegisterPressed(context, () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.home,
                                  );
                                });
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
