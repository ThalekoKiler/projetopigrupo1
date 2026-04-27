import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/models/paciente_model.dart';

class CarteirinhaViewModel extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  PacienteModel? paciente;
  bool isLoading = true;
  bool isEditing = false;

  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final generoController = TextEditingController();
  final enderecoController = TextEditingController();
  final telefoneController = TextEditingController();
  final fotoUrlController = TextEditingController();

  CarteirinhaViewModel() {
    carregarDados();
  }

  Future<void> carregarDados() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('pacientes')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          paciente = PacienteModel.fromMap(doc.data()!);
        }
      }
    } catch (e) {
      debugPrint("Erro ao carregar: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void entrarModoEdicao() {
    if (paciente != null) {
      nomeController.text = paciente!.nomeCompleto;
      cpfController.text = paciente!.cpf;
      generoController.text = paciente!.genero;
      enderecoController.text = paciente!.endereco;
      telefoneController.text = paciente!.telefone;
      fotoUrlController.text = paciente!.fotoUrl;
    }
    isEditing = true;
    notifyListeners();
  }

  void cancelarEdicao() {
    isEditing = false;
    notifyListeners();
  }

  Future<void> salvarDados() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final dados = {
          'nomeCompleto': nomeController.text,
          'cpf': cpfController.text,
          'genero': generoController.text,
          'endereco': enderecoController.text,
          'telefone': telefoneController.text,
          'fotoUrl': fotoUrlController.text,
          'status': 'Paciente Ativo',
        };

        await _firestore.collection('pacientes').doc(user.uid).set(dados);
        paciente = PacienteModel.fromMap(dados);
        isEditing = false;
      }
    } catch (e) {
      debugPrint("Erro ao salvar: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarDadosPaciente({String? uidExterno}) async {
    isLoading = true;
    notifyListeners();

    try {
      String uid = uidExterno ?? FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('pacientes')
          .doc(uid)
          .get();

      if (doc.exists) {
        paciente = PacienteModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        paciente = null;
      }
    } catch (e) {
      debugPrint("Erro ao carregar a carteirinha: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    generoController.dispose();
    enderecoController.dispose();
    telefoneController.dispose();
    fotoUrlController.dispose();
    super.dispose();
  }
}
