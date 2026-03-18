import 'package:flutter/material.dart';

class SubtitulosCadastro extends StatelessWidget {
  final String texto;
  const SubtitulosCadastro({super.key, required this.texto});

  
  @override
  Widget build(BuildContext context) {
    return Container(
                  alignment: Alignment.centerLeft, 
                  child:
                  Text( texto , style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),),
                );
  }
}