import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileViewModel extends ChangeNotifier {
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();
  final photoUrlController = TextEditingController();

  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Carrega os dados atuais do usuário
  Future<void> carregarDadosUsuario() async {
    final user = _auth.currentUser;
    if (user != null) {
      isLoading = true;
      notifyListeners();

      final doc = await _firestore.collection('usuarios').doc(user.uid).get();
      if (doc.exists) {
        nomeController.text = doc.data()?['nome'] ?? '';
        cpfController.text = doc.data()?['cpf'] ?? '';
        telefoneController.text = doc.data()?['telefone'] ?? '';
        photoUrlController.text = doc.data()?['photoUrl'] ?? '';
      }

      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> salvarAlteracoes(BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      isLoading = true;
      notifyListeners();

      await _firestore.collection('usuarios').doc(user.uid).update({
        'nome': nomeController.text.trim(),
        'cpf': cpfController.text.trim(),
        'telefone': telefoneController.text.trim(),
        'photoUrl': photoUrlController.text.trim(),
        'ultimaAtualizacao': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil Atualizado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar o perfil')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  final ImagePicker _picker = ImagePicker();
  File? imagemSelecionada;

  Future<void> escolherFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      imagemSelecionada = File(image.path);
      notifyListeners();
    }
  }
}
