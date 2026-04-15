import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:pi_projeto/core/espaco.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  String? servicoSelecionado;
  DateTime? dataSelecionada;
  String? horaSelecionada;

  final List<String> servicos = [
    'Avaliação',
    'Check-up Geral',
    'Limpeza',
    'Extração',
    'Canal',
    'Cirurgia',
  ];

  // --- GERADOR DE HORÁRIOS ---
  List<String> gerarHorarios() {
    List<String> horarios = [];
    for (int i = 8; i < 20; i++) {
      // Pula o horário de almoço (12:00 às 13:00)
      if (i == 12) continue;

      horarios.add("${i.toString().padLeft(2, '0')}:00");
      horarios.add("${i.toString().padLeft(2, '0')}:30");
    }
    return horarios;
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? escolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );
    if (escolhida != null) {
      setState(() {
        dataSelecionada = escolhida;
        horaSelecionada = null; // Reseta a hora se mudar a data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Agendamento'),
        backgroundColor: AppColors.CorPrincipal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
              value: servicoSelecionado,
              hint: const Text("Escolha o procedimento"),
              items: servicos
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) => setState(() => servicoSelecionado = val),
            ),
            Espaco.h24,

            const Text(
              "Data da Consulta:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text(
                dataSelecionada == null
                    ? "Selecione uma data primeiro"
                    : "${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}",
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () => _selecionarData(context),
            ),
            Espaco.h24,

            if (dataSelecionada != null) ...[
              const Text(
                "Horários Disponíveis:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Espaco.h12,

              // --- Horários ocupados (já agendados) não serão exibidos ---
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('agendamentos')
                    .where(
                      'data',
                      isEqualTo: Timestamp.fromDate(
                        DateTime(
                          dataSelecionada!.year,
                          dataSelecionada!.month,
                          dataSelecionada!.day,
                        ),
                      ),
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();

                  // Lista de horas que já foram agendadas nesse dia
                  List<String> horasOcupadas = snapshot.data!.docs
                      .map((doc) => doc['hora'] as String)
                      .toList();

                  List<String> todosHorarios = gerarHorarios();

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: todosHorarios.map((hora) {
                      bool isOcupado = horasOcupadas.contains(hora);
                      bool isSelecionado = horaSelecionada == hora;

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
                            : (selected) {
                                setState(
                                  () =>
                                      horaSelecionada = selected ? hora : null,
                                );
                              },
                        disabledColor: Colors.grey.shade200,
                      );
                    }).toList(),
                  );
                },
              ),
            ],

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.CorPrincipal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed:
                    (servicoSelecionado != null &&
                        dataSelecionada != null &&
                        horaSelecionada != null)
                    ? _salvarAgendamento
                    : null,
                child: const Text(
                  "Confirmar Agendamento",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _salvarAgendamento() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .get();
    String nomePaciente = userDoc.data()?['nome'] ?? 'Paciente sem nome';

    await FirebaseFirestore.instance.collection('agendamentos').add({
      'userId': user.uid,
      'nomePaciente': nomePaciente,
      'servico': servicoSelecionado,
      'data': Timestamp.fromDate(
        DateTime(
          dataSelecionada!.year,
          dataSelecionada!.month,
          dataSelecionada!.day,
        ),
      ),
      'hora': horaSelecionada,
      'status': 'pendente',
      'criadoEm': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Agendado com sucesso!')));
      Navigator.pop(context);
    }
  }
}
