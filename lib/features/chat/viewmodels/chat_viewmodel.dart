import 'dart:typed_data';

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

  Future<void> enviarDocumentoParaLuna(
    String texto,
    Uint8List bytes,
    String mimeType,
  ) async {
    mensagens.add(
      ChatMessage(text: "Enviando documento para análise...", isUser: true),
    );
    isLoading = true;
    notifyListeners();

    try {
      final resposta = await _chatService.enviarMensagemComArquivo(
        texto,
        bytes,
        mimeType,
      );

      if (resposta != null) {
        mensagens.add(ChatMessage(text: resposta, isUser: false));
      }
    } catch (e) {
      mensagens.add(
        ChatMessage(
          text:
              "Ops, tive um problema ao ler esse arquivo. Pode tentar novamente?",
          isUser: false,
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
