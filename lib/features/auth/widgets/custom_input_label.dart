import 'package:flutter/material.dart';




class CustomInputLabel extends StatelessWidget {
  final String text;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomInputLabel({
    super.key,
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller, 
    this.validator,  
  });

  @override
  Widget build(BuildContext context) {
    // ALTERADO: De TextField para TextFormField para funcionar o Form/Validator
    return TextFormField(
      controller: controller, // Conecta com a ViewModel
      validator: validator,   // Conecta com o Validatorless
      obscureText: obscureText,
      cursorColor: const Color(0xFFB76E79),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        hintText: text,
        // Design das bordas mantido exatamente como o seu
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFB76E79)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}