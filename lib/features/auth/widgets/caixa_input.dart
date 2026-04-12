import 'package:flutter/material.dart';

class CustomInputLabel extends StatelessWidget {
  final String text;
  final Widget? prefixIcon; // Renomeado de icon para clareza
  final Widget? suffixIcon; // NOVO: Ícone no final do campo
  final bool obscureText;

  const CustomInputLabel({
    super.key,
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFB76E79)),
        ),
      ),
    );
  }
}
