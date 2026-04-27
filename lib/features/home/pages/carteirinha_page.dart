import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import '../viewmodels/carteirinha_viewmodel.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CarteirinhaPage extends StatefulWidget {
  final String? pacienteUidExterno;

  const CarteirinhaPage({super.key, this.pacienteUidExterno});

  @override
  State<CarteirinhaPage> createState() => _CarteirinhaPageState();
}

class _CarteirinhaPageState extends State<CarteirinhaPage> {
  final viewModel = CarteirinhaViewModel();

  final maskCpf = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final maskTelefone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    viewModel.carregarDadosPaciente(uidExterno: widget.pacienteUidExterno);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Carteirinha"),
        backgroundColor: AppColors.CorPrincipal,
        actions: [
          if (viewModel.paciente != null && !viewModel.isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => viewModel.entrarModoEdicao()),
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.isEditing || viewModel.paciente == null) {
            return _buildFormulario();
          }

          return _buildExibicaoCartao();
        },
      ),
    );
  }

  Widget _buildFormulario() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Preencha seus dados para gerar a carteirinha",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildTextField(
            viewModel.nomeController,
            "Nome Completo",
            Icons.person,
            null,
          ),
          _buildTextField(viewModel.cpfController, "CPF", Icons.badge, [
            maskCpf,
          ]),
          _buildTextField(viewModel.generoController, "Gênero", Icons.wc, null),
          _buildTextField(
            viewModel.telefoneController,
            "Telefone",
            Icons.phone,
            [maskTelefone],
          ),
          _buildTextField(
            viewModel.enderecoController,
            "Endereço",
            Icons.location_on,
            null,
          ),
          _buildTextField(
            viewModel.fotoUrlController,
            "URL da Foto de Perfil",
            Icons.image,
            null,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => viewModel.salvarDados(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.CorPrincipal,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              "SALVAR E GERAR",
              style: TextStyle(color: Colors.white),
            ),
          ),
          if (viewModel.paciente != null)
            TextButton(
              onPressed: () => viewModel.cancelarEdicao(),
              child: const Text("Cancelar"),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    List<TextInputFormatter>? formatters,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        inputFormatters: formatters, // Adicione esta linha
        keyboardType: label == "Telefone" || label == "CPF"
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.CorPrincipal),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildExibicaoCartao() {
    final p = viewModel.paciente!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF6A1B9A), Color(0xFF4527A0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.health_and_safety,
                    size: 200,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(p.fotoUrl),
                            backgroundColor: Colors.white24,
                          ),
                          const Text(
                            "SAÚDE & VIDA",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        p.nomeCompleto.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "CPF: ${p.cpf}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "STATUS: ${p.status}",
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildInfoTile(Icons.wc, "Gênero", p.genero),
          _buildInfoTile(Icons.location_on, "Endereço", p.endereco),
          _buildInfoTile(Icons.phone, "Contato", p.telefone),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.CorPrincipal),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
