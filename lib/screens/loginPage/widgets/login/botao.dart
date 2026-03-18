import 'package:flutter/material.dart';

  class Botao extends StatelessWidget {
  final Color backgroundColor; 
  final String texto;
  final Color corDaFonte;    
  final VoidCallback onPressed;

  const Botao({
    super.key,
    required this.backgroundColor,
    required this.texto,
    required this.corDaFonte,
    required this.onPressed, 
  });



  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  backgroundColor,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                  onPressed: (){}, child: Text(
                    texto, 
                    style: TextStyle(
                    color: corDaFonte,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  )));
  }
}