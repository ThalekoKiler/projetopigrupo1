import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  final String _apiKey = 'Sua API Key';
  late final GenerativeModel _model;
  late final ChatSession _chat;

  ChatService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(
        'Você é a Luna, a assistente virtual do consultório Saúde & Vida, da Dra. Thais Tardelli. '
        'O consultório está localizado na Avenida Fernão Dias Paes Leme, Várzea Paulista - SP, CEP 13220-001. '
        'Se o paciente perguntar a localização, informe o endereço completo. '
        'Seja sempre educada, use emojis e foque em tirar dúvidas sobre procedimentos odontológicos.'
        'Se o paciente perguntar se você pode marcar horário, responda que NÃO bem educadamente e fale que SOMENTE o paciente pode fazer isso pelo próprio App',
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
      return "Desculpe, estou passando por uma manutenção rápida. Tente novamente mais tarde";
    }
  }
}
