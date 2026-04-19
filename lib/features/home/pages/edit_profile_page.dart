import 'package:flutter/material.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:pi_projeto/core/espaco.dart';
import 'package:pi_projeto/features/home/viewmodels/edit_profile_viewmodel.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final EditProfileViewModel viewModel;

  final maskCpf = MaskTextInputFormatter(
    mask: "###.###.###-##",
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    viewModel = EditProfileViewModel();
    viewModel.carregarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit Profile',
              style: TextStyle(color: AppColors.CorPrincipal),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.CorPrincipal),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Avatar com botão de editar
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Color(0xFFE0E0E0),
                              backgroundImage:
                                  viewModel.photoUrlController.text.isNotEmpty
                                  ? NetworkImage(
                                      viewModel.photoUrlController.text,
                                    )
                                  : null,
                              child: viewModel.photoUrlController.text.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 70,
                                      color: Color(0xFF9E9E9E),
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: AppColors.CorPrincipal,
                                radius: 18,
                                child: const Icon(
                                  Icons.link,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Espaco.h32,

                      _buildField(
                        "FULL NAME",
                        Icons.person_outline,
                        viewModel.nomeController,
                      ),
                      Espaco.h16,

                      _buildField(
                        "PROFILE IMAGE URL",
                        Icons.image_outlined,
                        viewModel.photoUrlController,
                        hint: "Paste the image link here",
                      ),
                      Espaco.h16,

                      _buildField(
                        "CPF",
                        Icons.badge_outlined,
                        viewModel.cpfController,
                        formatter: maskCpf,
                      ),
                      Espaco.h16,

                      _buildField(
                        "PHONE NUMBER",
                        Icons.phone_outlined,
                        viewModel.telefoneController,
                      ),

                      Espaco.h40,

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.CorPrincipal,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => viewModel.salvarAlteracoes(context),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Save Changes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildField(
    String label,
    IconData icon,
    TextEditingController controller, {
    MaskTextInputFormatter? formatter,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Espaco.h08,
        TextFormField(
          controller: controller,
          inputFormatters: formatter != null ? [formatter] : [],
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.CorPrincipal),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            if (label == "PROFILE IMAGE URL") {
              setState(() {});
            }
          },
        ),
      ],
    );
  }
}
