import 'package:flutter/material.dart';
import 'package:pi_projeto/core/theme/app_colors.dart';
import 'package:pi_projeto/features/chat/viewmodels/chat_viewmodel.dart';

class ChatPage extends StatefulWidget {
  final String? mensagemInicial;
  const ChatPage({super.key, this.mensagemInicial});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatViewModel viewModel = ChatViewModel();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Se houver uma mensagem inicial (do Card roxo), envia automaticamente
    if (widget.mensagemInicial != null) {
      viewModel.enviarMensagem(widget.mensagemInicial!);
    }
  }

  // Método para rolar a tela para o fim da conversa
  void _scrollParaBaixo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("IA Dentista"),
        backgroundColor: AppColors.CorPrincipal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          // 1. Área das Mensagens
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                // Sempre que a lista mudar, tentamos rolar para baixo
                _scrollParaBaixo();

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: viewModel.mensagens.length,
                  itemBuilder: (context, index) {
                    final msg = viewModel.mensagens[index];
                    return _buildBubble(msg);
                  },
                );
              },
            ),
          ),

          // 2. Indicador de "Digitando"
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              if (!viewModel.isLoading) return const SizedBox.shrink();

              return const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 8, top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "IA está digitando...",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              );
            },
          ),

          // 3. Rodapé com Chips e Campo de Texto
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              children: [
                _buildSugestaoChips(),
                const SizedBox(height: 12),
                _buildInputBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Molde do balão de conversa
  Widget _buildBubble(ChatMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8, left: 60),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.CorPrincipal,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                'assets/images/ai_assistant.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.smart_toy, color: AppColors.CorPrincipal),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 60),
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Color(0xFFEBE6E6),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: const TextStyle(color: Colors.black87, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSugestaoChips() {
    final sugestoes = [
      "Marcar horário",
      "Quero ajuda",
      "Sensibilidade",
      "Localização",
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sugestoes
            .map(
              (sugestao) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(sugestao, style: const TextStyle(fontSize: 12)),
                  onPressed: () => viewModel.enviarMensagem(sugestao),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // Barra de digitação
  Widget _buildInputBar() {
    return Row(
      children: [
        const Icon(Icons.camera_alt_outlined, color: Colors.grey),
        const SizedBox(width: 10),
        const Icon(Icons.attach_file, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Digitar....",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const Icon(Icons.mic, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            if (_controller.text.isNotEmpty) {
              viewModel.enviarMensagem(_controller.text);
              _controller.clear();
            }
          },
          child: const CircleAvatar(
            backgroundColor: AppColors.CorPrincipal,
            child: Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
