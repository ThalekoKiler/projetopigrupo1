import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pi_projeto/app/routes/app_routes.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:pi_projeto/core/espaco.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  int _abaAtual = 0; // Controla qual aba está ativa (0 = Agenda, 1 = Perfil)
  String get dataHoje => DateFormat("EEEE, d MMMM").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    // Lista de telas que mudam conforme a aba selecionada
    final List<Widget> _telas = [_buildCorpoAgenda(), _buildCorpoPerfil()];

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
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted)
                Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: _telas[_abaAtual], // Aqui o Flutter decide qual aba mostrar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaAtual,
        onTap: (index) => setState(() => _abaAtual = index),
        selectedItemColor: AppColors.CorPrincipal,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  // --- WIDGET DA ABA AGENDA ---
  Widget _buildCorpoAgenda() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Olá, Dra. Thais!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              dataHoje,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
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

  // --- WIDGET DA ABA PERFIL ---
  Widget _buildCorpoPerfil() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.CorPrincipal,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          Espaco.h16,
          const Text(
            'Dra. Thais Tardelli',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text('Dentista - Admin', style: TextStyle(color: Colors.grey)),
          Espaco.h32,
          const Text(
            'Customização de Perfil em breve...',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  // --- LISTA COM DADOS DO FIREBASE ---
  Widget _buildListaAgendamentos() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('agendamentos')
          .orderBy('criadoEm', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Erro ao carregar.');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Nenhum agendamento.'),
            ),
          );
        }

        return Column(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return _buildCardAgendamento(
              docId: doc.id,
              hora: data['hora'] ?? '--:--',
              servico: data['servico'] ?? 'Consulta',
              nome: data['nomePaciente'] ?? 'Paciente sem nome',
            );
          }).toList(),
        );
      },
    );
  }

  // --- CARD DO PACIENTE (Borda no lugar da sombra) ---
  Widget _buildCardAgendamento({
    required String docId,
    required String hora,
    required String servico,
    required String nome,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.CorPrincipal,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              hora,
              style: const TextStyle(
                color: AppColors.CorPrincipal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Espaco.w16,
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
                  servico,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.redAccent),
            onPressed: () => _confirmarExclusao(docId),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarExclusao(String docId) async {
    bool? deletar = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Horário?'),
        content: const Text('Deseja realmente remover este agendamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (deletar == true) {
      await FirebaseFirestore.instance
          .collection('agendamentos')
          .doc(docId)
          .delete();
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Agendamento removido!')));
    }
  }
}
