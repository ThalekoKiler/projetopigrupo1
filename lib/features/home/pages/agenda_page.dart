import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  String? servicoSelecionado;
  DateTime? dataSelecionada;
  TimeOfDay? horaSelecionada;

  final List<String> servicos = [
    'Check-up Geral',
    'Limpeza',
    'Extração',
    'Canal',
  ];

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? escolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );
    if (escolhida != null) setState(() => dataSelecionada = escolhida);
  }

  Future<void> _selecionarHora(BuildContext context) async {
    final TimeOfDay? escolhida = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (escolhida != null) setState(() => horaSelecionada = escolhida);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Agendamento'),
        backgroundColor: AppColors.CorPrincipal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
              items: servicos.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) => setState(() => servicoSelecionado = val),
            ),
            const SizedBox(height: 20),
            const Text(
              "Data da Consulta:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text(
                dataSelecionada == null
                    ? "Nenhuma data Selecionada"
                    : "${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}",
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () => _selecionarData(context),
            ),
            const SizedBox(height: 20),
            const Text(
              "Horário da Consulta:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text(
                horaSelecionada == null
                    ? "Nenhum horário selecionado"
                    : horaSelecionada!.format(context),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selecionarHora(context),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.CorPrincipal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () async {
                  if (servicoSelecionado != null && dataSelecionada != null) {
                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      await FirebaseFirestore.instance
                          .collection('agendamentos')
                          .add({
                            'userId': user.uid,
                            'servico': servicoSelecionado,
                            'data': dataSelecionada,
                            'hora': horaSelecionada?.format(context),
                            'status': 'pendente',
                            'criadoEm': FieldValue.serverTimestamp(),
                          });

                      // Feedback para o usuário
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Agendamento realizado com sucesso!'),
                        ),
                      );

                      // Volta para a Home
                      Navigator.pop(context);
                    }
                  } else {
                    // Aviso se esquecer de selecionar algo
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Por favor, selecione o serviço e a data.',
                        ),
                      ),
                    );
                  }
                },
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
}
