import 'package:flutter/material.dart';
import 'package:pi_projeto/core/services/chat_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final List<ChatMessage> mensagens = [];
  bool isLoading = false;

  Future<void> enviarMensagem(String texto) async {
    if (texto.trim().isEmpty) return;

    mensagens.add(ChatMessage(text: texto, isUser: true));
    isLoading = true;
    notifyListeners();

    final resposta = await _chatService.enviarMensagem(texto);

    if (resposta != null) {
      mensagens.add(ChatMessage(text: resposta, isUser: false));
    }

    isLoading = false;
    notifyListeners();
  }
}
