import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pi_projeto/app/routes/app_routes.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:pi_projeto/core/espaco.dart';
import 'package:pi_projeto/features/home/pages/admin_selecao_paciente_page.dart';
import 'package:pi_projeto/features/home/viewmodels/home_admin_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  late final HomeAdminViewModel viewModel;
  int _abaAtual = 0;

  String get dataHoje =>
      DateFormat("EEEE, d MMMM", "pt_BR").format(DateTime.now());

  @override
  void initState() {
    super.initState();
    viewModel = HomeAdminViewModel();
    viewModel.carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final List<Widget> telas = [_buildCorpoAgenda(), _buildCorpoPerfil()];

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.CorPrincipal,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminSelecaoPacientePage(),
                ),
              );
            },
          ),
          backgroundColor: const Color(0xFFF4F6F9),
          appBar: AppBar(
            title: Text(
              _abaAtual == 0 ? 'Painel da Dentista' : 'Configurações',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppColors.CorPrincipal,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () => _confirmarSair(),
              ),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : telas[_abaAtual],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _abaAtual,
            onTap: (index) => setState(() => _abaAtual = index),
            selectedItemColor: AppColors.CorPrincipal,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Agenda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },
    );
  }

  // --- ABA AGENDA ---
  Widget _buildCorpoAgenda() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      viewModel.fotoUrl != null && viewModel.fotoUrl!.isNotEmpty
                      ? NetworkImage(viewModel.fotoUrl!)
                      : null,
                  child: viewModel.fotoUrl == null || viewModel.fotoUrl!.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey, size: 30)
                      : null,
                ),
                Espaco.w12,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, Dra. ${viewModel.nomeAdmin.split(' ')[0]}!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dataHoje,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Espaco.h24,
            const Text(
              'Próximos Pacientes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Espaco.h12,
            _buildListaAgendamentos(),
          ],
        ),
      ),
    );
  }

  // --- ABA PERFIL ---
  Widget _buildCorpoPerfil() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.CorPrincipal,
            backgroundImage:
                viewModel.fotoUrl != null && viewModel.fotoUrl!.isNotEmpty
                ? NetworkImage(viewModel.fotoUrl!)
                : null,
            child: viewModel.fotoUrl == null || viewModel.fotoUrl!.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.CorPrincipal,
                  )
                : null,
          ),
          Espaco.h16,
          Text(
            viewModel.nomeAdmin,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Cirurgiã Dentista',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          Espaco.h32,
          ElevatedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.editProfile),
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              "Editar meu Perfil",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.CorPrincipal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaAgendamentos() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('agendamentos')
          .orderBy('criadoEm', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Erro ao carregar.');
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty)
          return const Center(child: Text('Nenhum agendamento para hoje.'));

        return Column(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return _buildCardAgendamento(
              docId: doc.id,
              hora: data['hora'] ?? '--:--',
              servico: data['servico'] ?? 'Consulta',
              nome: data['nomePaciente'] ?? 'Paciente',

              fotoPaciente: data['pacientePhotoUrl'],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCardAgendamento({
    required String docId,
    required String hora,
    required String servico,
    required String nome,
    String? fotoPaciente,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // FOTO DO PACIENTE (MAURO)
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFFF0F0F0),
            backgroundImage: fotoPaciente != null && fotoPaciente.isNotEmpty
                ? NetworkImage(fotoPaciente)
                : null,
            child: fotoPaciente == null || fotoPaciente.isEmpty
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          Espaco.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "$servico • $hora",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          // BOTÃO DE CANCELAR (X)
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
            onPressed: () => _confirmarExclusao(docId),
          ),
        ],
      ),
    );
  }

  // Função para deletar o agendamento
  Future<void> _confirmarExclusao(String docId) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancelar Consulta"),
        content: const Text("Tem certeza que deseja remover este agendamento?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Não"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Sim, cancelar",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await FirebaseFirestore.instance
          .collection('agendamentos')
          .doc(docId)
          .delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Agendamento cancelado com sucesso!")),
        );
      }
    }
  }

  Future<void> _confirmarSair() async {
    await viewModel.deslogar();
    if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}
