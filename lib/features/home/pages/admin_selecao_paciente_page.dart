import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pi_projeto/app/routes/app_routes.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:pi_projeto/features/home/viewmodels/admin_selecao_paciente_viewmodel.dart';

class AdminSelecaoPacientePage extends StatelessWidget {
  const AdminSelecaoPacientePage({super.key});

  @override
  Widget build(BuildContext context) {
    late final viewModel = AdminSelecaoPacienteViewmodel();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecionar Paciente"),
        backgroundColor: AppColors.CorPrincipal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: viewModel.pacientesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const Center(child: Text("Erro ao carregar"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var pacientes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              var dados = pacientes[index].data() as Map<String, dynamic>;
              String nome = dados['nome'] ?? 'Sem nome';
              String? foto = dados['photoUrl'];
              String uid = pacientes[index].id;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.CorPrincipal,
                  backgroundImage: foto != null && foto.isNotEmpty
                      ? NetworkImage(foto)
                      : null,

                  child: foto == null || foto.isEmpty
                      ? const Icon(Icons.person, color: AppColors.CorPrincipal)
                      : null,
                ),
                title: Text(
                  nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Clique para agendar um horário"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.agenda,
                    arguments: {
                      'uid': uid,
                      'nome': nome,
                      'foto': foto,
                      'isAgendamentoAdmin': true,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
