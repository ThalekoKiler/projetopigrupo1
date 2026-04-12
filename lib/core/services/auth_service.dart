import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Pegar o usuário atual
  User? get currentUser => _auth.currentUser;

  // Cadastro com Firebase
  Future<User?> register(String email, String password, String nome) async {
    UserCredential res = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Salva dados extras (nome) no Firestore
    if (res.user != null) {
      await _db.collection('usuarios').doc(res.user!.uid).set({
        'nome': nome,
        'email': email,
        'criadoEm': DateTime.now(),
      });
    }
    return res.user;
  }

  // Login
  Future<User?> login(String email, String password) async {
    UserCredential res = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.user;
  }
}
