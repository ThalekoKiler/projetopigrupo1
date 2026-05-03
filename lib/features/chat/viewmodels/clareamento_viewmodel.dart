import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ClareamentoViewModel extends ChangeNotifier {
  File? _image;
  bool _isLoading = false;
  String _resultado = "";

  File? get image => _image;
  bool get isLoading => _isLoading;
  String get resultado => _resultado;

  final ImagePicker _picker = ImagePicker();

  Future<void> selecionarImagem(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      _image = File(image.path);
      _resultado = "";
      notifyListeners();
    }
  }

  Future<void> simularClareamento() async {
    if (_image == null) return;

    _isLoading = true;
    _resultado = "";
    notifyListeners();

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: 'SUA API KEY',
        systemInstruction: Content.system(
          'Você é a Luna, assistente virtual do consultório Saúde & Vida. '
          'Você está analisando a foto de um sorriso para simular um clareamento dental. '
          'Dê uma estimativa de quantos tons o dente pode clarear e quais procedimentos são recomendados.',
        ),
      );

      final bytes = await _image!.readAsBytes();
      final imagePart = DataPart('image/jpeg', bytes);

      final response = await model.generateContent([
        Content.multi([
          imagePart,
          TextPart(
            'Analise esta imagem e simule os benefícios e o resultado do clareamento dental.',
          ),
        ]),
      ]);

      _resultado = response.text ?? "Não foi possível gerar a simulação.";
    } catch (e) {
      _resultado = "Erro ao processar a imagem: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limparImagem() {
    _image = null;
    _resultado = "";
    notifyListeners();
  }
}
