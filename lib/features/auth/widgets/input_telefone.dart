import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTelefone extends StatelessWidget {
  final String hintText;
  final String siglaPais;
  final VoidCallback onTapBandeira;
  final TextEditingController? controller;

  const InputTelefone({
    super.key,
    required this.hintText,
    required this.siglaPais,
    required this.onTapBandeira,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52, // Altura padrão dos seus inputs
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // O mesmo arredondamento do seu CustomInputLabel
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          // 1. ÁREA CLICÁVEL DA BANDEIRA
          InkWell(
            onTap: onTapBandeira,
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bandeira Redondinha (Simulando o design)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFDE6E6), // Fundo rosinha claro
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      siglaPais,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD32F2F), // Vermelho mais forte
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
                ],
              ),
            ),
          ),
          
          // 2. A LINHA DIVISÓRIA
          Container(
            width: 1,
            height: 24,
            color: const Color(0xFFE0E0E0),
          ),
          
          // 3. O CAMPO DE DIGITAÇÃO DO NÚMERO
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              cursorColor: const Color(0xFFB76E79), // A mesma cor da sua LoginPage
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none, // Tira a borda do input interno
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}