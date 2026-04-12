import 'package:flutter/material.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';

class Subtittlebutton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  const Subtittlebutton({super.key, required this.text, required this.onPressed});

  @override
  State<Subtittlebutton> createState() => _SubtittlebuttonState();
}

class _SubtittlebuttonState extends State<Subtittlebutton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
                      onPressed: () { widget.onPressed(); },
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.CorPrincipal,
                        ),
                      ),
                    );
  }
}