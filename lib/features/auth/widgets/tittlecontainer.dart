import 'package:flutter/material.dart';

class Tittlecontainer extends StatelessWidget {
  final String text;
  const Tittlecontainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
                  text,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                );
  }
}