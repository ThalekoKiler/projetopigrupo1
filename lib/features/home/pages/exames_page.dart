import 'package:flutter/material.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/exames_viewmodel.dart';

class ExamesPage extends StatefulWidget {
  final String pacienteUid;
  final String roleUsuarioLogado;

  const ExamesPage({
    super.key,
    required this.pacienteUid,
    required this.roleUsuarioLogado,
  });

  @override
  State<ExamesPage> createState() => _ExamesPageState();
}

class _ExamesPageState extends State<ExamesPage> {
  late final viewModel = ExamesViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.carregarExames(widget.pacienteUid);
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.roleUsuarioLogado == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exames e Documentos"),
        backgroundColor: AppColors.CorPrincipal,
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: AppColors.CorPrincipal,
              onPressed: () => _mostrarFormularioAdmin(context),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.exames.isEmpty) {
            return const Center(child: Text("Nenhum exame disponível."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.exames.length,
            itemBuilder: (context, index) {
              final exame = viewModel.exames[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf,
                    color: AppColors.CorPrincipal,
                  ),
                  title: Text(
                    exame.titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${exame.tipo} - ${exame.data}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    final url = Uri.parse(exame.urlDocumento);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _mostrarFormularioAdmin(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Cadastrar Exame para Paciente",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: viewModel.tituloController,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: viewModel.dataController,
              decoration: const InputDecoration(labelText: "Data"),
            ),
            TextField(
              controller: viewModel.tipoController,
              decoration: const InputDecoration(labelText: "Tipo (Ex: Raio-X)"),
            ),
            TextField(
              controller: viewModel.urlController,
              decoration: const InputDecoration(labelText: "Link do Documento"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () {
                viewModel.salvarNovoExame(widget.pacienteUid);
                Navigator.pop(context);
              },
              child: const Text("Salvar Exame"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
