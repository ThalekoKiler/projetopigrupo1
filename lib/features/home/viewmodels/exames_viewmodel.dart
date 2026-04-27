import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/models/exame_model.dart';

class ExamesViewModel extends ChangeNotifier {
  final firebaseFirestore = FirebaseFirestore.instance;

  List<ExameModel> exames = []; // Lista tipada e segura
  bool isLoading = true;

  // Controllers para o formulário da sua irmã (Admin)
  final tituloController = TextEditingController();
  final dataController = TextEditingController();
  final urlController = TextEditingController();
  final tipoController = TextEditingController();

  // Busca os exames de um UID específico
  Future<void> carregarExames(String pacienteUid) async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await firebaseFirestore
          .collection('pacientes')
          .doc(pacienteUid)
          .collection('exames')
          .orderBy('data', descending: true)
          .get();

      // Mapeia os documentos para objetos do tipo ExameModel
      exames = snapshot.docs.map((doc) {
        return ExameModel.fromMap(doc.data());
      }).toList();
    } catch (e) {
      debugPrint("Erro ao buscar exames: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Função para a Dra. Thais cadastrar o exame
  Future<void> salvarNovoExame(String pacienteUid) async {
    if (tituloController.text.isEmpty || urlController.text.isEmpty) return;

    try {
      final novoExame = {
        'titulo': tituloController.text,
        'data': dataController.text,
        'urlDocumento': urlController.text,
        'tipo': tipoController.text,
      };

      await firebaseFirestore
          .collection('pacientes')
          .doc(pacienteUid)
          .collection('exames')
          .add(novoExame);

      // Limpa os campos
      tituloController.clear();
      dataController.clear();
      urlController.clear();
      tipoController.clear();

      // Recarrega a lista para mostrar o novo exame
      await carregarExames(pacienteUid);
    } catch (e) {
      debugPrint("Erro ao salvar: $e");
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    dataController.dispose();
    urlController.dispose();
    tipoController.dispose();
    super.dispose();
  }
}
