import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AgendaViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? servicoSelecionado;
  DateTime? dataSelecionada;
  String? horaSelecionada;
  bool isLoading = false;

  // Variáveis para Remarcação/Edição da consulta
  String? agendamentoIdParaEditar;

  // Variáveis para agendamento via Admin
  String? pacienteUidSelecionadoPelaAdmin;
  String? pacienteNomeSelecionadoPelaAdmin;
  String? pacienteFotoSelecionadoPelaAdmin;

  final List<String> servicos = [
    'Avaliação',
    'Check-up Geral',
    'Limpeza',
    'Extração',
    'Canal',
    'Cirurgia',
  ];

  List<String> gerarHorarios() {
    List<String> horarios = [];
    for (int i = 8; i < 20; i++) {
      if (i == 12) continue;
      horarios.add("${i.toString().padLeft(2, '0')}:00");
      horarios.add("${i.toString().padLeft(2, '0')}:30");
    }
    return horarios;
  }

  void selecionarServico(String? val) {
    servicoSelecionado = val;
    notifyListeners();
  }

  void selecionarHora(String hora) {
    horaSelecionada = hora;
    notifyListeners();
  }

  void selecionarData(DateTime escolhida) {
    dataSelecionada = escolhida;
    horaSelecionada = null;
    notifyListeners();
  }

  void configurarAgendamentoAdmin(Map<String, dynamic> dados) {
    pacienteUidSelecionadoPelaAdmin = dados['uid'];
    pacienteNomeSelecionadoPelaAdmin = dados['nome'];
    pacienteFotoSelecionadoPelaAdmin = dados['foto'];
    notifyListeners();
  }

  void configurarRemarcacao(Map<String, dynamic> dados) {
    agendamentoIdParaEditar = dados['docId'];
    servicoSelecionado = dados['servico'];
    notifyListeners();
  }

  Future<bool> salvarAgendamento() async {
    try {
      isLoading = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Se for uma Remarcação
      if (agendamentoIdParaEditar != null) {
        await _firestore
            .collection('agendamentos')
            .doc(agendamentoIdParaEditar)
            .update({
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
            });
        return true;
      }

      /* --- LÓGICA DE DECISÃO ---
      Se a admin selecionou alguém, usamos esses dados.
      Caso contrário, buscamos os dados do usuário logado.*/

      String finalUid;
      String finalNome;
      String? finalFoto;

      if (pacienteUidSelecionadoPelaAdmin != null) {
        // Modo Admin: usa o que veio da lista de pacientes
        finalUid = pacienteUidSelecionadoPelaAdmin!;
        finalNome = pacienteNomeSelecionadoPelaAdmin!;
        finalFoto = pacienteFotoSelecionadoPelaAdmin;
      } else {
        // Modo Paciente: busca os dados de quem está logado
        final userDoc = await _firestore
            .collection('usuarios')
            .doc(currentUser.uid)
            .get();
        finalUid = currentUser.uid;
        finalNome = userDoc.data()?['nome'] ?? 'Paciente';
        finalFoto = userDoc.data()?['photoUrl'];
      }

      await _firestore.collection('agendamentos').add({
        'userId': finalUid,
        'nomePaciente': finalNome,
        'pacientePhotoUrl': finalFoto,
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

      return true;
    } catch (e) {
      debugPrint("Erro ao agendar: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
