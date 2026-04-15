import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class RegisterViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // Controllers (REMOVIDO adminCodigoController)
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final dataController = TextEditingController();
  final telefoneController = TextEditingController();
  final senhaController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;
  String dddPais = '+55';

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

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<void> onRegisterPressed(
    BuildContext context,
    VoidCallback onSuccess,
  ) async {
    final formValid = formKey.currentState?.validate() ?? false;
    if (!formValid) return;

    try {
      isLoading = true;
      notifyListeners();

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: senhaController.text.trim(),
          );

      if (userCredential.user != null) {
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
              'role': "paciente",
            });
      }
      onSuccess();
    } catch (e) {
      _mostrarErro(context, "Erro ao cadastrar. Verifique os dados.");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _mostrarErro(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    dataController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
