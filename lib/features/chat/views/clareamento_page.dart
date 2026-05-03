import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:pi_projeto/features/chat/viewmodels/clareamento_viewmodel.dart';

class ClareamentoPage extends StatefulWidget {
  const ClareamentoPage({super.key});

  @override
  State<ClareamentoPage> createState() => _ClareamentoPageState();
}

class _ClareamentoPageState extends State<ClareamentoPage> {
  late final ClareamentoViewModel viewModel = ClareamentoViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Documentação sobre Clareamento"),
        backgroundColor: AppColors.CorPrincipal,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Preview da imagem
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: viewModel.image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            viewModel.image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_camera,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text("Nenhuma imagem selecionada"),
                          ],
                        ),
                ),
                const SizedBox(height: 16),

                // Botões de seleção
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            viewModel.selecionarImagem(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Galeria"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.CorPrincipal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            viewModel.selecionarImagem(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Câmera"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.CorPrincipal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Botão de gerar simulação
                if (viewModel.image != null)
                  ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : viewModel.simularClareamento,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Gerar Simulação"),
                  ),
                const SizedBox(height: 24),

                // Área de resultados
                if (viewModel.resultado.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Resultado da Análise:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.CorPrincipal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          viewModel.resultado,
                          style: const TextStyle(fontSize: 14, height: 1.3),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
