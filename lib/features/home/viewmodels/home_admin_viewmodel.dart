import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeAdminViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String nomeAdmin = "Dra. Dentista";
  String? fotoUrl;
  bool isLoading = true;

  Future<void> carregarDados() async {
    try {
      isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await _firestore
            .collection('usuarios')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          nomeAdmin = doc.get('nome');

          try {
            fotoUrl = doc.get('photoUrl');
          } catch (e) {
            fotoUrl = null;
          }
        }
      }
    } catch (e) {
      debugPrint("Erro ao carregar admin: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deslogar() async {
    await _auth.signOut();
  }
}
