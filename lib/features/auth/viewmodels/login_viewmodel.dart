import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:validatorless/validatorless.dart';

class LoginViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  // Criação das Instâncias da Google e Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // --- Validações ---
  String? emailValidator(String? value) => Validatorless.multiple([
    Validatorless.required('O e-mail é obrigatório.'),
    Validatorless.max(254, 'O e-mail é longo demais.'),
  ])(value);

  String? passwordValidator(String? value) => Validatorless.multiple([
    Validatorless.required('A senha é obrigatória.'),
    Validatorless.min(6, 'A senha deve ter pelo menos 6 caracteres.'),
  ])(value);

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  // --- FUNÇÃO AUXILIAR PARA DECIDIR A ROTA ---
  // Visa evitar repetição de código
  Future<String> _definirRotaDestino(String uid) async {
    DocumentSnapshot userDoc = await _firestore
        .collection('usuarios')
        .doc(uid)
        .get();

    if (userDoc.exists) {
      String role = userDoc.get('role') ?? 'paciente';
      return (role == 'admin') ? '/home-admin' : '/home';
    }
    return '/home';
  }

  // --- Login / Email / Senha ---
  Future<void> onLoginPressed({
    required Function(String rota) onSuccess,
    required Function(String mensagem) onError,
  }) async {
    final formValid = formKey.currentState?.validate() ?? false;
    if (!formValid) return;

    try {
      isLoading = true;
      notifyListeners();

      String loginInput = emailController.text.trim();
      String passwordInput = passwordController.text.trim();

      if (loginInput.toUpperCase() == 'THAIS2026!@') {
        loginInput = "tvasconcellostardelli@gmail.com";
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: loginInput,
        password: passwordInput,
      );

      // BUSCA A ROTA BASEADA NO CARGO
      String rota = await _definirRotaDestino(userCredential.user!.uid);
      onSuccess(rota);
    } on FirebaseAuthException catch (e) {
      String mensagem = "E-mail ou senha incorretos.";
      if (e.code == 'user-disabled') mensagem = "Este usuário foi desativado.";
      onError(mensagem);
    } catch (e) {
      onError("Erro inesperado: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --- Login com o Google ---
  Future<void> onGoogleLoginPressed({
    required Function(String rota) onSuccess,
    required Function(String mensagem) onError,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // BUSCA A ROTA BASEADA NO CARGO (Mesmo no Google)
      String rota = await _definirRotaDestino(userCredential.user!.uid);
      onSuccess(rota);
    } catch (e) {
      onError("Erro ao entrar com Google: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
