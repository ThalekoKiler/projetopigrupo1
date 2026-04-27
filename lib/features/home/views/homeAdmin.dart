import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pi_projeto/app/routes/app_routes.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:pi_projeto/core/espaco.dart';
import 'package:pi_projeto/features/home/pages/carteirinha_page.dart';
import 'package:pi_projeto/features/home/viewmodels/home_admin_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/exames_page.dart';

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

  // Abre as opções de gestão para o paciente clicado
  void _abrirOpcoesPaciente(String uid, String nome) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              nome,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Text(
              "O que deseja gerenciar?",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.badge, color: Colors.blue),
              ),
              title: const Text("Ver Carteirinha"),
              onTap: () {
                Navigator.pop(context);
                // Passa o UID para a tela de carteirinha
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CarteirinhaPage(pacienteUidExterno: uid),
                  ),
                );
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFF3E5F5),
                child: Icon(Icons.folder_shared, color: Colors.purple),
              ),
              title: const Text("Gerenciar Exames"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamesPage(
                      pacienteUid: uid,
                      roleUsuarioLogado: 'admin',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final List<Widget> telas = [_buildCorpoAgenda(), _buildCorpoPerfil()];

        return Scaffold(
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
          // Botão de Adicionar Agendamento
          floatingActionButton: _abaAtual == 0
              ? FloatingActionButton(
                  backgroundColor: AppColors.CorPrincipal,
                  child: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    // Abre a página de seleção de paciente para novo agendamento
                    Navigator.pushNamed(
                      context,
                      AppRoutes.adminSelecaoPaciente,
                    );
                  },
                )
              : null,
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

  // --- ABA PERFIL (RESTAURADA) ---
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
                ? const Icon(Icons.person, size: 60, color: Colors.white)
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
    DateTime agora = DateTime.now();
    DateTime inicioHoje = DateTime(agora.year, agora.month, agora.day, 0, 0, 0);
    DateTime fimHoje = DateTime(agora.year, agora.month, agora.day, 23, 59, 59);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('agendamentos')
          .where('data', isGreaterThanOrEqualTo: inicioHoje)
          .where('data', isLessThanOrEqualTo: fimHoje)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Erro ao carregar.');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Nenhum agendamento para hoje.'),
            ),
          );
        }

        return Column(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return _buildCardAgendamento(
              docId: doc.id,
              pacienteUid: data['userId'] ?? '',
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
    required String pacienteUid,
    required String hora,
    required String servico,
    required String nome,
    String? fotoPaciente,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: () => _abrirOpcoesPaciente(pacienteUid, nome),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFFF0F0F0),
          backgroundImage: fotoPaciente != null && fotoPaciente.isNotEmpty
              ? NetworkImage(fotoPaciente)
              : null,
          child: fotoPaciente == null || fotoPaciente.isEmpty
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        title: Text(
          nome,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          "$servico • $hora",
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
          onPressed: () => _confirmarExclusao(docId),
        ),
      ),
    );
  }

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
    }
  }

  Future<void> _confirmarSair() async {
    await viewModel.deslogar();
    if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}
