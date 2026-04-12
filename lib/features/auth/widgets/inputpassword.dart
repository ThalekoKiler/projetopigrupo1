import 'package:flutter/material.dart';
import 'package:pi_projeto/features/auth/widgets/custom_input_label.dart';

class Inputpassword extends StatelessWidget {
  final String text;
  
  // ADICIONADOS: Agora o widget aceita ordens da ViewModel 🎮
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onPressedIcon;

  const Inputpassword({
    super.key,
    required this.text,
    this.controller,
    this.validator,
    this.obscureText = true, // Por padrão, começa escondido
    this.onPressedIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos o seu CustomInputLabel (caixa_input.dart) que já ajustamos
    return CustomInputLabel(
      text: text,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          // Se obscureText for true, mostra o olho pra "abrir"
          obscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
        onPressed: onPressedIcon, // Chama a função toggle la da ViewModel
      ),
    );
  }
}