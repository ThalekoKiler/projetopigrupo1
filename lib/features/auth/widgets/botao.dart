import 'package:flutter/material.dart';

class Botao extends StatelessWidget {
  final Color backgroundColor;
  final String texto;
  final Color corDaFonte;
  final VoidCallback? onPressed;
  final Widget? icone;

  const Botao({
    super.key,
    required this.backgroundColor,
    required this.texto,
    required this.corDaFonte,
    this.onPressed,
    this.icone,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed == null ? Colors.grey : backgroundColor,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,

      child: icone != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icone!,
                const SizedBox(width: 12),
                Text(
                  texto,
                  style: TextStyle(
                    color: corDaFonte,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Text(
              texto,
              style: TextStyle(
                color: corDaFonte,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
