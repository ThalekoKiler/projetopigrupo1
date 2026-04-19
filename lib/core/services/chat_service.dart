import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  final String _apiKey = 'AIzaSyDQVpNRerCauE1Z386XbjrEqR46CjSW9nQ';
  late final GenerativeModel _model;
  late final ChatSession _chat;

  ChatService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(
        'Você é a assistente virtual inteligente do consultório odontológico Saúde & Vida, da Dra. Thais Tardelli. '
        'Seu objetivo é ajudar pacientes com dúvidas sobre procedimentos, pós-operatórios e informações gerais do consultório. '
        'Seja sempre educada, use emojis ocasionalmente e, para casos de dor forte ou urgência, recomende sempre entrar em contato direto com a clínica.',
      ),
    );
    _chat = _model.startChat();
  }

  Future<String?> enviarMensagem(String mensagem) async {
    try {
      final response = await _chat.sendMessage(Content.text(mensagem));
      return response.text;
    } catch (e) {
      print("ERRO REAL DO GEMINI: $e");
      return "Erro técnico: $e";
    }
  }
}
