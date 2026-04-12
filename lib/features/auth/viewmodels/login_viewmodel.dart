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

  // Instâncias do Firebase e Google
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // --- Validações ---
  String? emailValidator(String? value) {
    return Validatorless.multiple([
      Validatorless.required('O e-mail é obrigatório.'),
      Validatorless.max(254, 'O e-mail é longo demais.'),
      Validatorless.email('Digite um e-mail válido.'),
    ])(value);
  }

  String? passwordValidator(String? value) {
    return Validatorless.multiple([
      Validatorless.required('A senha é obrigatória.'),
      Validatorless.min(6, 'A senha deve ter pelo menos 6 caracteres.'),
    ])(value);
  }

  // --- Lógica de UI ---
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  // --- Login Email e Senha ---
  Future<void> onLoginPressed({
    required VoidCallback onSuccess,
    required Function(String mensagem) onError,
  }) async {
    final formValid = formKey.currentState?.validate() ?? false;
    if (!formValid) return;

    try {
      isLoading = true;
      notifyListeners();

      // Login Real no Firebase
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      onSuccess();
    } on FirebaseAuthException catch (e) {
      // Tratamento de erros específicos do Firebase
      String mensagem = "Falha ao entrar";
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        mensagem = "E-mail ou senha incorretos.";
      } else if (e.code == 'user-disabled') {
        mensagem = "Este usuário foi desativado.";
      }
      onError(mensagem);
    } catch (e) {
      onError("Erro inesperado: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --- LOGIN COM GOOGLE ---
  Future<void> onGoogleLoginPressed({
    required VoidCallback onSuccess,
    required Function(String mensagem) onError,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // 1. Abre a janelinha do Google para escolher a conta
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading = false;
        notifyListeners();
        return; // Usuário cancelou
      }

      // 2. Pega os dados da autenticação
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Cria a credencial para o Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Faz o login no Firebase
      await _auth.signInWithCredential(credential);

      onSuccess();
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
