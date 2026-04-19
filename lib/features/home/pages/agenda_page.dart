import 'package:flutter/material.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:pi_projeto/core/espaco.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../viewmodels/agenda_viewmodel.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late final viewModel = AgendaViewModel();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      if (args['isRemarcacao'] == true) {
        viewModel.configurarRemarcacao(args);
      } else {
        viewModel.configurarAgendamentoAdmin(args);
      }
    }

    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              viewModel.pacienteNomeSelecionadoPelaAdmin != null
                  ? 'Agendar para: ${viewModel.pacienteNomeSelecionadoPelaAdmin}'
                  : 'Novo Agendamento',
            ),
            backgroundColor: AppColors.CorPrincipal,
            foregroundColor: Colors.white,
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selecione o Serviço:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: viewModel.servicoSelecionado,
                        hint: const Text("Escolha o procedimento"),
                        items: viewModel.servicos
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                        onChanged: viewModel.selecionarServico,
                      ),
                      Espaco.h24,
                      const Text(
                        "Data da Consulta:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListTile(
                        title: Text(
                          viewModel.dataSelecionada == null
                              ? "Selecione uma data"
                              : "${viewModel.dataSelecionada!.day}/${viewModel.dataSelecionada!.month}/${viewModel.dataSelecionada!.year}",
                        ),
                        trailing: const Icon(Icons.calendar_month),
                        onTap: () => _abrirCalendario(context),
                      ),
                      if (viewModel.dataSelecionada != null) ...[
                        Espaco.h24,
                        const Text(
                          "Horários Disponíveis:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        _buildGridHorarios(),
                      ],
                      Espaco.h32,
                      _buildBotaoConfirmar(),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // --- COMPONENTES DA PÁGINA ---

  Widget _buildGridHorarios() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('agendamentos')
          .where(
            'data',
            isEqualTo: Timestamp.fromDate(
              DateTime(
                viewModel.dataSelecionada!.year,
                viewModel.dataSelecionada!.month,
                viewModel.dataSelecionada!.day,
              ),
            ),
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();

        List<String> ocupados = snapshot.data!.docs
            .map((doc) => doc['hora'] as String)
            .toList();

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: viewModel.gerarHorarios().map((hora) {
            bool isOcupado = ocupados.contains(hora);
            bool isSelecionado = viewModel.horaSelecionada == hora;
            return ChoiceChip(
              label: Text(hora),
              selected: isSelecionado,
              selectedColor: AppColors.CorPrincipal,
              labelStyle: TextStyle(
                color: isSelecionado
                    ? Colors.white
                    : (isOcupado ? Colors.grey : Colors.black),
              ),
              onSelected: isOcupado
                  ? null
                  : (selected) => viewModel.selecionarHora(hora),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildBotaoConfirmar() {
    bool podeAgendar =
        viewModel.servicoSelecionado != null &&
        viewModel.dataSelecionada != null &&
        viewModel.horaSelecionada != null;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.CorPrincipal,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: podeAgendar ? () => _processarAgendamento() : null,
        child: const Text(
          "Confirmar Agendamento",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _abrirCalendario(BuildContext context) async {
    final DateTime? escolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );
    if (escolhida != null) viewModel.selecionarData(escolhida);
  }

  void _processarAgendamento() async {
    bool sucesso = await viewModel.salvarAgendamento();
    if (sucesso && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Agendado com sucesso!')));
      Navigator.pop(context);
    }
  }
}
