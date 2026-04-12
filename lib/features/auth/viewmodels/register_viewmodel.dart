import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class RegisterViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final dataController = TextEditingController();
  final telefoneController = TextEditingController();
  final senhaController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;
  String dddPais = '+55';

  // Instâncias do Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Validações ---
  String? nomeValidator(String? value) => Validatorless.multiple([
    Validatorless.required('O nome completo é obrigatório.'),
    Validatorless.min(3, 'O nome deve ter pelo menos 3 letras.'),
  ])(value);

  String? emailValidator(String? value) => Validatorless.multiple([
    Validatorless.required('O e-mail é obrigatório.'),
    Validatorless.email('Digite um e-mail válido.'),
  ])(value);

  String? senhaValidator(String? value) => Validatorless.multiple([
    Validatorless.required('A senha é obrigatória.'),
    Validatorless.min(6, 'A senha deve ter pelo menos 6 caracteres.'),
  ])(value);

  String? telefoneValidator(String? value) =>
      Validatorless.required('O telefone é obrigatório.')(value);

  String? dataValidator(String? value) =>
      Validatorless.required('A data é obrigatória.')(value);

  // --- Lógica de UI ---
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  // --- LÓGICA DE REGISTRO ---
  Future<void> onRegisterPressed(
    BuildContext context,
    VoidCallback onSuccess,
  ) async {
    final formValid = formKey.currentState?.validate() ?? false;
    if (!formValid) return;

    try {
      isLoading = true;
      notifyListeners();

      // 1. Criar usuário no Firebase Auth (E-mail e Senha)
      debugPrint("Tentando criar usuário no Auth...");
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: senhaController.text.trim(),
          );

      // 2. Salvar dados adicionais no Firestore
      if (userCredential.user != null) {
        debugPrint(
          "Usuário criado! UID: ${userCredential.user!.uid}. Salvando no Firestore...",
        );

        await _firestore
            .collection('usuarios')
            .doc(userCredential.user!.uid)
            .set({
              'nome': nomeController.text.trim(),
              'email': emailController.text.trim(),
              'dataNascimento': dataController.text,
              'telefone': "$dddPais ${telefoneController.text}",
              'uid': userCredential.user!.uid,
              'criadoEm': FieldValue.serverTimestamp(),
            });

        debugPrint("Dados salvos com sucesso no Firestore!");
      }

      onSuccess();
    } on FirebaseAuthException catch (e) {
      debugPrint("ERRO FIREBASE AUTH: ${e.code} - ${e.message}");
      String mensagem = "Erro ao cadastrar";

      if (e.code == 'email-already-in-use') {
        mensagem = "Este e-mail já está em uso.";
      } else if (e.code == 'weak-password') {
        mensagem = "A senha é muito fraca.";
      } else if (e.code == 'network-request-failed') {
        mensagem = "Verifique sua conexão com a internet.";
      }

      _mostrarErro(context, mensagem);
    } catch (e) {
      debugPrint("========= ERRO DETALHADO =========");
      debugPrint("TIPO DO ERRO: ${e.runtimeType}");
      debugPrint("MENSAGEM: $e");
      debugPrint("==================================");

      _mostrarErro(
        context,
        "Erro no banco de dados. Verifique as permissões do Firestore.",
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _mostrarErro(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- GERENCIAMENTO DE MEMÓRIA ---
  void disposeControllers() {
    nomeController.dispose();
    emailController.dispose();
    dataController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}
